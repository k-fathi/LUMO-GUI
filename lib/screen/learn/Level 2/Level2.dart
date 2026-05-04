import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


import 'Quiz2.dart';
import 'color_learn_screen.dart';
import 'day_learn_screen.dart';
import 'month_learn_screen.dart';

class LevelTwoScreen extends StatelessWidget {
  const LevelTwoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '🚀',
              style: TextStyle(fontSize: 28),
            ),
            const SizedBox(width: 10),
            Text(
              'Level 2',
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

              /// Day
              _buildCard(
                title: "Day",
                image: "assets/images/day_icon.png",
                color: const Color(0xFFE8F5E9),
                onTap: () {
                  Get.to(() => DayLearnScreen());
                },
              ),

              const SizedBox(height: 20),

              /// Months
              _buildCard(
                title: "Months",
                image: "assets/images/month_icon.png",
                color: const Color(0xFFFCE4EC),
                onTap: () {
                  Get.to(() => MonthLearnScreen());
                },
              ),

              const SizedBox(height: 20),

              /// Colour
              _buildCard(
                title: "Colour",
                image: "assets/images/colors_icon.png",
                color: const Color(0xFFE3F2FD),
                onTap: () {
                  Get.to(() => ColorLearnScreen());
                },
              ),

              const SizedBox(height: 40),

              /// Quiz Button
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0.9, end: 1),
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: child,
                  );
                },
                child: Center(
                  child: InkWell(
                    onTap: () {
                      Get.to(() => const KidsQuizScreen2());
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

              /// icon
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

              /// title
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