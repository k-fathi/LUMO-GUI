import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
              // Level 1 - Color Game
              _buildLevelCard(
                levelText: 'Level 1',
                subtitle: 'Colour Game',
                assetIcon: 'assets/images/color_game_icon.png',
                bgColor: const Color(0xFFE8F5E9),
                onTap: () {
                  Get.to(() => const ColorGameScreen());
                },
              ),

              const SizedBox(height: 20),

              // Level 2 - Puzzle Game
              _buildLevelCard(
                levelText: 'Level 2',
                subtitle: 'Puzzle Game',
                assetIcon: 'assets/images/puzzle_game_icon.png',
                bgColor: const Color(0xFFFCE4EC),
                onTap: () {
                  Get.to(() => const PuzzleGameScreen());
                },
              ),

              const SizedBox(height: 20),

              // Level 3 - Match Pair
              _buildLevelCard(
                levelText: 'Level 3',
                subtitle: 'Match Pair',
                assetIcon: 'assets/images/match_pair_icon.png',
                bgColor: const Color(0xFFE3F2FD),
                onTap: () {
                  Get.to(() => const MatchPairsGame());
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