import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';

class RobotScreen extends StatefulWidget {
  const RobotScreen({super.key});

  @override
  State<RobotScreen> createState() => _RobotScreenState();
}

class _RobotScreenState extends State<RobotScreen> {
  final AudioPlayer player = AudioPlayer();

  String question = "";
  String option1 = "";
  String option2 = "";
  String answer = "";

  String emotion = "";
  String moral = "";

  bool showQuestion = false;
  bool showMoral = false;
  bool isPlaying = false;

  final String url = "http://172.189.165.242:8081/get-story-audio";

  Future<void> loadStory() async {
    showQuestion = false;
    showMoral = false;

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        question =
            Uri.decodeComponent(response.headers['x-question'] ?? "");

        option1 =
            Uri.decodeComponent(response.headers['x-option1'] ?? "");

        option2 =
            Uri.decodeComponent(response.headers['x-option2'] ?? "");

        answer =
            Uri.decodeComponent(response.headers['x-answer'] ?? "");

        /// ✅ المهم
        emotion =
            Uri.decodeComponent(response.headers['x-emotion'] ?? "");

        moral =
            Uri.decodeComponent(response.headers['x-emotion-clues'] ?? "");

        isPlaying = true;
      });

      await player.stop();
      await player.play(BytesSource(response.bodyBytes));

      player.onPlayerComplete.listen((event) async {
        setState(() {
          isPlaying = false;
          showQuestion = true;
        });

        /// لو الطفل ما جاوبش
        await Future.delayed(const Duration(seconds: 10));
        if (!showMoral) {
          await loadStory();
        }
      });
    }
  }

  void checkAnswer(String selected) async {
    if (selected == answer) {
      Get.snackbar("✔", "Correct 🎉");

      /// 👇 هنا اللي بيظهر المغزى
      setState(() {
        showMoral = true;
      });
    } else {
      Get.snackbar("❌", "Wrong.. try again");

      await player.stop();
      await loadStory();
    }
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          /// 🖼️ صورة
          Positioned.fill(
            child: Container(
              color: Colors.white,
              child: Image.asset(
                'assets/images/robot.jpg',
                fit: BoxFit.contain,
              ),
            ),
          ),

          /// 🔙 رجوع
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Get.back(),
            ),
          ),

          /// 🎮 أزرار
          Positioned(
            top: 100,
            right: 20,
            child: Column(
              children: [

                /// ▶️ تشغيل
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 35,
                    ),
                    onPressed: () async {
                      if (isPlaying) {
                        await player.pause();
                        setState(() => isPlaying = false);
                      } else {
                        await loadStory();
                      }
                    },
                  ),
                ),

                const SizedBox(height: 10),

                /// 🎲 قصة جديدة
                ElevatedButton(
                  onPressed: () async {
                    await player.stop();

                    setState(() {
                      isPlaying = false;
                      showQuestion = false;
                      showMoral = false;
                    });

                    await loadStory();
                  },
                  child: const Text("🎲"),
                ),
              ],
            ),
          ),

          /// ❓ السؤال + 💡 المغزى
          if (showQuestion)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    /// ❓ السؤال
                    if (!showMoral) ...[
                      Text(
                        question,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      ElevatedButton(
                        onPressed: () => checkAnswer(option1),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                        ),
                        child: Text(option1),
                      ),

                      ElevatedButton(
                        onPressed: () => checkAnswer(option2),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                        ),
                        child: Text(option2),
                      ),
                    ],

                    /// 💡 المغزى
                    if (showMoral)
                      Column(
                        children: [
                          Text(
                            emotion.isEmpty ? "💡 الفكرة" : emotion,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            moral.isEmpty ? "👍 أحسنت!" : moral,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}