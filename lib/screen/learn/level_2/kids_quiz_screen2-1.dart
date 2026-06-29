import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

import '../level_2/color_learn_screen.dart';
import '../level_2/day_learn_screen.dart';
import '../level_2/month_learn_screen.dart';
import '../level_3/level_3.dart';

class KidsQuizScreen2 extends StatefulWidget {
  const KidsQuizScreen2({super.key});

  @override
  State<KidsQuizScreen2> createState() => _KidsQuizScreen2State();
}

class _KidsQuizScreen2State extends State<KidsQuizScreen2> {
  int currentQuestion = 0;
  int score = 0;
  bool showFeedback = false;
  String? selectedAnswer;

  late List<Question> questions;

  @override
  void initState() {
    super.initState();
    questions = generateQuestions(5);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      playCurrentSound();
    });
  }

  void playCurrentSound() async {
    final text = questions[currentQuestion].correct.display;
    final List<String> args = ['-s', '165', '-p', '70', '-v', 'en-us+f4', text];
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

  void handleAnswer(QuizItem option) {
    if (showFeedback) return;

    setState(() {
      selectedAnswer = option.display;
      showFeedback = true;
      bool isCorrect = option.display == questions[currentQuestion].correct.display;

      Timer(const Duration(seconds: 2), () {
        if (isCorrect) {
          score += 10;
          if (score >= 50) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LevelThreeScreen()),
            );
            return;
          }

          if (currentQuestion < questions.length - 1) {
            setState(() {
              currentQuestion++;
              selectedAnswer = null;
              showFeedback = false;
            });
            playCurrentSound();
          }
        } else {
          final currentType = questions[currentQuestion].type;
          Widget screen;
          if (currentType == 'color') {
            screen = const ColorLearnScreen();
          } else if (currentType == 'day') {
            screen = const DayLearnScreen();
          } else {
            screen = const MonthLearnScreen();
          }
          Future.delayed(const Duration(milliseconds: 500), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => screen),
            );
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentQ = questions[currentQuestion];

    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ===== Header (تم توحيد تصميمه ليعمل أوفلاين على الراسبيري) =====
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Icon(Icons.arrow_back, color: Colors.blue, size: 24),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.blue.shade200, width: 1.5),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    "Kids Learning Quiz 🎯",
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF2D3436),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "Question ${currentQuestion + 1} / ${questions.length}",
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF636E72),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF00B894), Color(0xFF00D2A0)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Score",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          "$score",
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // ===== Speaker Button =====
              GestureDetector(
                onTap: () => playCurrentSound(),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Colors.purple, Colors.pink]),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pink.withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.volume_up, size: 40, color: Colors.white),
                ),
              ),

              const SizedBox(height: 12),

              // ===== Info Box =====
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200, width: 1.5),
                ),
                child: const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "Listen and tap the correct answer!",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ===== Answer Cards =====
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: currentQ.options.map((option) {
                    Color cardColor = option.color;
                    bool isSelected = selectedAnswer == option.display;
                    bool isCorrect = option.display == currentQ.correct.display;

                    if (showFeedback && isSelected) {
                      cardColor = isCorrect ? Colors.green : Colors.red;
                    }

                    // تغميق الألوان الفاتحة (زي Yellow) عشان النص الأبيض يظهر
                    final Color darkened = HSLColor.fromColor(cardColor)
                        .withLightness(
                      (HSLColor.fromColor(cardColor).lightness * 0.65).clamp(0.25, 0.55),
                    )
                        .toColor();

                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: GestureDetector(
                          onTap: () => handleAnswer(option),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [darkened, cardColor],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: cardColor.withOpacity(0.4),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    option.display,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 48,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withOpacity(0.6),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                        Shadow(
                                          color: Colors.black.withOpacity(0.3),
                                          blurRadius: 16,
                                          offset: const Offset(0, 0),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

// ====== Quiz Data & Helpers ======
class QuizItem {
  final String display;
  final Color color;
  final String type;
  QuizItem({required this.display, required this.color, required this.type});
}

class Question {
  final QuizItem correct;
  final List<QuizItem> options;
  final String type;
  Question({required this.correct, required this.options, required this.type});
}

List<Question> generateQuestions(int count) {
  List<Question> questions = [];

  final colors = [
    QuizItem(display: 'Red', color: Colors.red, type: 'color'),
    QuizItem(display: 'Blue', color: Colors.blue, type: 'color'),
    QuizItem(display: 'Green', color: Colors.green, type: 'color'),
    QuizItem(display: 'Yellow', color: Colors.amber, type: 'color'),
    QuizItem(display: 'Purple', color: Colors.purple, type: 'color'),
    QuizItem(display: 'Orange', color: Colors.orange, type: 'color'),
  ];

  final days = [
    QuizItem(display: 'Sunday', color: Colors.pink, type: 'day'),
    QuizItem(display: 'Monday', color: Colors.teal, type: 'day'),
    QuizItem(display: 'Tuesday', color: Colors.orange, type: 'day'),
    QuizItem(display: 'Thursday', color: Colors.purple, type: 'day'),
    QuizItem(display: 'Friday', color: Colors.blue, type: 'day'),
    QuizItem(display: 'Saturday', color: Colors.red, type: 'day'),
  ];

  final months = [
    QuizItem(display: 'January', color: Colors.red, type: 'month'),
    QuizItem(display: 'February', color: Colors.pink, type: 'month'),
    QuizItem(display: 'March', color: Colors.green, type: 'month'),
    QuizItem(display: 'April', color: Colors.orange, type: 'month'),
    QuizItem(display: 'May', color: Colors.yellow, type: 'month'),
    QuizItem(display: 'June', color: Colors.blue, type: 'month'),
    QuizItem(display: 'July', color: Colors.purple, type: 'month'),
    QuizItem(display: 'August', color: Colors.teal, type: 'month'),
    QuizItem(display: 'October', color: Colors.orange, type: 'month'),
    QuizItem(display: 'November', color: Colors.brown, type: 'month'),
    QuizItem(display: 'December', color: Colors.blueGrey, type: 'month'),
  ];

  final types = ['color', 'day', 'month'];

  for (int i = 0; i < count; i++) {
    types.shuffle();
    String selectedType = types.first;

    List<QuizItem> pool;
    if (selectedType == 'color') {
      pool = List.from(colors);
    } else if (selectedType == 'day') {
      pool = List.from(days);
    } else {
      pool = List.from(months);
    }

    pool.shuffle();
    final correct = pool[0];
    final wrongs = pool.sublist(1)..shuffle();
    final options = [correct, wrongs[0], wrongs[1]]..shuffle();
    questions.add(Question(correct: correct, options: options, type: selectedType));
  }

  questions.shuffle();
  return questions;
}