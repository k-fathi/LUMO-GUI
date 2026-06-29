import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import '../../services/api_service.dart';

class RobotScreen extends StatefulWidget {
  final int segmentId;
  const RobotScreen({super.key, required this.segmentId});

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

  final String baseUrl = "http://20.230.160.202:8081";
  final ApiService _apiService = ApiService();

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
      print(data);

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

      // تأخير ثانية لتهيئة الهاردوير على الراسبيري
      Future.delayed(const Duration(seconds: 1), () {
        startRecording();
      });
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

  /// 📤 إرسال الصوت للسيرفر
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

      await submitStoryResult(isCorrect);

      Get.snackbar(
        '',
        '',
        titleText: Text(
          isCorrect ? "✔ صح" : "❌ غلط",
          style: const TextStyle(
            fontFamily: 'Cairo',
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        messageText: Text(
          isCorrect ? "إجابة ممتازة!" : "حاول مرة ثانية",
          style: const TextStyle(
            fontFamily: 'Cairo',
            color: Colors.white,
            fontSize: 14,
          ),
        ),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: isCorrect
            ? Colors.green.withOpacity(0.8)
            : Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );

      if (audioUrl != null) await player.play(UrlSource(audioUrl));
    } catch (e) {
      Get.snackbar(
        '',
        '',
        titleText: const Text(
          "خطأ",
          style: TextStyle(
            fontFamily: 'Cairo',
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        messageText: const Text(
          "مشكلة في الاتصال بالموديل",
          style: TextStyle(
            fontFamily: 'Cairo',
            color: Colors.white,
            fontSize: 14,
          ),
        ),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
      );
    }
  }

  Future<void> submitStoryResult(bool isCorrect) async {
    try {
      await _apiService.completeSegment(
        widget.segmentId,
        storyTrait: storyTitle,
        isAnswerCorrect: isCorrect,
      );
    } catch (e) {
      print("❌ خطأ: $e");
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
      backgroundColor: Colors
          .white, // تثبيت خلفية البيئة لعدم التأثر بالـ Dark Mode للراسبيري
      body: Stack(
        children: [
          /// 🖼️ الخلفية الأصلية تماماً (تأخذ BoxFit.contain مثل اللابتوب)
          Positioned.fill(
            child: Image.asset('assets/images/robot.jpg', fit: BoxFit.contain),
          ),

          /// 🔙 زر الرجوع
          Positioned(
            top: 20,
            left: 20,
            child: SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Get.back(),
                ),
              ),
            ),
          ),

          /// 🎮 أزرار التحكم فوق خالص على اليمين مع مسافة أمان (top: 20)
          Positioned(
            top: 90,
            right: 20,
            child: SafeArea(
              child: Column(
                children: [
                  FloatingActionButton(
                    heroTag: "btnPlay",
                    backgroundColor: Colors.white,
                    onPressed: startLesson,
                    child: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 38,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
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
                        size: 28,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  if (isRecording)
                    const Padding(
                      padding: EdgeInsets.only(top: 4.0),
                      child: Text(
                        "اسمعك...",
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          /// 📦 صندوق النصوص السفلي المؤمن بالألوان الصريحة (بدون سكرول)
          // if (showQuestion || showMoral || storyTitle.isNotEmpty)
          //   Positioned(
          //     bottom: 40, // تم رفعه قليلاً لضمان عدم خروجه لأسفل الشاشة في الراسبيري
          //     left: 20,
          //     right: 20,
          //     child: SafeArea(
          //       child: Container(
          //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          //         decoration: BoxDecoration(
          //           color: Colors.white, // خلفية بيضاء صلبة لعزل ثيم الراسبيري الداكن تلقائياً
          //           borderRadius: BorderRadius.circular(16),
          //           boxShadow: [
          //             BoxShadow(
          //               color: Colors.black.withOpacity(0.15),
          //               blurRadius: 10,
          //               spreadRadius: 1,
          //             ),
          //           ],
          //         ),
          //         child: Column(
          //           mainAxisSize: MainAxisSize.min, // ليتقلص الصندوق ويأخذ حجم المحتوى بدقة
          //           children: [
          //             /// 1. حالة القصة
          //             if (storyTitle.isNotEmpty && !showMoral && !showQuestion)
          //               Text(
          //                 "📖 قصة: $storyTitle",
          //                 textAlign: TextAlign.center,
          //                 style: const TextStyle(
          //                   fontSize: 18,
          //                   fontWeight: FontWeight.bold,
          //                   color: Colors.blueAccent,
          //                 ),
          //               ),
          //
          //             /// 2. حالة المغزى
          //             if (showMoral)
          //               Column(
          //                 children: [
          //                   Text(
          //                     "المغزى من قصة ($storyTitle) 💡",
          //                     textAlign: TextAlign.center,
          //                     style: const TextStyle(
          //                       fontSize: 16,
          //                       fontWeight: FontWeight.bold,
          //                       color: Colors.blueGrey,
          //                     ),
          //                   ),
          //                   const SizedBox(height: 6),
          //                   Text(
          //                     moral,
          //                     textAlign: TextAlign.center,
          //                     style: const TextStyle(
          //                       fontSize: 14,
          //                       fontWeight: FontWeight.w500,
          //                       color: Colors.black87, // لون أسود صريح ومضمون للظهور
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //
          //             /// 3. حالة السؤال
          //             if (showQuestion)
          //               Column(
          //                 children: [
          //                   Text(
          //                     question,
          //                     textAlign: TextAlign.center,
          //                     style: const TextStyle(
          //                       fontSize: 16,
          //                       fontWeight: FontWeight.bold,
          //                       color: Colors.black87, // لون أسود صريح ومضمون للظهور
          //                     ),
          //                   ),
          //                   const SizedBox(height: 10),
          //                   Row(
          //                     mainAxisAlignment: MainAxisAlignment.center,
          //                     children: [
          //                       _buildOptionChip(option2),
          //                       const SizedBox(width: 10),
          //                       const Text(
          //                         "أو",
          //                         style: TextStyle(
          //                           fontWeight: FontWeight.bold,
          //                           fontSize: 14,
          //                           color: Colors.black87, // لون أسود صريح ومضمون للظهور
          //                         ),
          //                       ),
          //                       const SizedBox(width: 10),
          //                       _buildOptionChip(option1),
          //                     ],
          //                   ),
          //                 ],
          //               ),
          //           ],
          //         ),
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }

  Widget _buildOptionChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.blueAccent, // لون أزرق ثابت وواضح
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }
}
