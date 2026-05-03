import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'big_or_small_game.dart';

class WhichHasMoreGame extends StatefulWidget {
  const WhichHasMoreGame({super.key});

  @override
  State<WhichHasMoreGame> createState() => _WhichHasMoreGameState();
}

class _WhichHasMoreGameState extends State<WhichHasMoreGame> {
  int score = 0;
  int leftCount = 0;
  int rightCount = 0;
  String currentItem = '🍎';

  final List<String> items = [
    '🍎','🍌','🍊','🍇','🍓','🍉','🍒','🍑','🥝','🍍',
    '⚽','🏀','⚾','🎾','🏐','🎈','🎁','🎀','🎨','🎭',
    '⭐','🌟','✨','💫','🌙','☀️','🌈','🌸','🌺','🌻',
    '🦋','🐝','🐞','🐛','🦄','🐠','🐟','🐬','🐳','🦈',
    '🚗','🚕','🚙','🚌','🚎','🏎️','🚓','🚑','🚒','🚐',
    '❤️','💛','💚','💙','💜','🧡','💖','💗','💝','💕'
  ];

  @override
  void initState() {
    super.initState();
    _generateNewQuestion();
  }

  void _generateNewQuestion() {
    final random = Random();

    leftCount = random.nextInt(8) + 2;
    rightCount = random.nextInt(8) + 2;

    while (leftCount == rightCount) {
      rightCount = random.nextInt(8) + 2;
    }

    currentItem = items[random.nextInt(items.length)];

    setState(() {});
  }

  void _showLevelUpDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                Colors.purple.shade400,
                Colors.blue.shade400
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "🏆",
                style: TextStyle(fontSize: 70),
              ),
              const SizedBox(height: 16),
              const Text(
                "Great Job!",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "You completed Level 1!\nLet's go to Level 2 🎮",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BigOrSmallGame(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Go To Level 2 🚀",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // التعديل هنا: مافيش Dialog بعد الإجابة
  void _checkAnswer(bool leftSelected) {
    final correctAnswer = leftCount > rightCount;
    final isCorrect = leftSelected == correctAnswer;

    if (isCorrect) {
      score++;

      if (score == 10) {
        Future.delayed(const Duration(milliseconds: 300), () {
          _showLevelUpDialog();
        });
      }
    }

    _generateNewQuestion(); // مباشرة نسأل سؤال جديد
  }

  Widget buildItems(int count) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: List.generate(
        count,
            (index) => Text(
          currentItem,
          style: const TextStyle(fontSize: 36),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Which More?',
          style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Score: $score',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade50,
              Colors.purple.shade50,
              Colors.pink.shade50
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.purple.shade300,
                      Colors.blue.shade300
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'Which side has more items?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 32),

              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _checkAnswer(true),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius:
                          BorderRadius.circular(20),
                          border: Border.all(
                              color: Colors.blue,
                              width: 4),
                        ),
                        child: buildItems(leftCount),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: GestureDetector(
                      onTap: () => _checkAnswer(false),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.pink.shade100,
                          borderRadius:
                          BorderRadius.circular(20),
                          border: Border.all(
                              color: Colors.pink,
                              width: 4),
                        ),
                        child: buildItems(rightCount),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              const Text(
                '👆 Tap the side with MORE items! 👆',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}