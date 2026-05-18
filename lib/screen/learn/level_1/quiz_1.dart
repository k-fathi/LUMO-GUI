import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'alphabet_learning_screen.dart';
import 'number_learn_screen.dart';
import '../level_2/level_2.dart';

// ====== Kids Quiz Screen ======
class KidsQuizScreen extends StatefulWidget {
  const KidsQuizScreen({super.key});

  @override
  State<KidsQuizScreen> createState() => _KidsQuizScreenState();
}

class _KidsQuizScreenState extends State<KidsQuizScreen> {
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

    // إعدادات النطق الموحدة للراسبيري باي
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
      backgroundColor: Colors.blue[50], // الخلفية الفاتحة الثابتة
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Header (يحتوي على زرار الرجوع والعناوين المؤمنة)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // زرار الرجوع بتصميم متناسق ومحمي
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
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.blue,
                              size: 24,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Kids Learning Quiz 🎯",
                              style: TextStyle(
                                fontSize: 24, // تصغير بسيط ليناسب الشاشات العريضة المضغوطة
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF2D3436), // قفل اللون غامق صريح
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "Question ${currentQuestion + 1} / ${questions.length}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF636E72), // لون رمادي صلب وواضح
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
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
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            "Score",
                            style: TextStyle(
                              color: Colors.white, // أبيض صريح فوق خلفية غامقة ملونة عادية
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
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

                const SizedBox(height: 20),

                // Speaker Button
                Center(
                  child: GestureDetector(
                    onTap: () => playCurrentSound(),
                    child: Container(
                      width: 90, // تصغير الحجم قليلاً ليناسب الارتفاع العمودي للراسبيري
                      height: 90,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.purple, Colors.pink],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.pink.withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 5),
                          )
                        ],
                      ),
                      child: const Icon(
                        Icons.volume_up,
                        size: 45,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                const Text(
                  "🎧 Listen and tap the correct answer!",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF2D3436), // قفل اللون غامق صريح لمنع الاختفاء
                  ),
                ),

                const SizedBox(height: 25),

                // Answer Cards (تم ضبط المساحات لمنع الـ Overflow وظهور الـ 3 خيارات بوضوح تام)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: currentQ.options.map((option) {
                    Color cardColor = option.color;
                    bool isSelected = selectedAnswer == option.display;
                    bool isCorrect = option.display == currentQ.correct.display;

                    if (showFeedback && isSelected) {
                      cardColor = isCorrect ? Colors.green : Colors.red;
                    }

                    return Flexible( // استخدام Flexible لمنع المشاكل الحسابية للأبعاد الأفية للـ Row
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0), // مسافات صغيرة متناسقة
                        child: GestureDetector(
                          onTap: () => handleAnswer(option),
                          child: AspectRatio(
                            aspectRatio: 1.0, // جعل الكروت مربعة تماماً لتوفير مساحة عمودية
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [cardColor.withOpacity(0.85), cardColor],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: cardColor.withOpacity(0.35),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  )
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  option.display,
                                  style: const TextStyle(
                                    fontSize: 48, // تصغير الحجم من 64 إلى 48 ليناسب شاشة الراسبيري ولا يخرج عن حدود الكارت
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white, // أبيض صريح فوق خلفيات الكروت الملونة الغامقة
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
              ],
            ),
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