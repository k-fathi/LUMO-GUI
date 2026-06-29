import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NumberLearnScreen extends StatefulWidget {
  const NumberLearnScreen({super.key});

  @override
  State<NumberLearnScreen> createState() => _NumberLearnScreenState();
}

class _NumberLearnScreenState extends State<NumberLearnScreen>
    with SingleTickerProviderStateMixin {
  int? selectedNumber;
  late AnimationController _animationController;

  late final List<Map<String, dynamic>> numbers;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    numbers = List.generate(100, (index) {
      final number = index + 1;
      final color = _getColorForNumber(number);
      return {'number': number, 'color': color};
    });
  }

  Color _getColorForNumber(int number) {
    final colors = [
      const Color(0xFFFF6B9D),
      const Color(0xFF4ECDC4),
      const Color(0xFFFFA07A),
      const Color(0xFF95E1D3),
      const Color(0xFFFCB040),
      const Color(0xFFE17055),
      const Color(0xFF6C5CE7),
      const Color(0xFF00B894),
      const Color(0xFFFD79A8),
      const Color(0xFF74B9FF),
      const Color(0xFFFF7675),
      const Color(0xFFA29BFE),
      const Color(0xFF55EFC4),
      const Color(0xFFFFBE76),
      const Color(0xFF81ECEC),
    ];
    return colors[(number - 1) % colors.length];
  }

  Future<void> _speak(int number) async {
    setState(() {
      selectedNumber = number;
    });
    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    final String numberString = number.toString();
    final List<String> args = ['-s', '165', '-p', '70', '-v', 'en-us+f4', numberString];

    try {
      if (Platform.isWindows) {
        await Process.run('espeak', args);
      } else if (Platform.isLinux) {
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
              const Color(0xFF4ECDC4).withValues(alpha: 0.1),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView( // ✅ التغيير الأول
            child: Column(
              children: [
                _buildHeader(),
                _buildInstructions(),
                _buildNumberGrid(), // ✅ شيلنا Expanded
              ],
            ),
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
              child: Icon(Icons.arrow_back, color: Color(0xFF4ECDC4)),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Learn Numbers',
                  style: TextStyle(fontFamily: 'Poppins',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2D3436),
                  ),
                ),
                Text(
                  'Tap any number to hear it!',
                  style: TextStyle(fontFamily: 'Poppins',
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
              color: const Color(0xFF4ECDC4),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4ECDC4).withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(Icons.volume_up, color: Colors.white, size: 24),
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
          colors: [Color(0xFF4ECDC4), Color(0xFF00B894)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4ECDC4).withValues(alpha: 0.3),
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
            child: Icon(Icons.touch_app, color: Colors.white, size: 28),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Touch any number to hear it count!',
              style: TextStyle(fontFamily: 'Poppins',
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

  Widget _buildNumberGrid() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(), // ✅ التغيير الثاني
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemCount: numbers.length,
          itemBuilder: (context, index) {
            final item = numbers[index];
            final number = item['number'] as int;
            final color = item['color'] as Color;
            final isSelected = selectedNumber == number;

            return _buildNumberCard(number, color, isSelected);
          },
        ),
      ),
    );
  }

  Widget _buildNumberCard(int number, Color color, bool isSelected) {
    return GestureDetector(
      onTap: () => _speak(number),
      child: AnimatedScale(
        scale: isSelected ? 1.15 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color, color.withValues(alpha: 0.7)],
            ),
            borderRadius: BorderRadius.circular(16),
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
                  borderRadius: BorderRadius.circular(16),
                  child: CustomPaint(
                    painter: NumberCardPatternPainter(
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                ),
              ),
              Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      number.toString(),
                      style: TextStyle(fontFamily: 'Poppins',
                        fontSize: number >= 100 ? 24 : (number >= 10 ? 28 : 32),
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
              if (isSelected)
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.all(3),
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
                    child: Icon(Icons.volume_up, size: 12, color: color),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class NumberCardPatternPainter extends CustomPainter {
  final Color color;

  NumberCardPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (double i = -size.height; i < size.width; i += 15) {
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