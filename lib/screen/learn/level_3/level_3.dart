import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kids_world_app/screen/learn/level_3/daily_life_learn_screen_new.dart';
import 'package:kids_world_app/screen/learn/level_3/shape_learn_screen.dart';
import 'package:kids_world_app/soundsAnimal/animalssounds.dart';

class LevelThreeScreen extends StatelessWidget {
  const LevelThreeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// أيقونة التاج
            Text('👑', style: TextStyle(fontFamily: 'Poppins', fontSize: 28)),

            SizedBox(width: 10),

            Text(
              'Level 3',
              style: TextStyle(fontFamily: 'Poppins', 
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                children: [
                  /// Animals
                  _buildCard(
                    title: "Animals",
                    image: "assets/images/animal_icon.png", // حطي الصورة هنا
                    color: const Color(0xFFE8F5E9),
                    height: cardHeight,
                    onTap: () {
                      Get.to(() => AnimalSoundsScreen());
                    },
                  ),

                  SizedBox(height: gap),

                  /// Shapes
                  _buildCard(
                    title: "Shapes",
                    image: "assets/images/shape_icon.png",
                    color: const Color(0xFFFCE4EC),
                    height: cardHeight,
                    onTap: () {
                      Get.to(() => ShapeLearnScreen());
                    },
                  ),

                  SizedBox(height: gap),

                  /// Daily Life
                  _buildCard(
                    title: "Daily Life",
                    image: "assets/images/daily_life_icon.png",
                    color: const Color(0xFFE3F2FD),
                    height: cardHeight,
                    onTap: () {
                      Get.to(() => DailyLifeLearnScreen());
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

  Widget _buildCard({
    required String title,
    required String image,
    required Color color,
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
          color: color,
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
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Row(
            children: [
              /// الصورة
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Image.asset(image, height: 50, width: 50),
              ),

              SizedBox(width: 20),

              /// النص
              Text(
                title,
                style: TextStyle(fontFamily: 'Poppins', 
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const Spacer(),

              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.black26,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
