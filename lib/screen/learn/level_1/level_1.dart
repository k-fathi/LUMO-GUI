import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kids_world_app/screen/learn/level_1/alphabet_learning_screen.dart';
import 'package:kids_world_app/screen/learn/level_1/arabic_learn_screen.dart';
import 'package:kids_world_app/screen/learn/level_1/number_learn_screen.dart';

import 'kids_quiz_screen-1.dart';



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
            Text('⭐', style: TextStyle(fontFamily: 'Poppins', fontSize: 28)),
            SizedBox(width: 10),
            Text(
              'Level 1',
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
        // LayoutBuilder lets us size each card (and the quiz button) as a
        // fraction of the actual available height, so all content fits on
        // small screens (like the Raspberry Pi display) without scrolling.
        child: LayoutBuilder(
          builder: (context, constraints) {
            const verticalPadding = 24.0; // top+bottom padding total
            const cardGap = 20.0; // space between cards (3 cards -> 2 gaps)
            const quizGap = 40.0; // space before quiz button (original SizedBox(height: 40))
            const trailingGap = 20.0; // space after quiz button (original SizedBox(height: 20))
            const quizButtonHeight = 60.0; // original fixed height of quiz button

            final reserved = verticalPadding + (cardGap * 2) + quizGap + quizButtonHeight + trailingGap;
            final availableForCards = constraints.maxHeight - reserved;
            // Keep a sensible minimum/maximum so cards never look too
            // squashed or oversized; SingleChildScrollView below remains
            // as a safety net for any leftover overflow.
            final cardHeight = (availableForCards / 3).clamp(70.0, 120.0);

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                children: [
                  /// Arabic
                  _buildCard(
                    title: "Arabic",
                    image: "assets/images/arabic_icon.png",
                    color: const Color(0xFFE8F5E9),
                    height: cardHeight,
                    onTap: () {
                      Get.to(() => const ArabicLearnScreen());
                    },
                  ),

                  SizedBox(height: cardGap),

                  /// Alphabet
                  _buildCard(
                    title: "Alphabet",
                    image: "assets/images/alphabet_icon.png",
                    color: const Color(0xFFFCE4EC),
                    height: cardHeight,
                    onTap: () {
                      Get.to(() => const AlphabetLearningScreen());
                    },
                  ),

                  SizedBox(height: cardGap),

                  /// Numbers
                  _buildCard(
                    title: "Numbers",
                    image: "assets/images/number_icon.png",
                    color: const Color(0xFFE3F2FD),
                    height: cardHeight,
                    onTap: () {
                      Get.to(() => const NumberLearnScreen());
                    },
                  ),

                  SizedBox(height: quizGap),

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
                          height: quizButtonHeight,
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
                              style: TextStyle(fontFamily: 'Poppins', 
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

                  SizedBox(height: trailingGap),
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
