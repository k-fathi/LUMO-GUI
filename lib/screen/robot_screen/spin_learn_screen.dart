import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

class RobotScreen extends StatefulWidget {
  const RobotScreen({super.key});

  @override
  State<RobotScreen> createState() => _RobotScreenState();
}

class _RobotScreenState extends State<RobotScreen> {
  final AudioPlayer player = AudioPlayer();
  final AudioRecorder recorder = AudioRecorder();

  String storyTitle = "";
  String question = "";
  String option1 = "";
  String option2 = "";
  String moral = "";

  bool showQuestion = false;
  bool showMoral = false;
  bool isRecording = false;
  bool isPlaying = false;

  String? filePath;

  // السيرفر الخاص بالدروس
  final String baseUrl = "http://172.189.165.242:8081";
  // السيرفر الخاص بحفظ النتيجة النهائية
  final String completionUrl =
      "https://clickexpress.delivery/api/segments/5/complete";

  @override
  void initState() {
    super.initState();
    player.onPlayerComplete.listen((event) {
      setState(() => isPlaying = false);
    });
  }

  /// 🚀 ابدأ الدرس
  Future<void> startLesson() async {
    if (isPlaying) {
      await player.pause();
      setState(() => isPlaying = false);
      return;
    }

    setState(() {
      showQuestion = false;
      showMoral = false;
      storyTitle = "";
      isPlaying = true;
    });

    try {
      final res = await http.post(Uri.parse("$baseUrl/start-lesson"));
      final data = jsonDecode(res.body);

      setState(() {
        storyTitle = data['trait'] ?? "قصة جديدة";
      });

      final storyAudio = data['story']['audio_url'];
      final learningText = data['learning']['text'];
      final learningAudio = data['learning']['audio_url'];

      await player.play(UrlSource(storyAudio));
      await player.onPlayerComplete.first;

      setState(() {
        showMoral = true;
        moral = learningText ?? "";
        isPlaying = true;
      });

      await player.play(UrlSource(learningAudio));
      await player.onPlayerComplete.first;

      await loadQuestion();
    } catch (e) {
      setState(() => isPlaying = false);
      Get.snackbar("خطأ", "فشل في تحميل الدرس");
    }
  }

  /// ❓ تحميل السؤال
  Future<void> loadQuestion() async {
    try {
      final res = await http.get(Uri.parse("$baseUrl/get-question"));
      final data = jsonDecode(res.body);

      setState(() {
        question = data['question'] ?? "";
        option1 = data['options']['option_1'] ?? "";
        option2 = data['options']['option_2'] ?? "";
        showQuestion = true;
        showMoral = false;
        isPlaying = true;
      });

      await player.play(UrlSource(data['audio_url']));
      await player.onPlayerComplete.first;

      setState(() => isPlaying = false);
      startRecording();
    } catch (e) {
      print("Error loading question: $e");
    }
  }

  /// 🎤 بدء التسجيل
  Future<void> startRecording() async {
    if (await recorder.hasPermission()) {
      final dir = await getTemporaryDirectory();
      filePath = '${dir.path}/answer.wav';
      await recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.wav,
          sampleRate: 16000,
          numChannels: 1,
        ),
        path: filePath!,
      );
      setState(() => isRecording = true);
    }
  }

  /// 🛑 إيقاف التسجيل
  Future<void> stopRecording() async {
    final path = await recorder.stop();
    setState(() => isRecording = false);
    if (path != null) await sendAudio(path);
  }

  /// 📤 إرسال الصوت للسيرفر ثم إرسال النتيجة النهائية للرابط الجديد
  Future<void> sendAudio(String path) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("$baseUrl/transcribe-answer"),
    );
    request.files.add(await http.MultipartFile.fromPath('audio', path));

    try {
      var response = await request.send();
      var res = await response.stream.bytesToString();
      final data = jsonDecode(res);
      final bool isCorrect = data['is_correct'] ?? false;
      final String? audioUrl = data['audio_url'];

      // ✅ استدعاء رابط الـ Complete الذي أرسلتيه
      await submitStoryResult(isCorrect);

      Get.snackbar(
        isCorrect ? "✔ صح" : "❌ غلط",
        isCorrect ? "إجابة ممتازة!" : "حاول مرة ثانية",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: isCorrect
            ? Colors.green.withOpacity(0.8)
            : Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );

      if (audioUrl != null) await player.play(UrlSource(audioUrl));
    } catch (e) {
      Get.snackbar("خطأ", "مشكلة في الاتصال بالموديل");
    }
  }

  /// 📬 إرسال JSON النتيجة النهائية للرابط: https://clickexpress.delivery/api/segments/5/complete
  Future<void> submitStoryResult(bool isCorrect) async {
    try {
      await http.post(
        Uri.parse(completionUrl),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "story_trait": storyTitle,
          "is_answer_correct": isCorrect,
        }),
      );
      print("✅ تم إرسال نتيجة القصة بنجاح للرابط النهائي");
    } catch (e) {
      print("❌ خطأ في إرسال النتيجة النهائية: $e");
    }
  }

  @override
  void dispose() {
    player.dispose();
    recorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// 🖼️ الخلفية
          Positioned.fill(
            child: Image.asset('assets/images/robot.jpg', fit: BoxFit.contain),
          ),

          /// 🔙 زر الرجوع
          Positioned(
            top: 40,
            left: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Get.back(),
              ),
            ),
          ),

          /// 🎮 أزرار التحكم
          Positioned(
            top: 120,
            right: 20,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: "btnPlay",
                  backgroundColor: Colors.white,
                  onPressed: startLesson,
                  child: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 40,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onLongPressStart: (_) => startRecording(),
                  onLongPressEnd: (_) => stopRecording(),
                  child: FloatingActionButton(
                    heroTag: "btnMic",
                    backgroundColor: isRecording
                        ? Colors.red
                        : Colors.blueAccent,
                    onPressed: () {
                      if (isRecording) stopRecording();
                    },
                    child: Icon(
                      isRecording ? Icons.stop : Icons.mic,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (isRecording)
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      "اسمعك...",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          /// 📦 صندوق النصوص السفلي
          if (showQuestion || showMoral || storyTitle.isNotEmpty)
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// 1. حالة القصة
                    if (storyTitle.isNotEmpty && !showMoral && !showQuestion)
                      Text(
                        "📖 قصة: $storyTitle",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),

                    /// 2. حالة المغزى
                    if (showMoral)
                      Column(
                        children: [
                          Text(
                            "المغزى من قصة ($storyTitle) 💡",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            moral,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                    /// 3. حالة السؤال (تقريب المسافات)
                    if (showQuestion)
                      Column(
                        children: [
                          Text(
                            question,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.center, // تجميع في المنتصف
                            children: [
                              _buildOptionChip(option2),
                              const SizedBox(width: 10), // مسافة صغيرة قبل أو
                              const Text(
                                "أو",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 10), // مسافة صغيرة بعد أو
                              _buildOptionChip(option1),
                            ],
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

  Widget _buildOptionChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.blueAccent,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
