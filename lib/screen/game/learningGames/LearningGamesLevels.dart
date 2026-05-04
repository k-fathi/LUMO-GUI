import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kids_world_app/screen/game/learningGames/word_game_screen.dart';
import 'alphabet_number_puzzle_screen.dart';
import 'count_choose_game.dart';

class LearningGamesLevels extends StatelessWidget {
  const LearningGamesLevels({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // خلفية بيضاء
      appBar: AppBar(
        title: Text(
          'Learning Levels',
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
            mainAxisSize: MainAxisSize.min, // لتوسيط الـ 3 كروت
            children: [
              // كارت 1 - Count & Choose
              _buildLevelCard(
                levelText: 'Level 1',
                subtitle: 'Count & Choose',
                assetIcon: 'assets/images/count_game_icon.png', // صورة عد وأرقام
                bgColor: const Color(0xFFFCE4EC),
                onTap: () {
                  Get.to(() => const CountChooseGame());
                },
              ),

              const SizedBox(height: 15),

              // كارت 2 - Word Game
              _buildLevelCard(
                levelText: 'Level 2',
                subtitle: 'Word Game',
                assetIcon: 'assets/images/word_game_icon.png', // صورة كلمات وملصقات
                bgColor: const Color(0xFFFFF3E0),
                onTap: () {
                  Get.to(() => const WordGameScreen());
                },
              ),

              const SizedBox(height: 15),

              // كارت 3 - Alphabet Puzzle
              _buildLevelCard(
                levelText: 'Level 3',
                subtitle: 'Alpha Puzzle',
                assetIcon: 'assets/images/alpha_puzzle_game.png', // صورة بازل الحروف
                bgColor: const Color(0xFFE3F2FD),
                onTap: () {
                  Get.to(() => const AlphabetNumberPuzzleScreen());
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
        height: 105,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
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
                  height: 45,
                  width: 45,
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
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios_rounded, color: Colors.black26, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}