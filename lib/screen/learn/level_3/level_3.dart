import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kids_world_app/screen/learn/level_3/animal_learn_screen.dart';
import 'package:kids_world_app/screen/learn/level_3/daily_life_learn_screen_new.dart';
import 'package:kids_world_app/screen/learn/level_3/shape_learn_screen.dart';

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
            const Text(
              '👑',
              style: TextStyle(fontSize: 28),
            ),

            const SizedBox(width: 10),

            Text(
              'Level 3',
              style: GoogleFonts.poppins(
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
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [

              /// Animals
              _buildCard(
                title: "Animals",
                image: "assets/images/animal_icon.png", // حطي الصورة هنا
                color: const Color(0xFFE8F5E9),
                onTap: () {
                  Get.to(() => AnimalLearnScreen());
                },
              ),

              const SizedBox(height: 20),

              /// Shapes
              _buildCard(
                title: "Shapes",
                image: "assets/images/shape_icon.png",
                color: const Color(0xFFFCE4EC),
                onTap: () {
                  Get.to(() => ShapeLearnScreen());
                },
              ),

              const SizedBox(height: 20),

              /// Daily Life
              _buildCard(
                title: "Daily Life",
                image: "assets/images/daily_life_icon.png",
                color: const Color(0xFFE3F2FD),
                onTap: () {
                  Get.to(() => DailyLifeLearnScreen());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String image,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        width: double.infinity,
        height: 120,
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
                child: Image.asset(
                  image,
                  height: 50,
                  width: 50,
                ),
              ),

              const SizedBox(width: 20),

              /// النص
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const Spacer(),

              const Icon(
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