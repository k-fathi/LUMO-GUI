import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';

class TimerController extends GetxController {
  final ApiService _apiService = ApiService();

  Timer? _timer;
  final RxInt remainingSeconds = 0.obs;
  final RxInt activeSegmentId = 0.obs;
  final RxString activeSegmentType = ''.obs;
  final RxBool isRunning = false.obs;
  final RxInt totalSeconds = 0.obs;

  // Custom callback to trigger UI updates when a segment finishes
  VoidCallback? onSegmentCompleted;

  String get formattedTime {
    final minutes = remainingSeconds.value ~/ 60;
    final seconds = remainingSeconds.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void startTimer(int seconds, int segmentId, String type) {
    _timer?.cancel();
    remainingSeconds.value = seconds;
    totalSeconds.value = seconds;
    activeSegmentId.value = segmentId;
    activeSegmentType.value = type;
    isRunning.value = true;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (remainingSeconds.value <= 1) {
        timer.cancel();
        remainingSeconds.value = 0;
        isRunning.value = false;
        await _handleSegmentComplete();
      } else {
        remainingSeconds.value--;
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
    isRunning.value = false;
    remainingSeconds.value = 0;
    activeSegmentId.value = 0;
    activeSegmentType.value = '';
  }

  Future<void> endSegmentManually() async {
    final segmentId = activeSegmentId.value;
    
    // Stop local timer
    _timer?.cancel();
    _timer = null;
    isRunning.value = false;
    remainingSeconds.value = 0;

    // Call API to complete
    if (segmentId != 0) {
      await _apiService.completeSegment(segmentId);
    }

    // Trigger state callback in MainScreen
    if (onSegmentCompleted != null) {
      onSegmentCompleted!();
    }

    activeSegmentId.value = 0;
    activeSegmentType.value = '';

    // Route back to MainScreen if not already there
    Get.until((route) => route.settings.name == 'MainScreen' || route.settings.name == '/MainScreen' || route.isFirst);
  }

  Future<void> _handleSegmentComplete() async {
    final segmentId = activeSegmentId.value;
    final type = activeSegmentType.value;

    // 1. Call standard complete API endpoint
    await _apiService.completeSegment(segmentId);

    // 2. Trigger state callback in MainScreen
    if (onSegmentCompleted != null) {
      onSegmentCompleted!();
    }

    // 3. Gracefully route back to MainScreen if currently inside an activity screen
    Get.until((route) => route.settings.name == 'MainScreen' || route.settings.name == '/MainScreen' || route.isFirst);

    // 4. Show success dialog
    await Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.green, size: 28),
            const SizedBox(width: 10),
            Text(
              'Part Completed!',
              style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          'The "$type" activity has completed successfully.',
          style: TextStyle(fontFamily: 'Poppins', fontSize: 15),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Get.back(),
            child: Text(
              'OK',
              style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );

    // 5. Reset timer details
    activeSegmentId.value = 0;
    activeSegmentType.value = '';
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
