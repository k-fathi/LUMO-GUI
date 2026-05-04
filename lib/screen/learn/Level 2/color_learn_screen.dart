import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class ColorLearnScreen extends StatefulWidget {
  const ColorLearnScreen({super.key});

  @override
  State<ColorLearnScreen> createState() => _ColorLearnScreenState();
}

class _ColorLearnScreenState extends State<ColorLearnScreen> with SingleTickerProviderStateMixin {
  final FlutterTts flutterTts = FlutterTts();
  String? selectedColor;
  late AnimationController _animationController;

  // Basic colors for kids to learn
  final List<Map<String, dynamic>> colors = [
    {'name': 'Red', 'color': const Color(0xFFFF3B30)},
    {'name': 'Blue', 'color': const Color(0xFF007AFF)},
    {'name': 'Green', 'color': const Color(0xFF34C759)},
    {'name': 'Yellow', 'color': const Color(0xFFFFCC00)},
    {'name': 'Orange', 'color': const Color(0xFFFF9500)},
    {'name': 'Purple', 'color': const Color(0xFFAF52DE)},
    {'name': 'Pink', 'color': const Color(0xFFFF2D55)},
    {'name': 'Brown', 'color': const Color(0xFF8B4513)},
    {'name': 'Black', 'color': const Color(0xFF000000)},
    {'name': 'White', 'color': const Color(0xFFFFFFFF)},
    {'name': 'Gray', 'color': const Color(0xFF8E8E93)},
    {'name': 'Cyan', 'color': const Color(0xFF5AC8FA)},
    {'name': 'Magenta', 'color': const Color(0xFFFF2D92)},
    {'name': 'Lime', 'color': const Color(0xFFCDDC39)},
    {'name': 'Indigo', 'color': const Color(0xFF5856D6)},
    {'name': 'Teal', 'color': const Color(0xFF30D5C8)},
    {'name': 'Maroon', 'color': const Color(0xFF800000)},
    {'name': 'Gold', 'color': const Color(0xFFFFD700)},
    {'name': 'Silver', 'color': const Color(0xFFC0C0C0)},
    {'name': 'Coral', 'color': const Color(0xFFFF7F50)},
  ];

  @override
  void initState() {
    super.initState();
    _initializeTts();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  Future<void> _initializeTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.2);
  }

  Future<void> _speak(String colorName) async {
    setState(() {
      selectedColor = colorName;
    });
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
    await flutterTts.speak(colorName);
  }

  @override
  void dispose() {
    flutterTts.stop();
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
              const Color(0xFFFFA07A).withValues(alpha: 0.1),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildInstructions(),
              Expanded(
                child: _buildColorGrid(),
              ),
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
              child: const Icon(Icons.arrow_back, color: Color(0xFFFFA07A)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Learn Colors',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2D3436),
                  ),
                ),
                Text(
                  'Tap any color to hear its name!',
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
              color: const Color(0xFFFFA07A),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFA07A).withValues(alpha: 0.3),
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
          colors: [Color(0xFFFFA07A), Color(0xFFFF6B6B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFA07A).withValues(alpha: 0.3),
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
            child: const Icon(Icons.palette, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Touch any color to learn its name!',
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

  Widget _buildColorGrid() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.85,
        ),
        itemCount: colors.length,
        itemBuilder: (context, index) {
          final item = colors[index];
          final colorName = item['name'] as String;
          final color = item['color'] as Color;
          final isSelected = selectedColor == colorName;

          return _buildColorCard(colorName, color, isSelected);
        },
      ),
    );
  }

  Widget _buildColorCard(String colorName, Color color, bool isSelected) {
    // Determine if text should be white or black based on color brightness
    final brightness = color.computeLuminance();
    final textColor = brightness > 0.5 ? Colors.black : Colors.white;
    final borderColor = brightness > 0.8 ? Colors.grey.shade300 : color;

    return GestureDetector(
      onTap: () => _speak(colorName),
      child: AnimatedScale(
        scale: isSelected ? 1.1 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: borderColor,
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.5),
                blurRadius: isSelected ? 20 : 12,
                offset: const Offset(0, 6),
                spreadRadius: isSelected ? 3 : 0,
              ),
            ],
          ),
          child: Stack(
            children: [
              // Decorative circles pattern
              Positioned(
                top: -20,
                right: -20,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
              ),
              Positioned(
                bottom: -30,
                left: -30,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
              ),
              // Color name
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Color swatch icon
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: brightness > 0.5
                            ? Colors.black.withValues(alpha: 0.1)
                            : Colors.white.withValues(alpha: 0.2),
                      ),
                      child: Icon(
                        Icons.palette,
                        size: 30,
                        color: textColor.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      colorName,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                        shadows: [
                          Shadow(
                            color: brightness > 0.5
                                ? Colors.white.withValues(alpha: 0.8)
                                : Colors.black.withValues(alpha: 0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Play icon indicator
              if (isSelected)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: textColor.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.volume_up,
                      size: 16,
                      color: color,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
