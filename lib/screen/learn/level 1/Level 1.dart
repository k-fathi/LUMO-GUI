 import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Quiz 1.dart';
import 'alphabet_learning_screen.dart';
import 'arabic_learn_screen.dart';
import 'number_learn_screen.dart';

class LevelOneScreen extends StatelessWidget {
  const LevelOneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('⭐', style: TextStyle(fontSize: 28)),
            const SizedBox(width: 10),
            Text(
              'Level 1',
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
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
          onPressed: () => Get.back(),
        ),
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              /// Arabic
              _buildCard(
                title: "Arabic",
                image: "assets/images/arabic_icon.png",
                color: const Color(0xFFE8F5E9),
                onTap: () {
                  Get.to(() => const ArabicLearnScreen());
                },
              ),

              const SizedBox(height: 20),

              /// Alphabet
              _buildCard(
                title: "Alphabet",
                image: "assets/images/alphabet_icon.png",
                color: const Color(0xFFFCE4EC),
                onTap: () {
                  Get.to(() => const AlphabetLearningScreen());
                },
              ),

              const SizedBox(height: 20),

              /// Numbers
              _buildCard(
                title: "Numbers",
                image: "assets/images/number_icon.png",
                color: const Color(0xFFE3F2FD),
                onTap: () {
                  Get.to(() => const NumberLearnScreen());
                },
              ),

              const SizedBox(height: 40),

              /// Quiz Button
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0.9, end: 1),
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  return Transform.scale(scale: value, child: child);
                },
                child: Center(
                  child: InkWell(
                    onTap: () {
                      Get.to(() => const KidsQuizScreen());
                    },
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width * 0.5,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3E0),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange.withOpacity(0.35),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          "Quiz 💪🏻",
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
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
                child: Image.asset(image, height: 50, width: 50),
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
