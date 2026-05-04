import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'alphabet_learning_screen.dart';
import 'number_learn_screen.dart';
import '../level_2/level_2.dart';
// // ====== Level 2 Screen ======
// class LevelTwoScreen extends StatelessWidget {
//   const LevelTwoScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Level 2")),
//       body: const Center(
//         child: Text("Welcome to Level 2", style: TextStyle(fontSize: 24)),
//       ),
//     );
//   }
// }

// // ====== Number Learn Screen ======
// class NumberLearnScreen extends StatelessWidget {
//   const NumberLearnScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Number Learning")),
//       body: const Center(
//         child: Text("Learn Numbers Here", style: TextStyle(fontSize: 24)),
//       ),
//     );
//   }
// }

// // ====== Alphabet Learn Screen ======
// class AlphabetLearningScreen extends StatelessWidget {
//   const AlphabetLearningScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Alphabet Learning")),
//       body: const Center(
//         child: Text("Learn Alphabets Here", style: TextStyle(fontSize: 24)),
//       ),
//     );
//   }
// }

// ====== Kids Quiz Screen ======
class KidsQuizScreen extends StatefulWidget {
  const KidsQuizScreen({super.key});

  @override
  State<KidsQuizScreen> createState() => _KidsQuizScreenState();
}

class _KidsQuizScreenState extends State<KidsQuizScreen> {
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

      bool isCorrect =
          option.display == questions[currentQuestion].correct.display;

      Timer(const Duration(seconds: 2), () {
        if (isCorrect) {
          score += 10;

          if (score >= 50) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LevelTwoScreen()),
            );

            return;
          }
        } else {
          // لو غلط حسب نوع السؤال
          final currentType = questions[currentQuestion].type;
          if (currentType == 'number') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const NumberLearnScreen()),
            );
          } else if (currentType == 'alphabet') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const AlphabetLearningScreen()),
            );
          }

          return;
        }

        // ننتقل للسؤال التالي إذا موجود
        if (currentQuestion < questions.length - 1) {
          setState(() {
            currentQuestion++;
            selectedAnswer = null;
            showFeedback = false;
          });
          playCurrentSound();
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
            // Header
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
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Question ${currentQuestion + 1} / ${questions.length}",
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.green, Colors.blue],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Score",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          "$score",
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Speaker
            GestureDetector(
              onTap: () => playCurrentSound(),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.purple, Colors.pink],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.volume_up,
                  size: 64,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "🎧 Listen and tap the correct answer!",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),
            // Answer Cards
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
                        gradient: LinearGradient(
                          colors: [cardColor.withOpacity(0.8), cardColor],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          option.display,
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
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

// ====== Quiz Data & Helpers ======
class QuizItem {
  final String display;
  final Color color;
  final String type; // 'alphabet' or 'number'

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
  final alphabets = [
    QuizItem(display: 'A', color: Colors.pink, type: 'alphabet'),
    QuizItem(display: 'B', color: Colors.teal, type: 'alphabet'),
    QuizItem(display: 'C', color: Colors.orange, type: 'alphabet'),
    QuizItem(display: 'D', color: Colors.green, type: 'alphabet'),
    QuizItem(display: 'E', color: Colors.purple, type: 'alphabet'),
    QuizItem(display: 'F', color: Colors.blue, type: 'alphabet'),
    QuizItem(display: 'G', color: Colors.red, type: 'alphabet'),
  ];

  final numbers = [
    QuizItem(display: '1', color: Colors.red, type: 'number'),
    QuizItem(display: '2', color: Colors.teal, type: 'number'),
    QuizItem(display: '3', color: Colors.orange, type: 'number'),
    QuizItem(display: '4', color: Colors.green, type: 'number'),
    QuizItem(display: '5', color: Colors.purple, type: 'number'),
    QuizItem(display: '6', color: Colors.blue, type: 'number'),
    QuizItem(display: '7', color: Colors.pink, type: 'number'),
  ];

  final allItems = [...alphabets, ...numbers];

  for (int i = 0; i < count; i++) {
    allItems.shuffle();
    final correct = allItems[0];
    final wrongs = allItems.sublist(1, allItems.length)..shuffle();
    final options = [correct, wrongs[0], wrongs[1]]..shuffle();
    questions.add(
      Question(correct: correct, options: options, type: correct.type),
    );
  }

  questions.shuffle();
  return questions;
}
