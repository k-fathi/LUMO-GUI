import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
          style: TextStyle(fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Colors.black87,
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
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 900, // عرض الموبايل
          ),
          // LayoutBuilder lets us size each card as a fraction of the actual
          // available height, so all 3 cards fit on small screens (like the
          // Raspberry Pi display) without needing to scroll.
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Reserve a little breathing room (top/bottom padding + gaps)
              // then split the rest evenly between the 3 cards.
              const verticalPadding = 24.0; // top+bottom padding total
              const gap = 16.0; // space between cards
              const gapsTotal = gap * 2; // 2 gaps between 3 cards

              final availableHeight = constraints.maxHeight - verticalPadding - gapsTotal;
              // Keep a sensible minimum/maximum so cards never look too
              // squashed or oversized; fall back to natural height (130)
              // and let SingleChildScrollView handle any overflow as a
              // safety net.
              final cardHeight = (availableHeight / 3).clamp(80.0, 130.0);

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    /// Level 1
                    _buildLevelCard(
                      title: 'Level 1',
                      subtitle: 'Arabic - Alphabet - Numbers',
                      icon: '    ⭐',
                      bgColor: const Color(0xFFE8F5E9),
                      height: cardHeight,
                      onTap: () {
                        Get.to(() => LevelOneScreen());
                      },
                    ),

                    SizedBox(height: gap),

                    /// Level 2
                    _buildLevelCard(
                      title: 'Level 2',
                      subtitle: 'Day - Months - Colour',
                      icon: '🚀',
                      bgColor: const Color(0xFFFCE4EC),
                      height: cardHeight,
                      onTap: () {
                        Get.to(() => LevelTwoScreen());
                      },
                    ),

                    SizedBox(height: gap),

                    /// Level 3
                    _buildLevelCard(
                      title: 'Level 3',
                      subtitle: 'Animals - Shapes - Daily Life',
                      icon: '    👑',
                      bgColor: const Color(0xFFE3F2FD),
                      height: cardHeight,
                      onTap: () {
                        Get.to(() => LevelThreeScreen());
                      },
                    ),
                  ],
                ),
              );
            },
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
    double height = 130,
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
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(icon, style: TextStyle(fontFamily: 'Poppins', fontSize: 50)),
              SizedBox(width: 20),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// Title
                  Text(
                    title,
                    style: TextStyle(fontFamily: 'Poppins',
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),

                  SizedBox(height: 4),/// Subtitle
                  Text(
                    subtitle,
                    style: TextStyle(fontFamily: 'Poppins',
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