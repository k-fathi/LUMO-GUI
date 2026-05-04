import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class ArabicLearnScreen extends StatefulWidget {
  const ArabicLearnScreen({super.key});

  @override
  State<ArabicLearnScreen> createState() => _ArabicLearnScreenState();
}

class _ArabicLearnScreenState extends State<ArabicLearnScreen>
    with SingleTickerProviderStateMixin {
  final AudioPlayer audioPlayer = AudioPlayer();
  String? selectedLetter;
  late AnimationController _animationController;

  final List<Map<String, dynamic>> arabicLetters = [
    {'letter': 'ا', 'name': 'Alif', 'color': const Color(0xFF00B894)},
    {'letter': 'ب', 'name': 'Ba', 'color': const Color(0xFF6C5CE7)},
    {'letter': 'ت', 'name': 'Ta', 'color': const Color(0xFFFF6B9D)},
    {'letter': 'ث', 'name': 'Tha', 'color': const Color(0xFF4ECDC4)},
    {'letter': 'ج', 'name': 'Jeem', 'color': const Color(0xFFFFA07A)},
    {'letter': 'ح', 'name': 'Ha', 'color': const Color(0xFF95E1D3)},
    {'letter': 'خ', 'name': 'Kha', 'color': const Color(0xFFFCB040)},
    {'letter': 'د', 'name': 'Dal', 'color': const Color(0xFFE17055)},
    {'letter': 'ذ', 'name': 'Thal', 'color': const Color(0xFFAF52DE)},
    {'letter': 'ر', 'name': 'Ra', 'color': const Color(0xFFFD79A8)},
    {'letter': 'ز', 'name': 'Zay', 'color': const Color(0xFF74B9FF)},
    {'letter': 'س', 'name': 'Seen', 'color': const Color(0xFFFF7675)},
    {'letter': 'ش', 'name': 'Sheen', 'color': const Color(0xFFA29BFE)},
    {'letter': 'ص', 'name': 'Sad', 'color': const Color(0xFF55EFC4)},
    {'letter': 'ض', 'name': 'Dad', 'color': const Color(0xFFFFBE76)},
    {'letter': 'ط', 'name': 'Toa', 'color': const Color(0xFF81ECEC)},
    {'letter': 'ظ', 'name': 'Zoa', 'color': const Color(0xFFFF6B6B)},
    {'letter': 'ع', 'name': 'Ain', 'color': const Color(0xFFB8E994)},
    {'letter': 'غ', 'name': 'Ghain', 'color': const Color(0xFFFFD700)},
    {'letter': 'ف', 'name': 'Fa', 'color': const Color(0xFF30D5C8)},
    {'letter': 'ق', 'name': 'Qaf', 'color': const Color(0xFFFF9500)},
    {'letter': 'ك', 'name': 'Kaf', 'color': const Color(0xFF5AC8FA)},
    {'letter': 'ل', 'name': 'Lam', 'color': const Color(0xFFFF2D92)},
    {'letter': 'م', 'name': 'Meem', 'color': const Color(0xFFCDDC39)},
    {'letter': 'ن', 'name': 'Noon', 'color': const Color(0xFF5856D6)},
    {'letter': 'ه', 'name': 'Haa', 'color': const Color(0xFFFF6B9D)},
    {'letter': 'و', 'name': 'Waw', 'color': const Color(0xFF4ECDC4)},
    {'letter': 'ي', 'name': 'Ya', 'color': const Color(0xFF00B894)},
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  Future<void> _speak(String letter, String name) async {
    await audioPlayer.stop();

    setState(() {
      selectedLetter = letter;
    });

    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    // اسم الملف لازم يطابق name
    String fileName = name.toLowerCase();

    await audioPlayer.play(AssetSource('sounds/$fileName.mp3'));
  }

  @override
  void dispose() {
    audioPlayer.dispose();
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
              const Color(0xFF00B894).withValues(alpha: 0.1),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildInstructions(),
              Expanded(child: _buildArabicLetterGrid()),
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
              child: const Icon(Icons.arrow_back, color: Color(0xFF00B894)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'تعلم الحروف العربية',
                  style: GoogleFonts.notoNaskhArabic(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2D3436),
                  ),
                  textDirection: TextDirection.rtl,
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
              color: const Color(0xFF00B894),
              borderRadius: BorderRadius.circular(12),
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
          colors: [Color(0xFF00B894), Color(0xFF00D2A0)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Text(
            'أ',
            style: GoogleFonts.notoNaskhArabic(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Touch any letter to hear its sound!',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArabicLetterGrid() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: arabicLetters.length,
        itemBuilder: (context, index) {
          final item = arabicLetters[index];
          return _buildLetterCard(
            item['letter'],
            item['name'],
            item['color'],
            selectedLetter == item['letter'],
          );
        },
      ),
    );
  }

  Widget _buildLetterCard(
    String letter,
    String name,
    Color color,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () => _speak(letter, name),
      child: AnimatedScale(
        scale: isSelected ? 1.1 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              letter,
              style: GoogleFonts.notoNaskhArabic(
                fontSize: 48,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
