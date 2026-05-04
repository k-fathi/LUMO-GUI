import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../soundsAnimal/animalssounds.dart';
import '../Robot Screen/spin_learn_screen.dart';
import '../game/game_levels_screen.dart';
import '../learn/learn_level_screen.dart';
import '../draw/main_drawing_screen.dart';
import '../../utils/timer_controller.dart';

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
            child: const Text(
              'Yes',
              style: TextStyle(color: Colors.red),
            ),
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
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),

        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [

                Text(
                  'Hello',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'Welcome to LUMO World',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 10),

                /// ✅ الجريد
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1.1,

                    children: [

                      _buildCard('Learn', '📚', const Color(0xFFE8F5E9), () {
                        Get.to(() => LearnLevels());
                      }),

                      _buildCard('Animal Sounds', '🐶', const Color(0xFFD1C4E9), () {
                        Get.to(() => AnimalSoundsScreen());
                      }, isSpecial: true),

                      _buildCard('Story', '🤖', const Color(0xFFE3F2FD), () {
                        Get.to(() => RobotScreen());
                      }),

                      _buildCard('Game', '🎮', const Color(0xFFFFF3E0), () {
                        Get.to(() => GameLevels());
                      }),

                      _buildCard('Drawing', '🎨', const Color(0xFFFCE4EC), () {
                        Get.to(() => MainDrawingScreen());
                      }),

                      /// 👇 كارت فاضي عشان التوسيط
                      const SizedBox(),
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

  Widget _buildCard(
      String title,
      String icon,
      Color color,
      VoidCallback onTap, {
        bool isSpecial = false,
      }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          gradient: isSpecial
              ? const LinearGradient(
            colors: [Color(0xFFD1C4E9), Color(0xFFD1C4E9)],
          )
              : null,
          color: isSpecial ? null : color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              icon,
              style: TextStyle(fontSize: isSpecial ? 42 : 34),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}