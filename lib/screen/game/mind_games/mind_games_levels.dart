import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kids_world_app/screen/game/mind_games/which_has_more_game.dart';
import 'big_or_small_game.dart';
import 'funny_ball_game.dart';

class MindGamesLevels extends StatelessWidget {
  const MindGamesLevels({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Mind Games Levels',
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: Colors.black87
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Level 1 - Which Has More
              _buildLevelCard(
                levelText: 'Level 1',
                subtitle: 'Which Has More',
                assetIcon: 'assets/images/more_find_icon.png', // رسمة الـ Stickers مناسبة للمقارنة
                bgColor: const Color(0xFFE8F5E9),
                onTap: () {
                  Get.to(() => const WhichHasMoreGame());
                },
              ),

              const SizedBox(height: 20),

              // Level 2 - Big or Small
              _buildLevelCard(
                levelText: 'Level 2',
                subtitle: 'Big or Small',
                assetIcon: 'assets/images/find_big_icon.png', // رسمة أحجام ومكعبات
                bgColor: const Color(0xFFFCE4EC),
                onTap: () {
                  Get.to(() => const BigOrSmallGame());
                },
              ),

              const SizedBox(height: 20),

              // Level 3 - Funny Ball
              _buildLevelCard(
                levelText: 'Level 3',
                subtitle: 'Funny Ball',
                assetIcon: 'assets/images/ball_game_icon.png', // رسمة كرات ملونة
                bgColor: const Color(0xFFE3F2FD),
                onTap: () {
                  Get.to(() => const FunnyBallGame());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLevelCard({
    required String levelText,
    required String subtitle,
    required String assetIcon,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(25),
        child: Container(
          width: double.infinity,
          height: 120,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
                children: [
            Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              assetIcon,
              height: 55, // تكبير الصورة شوية عشان توضح
              width: 55,
              fit: BoxFit.contain,
            ),
          ),
                  const SizedBox(width: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        levelText,
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios_rounded, color: Colors.black26),
                ],
            ),
          ),
        ),
    );
  }
}