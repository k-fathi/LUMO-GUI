import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kids_world_app/screen/game/learningGames/LearningGamesLevels.dart';

import 'matching/MachingLevels.dart';
import 'mindGames/MindGamesLevels.dart';

class GameLevels extends StatelessWidget {
  const GameLevels({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. جعل الخلفية بيضاء
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Game Levels',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      // 2. وضع الكروت في منتصف الشاشة بالظبط
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // لجعل العمود يتوسط الشاشة
            children: [
              // الكارت الأول - Matching (الأخضر الفاتح)
              _buildLevelCard(
                title: 'Matching Games',
                icon: '🧩',
                bgColor: const Color(0xFFE8F5E9),
                onTap: () {
                  Get.to(
                    () => const MatchingLevels(),
                    transition: Transition.rightToLeft,
                  );
                },
              ),

              const SizedBox(height: 20),

              // الكارت الثاني - Mind Games (الوردي الفاتح)
              _buildLevelCard(
                title: 'Mind Games',
                icon: '🧠',
                bgColor: const Color(0xFFFCE4EC),
                onTap: () {
                  Get.to(() => MindGamesLevels());
                },
              ),

              const SizedBox(height: 20),

              // الكارت الثالث - Learning Games (الأزرق الفاتح)
              _buildLevelCard(
                title: 'Learning Games',
                icon: '🎓',
                bgColor: const Color(0xFFE3F2FD),
                onTap: () {
                  Get.to(() => LearningGamesLevels());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLevelCard({
    required String title,
    required String icon,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        width: double.infinity,
        height: 130, // ارتفاع الكارت
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(25),
          // ظل خفيف ليتناسب مع الخلفية البيضاء
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(icon, style: const TextStyle(fontSize: 50)),
              const SizedBox(width: 20),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
