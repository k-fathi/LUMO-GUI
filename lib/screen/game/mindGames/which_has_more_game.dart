import 'dart:math';
import 'package:flutter/material.dart';

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
                "You completed Level 1!\nLet's go to Level 2 🎮",
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
                child: Text(
                  "Go To Level 2 🚀",
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

  Widget buildItems(int count, [bool isSmall = false]) {
    final emojiSize = isSmall ? 22.0 : 28.0;
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 4,
      runSpacing: 4,
      children: List.generate(
        count,
        (index) => Text(
          currentItem,
          style: TextStyle(fontFamily: 'Poppins', fontSize: emojiSize),
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
          style: TextStyle(fontFamily: 'Poppins',  
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
                style: TextStyle(fontFamily: 'Poppins', 
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
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final sw = MediaQuery.of(context).size.width;
                  final sh = MediaQuery.of(context).size.height;
                  final isSmall = sw < 360;
                  final isShort = sh < 700;
                  final questionFontSize = isSmall ? 17.0 : (isShort ? 19.0 : 21.0);
                  final hintFontSize = isSmall ? 13.0 : 15.0;
                  final cardPadding = isSmall ? 12.0 : 16.0;

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            horizontal: 16, vertical: cardPadding),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.purple.shade300,
                              Colors.blue.shade300,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.purple.shade200,
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          'Which side has more items?',
                          style: TextStyle(fontFamily: 'Poppins', 
                            fontSize: questionFontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      SizedBox(height: isShort ? 16 : 24),

                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _checkAnswer(true),
                                child: Container(
                                  padding: EdgeInsets.all(cardPadding),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade100,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: Colors.blue, width: 3),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blue.shade200,
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: buildItems(leftCount, isSmall),
                                ),
                              ),
                            ),

                            SizedBox(width: 12),

                            Expanded(
                              child: GestureDetector(
                                onTap: () => _checkAnswer(false),
                                child: Container(
                                  padding: EdgeInsets.all(cardPadding),
                                  decoration: BoxDecoration(
                                    color: Colors.pink.shade100,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: Colors.pink, width: 3),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.pink.shade200,
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: buildItems(rightCount, isSmall),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: isShort ? 16 : 24),

                      Text(
                        '👆 Tap the side with MORE items! 👆',
                        style: TextStyle(fontFamily: 'Poppins', 
                          fontSize: hintFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}