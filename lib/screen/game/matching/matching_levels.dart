import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kids_world_app/screen/game/matching/puzzle_game_screen.dart';
import 'color_game_screen.dart';
import 'match_pair_game.dart';

class MatchingLevels extends StatelessWidget {
  const MatchingLevels({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Matching Levels',
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
            const gap = 20.0; // space between cards (matches original SizedBox(height: 20))
            const gapsTotal = gap * 2; // 2 gaps between 3 cards

            final availableHeight = constraints.maxHeight - verticalPadding - gapsTotal;
            // Keep a sensible minimum/maximum so cards never look too
            // squashed or oversized; SingleChildScrollView below remains
            // as a safety net for any leftover overflow.
            final cardHeight = (availableHeight / 3).clamp(80.0, 120.0);

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Level 1 - Color Game
                  _buildLevelCard(
                    levelText: 'Level 1',
                    subtitle: 'Colour Game',
                    assetIcon: 'assets/images/color_game_icon.png',
                    bgColor: const Color(0xFFE8F5E9),
                    height: cardHeight,
                    onTap: () {
                      Get.to(() => const ColorGameScreen());
                    },
                  ),

                  SizedBox(height: gap),

                  // Level 2 - Puzzle Game
                  _buildLevelCard(
                    levelText: 'Level 2',
                    subtitle: 'Puzzle Game',
                    assetIcon: 'assets/images/puzzle_game_icon.png',
                    bgColor: const Color(0xFFFCE4EC),
                    height: cardHeight,
                    onTap: () {
                      Get.to(() => const PuzzleGameScreen());
                    },
                  ),

                  SizedBox(height: gap),

                  // Level 3 - Match Pair
                  _buildLevelCard(
                    levelText: 'Level 3',
                    subtitle: 'Match Pair',
                    assetIcon: 'assets/images/match_pair_icon.png',
                    bgColor: const Color(0xFFE3F2FD),
                    height: cardHeight,
                    onTap: () {
                      Get.to(() => const MatchPairsGame());
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
    double height = 120,
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
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                  children: [
              // استبدال الـ Text(icon) بـ Image.asset
              Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                assetIcon,
                height: 50,
                width: 50,
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
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontFamily: 'Poppins',  
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
                    const Spacer(),
                    Icon(Icons.arrow_forward_ios_rounded, color: Colors.black26),
                  ],
              ),
            ),
        ),
    );
  }
}
