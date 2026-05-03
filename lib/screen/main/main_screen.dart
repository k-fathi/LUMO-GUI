import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Robot Screen/spin_learn_screen.dart';
import '../game/game_levels_screen.dart';
import '../learn/learn_level_screen.dart';
import '../draw/main_drawing_screen.dart';
import '../../utils/timer_controller.dart';
// import '../splash/splash_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int dailyOpenCount = 0;

  @override
  void initState() {
    super.initState();
    _loadDailyOpenCount();
  }

  Future<void> _loadDailyOpenCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final count = prefs.getInt('daily_open_count') ?? 0;
      if (mounted) setState(() => dailyOpenCount = count);
    } catch (_) {}
  }

  void _confirmEndSession() {
    Get.dialog(
      AlertDialog(
        title: const Text('End Session'),
        content: const Text('Are you want to end the session now?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              Get.find<TimerController>().endSession();
            },
            child: const Text('Yes', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            TextButton.icon(
              onPressed: _confirmEndSession,
              icon: const Icon(Icons.exit_to_app, color: Colors.redAccent),
              label: const Text(
                'End Session',
                style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: SizedBox.expand(
            // 👈 يخليها تاخد حجم الشاشة بالكامل
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 0),

                      Text(
                        'Hello',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        'Welcome to LUMO World',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 25,
                          color: Colors.grey.shade600,
                        ),
                      ),

                      const SizedBox(height: 30),

                      /// 4 أعمدة ثابتة
                      GridView.count(
                        crossAxisCount: 4,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        childAspectRatio: 1.1,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          _buildCategoryCard(
                            title: 'Learn',
                            icon: '📚',
                            bgColor: const Color(0xFFE8F5E9),
                            onTap: () {
                              Get.to(
                                () => LearnLevels(),
                                transition: Transition.fadeIn,
                              );
                            },
                          ),

                          _buildCategoryCard(
                            title: 'Game',
                            icon: '🎮',
                            bgColor: const Color(0xFFFFF3E0),
                            onTap: () {
                              Get.to(
                                () => GameLevels(),
                                transition: Transition.fadeIn,
                              );
                            },
                          ),

                          _buildCategoryCard(
                            title: 'Drawing',
                            icon: '🎨',
                            bgColor: const Color(0xFFFCE4EC),
                            onTap: () {
                              Get.to(
                                () => MainDrawingScreen(),
                                transition: Transition.fadeIn,
                              );
                            },
                          ),

                          _buildCategoryCard(
                            title: 'Storyteller',
                            icon: '🤖',
                            bgColor: const Color(0xFFE3F2FD),
                            onTap: () {
                              Get.to(
                                () => RobotScreen(),
                                transition: Transition.fadeIn,
                              );
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard({
    required String title,
    required String icon,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(icon, style: const TextStyle(fontSize: 40)),
              const SizedBox(height: 10),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
