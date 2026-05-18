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
      backgroundColor: Colors.blue[50], // خلفية ثابتة لحماية العرض
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Header (تأمين كامل لألوان الخطوط ضد الـ Dark Mode تلقائياً)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // زرار الرجوع المحمي
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
                                fontSize: 24, // مقاس متناسق للراسبيري
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF2D3436), // لون داكن صريح
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "Question ${currentQuestion + 1} / ${questions.length}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF636E72), // لون رمادي ثابت وواضح
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFF00B894), Color(0xFF00D2A0)]),
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
                          const Text("Score", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                          Text("$score", style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 20),

                // Speaker Button (ملموم ليناسب الأبعاد العمودية الضيقة)
                Center(
                  child: GestureDetector(
                    onTap: () => playCurrentSound(),
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Colors.purple, Colors.pink]),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.pink.withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 5),
                          )
                        ],
                      ),
                      child: const Icon(Icons.volume_up, size: 45, color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                const Text(
                  "🎧 Listen and tap the correct answer!",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF2D3436), // قفل اللون غامق لمنع اختفائه تماماً
                  ),
                ),

                const SizedBox(height: 25),

                // Answer Cards (تعديل الـ Row لضمان عدم حدوث Overflow مع الكلمات الطويلة)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: currentQ.options.map((option) {
                    Color cardColor = option.color;
                    bool isSelected = selectedAnswer == option.display;
                    bool isCorrect = option.display == currentQ.correct.display;

                    if (showFeedback && isSelected) {
                      cardColor = isCorrect ? Colors.green : Colors.red;
                    }

                    return Flexible( // استخدام Flexible لحساب عرض الثلاثة كروت بدقة تلقائياً
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0), // مسافات أفقية ملمومة ومتناسقة
                        child: GestureDetector(
                          onTap: () => handleAnswer(option),
                          child: AspectRatio(
                            aspectRatio: 1.0, // كروت مربعة تماماً لتوفير مساحة رأسية
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
                                child: FittedBox(
                                  fit: BoxFit.scaleDown, // تصغير مرن للكلمة تلقائياً لو كانت طويلة جداً عن حجم الكارت
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0), // بادينج داخلي خفيف لحماية النص من الحواف
                                    child: Text(
                                      option.display,
                                      style: const TextStyle(
                                        fontSize: 24, // تصغير الحجم الافتراضي لتستوعب الكلمات الطويلة (أيام/شهور) على الراسبيري
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white, // أبيض صريح يظهر بقوة فوق كروت الإجابات الملونة
                                      ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Quiz Data & Helpers
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
    final wrongs = pool.sublist(1);

    wrongs.shuffle();

    final options = [correct, wrongs[0], wrongs[1]]..shuffle();

    questions.add(Question(correct: correct, options: options, type: selectedType));
  }

  questions.shuffle();
  return questions;
}