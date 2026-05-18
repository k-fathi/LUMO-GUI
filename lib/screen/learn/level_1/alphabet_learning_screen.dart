import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class AlphabetLearningScreen extends StatefulWidget {
  const AlphabetLearningScreen({super.key});

  @override
  State<AlphabetLearningScreen> createState() => _AlphabetLearningScreenState();
}

class _AlphabetLearningScreenState extends State<AlphabetLearningScreen>
    with SingleTickerProviderStateMixin {
  String? selectedLetter;
  late AnimationController _animationController;

  final List<Map<String, dynamic>> alphabets = [
    {'letter': 'A', 'color': const Color(0xFFFF6B9D)},
    {'letter': 'B', 'color': const Color(0xFF4ECDC4)},
    {'letter': 'C', 'color': const Color(0xFFFFA07A)},
    {'letter': 'D', 'color': const Color(0xFF95E1D3)},
    {'letter': 'E', 'color': const Color(0xFFFCB040)},
    {'letter': 'F', 'color': const Color(0xFFE17055)},
    {'letter': 'G', 'color': const Color(0xFF6C5CE7)},
    {'letter': 'H', 'color': const Color(0xFF00B894)},
    {'letter': 'I', 'color': const Color(0xFFFD79A8)},
    {'letter': 'J', 'color': const Color(0xFF74B9FF)},
    {'letter': 'K', 'color': const Color(0xFFFF7675)},
    {'letter': 'L', 'color': const Color(0xFFA29BFE)},
    {'letter': 'M', 'color': const Color(0xFF55EFC4)},
    {'letter': 'N', 'color': const Color(0xFFFFBE76)},
    {'letter': 'O', 'color': const Color(0xFF81ECEC)},
    {'letter': 'P', 'color': const Color(0xFFFF6B6B)},
    {'letter': 'Q', 'color': const Color(0xFFB8E994)},
    {'letter': 'R', 'color': const Color(0xFFFF6B9D)},
    {'letter': 'S', 'color': const Color(0xFF4ECDC4)},
    {'letter': 'T', 'color': const Color(0xFFFFA07A)},
    {'letter': 'U', 'color': const Color(0xFF95E1D3)},
    {'letter': 'V', 'color': const Color(0xFFFCB040)},
    {'letter': 'W', 'color': const Color(0xFFE17055)},
    {'letter': 'X', 'color': const Color(0xFF6C5CE7)},
    {'letter': 'Y', 'color': const Color(0xFF00B894)},
    {'letter': 'Z', 'color': const Color(0xFFFD79A8)},
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  Future<void> _speak(String letter) async {
    setState(() {
      selectedLetter = letter;
    });
    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    // الإعدادات المطلوبة: السرعة 165، الـ Pitch 70، والصوت الأنثوي f4
    final List<String> args = ['-s', '165', '-p', '70', '-v', 'en-us+f4', letter];

    try {
      if (Platform.isWindows) {
        await Process.run('espeak', args);
      } else if (Platform.isLinux) {
        // تشغيل espeak-ng الافتراضي على لينكس / راسبيري باي
        ProcessResult result = await Process.run('espeak-ng', args);
        if (result.exitCode != 0) {
          await Process.run('espeak', args);
        }
      }
    } catch (e) {
      debugPrint("eSpeak Error: $e");
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF6C5CE7).withValues(alpha: 0.1),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildInstructions(),
              Expanded(child: _buildAlphabetGrid()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.arrow_back, color: Color(0xFF6C5CE7)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Learn Alphabets',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2D3436),
                  ),
                ),
                Text(
                  'Tap any letter to hear it!',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: const Color(0xFF636E72),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF6C5CE7),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6C5CE7).withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(Icons.volume_up, color: Colors.white, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructions() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C5CE7), Color(0xFF5F27CD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C5CE7).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.touch_app, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Touch any letter to hear its sound!',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlphabetGrid() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemCount: alphabets.length,
          itemBuilder: (context, index) {
            final item = alphabets[index];
            final letter = item['letter'] as String;
            final color = item['color'] as Color;
            final isSelected = selectedLetter == letter;

            return _buildLetterCard(letter, color, isSelected);
          },
        ),
      ),
    );
  }

  Widget _buildLetterCard(String letter, Color color, bool isSelected) {
    return GestureDetector(
      onTap: () => _speak(letter),
      child: AnimatedScale(
        scale: isSelected ? 1.1 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color, color.withValues(alpha: 0.7)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.4),
                blurRadius: isSelected ? 16 : 8,
                offset: const Offset(0, 4),
                spreadRadius: isSelected ? 2 : 0,
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CustomPaint(
                    painter: LetterCardPatternPainter(
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            letter,
                            style: GoogleFonts.poppins(
                              fontSize: 48,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        letter.toLowerCase(),
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
              if (isSelected)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(Icons.volume_up, size: 16, color: color),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class LetterCardPatternPainter extends CustomPainter {
  final Color color;

  LetterCardPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (double i = -size.height; i < size.width; i += 20) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}