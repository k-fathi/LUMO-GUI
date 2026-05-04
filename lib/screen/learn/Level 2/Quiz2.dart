import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../Level 2/color_learn_screen.dart';
import '../Level 2/day_learn_screen.dart';
import '../Level 2/month_learn_screen.dart';
import '../Level 3/Level 3.dart';

class KidsQuizScreen2 extends StatefulWidget {
  const KidsQuizScreen2({super.key});

  @override
  State<KidsQuizScreen2> createState() => _KidsQuizScreen2State();
}

class _KidsQuizScreen2State extends State<KidsQuizScreen2> {
  final FlutterTts tts = FlutterTts();
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
    await tts.setLanguage("en-US");
    await tts.setPitch(1.2);
    await tts.setSpeechRate(0.5);
    await tts.speak(text);
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

          String message = '';
          Widget screen;

          if (currentType == 'color') {
            message = 'Learn Colors Again 🎨';
            screen = const ColorLearnScreen();
          } else if (currentType == 'day') {
            message = 'Learn Days Again 📅';
            screen = const DayLearnScreen();
          } else {
            message = 'Learn Months Again 🗓️';
            screen = const MonthLearnScreen();
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
          );

          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => screen),
            );
          });
        }
      });
    });
  }

  void restartQuiz() {
    setState(() {
      currentQuestion = 0;
      score = 0;
      selectedAnswer = null;
      showFeedback = false;
      questions = generateQuestions(5);
      playCurrentSound();
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentQ = questions[currentQuestion];

    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Kids Learning Quiz 🎯",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Question ${currentQuestion + 1} / ${questions.length}",
                        style: const TextStyle(fontSize: 18),
                      )
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Colors.green, Colors.blue]),
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: [
                        const Text("Score", style: TextStyle(color: Colors.white)),
                        Text("$score", style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => playCurrentSound(),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Colors.purple, Colors.pink]),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.volume_up, size: 64, color: Colors.white),
              ),
            ),
            const SizedBox(height: 12),
            const Text("🎧 Listen and tap the correct answer!", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                padding: const EdgeInsets.all(12),
                children: currentQ.options.map((option) {
                  Color cardColor = option.color;
                  bool isSelected = selectedAnswer == option.display;
                  bool isCorrect = option.display == currentQ.correct.display;

                  if (showFeedback && isSelected) {
                    cardColor = isCorrect ? Colors.green : Colors.red;
                  }

                  return GestureDetector(
                    onTap: () => handleAnswer(option),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [cardColor.withOpacity(0.8), cardColor]),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          option.display,
                          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Quiz Data & Helpers
class QuizItem {
  final String display;
  final Color color;
  final String type; // 'color', 'day', 'month'

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
    QuizItem(display: 'Yellow', color: Colors.yellow, type: 'color'),
    QuizItem(display: 'Purple', color: Colors.purple, type: 'color'),
    QuizItem(display: 'Orange', color: Colors.orange, type: 'color'),
  ];

  final days = [
    QuizItem(display: 'Sunday', color: Colors.pink, type: 'day'),
    QuizItem(display: 'Monday', color: Colors.teal, type: 'day'),
    QuizItem(display: 'Tuesday', color: Colors.orange, type: 'day'),
    // QuizItem(display: 'Wednesday', color: Colors.green, type: 'day'),
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
    // QuizItem(display: 'September', color: Colors.green, type: 'month'),
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
    final wrongs = pool.sublist(1);

    wrongs.shuffle();

    final options = [correct, wrongs[0], wrongs[1]]..shuffle();

    questions.add(Question(correct: correct, options: options, type: selectedType));
  }

  questions.shuffle();
  return questions;
}

