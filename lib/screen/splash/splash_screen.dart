import 'package:flutter/material.dart';
import '../auth/sign_in_screen.dart';

class SplashFaceScreen extends StatefulWidget {
  const SplashFaceScreen({super.key});

  @override
  State<SplashFaceScreen> createState() => _SplashFaceScreenState();
}

class _SplashFaceScreenState extends State<SplashFaceScreen> {
  void _goToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const SignInScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: _goToLogin,
        child: CustomPaint(size: Size.infinite, painter: FacePainter()),
      ),
    );
  }
}

/// 🎨 Painter كامل للوجه
class FacePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    /// 🌌 Background
    final bgPaint = Paint()..color = const Color(0xFF081826);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final center = Offset(size.width / 2, size.height / 2);

    /// 👁️ نفس توزيع الصورة تقريبًا
    final eyeOffsetY = -65.0;
    final eyeSpacing = 72.0; // 👈 أقرب زي الصورة

    _drawEye(canvas, center.translate(-eyeSpacing, eyeOffsetY));
    _drawEye(canvas, center.translate(eyeSpacing, eyeOffsetY));

    _drawSmile(canvas, center);
  }

  void _drawEye(Canvas canvas, Offset center) {
    /// ✨ Glow خفيف
    final glow = Paint()
      ..color = Colors.blueAccent.withOpacity(0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);

    canvas.drawCircle(center, 48, glow);

    /// ⚪ Eye
    final white = Paint()..color = Colors.white;
    canvas.drawOval(
      Rect.fromCenter(center: center, width: 58, height: 80),
      white,
    );

    /// 🔵 Iris
    final iris = Paint()..color = const Color(0xFF29B6F6);
    canvas.drawOval(
      Rect.fromCenter(center: center, width: 42, height: 60),
      iris,
    );

    /// ⚫ Pupil
    final pupil = Paint()..color = Colors.black;
    canvas.drawOval(
      Rect.fromCenter(center: center, width: 28, height: 45),
      pupil,
    );

    /// ✨ Highlight
    final highlight = Paint()..color = Colors.white;
    canvas.drawCircle(center.translate(5, 17), 4, highlight);

    final highlight1 = Paint()..color = Colors.white;
    canvas.drawCircle(center.translate(-10, -9), 3, highlight1);

    /// 🌙 Eyelash (شكل أقرب للصورة)
    final lash = Paint()
      ..color = const Color(0xFF4FC3F7)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(center.dx - 18, center.dy - 48);
    path.quadraticBezierTo(
      center.dx,
      center.dy - 75, // 👈 انحناء أعلى
      center.dx + 18,
      center.dy - 48,
    );

    canvas.drawPath(path, lash);
  }

  void _drawSmile(Canvas canvas, Offset center) {
    final smileWidth = 160.0;
    final smileHeight = 80.0;

    /// 👇 مسافة ثابتة بين العين والفم
    final smileOffsetY = 66.0;

    final smileCenter = center.translate(0, smileOffsetY);

    final rect = Rect.fromCenter(
      center: smileCenter,
      width: smileWidth,
      height: smileHeight,
    );

    final path = Path()
      ..moveTo(rect.left, rect.center.dy)
      ..quadraticBezierTo(
        rect.center.dx,
        rect.bottom + 45, // 👈 يخليه مبتسم بوضوح
        rect.right,
        rect.center.dy,
      )
      ..quadraticBezierTo(
        rect.center.dx,
        rect.bottom - 10,
        rect.left,
        rect.center.dy,
      );

    final paint = Paint()..color = const Color(0xFF29B6F6);

    canvas.drawShadow(path, Colors.blueAccent, 10, false);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}