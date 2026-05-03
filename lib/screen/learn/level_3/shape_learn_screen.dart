import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

class ShapeLearnScreen extends StatefulWidget {
  const ShapeLearnScreen({super.key});

  @override
  State<ShapeLearnScreen> createState() => _ShapeLearnScreenState();
}

class _ShapeLearnScreenState extends State<ShapeLearnScreen> with SingleTickerProviderStateMixin {
  final FlutterTts flutterTts = FlutterTts();
  String? selectedShape;
  late AnimationController _animationController;

  // Basic shapes for kids to learn
  final List<Map<String, dynamic>> shapes = [
    {'name': 'Circle', 'color': const Color(0xFF6C5CE7), 'type': ShapeType.circle},
    {'name': 'Square', 'color': const Color(0xFFFF6B9D), 'type': ShapeType.square},
    {'name': 'Triangle', 'color': const Color(0xFF4ECDC4), 'type': ShapeType.triangle},
    {'name': 'Rectangle', 'color': const Color(0xFFFFA07A), 'type': ShapeType.rectangle},
    {'name': 'Star', 'color': const Color(0xFFFFD700), 'type': ShapeType.star},
    {'name': 'Heart', 'color': const Color(0xFFFF2D55), 'type': ShapeType.heart},
    {'name': 'Diamond', 'color': const Color(0xFF00B894), 'type': ShapeType.diamond},
    {'name': 'Pentagon', 'color': const Color(0xFFAF52DE), 'type': ShapeType.pentagon},
    {'name': 'Hexagon', 'color': const Color(0xFF5AC8FA), 'type': ShapeType.hexagon},
    {'name': 'Oval', 'color': const Color(0xFFFF9500), 'type': ShapeType.oval},
    {'name': 'Semicircle', 'color': const Color(0xFFFF7675), 'type': ShapeType.semicircle},
    {'name': 'Octagon', 'color': const Color(0xFFA29BFE), 'type': ShapeType.octagon},
  ];

  @override
  void initState() {
    super.initState();
    _initializeTts();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  Future<void> _initializeTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.2);
  }

  Future<void> _speak(String shapeName) async {
    setState(() {
      selectedShape = shapeName;
    });
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
    await flutterTts.speak(shapeName);
  }

  @override
  void dispose() {
    flutterTts.stop();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF95E1D3).withValues(alpha: 0.1),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildInstructions(),
              Expanded(
                child: _buildShapeGrid(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.arrow_back, color: Color(0xFF95E1D3)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Learn Shapes',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2D3436),
                  ),
                ),
                Text(
                  'Tap any shape to hear its name!',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: const Color(0xFF636E72),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF95E1D3),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF95E1D3).withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(Icons.volume_up, color: Colors.white, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructions() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF95E1D3), Color(0xFF00B894)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.category, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Touch any shape to learn its name!',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShapeGrid() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.85,
        ),
        itemCount: shapes.length,
        itemBuilder: (context, index) {
          final item = shapes[index];
          final shapeName = item['name'] as String;
          final color = item['color'] as Color;
          final type = item['type'] as ShapeType;
          final isSelected = selectedShape == shapeName;

          return _buildShapeCard(shapeName, color, type, isSelected);
        },
      ),
    );
  }

  Widget _buildShapeCard(String shapeName, Color color, ShapeType type, bool isSelected) {
    return GestureDetector(
      onTap: () => _speak(shapeName),
      child: AnimatedScale(
        scale: isSelected ? 1.1 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.3),
                blurRadius: isSelected ? 20 : 12,
                offset: const Offset(0, 6),
                spreadRadius: isSelected ? 3 : 0,
              ),
            ],
          ),
          child: Stack(
            children: [
              // Background gradient
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      color.withValues(alpha: 0.1),
                      color.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              // Shape and name
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Shape icon
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: CustomPaint(
                        painter: ShapePainter(type: type, color: color),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      shapeName,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF2D3436),
                      ),
                    ),
                  ],
                ),
              ),
              // Play icon indicator
              if (isSelected)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.volume_up,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// Enum for shape types
enum ShapeType {
  circle,
  square,
  triangle,
  rectangle,
  star,
  heart,
  diamond,
  pentagon,
  hexagon,
  oval,
  semicircle,
  octagon,
}

// Custom painter for shapes
class ShapePainter extends CustomPainter {
  final ShapeType type;
  final Color color;

  ShapePainter({required this.type, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = color.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final center = Offset(size.width / 2, size.height / 2);

    switch (type) {
      case ShapeType.circle:
        canvas.drawCircle(center, size.width * 0.35, paint);
        canvas.drawCircle(center, size.width * 0.35, strokePaint);
        break;

      case ShapeType.square:
        final rect = Rect.fromCenter(
          center: center,
          width: size.width * 0.6,
          height: size.width * 0.6,
        );
        canvas.drawRect(rect, paint);
        canvas.drawRect(rect, strokePaint);
        break;

      case ShapeType.triangle:
        final path = Path()
          ..moveTo(center.dx, center.dy - size.height * 0.35)
          ..lineTo(center.dx - size.width * 0.35, center.dy + size.height * 0.25)
          ..lineTo(center.dx + size.width * 0.35, center.dy + size.height * 0.25)
          ..close();
        canvas.drawPath(path, paint);
        canvas.drawPath(path, strokePaint);
        break;

      case ShapeType.rectangle:
        final rect = Rect.fromCenter(
          center: center,
          width: size.width * 0.7,
          height: size.height * 0.45,
        );
        canvas.drawRect(rect, paint);
        canvas.drawRect(rect, strokePaint);
        break;

      case ShapeType.star:
        final path = _createStarPath(center, size.width * 0.35, size.width * 0.15, 5);
        canvas.drawPath(path, paint);
        canvas.drawPath(path, strokePaint);
        break;

      case ShapeType.heart:
        final path = _createHeartPath(size);
        canvas.drawPath(path, paint);
        canvas.drawPath(path, strokePaint);
        break;

      case ShapeType.diamond:
        final path = Path()
          ..moveTo(center.dx, center.dy - size.height * 0.35)
          ..lineTo(center.dx + size.width * 0.3, center.dy)
          ..lineTo(center.dx, center.dy + size.height * 0.35)
          ..lineTo(center.dx - size.width * 0.3, center.dy)
          ..close();
        canvas.drawPath(path, paint);
        canvas.drawPath(path, strokePaint);
        break;

      case ShapeType.pentagon:
        final path = _createPolygonPath(center, size.width * 0.35, 5);
        canvas.drawPath(path, paint);
        canvas.drawPath(path, strokePaint);
        break;

      case ShapeType.hexagon:
        final path = _createPolygonPath(center, size.width * 0.35, 6);
        canvas.drawPath(path, paint);
        canvas.drawPath(path, strokePaint);
        break;

      case ShapeType.oval:
        final rect = Rect.fromCenter(
          center: center,
          width: size.width * 0.7,
          height: size.height * 0.5,
        );
        canvas.drawOval(rect, paint);
        canvas.drawOval(rect, strokePaint);
        break;

      case ShapeType.semicircle:
        final rect = Rect.fromCenter(
          center: center,
          width: size.width * 0.7,
          height: size.height * 0.7,
        );
        canvas.drawArc(rect, math.pi, math.pi, true, paint);
        canvas.drawArc(rect, math.pi, math.pi, true, strokePaint);
        break;

      case ShapeType.octagon:
        final path = _createPolygonPath(center, size.width * 0.35, 8);
        canvas.drawPath(path, paint);
        canvas.drawPath(path, strokePaint);
        break;
    }
  }

  Path _createStarPath(Offset center, double outerRadius, double innerRadius, int points) {
    final path = Path();
    final angle = math.pi / points;

    for (int i = 0; i < points * 2; i++) {
      final radius = i.isEven ? outerRadius : innerRadius;
      final x = center.dx + radius * math.cos(i * angle - math.pi / 2);
      final y = center.dy + radius * math.sin(i * angle - math.pi / 2);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }

  Path _createHeartPath(Size size) {
    final path = Path();
    final width = size.width * 0.7;
    final height = size.height * 0.7;
    final centerX = size.width / 2;
    final top = size.height * 0.2;

    path.moveTo(centerX, top + height / 4);

    // Left curve
    path.cubicTo(
      centerX - width / 2, top,
      centerX - width / 2, top + height / 3,
      centerX, top + height * 0.75,
    );

    // Right curve
    path.cubicTo(
      centerX + width / 2, top + height / 3,
      centerX + width / 2, top,
      centerX, top + height / 4,
    );

    path.close();
    return path;
  }

  Path _createPolygonPath(Offset center, double radius, int sides) {
    final path = Path();
    final angle = (math.pi * 2) / sides;

    for (int i = 0; i < sides; i++) {
      final x = center.dx + radius * math.cos(i * angle - math.pi / 2);
      final y = center.dy + radius * math.sin(i * angle - math.pi / 2);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
