import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
// تأكدي من عمل import لشاشة WordGameScreen
import 'package:kids_world_app/screen/game/learning_games/word_game_screen.dart';

class CountChooseGame extends StatefulWidget {
  const CountChooseGame({super.key});

  @override
  State<CountChooseGame> createState() => _CountChooseGameState();
}

class _CountChooseGameState extends State<CountChooseGame> {
  int score = 0;
  final int winningScore = 10; // finish the game after 10 correct answers
  int correctAnswer = 0;
  String currentItem = '⭐';
  late List<int> options;
  // expanded list of items for more variety
  final List<String> items = [
    '⭐', '🎈', '🍎', '🌸', '🦋', '⚽', '🍌', '🍊', '🍇', '🍓',
    '🍉', '🍒', '🍍', '🍑', '🥝', '🐶', '🐱', '🐭', '🐰', '🦊',
    '🐻', '🐼', '🐯', '🦁', '🐵', '🚗', '🚕', '🚙', '🚌', '🏎️',
    '🚓', '🚑', '🚒', '✈️', '🚀', '🌈', '☀️', '🌙', '🍰', '🍩',
    '🎂', '🎁', '🎵', '🔔', '🎈', '🔷', '🔶', '🔺', '🔵', '⚫',
  ];

  @override
  void initState() {
    super.initState();
    _generateQuestion();
  }

  void _generateQuestion() {
    final random = Random();
    correctAnswer = random.nextInt(8) + 3;
    currentItem = items[random.nextInt(items.length)];

    options = [correctAnswer];
    while (options.length < 4) {
      final opt = random.nextInt(8) + 3;
      if (!options.contains(opt)) options.add(opt);
    }
    options.shuffle();
    setState(() {});
  }

  void _checkAnswer(int selected) {
    if (selected == correctAnswer) {
      score++;
      // if reached winning score, show GetX dialog instead of scheduling a new question
      if (score >= winningScore) {
        // show celebratory dialog
        Get.dialog(
          Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: const LinearGradient(
                  colors: [Color(0xFF00C9FF), Color(0xFF92FE9D)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.celebration, size: 56, color: Colors.white),
                  const SizedBox(height: 12),
                  Text(
                    'Well done!',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You completed Level One!\nReady for Level Two?',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Get.back(); // إغلاق الديالوج
                          // الانتقال للمستوى الثاني (Word Game)
                          Get.off(() => const WordGameScreen());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF00C9FF),
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text('Level Two', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton(
                        onPressed: () {
                          Get.back();
                          setState(() {
                            score = 0;
                            _generateQuestion();
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white70),
                          foregroundColor: Colors.white,
                        ),
                        child: Text('Restart', style: GoogleFonts.poppins(color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          barrierDismissible: false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Correct! 🎉'), backgroundColor: Colors.green, duration: Duration(milliseconds: 800)),
        );
        Future.delayed(const Duration(milliseconds: 900), _generateQuestion);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Count again! 💪'), backgroundColor: Colors.orange, duration: Duration(milliseconds: 800)),
      );
      // Removed Future.delayed _generateQuestion here to let the user try again on the same question
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Count & Choose',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text('Score: $score', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Count the items!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.blue, width: 2),
                ),
                child: SingleChildScrollView(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 12,
                    runSpacing: 12,
                    children: List.generate(correctAnswer, (index) => Text(currentItem, style: const TextStyle(fontSize: 40))),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Text('How many?', style: TextStyle(fontSize: 18, color: Colors.grey)),
              const SizedBox(height: 16),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: options.map((number) {
                  return GestureDetector(
                    onTap: () => _checkAnswer(number),
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green, width: 3),
                      ),
                      child: Center(
                        child: Text(
                          number.toString(),
                          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}