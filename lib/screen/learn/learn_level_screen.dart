import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'level_1/level_1.dart';
import 'level_2/level_2.dart';
import 'level_3/level_3.dart';


class LearnLevels extends StatelessWidget {
  const LearnLevels({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: Text(
          'Learn Levels',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
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
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 900, // عرض الموبايل
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                /// Level 1
                _buildLevelCard(
                  title: 'Level 1',
                  subtitle: 'Arabic - Alphabet - Numbers',
                  icon: '    ⭐',
                  bgColor: const Color(0xFFE8F5E9),
                  onTap: () {
                    Get.to(() => LevelOneScreen());
                  },
                ),

                const SizedBox(height: 20),

                /// Level 2
                _buildLevelCard(
                  title: 'Level 2',
                  subtitle: 'Day - Months - Colour',
                  icon: '🚀',
                  bgColor: const Color(0xFFFCE4EC),
                  onTap: () {
                    Get.to(() => LevelTwoScreen());
                  },
                ),

                const SizedBox(height: 20),

                /// Level 3
                _buildLevelCard(
                  title: 'Level 3',
                  subtitle: 'Animals - Shapes - Daily Life',
                  icon: '    👑',
                  bgColor: const Color(0xFFE3F2FD),
                  onTap: () {
                    Get.to(() => LevelThreeScreen());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLevelCard({
    required String title,
    required String subtitle,
    required String icon,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(25),
        child: Container(
            width: double.infinity,
            height: 130,
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
            child: Center(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Text(icon, style: const TextStyle(fontSize: 50)),
              const SizedBox(width: 20),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                /// Title
                Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 4),/// Subtitle
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
                  ],
              ),
            ),
        ),
    );
  }
}

