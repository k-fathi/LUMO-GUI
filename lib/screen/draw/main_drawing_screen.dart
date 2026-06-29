import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'coloring_screen.dart';
import 'free_draw_screen.dart';

class MainDrawingScreen extends StatelessWidget {
  const MainDrawingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox.expand(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(Icons.arrow_back),
                          ),
                        ),

                        SizedBox(width: 24),

                        Text(
                          'Draw & Learn',
                          style: TextStyle(fontFamily: 'Poppins',  
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 30),

                /// ✅ الكارتين في المنتصف
                Expanded(
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 180,
                          height: 180,
                          child: _buildCategoryCard(
                            title: 'Drawing',
                            icon: '🎨',
                            bgColor: const Color(0xFFE8F5E9),
                            onTap: () {
                              Get.to(
                                () => const FreeDrawScreen(),
                                transition: Transition.fadeIn,
                              );
                            },
                          ),
                        ),

                        SizedBox(width: 20),

                        SizedBox(
                          width: 180,
                          height: 180,
                          child: _buildCategoryCard(
                            title: 'Coloring',
                            icon: '🎨🖌️',
                            bgColor: const Color(0xFFFFF3E0),
                            onTap: () {
                              Get.to(
                                () => const ColoringScreen(),
                                transition: Transition.fadeIn,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard({
    required String title,
    required String icon,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: TextStyle(fontFamily: 'Poppins', fontSize: 60)),

            SizedBox(height: 10),

            Text(
              title,
              style: TextStyle(fontFamily: 'Poppins',  
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
