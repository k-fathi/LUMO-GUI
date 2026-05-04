import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class AnimalLearnScreen extends StatefulWidget {
  const AnimalLearnScreen({super.key});

  @override
  State<AnimalLearnScreen> createState() => _AnimalLearnScreenState();
}

class _AnimalLearnScreenState extends State<AnimalLearnScreen> with SingleTickerProviderStateMixin {
  final FlutterTts flutterTts = FlutterTts();
  String? selectedAnimal;
  late AnimationController _animationController;

  // Animals for kids to learn with emojis
  final List<Map<String, dynamic>> animals = [
    {'name': 'Dog', 'emoji': '🐕', 'color': const Color(0xFFFF6B9D)},
    {'name': 'Cat', 'emoji': '🐱', 'color': const Color(0xFF4ECDC4)},
    {'name': 'Lion', 'emoji': '🦁', 'color': const Color(0xFFFFA07A)},
    {'name': 'Tiger', 'emoji': '🐯', 'color': const Color(0xFF95E1D3)},
    {'name': 'Elephant', 'emoji': '🐘', 'color': const Color(0xFFFCB040)},
    {'name': 'Monkey', 'emoji': '🐵', 'color': const Color(0xFFE17055)},
    {'name': 'Bear', 'emoji': '🐻', 'color': const Color(0xFF6C5CE7)},
    {'name': 'Rabbit', 'emoji': '🐰', 'color': const Color(0xFF00B894)},
    {'name': 'Fox', 'emoji': '🦊', 'color': const Color(0xFFFD79A8)},
    {'name': 'Panda', 'emoji': '🐼', 'color': const Color(0xFF74B9FF)},
    {'name': 'Cow', 'emoji': '🐄', 'color': const Color(0xFFFF7675)},
    {'name': 'Pig', 'emoji': '🐷', 'color': const Color(0xFFA29BFE)},
    {'name': 'Horse', 'emoji': '🐴', 'color': const Color(0xFF55EFC4)},
    {'name': 'Sheep', 'emoji': '🐑', 'color': const Color(0xFFFFBE76)},
    {'name': 'Giraffe', 'emoji': '🦒', 'color': const Color(0xFF81ECEC)},
    {'name': 'Zebra', 'emoji': '🦓', 'color': const Color(0xFFFF6B6B)},
    {'name': 'Bird', 'emoji': '🐦', 'color': const Color(0xFFB8E994)},
    {'name': 'Duck', 'emoji': '🦆', 'color': const Color(0xFFFFD700)},
    {'name': 'Chicken', 'emoji': '🐔', 'color': const Color(0xFFFF9500)},
    {'name': 'Penguin', 'emoji': '🐧', 'color': const Color(0xFF5AC8FA)},
    {'name': 'Fish', 'emoji': '🐠', 'color': const Color(0xFF30D5C8)},
    {'name': 'Dolphin', 'emoji': '🐬', 'color': const Color(0xFF007AFF)},
    {'name': 'Butterfly', 'emoji': '🦋', 'color': const Color(0xFFFF2D92)},
    {'name': 'Bee', 'emoji': '🐝', 'color': const Color(0xFFCDDC39)},
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

  Future<void> _speak(String animalName) async {
    setState(() {
      selectedAnimal = animalName;
    });
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
    await flutterTts.speak(animalName);
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
              const Color(0xFFFCB040).withValues(alpha: 0.1),
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
                child: _buildAnimalGrid(),
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
              child: const Icon(Icons.arrow_back, color: Color(0xFFFCB040)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Learn Animals',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2D3436),
                  ),
                ),
                Text(
                  'Tap any animal to hear its name!',
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
              color: const Color(0xFFFCB040),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFCB040).withValues(alpha: 0.3),
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
          colors: [Color(0xFFFCB040), Color(0xFFFF9500)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFCB040).withValues(alpha: 0.3),
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
            child: const Text('🦁', style: TextStyle(fontSize: 28)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Touch any animal to learn its name!',
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

  Widget _buildAnimalGrid() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.9,
        ),
        itemCount: animals.length,
        itemBuilder: (context, index) {
          final item = animals[index];
          final animalName = item['name'] as String;
          final emoji = item['emoji'] as String;
          final color = item['color'] as Color;
          final isSelected = selectedAnimal == animalName;

          return _buildAnimalCard(animalName, emoji, color, isSelected);
        },
      ),
    );
  }

  Widget _buildAnimalCard(String animalName, String emoji, Color color, bool isSelected) {
    return GestureDetector(
      onTap: () => _speak(animalName),
      child: AnimatedScale(
        scale: isSelected ? 1.1 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: color.withValues(alpha: 0.3),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.3),
                blurRadius: isSelected ? 16 : 8,
                offset: const Offset(0, 4),
                spreadRadius: isSelected ? 2 : 0,
              ),
            ],
          ),
          child: Stack(
            children: [
              // Background gradient
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      color.withValues(alpha: 0.08),
                      color.withValues(alpha: 0.02),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              // Decorative circle
              Positioned(
                top: -15,
                right: -15,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withValues(alpha: 0.08),
                  ),
                ),
              ),
              // Animal emoji and name
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animal emoji
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: 42),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      animalName,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF2D3436),
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
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.volume_up,
                      size: 14,
                      color: Colors.white,
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
