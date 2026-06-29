import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ArabicLearnScreen extends StatefulWidget {
  const ArabicLearnScreen({super.key});

  @override
  State<ArabicLearnScreen> createState() => _ArabicLearnScreenState();
}

class _ArabicLearnScreenState extends State<ArabicLearnScreen>
    with SingleTickerProviderStateMixin {
  String? selectedLetter;
  late AnimationController _animationController;

  final List<Map<String, dynamic>> arabicLetters = [
    {'letter': 'ا', 'name': 'Alif', 'color': const Color(0xFF00B894)},
    {'letter': 'ب', 'name': 'pa', 'color': const Color(0xFF6C5CE7)},
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
    setState(() {
      selectedLetter = letter;
    });

    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    final List<String> args = ['-s', '165', '-p', '70', '-v', 'en-us+f4', name];

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
              const Color(0xFF00B894).withValues(alpha: 0.1),
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
                _buildArabicLetterGrid(), // ✅ شيلنا Expanded
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
              child: Icon(Icons.arrow_back, color: Color(0xFF00B894)),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'تعلم الحروف العربية',
                  style: TextStyle(fontFamily: 'Poppins',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2D3436),
                  ),
                  textDirection: TextDirection.rtl,
                ),
                Text(
                  'Tap any letter to hear it!',
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
              color: const Color(0xFF00B894),
              borderRadius: BorderRadius.circular(12),
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
          colors: [Color(0xFF00B894), Color(0xFF00D2A0)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Text(
            'أ',
            style: TextStyle(fontFamily: 'Poppins',
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Touch any letter to hear its sound!',
              style: TextStyle(fontFamily: 'Poppins', color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArabicLetterGrid() {
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
      ),
    );
  }

  Widget _buildLetterCard(String letter, String name, Color color, bool isSelected) {
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
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  letter,
                  style: TextStyle(fontFamily: 'Poppins',
                    fontSize: 48,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}