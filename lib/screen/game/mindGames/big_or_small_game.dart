import 'dart:math';
import 'package:flutter/material.dart';

import 'funny_ball_game.dart';

class BigOrSmallGame extends StatefulWidget {
  const BigOrSmallGame({super.key});

  @override
  State<BigOrSmallGame> createState() => _BigOrSmallGameState();
}

class _BigOrSmallGameState extends State<BigOrSmallGame> {
  int score = 0;
  double leftSize = 100;
  double rightSize = 100;
  String currentItem = '⚽';
  final List<String> items = [
    '⚽', '🏀', '⚾', '🎾', '🏐', '🎈', '🎁', '🎀', '🎨', '🎭',
    '⭐', '🌟', '✨', '💫', '🌙', '☀️', '🌈', '🌸', '🌺', '🌻',
    '🦋', '🐝', '🐞', '🐛', '🦄', '🐠', '🐟', '🐬', '🐳', '🦈',
    '🍎', '🍌', '🍊', '🍇', '🍓', '🍉', '🍒', '🍑', '🥝', '🍍',
    '🚗', '🚕', '🚙', '🚌', '🚎', '🏎️', '🚓', '🚑', '🚒', '🚐',
    '❤️','💛','💚','💙','💜','🧡','💖','💗','💝','💕'
  ];

  @override
  void initState() {
    super.initState();
    _generateNewQuestion();
  }

  void _generateNewQuestion() {
    final random = Random();
    leftSize = random.nextInt(100) + 80.0;
    rightSize = random.nextInt(100) + 80.0;
    while ((leftSize - rightSize).abs() < 30) {
      rightSize = random.nextInt(100) + 80.0;
    }
    currentItem = items[random.nextInt(items.length)];
    setState(() {});
  }

  void _checkAnswer(bool leftSelected) {
    final correctAnswer = leftSize > rightSize;
    final isCorrect = leftSelected == correctAnswer;

    if (isCorrect) {
      score++;
    }

    // Level Up Dialog للـ Level 3
    if (score >= 10) {
      Future.delayed(const Duration(milliseconds: 300), () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
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
                  Text(
                    "🏆",
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 70),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Great Job!",
                    style: TextStyle(fontFamily: 'Poppins', 
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "You completed Level 2!\nLet's go to Level 3 🎮",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: 'Poppins', 
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FunnyBallGame()),
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
                    child: Text(
                      "Go To Level 3 🚀",
                      style: TextStyle(fontFamily: 'Poppins', 
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
      });
      return;
    }

    _generateNewQuestion(); // السؤال الجديد يظهر مباشرة
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final isSmall = sw < 360;
    final isShort = sh < 700;
    // Scale emoji sizes down so they fit side-by-side on small screens
    final scaleFactor = isSmall ? 0.40 : (isShort ? 0.48 : 0.55);
    final displayLeft = (leftSize * scaleFactor).clamp(30.0, 90.0);
    final displayRight = (rightSize * scaleFactor).clamp(30.0, 90.0);

    return Scaffold(
      appBar: AppBar(
        title: Text('Which Big?',
            style: TextStyle(fontFamily: 'Poppins', 
                
                fontSize: isSmall ? 18 : 22,
                fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Score: $score',
                style: TextStyle(fontFamily: 'Poppins', 
                  fontSize: isSmall ? 14 : 16,
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
              Colors.orange.shade50,
              Colors.pink.shade50,
              Colors.purple.shade50,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isSmall ? 12 : 16,
                vertical: isShort ? 8 : 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Question header
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                        horizontal: 16, vertical: isShort ? 10 : 14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.orange.shade300, Colors.pink.shade300],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.shade200,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      'Which one is BIGGER?',
                      style: TextStyle(fontFamily: 'Poppins', 
                        fontSize: isSmall ? 16.0 : (isShort ? 18.0 : 20.0),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  SizedBox(height: isShort ? 10 : 16),

                  // Hint
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 14, vertical: isShort ? 6 : 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      'Tap the BIGGER one! 👇',
                      style: TextStyle(fontFamily: 'Poppins', 
                        fontSize: isSmall ? 13.0 : 15.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.deepOrange,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  SizedBox(height: isShort ? 20 : 32),

                  // Two circles side by side
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Left circle
                      GestureDetector(
                        onTap: () => _checkAnswer(true),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.blue.shade200, Colors.blue.shade100],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.blue.shade400, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.shade300,
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Text(
                            currentItem,
                            style: TextStyle(fontFamily: 'Poppins', fontSize: displayLeft),
                          ),
                        ),
                      ),

                      // VS label
                      Text(
                        'VS',
                        style: TextStyle(fontFamily: 'Poppins', 
                          fontSize: isSmall ? 16 : 20,
                          fontWeight: FontWeight.w900,
                          color: Colors.deepPurple.shade300,
                        ),
                      ),

                      // Right circle
                      GestureDetector(
                        onTap: () => _checkAnswer(false),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.pink.shade200, Colors.pink.shade100],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.pink.shade400, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.pink.shade300,
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Text(
                            currentItem,
                            style: TextStyle(fontFamily: 'Poppins', fontSize: displayRight),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: isShort ? 24 : 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}