import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
          style: TextStyle(fontFamily: 'Poppins',  
              fontWeight: FontWeight.bold,
              color: Colors.black87
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Center(
        // LayoutBuilder lets us size each card as a fraction of the actual
        // available height, so all 3 cards fit on small screens (like the
        // Raspberry Pi display) without needing to scroll.
        child: LayoutBuilder(
          builder: (context, constraints) {
            const verticalPadding = 24.0; // top+bottom padding total
            const gap = 15.0; // space between cards (matches original SizedBox(height: 15))
            const gapsTotal = gap * 2; // 2 gaps between 3 cards

            final availableHeight = constraints.maxHeight - verticalPadding - gapsTotal;
            // Keep a sensible minimum/maximum so cards never look too
            // squashed or oversized; SingleChildScrollView below remains
            // as a safety net for any leftover overflow.
            final cardHeight = (availableHeight / 3).clamp(70.0, 105.0);

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min, // لتوسيط الـ 3 كروت
                children: [
                  // كارت 1 - Count & Choose
                  _buildLevelCard(
                    levelText: 'Level 1',
                    subtitle: 'Count & Choose',
                    assetIcon: 'assets/images/count_game_icon.png', // صورة عد وأرقام
                    bgColor: const Color(0xFFFCE4EC),
                    height: cardHeight,
                    onTap: () {
                      Get.to(() => const CountChooseGame());
                    },
                  ),

                  SizedBox(height: gap),

                  // كارت 2 - Word Game
                  _buildLevelCard(
                    levelText: 'Level 2',
                    subtitle: 'Word Game',
                    assetIcon: 'assets/images/word_game_icon.png', // صورة كلمات وملصقات
                    bgColor: const Color(0xFFFFF3E0),
                    height: cardHeight,
                    onTap: () {
                      Get.to(() => const WordGameScreen());
                    },
                  ),

                  SizedBox(height: gap),

                  // كارت 3 - Alphabet Puzzle
                  _buildLevelCard(
                    levelText: 'Level 3',
                    subtitle: 'Alpha Puzzle',
                    assetIcon: 'assets/images/alpha_puzzle_game.png', // صورة بازل الحروف
                    bgColor: const Color(0xFFE3F2FD),
                    height: cardHeight,
                    onTap: () {
                      Get.to(() => const AlphabetNumberPuzzleScreen());
                    },
                  ),
                ],
              ),
            );
          },
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
    double height = 105,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        width: double.infinity,
        height: height,
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
              SizedBox(width: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    levelText,
                    style: TextStyle(fontFamily: 'Poppins',  
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontFamily: 'Poppins',  
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Icon(Icons.arrow_forward_ios_rounded, color: Colors.black26, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
