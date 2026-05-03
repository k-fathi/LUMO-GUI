import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../screen/splash/splash_screen.dart';

class TimerController extends GetxController {
  var secondsElapsed = 0.obs;
  var isVisible = false.obs;
  Timer? _timer;

  void startTimer() {
    isVisible.value = true;
    if (_timer != null && _timer!.isActive) return;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      secondsElapsed.value++;

      // If 1 hour (3600 seconds) is reached, show session completed dialog
      if (secondsElapsed.value == 3600) {
        stopTimer();
        _showSessionCompletedDialog();
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  void resetTimer() {
    _timer?.cancel();
    secondsElapsed.value = 0;
    isVisible.value = false;
  }

  void _showSessionCompletedDialog() {
    Get.dialog(
      PopScope(
        canPop: false,
        child: AlertDialog(
          title: const Text('Session Completed'),
          content: const Text('Your session is completed.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Get.back(); // Close dialog Let's clear the dialog
                endSession();
              },
              child: const Text('End Session'),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  void endSession() {
    resetTimer();
    Get.offAll(() => const SplashFaceScreen());
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  String get formattedTime {
    int h = secondsElapsed.value ~/ 3600;
    int m = (secondsElapsed.value % 3600) ~/ 60;
    int s = secondsElapsed.value % 60;

    if (h > 0) {
      return '${_twoDigits(h)}:${_twoDigits(m)}:${_twoDigits(s)}';
    } else {
      return '${_twoDigits(m)}:${_twoDigits(s)}';
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
