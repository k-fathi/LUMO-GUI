import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/session_model.dart';
import '../../models/segment_model.dart';
import '../../services/api_service.dart';
import '../../controllers/timer_controller.dart';

import '../game/game_levels_screen.dart';
import '../learn/learn_level_screen.dart';
import '../draw/main_drawing_screen.dart';
import '../robot_screen/spin_learn_screen (1).dart';
import '../splash/splash_screen.dart';

class MainScreen extends StatefulWidget {
  final Session? session;
  const MainScreen({super.key, this.session});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final ApiService _apiService = ApiService();
  Session? _currentSession;
  int dailyOpenCount = 0;
  bool _isStartingSegment = false;

  @override
  void initState() {
    super.initState();
    _currentSession = widget.session;
    _loadDailyOpenCount();

    // Register segment completed state updates
    final timerController = Get.find<TimerController>();
    timerController.onSegmentCompleted = () {
      if (_currentSession != null) {
        final completedId = timerController.activeSegmentId.value;
        setState(() {
          for (var i = 0; i < _currentSession!.segments.length; i++) {
            if (_currentSession!.segments[i].id == completedId) {
              final s = _currentSession!.segments[i];
              _currentSession!.segments[i] = Segment(
                id: s.id,
                type: s.type,
                plannedMinutes: s.plannedMinutes,
                status: 'completed',
                startedAt: s.startedAt,
                endedAt: s.endedAt,
              );
            }
          }
        });
      }
    };
  }

  Future<void> _loadDailyOpenCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final count = prefs.getInt('daily_open_count') ?? 0;
      if (mounted) setState(() => dailyOpenCount = count);
    } catch (_) {}
  }

  Future<void> _confirmEndSession() async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'End Session',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to end the session now?',
          style: TextStyle(fontFamily: 'Poppins', fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(
              'Cancel',
              style: TextStyle(fontFamily: 'Poppins', color: Colors.grey.shade700),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Get.back(result: true),
            child: Text(
              'Yes',
              style: TextStyle(fontFamily: 'Poppins', 
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // Cancel active timer
      final timerController = Get.find<TimerController>();
      timerController.stopTimer();

      if (_currentSession != null) {
        // Call end session API
        await _apiService.endSession(_currentSession!.sessionId);
      }

      Get.offAll(() => const SplashFaceScreen());
    }
  }

  Segment? _getSegmentForType(String type) {
    if (_currentSession == null) return null;
    final norm = type.toLowerCase();
    try {
      return _currentSession!.segments.firstWhere(
        (s) => s.type.toLowerCase() == norm,
      );
    } catch (_) {
      try {
        return _currentSession!.segments.firstWhere(
          (s) =>
              s.type.toLowerCase().contains(norm) ||
              norm.contains(s.type.toLowerCase()),
        );
      } catch (_) {
        return null;
      }
    }
  }

  Future<void> _handleStartSegment(
    Segment segment,
    VoidCallback redirect,
  ) async {
    final timerController = Get.find<TimerController>();

    if (timerController.isRunning.value) {
      if (timerController.activeSegmentId.value == segment.id) {
        redirect();
        return;
      }
      Get.snackbar(
        'Already Running',
        'Please wait for the current segment to finish.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    setState(() => _isStartingSegment = true);

    // Call start API
    await _apiService.startSegment(segment.id);

    setState(() => _isStartingSegment = false);

    // Start local timer (completely client-side countdown using planned duration)
    timerController.startTimer(
      segment.plannedMinutes * 60,
      segment.id,
      segment.type,
    );

    // Redirect to the activity screen
    redirect();
  }

  @override
  Widget build(BuildContext context) {
    final timerController = Get.find<TimerController>();

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: _currentSession != null
              ? Text(
                  'Session #${_currentSession!.sessionId} - ${_currentSession!.patientName}',
                  style: TextStyle(fontFamily: 'Poppins', 
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                )
              : null,
          centerTitle: true,
          actions: [
            TextButton.icon(
              onPressed: _isStartingSegment ? null : _confirmEndSession,
              icon: Icon(Icons.exit_to_app, color: Colors.redAccent),
              label: Text(
                'End Session',
                style: TextStyle(fontFamily: 'Poppins', 
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 180),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                Text(
                  'Hello',
                  style: TextStyle(fontFamily: 'Poppins', 
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Welcome to LUMO World',
                  style: TextStyle(fontFamily: 'Poppins', 
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 24),

                // Expanded Row of 4 Premium cards in one row
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Obx(() {
                        // Read properties inside Get.find Obx to automatically trigger rebuild on timer changes
                        final isAnyRunning = timerController.isRunning.value;
                        final activeId = timerController.activeSegmentId.value;

                        final studySegment = _getSegmentForType('study');
                        final storiesSegment = _getSegmentForType('stories');
                        final gamesSegment = _getSegmentForType('games');
                        final drawingSegment = _getSegmentForType('drawing');

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Learn (study) card
                            SizedBox(
                              width: 175,
                              height: 230,
                              child: _buildCard(
                                title: 'Learn',
                                icon: '📚',
                                color: const Color(0xFFE8F5E9),
                                accentColor: const Color(0xFF43A047),
                                segment: studySegment,
                                timerController: timerController,
                                isAnyRunning: isAnyRunning,
                                activeId: activeId,
                                onStartPressed: () => _handleStartSegment(
                                  studySegment!,
                                  () => Get.to(() => LearnLevels()),
                                ),
                              ),
                            ),
                            SizedBox(width: 16),

                            // Story (stories) card
                            SizedBox(
                              width: 175,
                              height: 230,
                              child: _buildCard(
                                title: 'Story',
                                icon: '🤖',
                                color: const Color(0xFFE3F2FD),
                                accentColor: const Color(0xFF1E88E5),
                                segment: storiesSegment,
                                timerController: timerController,
                                isAnyRunning: isAnyRunning,
                                activeId: activeId,
                                onStartPressed: () => _handleStartSegment(
                                  storiesSegment!,
                                  () => Get.to(
                                    () => RobotScreen(
                                      segmentId: storiesSegment.id,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 16),

                            // Game (games) card
                            SizedBox(
                              width: 175,
                              height: 230,
                              child: _buildCard(
                                title: 'Game',
                                icon: '🎮',
                                color: const Color(0xFFFFF3E0),
                                accentColor: const Color(0xFFFB8C00),
                                segment: gamesSegment,
                                timerController: timerController,
                                isAnyRunning: isAnyRunning,
                                activeId: activeId,
                                onStartPressed: () => _handleStartSegment(
                                  gamesSegment!,
                                  () => Get.to(() => GameLevels()),
                                ),
                              ),
                            ),
                            SizedBox(width: 16),

                            // Drawing (drawing) card
                            SizedBox(
                              width: 175,
                              height: 230,
                              child: _buildCard(
                                title: 'Drawing',
                                icon: '🎨',
                                color: const Color(0xFFFCE4EC),
                                accentColor: const Color(0xFFE91E63),
                                segment: drawingSegment,
                                timerController: timerController,
                                isAnyRunning: isAnyRunning,
                                activeId: activeId,
                                onStartPressed: () => _handleStartSegment(
                                  drawingSegment!,
                                  () => Get.to(() => MainDrawingScreen()),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String icon,
    required Color color,
    required Color accentColor,
    required Segment? segment,
    required TimerController timerController,
    required bool isAnyRunning,
    required int activeId,
    required VoidCallback onStartPressed,
  }) {
    final bool isCompleted = segment?.isCompleted ?? false;
    final bool isActive =
        segment != null && isAnyRunning && activeId == segment.id;

    Color buttonColor;
    if (segment == null) {
      buttonColor = Colors.grey;
    } else if (isCompleted) {
      buttonColor = Colors.red;
    } else if (isActive) {
      buttonColor = Colors.green;
    } else {
      buttonColor = Colors.blue;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isActive
                ? accentColor.withOpacity(0.2)
                : Colors.black.withOpacity(0.06),
            blurRadius: isActive ? 14 : 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: isActive
            ? Border.all(color: accentColor, width: 2.5)
            : Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Icon, Title, and planned minutes
            Column(
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(icon, style: TextStyle(fontFamily: 'Poppins', fontSize: 32)),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  title,
                  style: TextStyle(fontFamily: 'Poppins', 
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                if (segment != null) ...[
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        size: 12,
                        color: Colors.grey.shade500,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '${segment.plannedMinutes} min',
                        style: TextStyle(fontFamily: 'Poppins', 
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),

            // Start Button at the bottom
            SizedBox(
              width: double.infinity,
              height: 38,
              child: ElevatedButton(
                onPressed:
                    (segment == null ||
                        isCompleted ||
                        _isStartingSegment ||
                        (isAnyRunning && !isActive))
                    ? null
                    : onStartPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  disabledBackgroundColor: buttonColor.withOpacity(0.6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                  padding: EdgeInsets.zero,
                ),
                child: Text(
                  isCompleted
                      ? 'Completed'
                      : isActive
                      ? 'Running'
                      : 'Start',
                  style: TextStyle(fontFamily: 'Poppins', 
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
