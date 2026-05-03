import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ColoringScreen extends StatefulWidget {
  const ColoringScreen({super.key});

  @override
  State<ColoringScreen> createState() => _ColoringScreenState();
}

class _ColoringScreenState extends State<ColoringScreen> {
  int selectedDrawing = 0;
  Color selectedColor = Colors.red;
  List<DrawingPoint> points = [];
  bool isErasing = false;
  double penSize = 5.0;

  final List<Color> colors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.pink,
    Colors.brown,
    Colors.black,
    Colors.grey,
    Colors.cyan,
    Colors.lime,
  ];

  final List<Map<String, dynamic>> drawings = [
    {'name': '🦋 Butterfly', 'icon': Icons.flutter_dash},
    {'name': '🌸 Flower', 'icon': Icons.local_florist},
    {'name': '🏠 House', 'icon': Icons.home},
    {'name': '🚗 Car', 'icon': Icons.directions_car},
    {'name': '⭐ Star', 'icon': Icons.star},
    {'name': '🐠 Fish', 'icon': Icons.set_meal},
    {'name': '🌞 Sun', 'icon': Icons.wb_sunny},
    {'name': '🌙 Moon', 'icon': Icons.nightlight},
    {'name': '☁️ Cloud', 'icon': Icons.cloud},
    {'name': '🌈 Rainbow', 'icon': Icons.water_drop},
    {'name': '🎈 Balloon', 'icon': Icons.circle_outlined},
    {'name': '🎂 Cake', 'icon': Icons.cake},
    {'name': '🍎 Apple', 'icon': Icons.apple},
    {'name': '🍦 Ice Cream', 'icon': Icons.icecream},
    {'name': '🎁 Gift', 'icon': Icons.card_giftcard},
    {'name': '⚽ Ball', 'icon': Icons.sports_soccer},
    {'name': '🚀 Rocket', 'icon': Icons.rocket_launch},
    {'name': '✈️ Airplane', 'icon': Icons.flight},
    {'name': '🚢 Boat', 'icon': Icons.sailing},
    {'name': '🚂 Train', 'icon': Icons.train},
    {'name': '🎪 Tent', 'icon': Icons.roofing},
    {'name': '🏰 Castle', 'icon': Icons.castle},
    {'name': '🌳 Tree', 'icon': Icons.park},
    {'name': '🌻 Sunflower', 'icon': Icons.local_florist},
    {'name': '🐝 Bee', 'icon': Icons.pest_control},
    {'name': '🦆 Duck', 'icon': Icons.water},
    {'name': '🐙 Octopus', 'icon': Icons.waves},
    {'name': '🐢 Turtle', 'icon': Icons.pets},
    {'name': '🦀 Crab', 'icon': Icons.cruelty_free},
    {'name': '🐱 Cat', 'icon': Icons.pets},
    {'name': '🐶 Dog', 'icon': Icons.pets},
    {'name': '🐰 Rabbit', 'icon': Icons.catching_pokemon},
    {'name': '🍄 Mushroom', 'icon': Icons.food_bank},
    {'name': '🎨 Palette', 'icon': Icons.palette},
    {'name': '❤️ Heart', 'icon': Icons.favorite},
  ];

  void clearCanvas() {
    setState(() {
      points.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F7FA),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.arrow_back, color: Color(0xFFE17055)),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Coloring Fun',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2D3436),
                  ),
                ),
                Text(
                  'Color anything you like!',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: const Color(0xFF636E72),
                  ),
                ),
              ],
            ),
          ],
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: clearCanvas,
            tooltip: 'Clear Canvas',
          ),
        ],
      ),
      body: Column(
        children: [
          // Drawing selector
          Container(
            height: 90,
            color: Colors.white,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: drawings.length,
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDrawing = index;
                      points.clear();
                    });
                  },
                  child: Container(
                    width: 100,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      gradient: selectedDrawing == index
                          ? LinearGradient(
                              colors: [Colors.purple.shade300, Colors.purple.shade400],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      color: selectedDrawing == index ? null : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: selectedDrawing == index
                            ? Colors.purple.shade700
                            : Colors.transparent,
                        width: 3,
                      ),
                      boxShadow: selectedDrawing == index
                          ? [
                              BoxShadow(
                                color: Colors.purple.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          drawings[index]['icon'],
                          size: 36,
                          color: selectedDrawing == index
                              ? Colors.white
                              : Colors.grey.shade700,
                        ),
                        const SizedBox(height: 6),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            drawings[index]['name'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: selectedDrawing == index
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: selectedDrawing == index
                                  ? Colors.white
                                  : Colors.grey.shade700,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Canvas area
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: GestureDetector(
                  onPanStart: (details) {
                    setState(() {
                      points.add(
                        DrawingPoint(
                          details.localPosition,
                          isErasing ? Colors.white : selectedColor,
                          isErasing ? 20.0 : penSize,
                        ),
                      );
                    });
                  },
                  onPanUpdate: (details) {
                    setState(() {
                      points.add(
                        DrawingPoint(
                          details.localPosition,
                          isErasing ? Colors.white : selectedColor,
                          isErasing ? 20.0 : penSize,
                        ),
                      );
                    });
                  },
                  onPanEnd: (details) {
                    setState(() {
                      points.add(DrawingPoint(null, Colors.transparent, 0));
                    });
                  },
                  child: CustomPaint(
                    painter: DrawingPainter(points, selectedDrawing),
                    size: Size.infinite,
                  ),
                ),
              ),
            ),
          ),

          // Tools panel
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Pen size and eraser controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Pen/Brush mode
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            isErasing = false;
                          });
                        },
                        icon: const Icon(Icons.brush, size: 20),
                        label: const Text('Brush', style: TextStyle(fontSize: 12)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: !isErasing ? Colors.purple.shade400 : Colors.grey.shade300,
                          foregroundColor: !isErasing ? Colors.white : Colors.grey.shade700,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Eraser mode
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            isErasing = true;
                          });
                        },
                        icon: const Icon(Icons.auto_fix_high, size: 20),
                        label: const Text('Eraser', style: TextStyle(fontSize: 12)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isErasing ? Colors.orange.shade400 : Colors.grey.shade300,
                          foregroundColor: isErasing ? Colors.white : Colors.grey.shade700,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Pen size slider
                if (!isErasing)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.line_weight, size: 20, color: Colors.purple),
                            const SizedBox(width: 8),
                            Text(
                              'Pen Size: ${penSize.toInt()}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.purple.shade700,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: selectedColor,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: selectedColor.withValues(alpha: 0.5),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Container(
                                  width: penSize.clamp(2, 20),
                                  height: penSize.clamp(2, 20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SliderTheme(
                          data: SliderThemeData(
                            activeTrackColor: Colors.purple.shade300,
                            inactiveTrackColor: Colors.purple.shade100,
                            thumbColor: Colors.purple.shade500,
                            overlayColor: Colors.purple.withValues(alpha: 0.2),
                            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                          ),
                          child: Slider(
                            value: penSize,
                            min: 1.0,
                            max: 20.0,
                            divisions: 19,
                            onChanged: (value) {
                              setState(() {
                                penSize = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 12),

                // Color palette
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: colors.map((color) {
                    final isSelected = selectedColor == color && !isErasing;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedColor = color;
                          isErasing = false;
                        });
                      },
                      child: Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? Colors.black : Colors.white,
                            width: isSelected ? 4 : 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: color.withValues(alpha: 0.5),
                              blurRadius: isSelected ? 12 : 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 20,
                              )
                            : null,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DrawingPoint {
  final Offset? point;
  final Color color;
  final double strokeWidth;

  DrawingPoint(this.point, this.color, this.strokeWidth);
}

class DrawingPainter extends CustomPainter {
  final List<DrawingPoint> points;
  final int selectedDrawing;

  DrawingPainter(this.points, this.selectedDrawing);

  @override
  void paint(Canvas canvas, Size size) {
    // Draw the template outline
    _drawTemplate(canvas, size, selectedDrawing);

    // Draw user's coloring
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i].point != null && points[i + 1].point != null) {
        canvas.drawLine(
          points[i].point!,
          points[i + 1].point!,
          Paint()
            ..color = points[i].color
            ..strokeWidth = points[i].strokeWidth
            ..strokeCap = StrokeCap.round,
        );
      }
    }
  }

  void _drawTemplate(Canvas canvas, Size size, int template) {
    final paint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final cx = size.width / 2;
    final cy = size.height / 2;

    switch (template) {
      case 0: _drawButterfly(canvas, cx, cy, paint); break;
      case 1: _drawFlower(canvas, cx, cy, paint); break;
      case 2: _drawHouse(canvas, cx, cy, paint); break;
      case 3: _drawCar(canvas, cx, cy, paint); break;
      case 4: _drawStar(canvas, cx, cy, paint); break;
      case 5: _drawFish(canvas, cx, cy, paint); break;
      case 6: _drawSun(canvas, cx, cy, paint); break;
      case 7: _drawMoon(canvas, cx, cy, paint); break;
      case 8: _drawCloud(canvas, cx, cy, paint); break;
      case 9: _drawRainbow(canvas, cx, cy, paint); break;
      case 10: _drawBalloon(canvas, cx, cy, paint); break;
      case 11: _drawCake(canvas, cx, cy, paint); break;
      case 12: _drawApple(canvas, cx, cy, paint); break;
      case 13: _drawIceCream(canvas, cx, cy, paint); break;
      case 14: _drawGift(canvas, cx, cy, paint); break;
      case 15: _drawBall(canvas, cx, cy, paint); break;
      case 16: _drawRocket(canvas, cx, cy, paint); break;
      case 17: _drawAirplane(canvas, cx, cy, paint); break;
      case 18: _drawBoat(canvas, cx, cy, paint); break;
      case 19: _drawTrain(canvas, cx, cy, paint); break;
      case 20: _drawTent(canvas, cx, cy, paint); break;
      case 21: _drawCastle(canvas, cx, cy, paint); break;
      case 22: _drawTree(canvas, cx, cy, paint); break;
      case 23: _drawSunflower(canvas, cx, cy, paint); break;
      case 24: _drawBee(canvas, cx, cy, paint); break;
      case 25: _drawDuck(canvas, cx, cy, paint); break;
      case 26: _drawOctopus(canvas, cx, cy, paint); break;
      case 27: _drawTurtle(canvas, cx, cy, paint); break;
      case 28: _drawCrab(canvas, cx, cy, paint); break;
      case 29: _drawCat(canvas, cx, cy, paint); break;
      case 30: _drawDog(canvas, cx, cy, paint); break;
      case 31: _drawRabbit(canvas, cx, cy, paint); break;
      case 32: _drawMushroom(canvas, cx, cy, paint); break;
      case 33: _drawPalette(canvas, cx, cy, paint); break;
      case 34: _drawHeart(canvas, cx, cy, paint); break;
    }
  }

  void _drawButterfly(Canvas canvas, double cx, double cy, Paint paint) {
    canvas.drawOval(Rect.fromCenter(center: Offset(cx - 60, cy - 30), width: 80, height: 100), paint);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx - 60, cy + 40), width: 70, height: 80), paint);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx + 60, cy - 30), width: 80, height: 100), paint);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx + 60, cy + 40), width: 70, height: 80), paint);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy), width: 20, height: 120), paint);
    canvas.drawLine(Offset(cx - 5, cy - 60), Offset(cx - 20, cy - 80), paint);
    canvas.drawLine(Offset(cx + 5, cy - 60), Offset(cx + 20, cy - 80), paint);
    canvas.drawCircle(Offset(cx - 20, cy - 80), 4, paint);
    canvas.drawCircle(Offset(cx + 20, cy - 80), 4, paint);
  }

  void _drawFlower(Canvas canvas, double cx, double cy, Paint paint) {
    for (int i = 0; i < 6; i++) {
      final angle = (i * 60) * math.pi / 180;
      final x = cx + 50 * math.cos(angle);
      final y = cy + 50 * math.sin(angle);
      canvas.drawCircle(Offset(x, y), 30, paint);
    }
    canvas.drawCircle(Offset(cx, cy), 25, paint);
    canvas.drawLine(Offset(cx, cy + 25), Offset(cx, cy + 120), paint);
    final leafPath1 = Path()
      ..moveTo(cx, cy + 70)
      ..quadraticBezierTo(cx - 30, cy + 80, cx - 25, cy + 100)
      ..quadraticBezierTo(cx - 20, cy + 85, cx, cy + 75);
    canvas.drawPath(leafPath1, paint);
    final leafPath2 = Path()
      ..moveTo(cx, cy + 90)
      ..quadraticBezierTo(cx + 30, cy + 100, cx + 25, cy + 120)
      ..quadraticBezierTo(cx + 20, cy + 105, cx, cy + 95);
    canvas.drawPath(leafPath2, paint);
  }

  void _drawHouse(Canvas canvas, double cx, double cy, Paint paint) {
    canvas.drawRect(Rect.fromLTWH(cx - 80, cy - 20, 160, 100), paint);
    final roofPath = Path()
      ..moveTo(cx - 100, cy - 20)
      ..lineTo(cx, cy - 80)
      ..lineTo(cx + 100, cy - 20)
      ..close();
    canvas.drawPath(roofPath, paint);
    canvas.drawRect(Rect.fromLTWH(cx - 25, cy + 20, 50, 60), paint);
    canvas.drawCircle(Offset(cx + 15, cy + 50), 3, paint);
    canvas.drawRect(Rect.fromLTWH(cx - 65, cy, 30, 30), paint);
    canvas.drawRect(Rect.fromLTWH(cx + 35, cy, 30, 30), paint);
    canvas.drawLine(Offset(cx - 50, cy), Offset(cx - 50, cy + 30), paint);
    canvas.drawLine(Offset(cx - 65, cy + 15), Offset(cx - 35, cy + 15), paint);
    canvas.drawLine(Offset(cx + 50, cy), Offset(cx + 50, cy + 30), paint);
    canvas.drawLine(Offset(cx + 35, cy + 15), Offset(cx + 65, cy + 15), paint);
  }

  void _drawCar(Canvas canvas, double cx, double cy, Paint paint) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(cx - 80, cy - 20, 160, 50), const Radius.circular(10)),
      paint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(cx - 50, cy - 50, 100, 30), const Radius.circular(10)),
      paint,
    );
    canvas.drawCircle(Offset(cx - 45, cy + 30), 20, paint);
    canvas.drawCircle(Offset(cx + 45, cy + 30), 20, paint);
    canvas.drawCircle(Offset(cx - 45, cy + 30), 10, paint);
    canvas.drawCircle(Offset(cx + 45, cy + 30), 10, paint);
    canvas.drawRect(Rect.fromLTWH(cx - 45, cy - 45, 40, 20), paint);
    canvas.drawRect(Rect.fromLTWH(cx + 5, cy - 45, 40, 20), paint);
  }

  void _drawStar(Canvas canvas, double cx, double cy, Paint paint) {
    final path = Path();
    final outerRadius = 80.0;
    final innerRadius = 35.0;
    for (int i = 0; i < 10; i++) {
      final radius = i.isEven ? outerRadius : innerRadius;
      final angle = (i * 36 - 90) * math.pi / 180;
      final x = cx + radius * math.cos(angle);
      final y = cy + radius * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawFish(Canvas canvas, double cx, double cy, Paint paint) {
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy), width: 120, height: 80), paint);
    final tailPath = Path()
      ..moveTo(cx + 60, cy)
      ..lineTo(cx + 100, cy - 40)
      ..lineTo(cx + 100, cy + 40)
      ..close();
    canvas.drawPath(tailPath, paint);
    final topFinPath = Path()
      ..moveTo(cx - 10, cy - 40)
      ..lineTo(cx, cy - 70)
      ..lineTo(cx + 20, cy - 40);
    canvas.drawPath(topFinPath, paint);
    final bottomFinPath = Path()
      ..moveTo(cx, cy + 40)
      ..lineTo(cx + 10, cy + 60)
      ..lineTo(cx + 20, cy + 40);
    canvas.drawPath(bottomFinPath, paint);
    canvas.drawCircle(Offset(cx - 25, cy - 10), 12, paint);
    canvas.drawCircle(Offset(cx - 25, cy - 10), 6, Paint()..color = Colors.grey.shade700..style = PaintingStyle.fill);
  }

  void _drawSun(Canvas canvas, double cx, double cy, Paint paint) {
    canvas.drawCircle(Offset(cx, cy), 50, paint);
    for (int i = 0; i < 12; i++) {
      final angle = (i * 30) * math.pi / 180;
      final x1 = cx + 60 * math.cos(angle);
      final y1 = cy + 60 * math.sin(angle);
      final x2 = cx + 85 * math.cos(angle);
      final y2 = cy + 85 * math.sin(angle);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint..strokeWidth = 4);
    }
  }

  void _drawMoon(Canvas canvas, double cx, double cy, Paint paint) {
    canvas.drawCircle(Offset(cx, cy), 60, paint);
    canvas.drawCircle(Offset(cx + 25, cy - 15), 55, Paint()..color = Colors.white..style = PaintingStyle.fill);
    canvas.drawCircle(Offset(cx - 20, cy - 10), 8, paint);
    canvas.drawCircle(Offset(cx - 5, cy + 15), 5, paint);
    canvas.drawCircle(Offset(cx + 10, cy + 25), 6, paint);
  }

  void _drawCloud(Canvas canvas, double cx, double cy, Paint paint) {
    canvas.drawCircle(Offset(cx - 40, cy), 35, paint);
    canvas.drawCircle(Offset(cx - 10, cy - 20), 40, paint);
    canvas.drawCircle(Offset(cx + 20, cy - 10), 38, paint);
    canvas.drawCircle(Offset(cx + 45, cy + 5), 32, paint);
    canvas.drawRect(Rect.fromLTWH(cx - 60, cy, 120, 30), Paint()..color = Colors.white..style = PaintingStyle.fill);
  }

  void _drawRainbow(Canvas canvas, double cx, double cy, Paint paint) {
    final colors = [Colors.red, Colors.orange, Colors.yellow, Colors.green, Colors.blue, Colors.purple];
    for (int i = 0; i < 6; i++) {
      canvas.drawArc(
        Rect.fromCenter(center: Offset(cx, cy + 50), width: 200 - (i * 20), height: 200 - (i * 20)),
        math.pi,
        math.pi,
        false,
        Paint()..color = colors[i]..strokeWidth = 8..style = PaintingStyle.stroke,
      );
    }
  }

  void _drawBalloon(Canvas canvas, double cx, double cy, Paint paint) {
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy - 30), width: 80, height: 100), paint);
    canvas.drawLine(Offset(cx, cy + 20), Offset(cx, cy + 80), paint);
    final path = Path()
      ..moveTo(cx - 8, cy + 20)
      ..quadraticBezierTo(cx, cy + 25, cx + 8, cy + 20);
    canvas.drawPath(path, paint);
    canvas.drawLine(Offset(cx, cy + 80), Offset(cx - 20, cy + 100), paint);
    canvas.drawLine(Offset(cx, cy + 80), Offset(cx + 20, cy + 100), paint);
  }

  void _drawCake(Canvas canvas, double cx, double cy, Paint paint) {
    canvas.drawRect(Rect.fromLTWH(cx - 60, cy, 120, 60), paint);
    canvas.drawRect(Rect.fromLTWH(cx - 45, cy - 30, 90, 30), paint);
    for (int i = 0; i < 3; i++) {
      final x = cx - 30 + (i * 30);
      canvas.drawRect(Rect.fromLTWH(x - 3, cy - 45, 6, 15), paint);
      canvas.drawOval(Rect.fromCenter(center: Offset(x, cy - 48), width: 10, height: 15), paint);
    }
    for (int i = 0; i < 4; i++) {
      canvas.drawLine(Offset(cx - 60 + (i * 30), cy + 15), Offset(cx - 45 + (i * 30), cy + 35), paint);
    }
  }

  void _drawApple(Canvas canvas, double cx, double cy, Paint paint) {
    canvas.drawCircle(Offset(cx - 10, cy), 50, paint);
    canvas.drawCircle(Offset(cx + 10, cy), 50, paint);
    canvas.drawRect(Rect.fromLTWH(cx - 5, cy - 60, 10, 25), paint);
    final leafPath = Path()
      ..moveTo(cx + 5, cy - 50)
      ..quadraticBezierTo(cx + 25, cy - 60, cx + 30, cy - 45)
      ..quadraticBezierTo(cx + 20, cy - 50, cx + 10, cy - 48);
    canvas.drawPath(leafPath, paint);
  }

  void _drawIceCream(Canvas canvas, double cx, double cy, Paint paint) {
    canvas.drawCircle(Offset(cx, cy - 40), 45, paint);
    canvas.drawCircle(Offset(cx - 25, cy - 60), 35, paint);
    canvas.drawCircle(Offset(cx + 25, cy - 60), 35, paint);
    final conePath = Path()
      ..moveTo(cx - 40, cy)
      ..lineTo(cx, cy + 80)
      ..lineTo(cx + 40, cy)
      ..close();
    canvas.drawPath(conePath, paint);
    for (int i = 0; i < 4; i++) {
      canvas.drawLine(
        Offset(cx - 30 + (i * 15), cy + (i * 15)),
        Offset(cx + 30 - (i * 15), cy + (i * 15)),
        paint,
      );
    }
  }

  void _drawGift(Canvas canvas, double cx, double cy, Paint paint) {
    canvas.drawRect(Rect.fromLTWH(cx - 60, cy - 10, 120, 80), paint);
    canvas.drawRect(Rect.fromLTWH(cx - 70, cy - 30, 140, 20), paint);
    canvas.drawRect(Rect.fromLTWH(cx - 5, cy - 30, 10, 100), paint);
    canvas.drawRect(Rect.fromLTWH(cx - 70, cy - 5, 140, 10), paint);
    final bowPath1 = Path()
      ..moveTo(cx - 30, cy - 30)
      ..quadraticBezierTo(cx - 40, cy - 60, cx - 20, cy - 70)
      ..quadraticBezierTo(cx - 25, cy - 50, cx - 30, cy - 30);
    canvas.drawPath(bowPath1, paint);
    final bowPath2 = Path()
      ..moveTo(cx + 30, cy - 30)
      ..quadraticBezierTo(cx + 40, cy - 60, cx + 20, cy - 70)
      ..quadraticBezierTo(cx + 25, cy - 50, cx + 30, cy - 30);
    canvas.drawPath(bowPath2, paint);
  }

  void _drawBall(Canvas canvas, double cx, double cy, Paint paint) {
    canvas.drawCircle(Offset(cx, cy), 60, paint);
    final path1 = Path()
      ..moveTo(cx - 60, cy)
      ..quadraticBezierTo(cx - 30, cy - 40, cx, cy)
      ..quadraticBezierTo(cx + 30, cy + 40, cx + 60, cy);
    canvas.drawPath(path1, paint);
    final path2 = Path()
      ..moveTo(cx, cy - 60)
      ..quadraticBezierTo(cx + 40, cy - 30, cx, cy)
      ..quadraticBezierTo(cx - 40, cy + 30, cx, cy + 60);
    canvas.drawPath(path2, paint);
  }

  void _drawRocket(Canvas canvas, double cx, double cy, Paint paint) {
    canvas.drawRect(Rect.fromLTWH(cx - 25, cy - 20, 50, 80), paint);
    final nosePath = Path()
      ..moveTo(cx - 25, cy - 20)
      ..lineTo(cx, cy - 60)
      ..lineTo(cx + 25, cy - 20)
      ..close();
    canvas.drawPath(nosePath, paint);
    canvas.drawCircle(Offset(cx, cy + 10), 15, paint);
    final finLeft = Path()
      ..moveTo(cx - 25, cy + 40)
      ..lineTo(cx - 45, cy + 60)
      ..lineTo(cx - 25, cy + 60)
      ..close();
    canvas.drawPath(finLeft, paint);
    final finRight = Path()
      ..moveTo(cx + 25, cy + 40)
      ..lineTo(cx + 45, cy + 60)
      ..lineTo(cx + 25, cy + 60)
      ..close();
    canvas.drawPath(finRight, paint);
  }

  void _drawAirplane(Canvas canvas, double cx, double cy, Paint paint) {
    canvas.drawRect(Rect.fromLTWH(cx - 10, cy - 60, 20, 120), paint);
    canvas.drawRect(Rect.fromLTWH(cx - 70, cy - 10, 140, 20), paint);
    canvas.drawRect(Rect.fromLTWH(cx - 40, cy + 40, 80, 15), paint);
    final nosePath = Path()
      ..moveTo(cx - 10, cy - 60)
      ..lineTo(cx, cy - 80)
      ..lineTo(cx + 10, cy - 60);
    canvas.drawPath(nosePath, paint);
  }

  void _drawBoat(Canvas canvas, double cx, double cy, Paint paint) {
    final hullPath = Path()
      ..moveTo(cx - 80, cy)
      ..lineTo(cx - 60, cy + 40)
      ..lineTo(cx + 60, cy + 40)
      ..lineTo(cx + 80, cy)
      ..close();
    canvas.drawPath(hullPath, paint);
    canvas.drawLine(Offset(cx, cy), Offset(cx, cy - 80), paint);
    final sailPath = Path()
      ..moveTo(cx, cy - 80)
      ..lineTo(cx + 50, cy - 20)
      ..lineTo(cx, cy)
      ..close();
    canvas.drawPath(sailPath, paint);
  }

  void _drawTrain(Canvas canvas, double cx, double cy, Paint paint) {
    canvas.drawRect(Rect.fromLTWH(cx - 60, cy - 40, 120, 60), paint);
    canvas.drawRect(Rect.fromLTWH(cx - 40, cy - 60, 50, 20), paint);
    canvas.drawRect(Rect.fromLTWH(cx - 35, cy - 20, 30, 25), paint);
    canvas.drawRect(Rect.fromLTWH(cx + 10, cy - 20, 30, 25), paint);
    canvas.drawCircle(Offset(cx - 35, cy + 25), 12, paint);
    canvas.drawCircle(Offset(cx, cy + 25), 12, paint);
    canvas.drawCircle(Offset(cx + 35, cy + 25), 12, paint);
  }

  void _drawTent(Canvas canvas, double cx, double cy, Paint paint) {
    final tentPath = Path()
      ..moveTo(cx - 80, cy + 60)
      ..lineTo(cx, cy - 60)
      ..lineTo(cx + 80, cy + 60)
      ..close();
    canvas.drawPath(tentPath, paint);
    canvas.drawLine(Offset(cx, cy - 60), Offset(cx, cy + 60), paint);
    canvas.drawLine(Offset(cx - 80, cy + 60), Offset(cx + 80, cy + 60), paint);
  }

  void _drawCastle(Canvas canvas, double cx, double cy, Paint paint) {
    canvas.drawRect(Rect.fromLTWH(cx - 80, cy - 40, 160, 100), paint);
    canvas.drawRect(Rect.fromLTWH(cx - 100, cy - 60, 40, 80), paint);
    canvas.drawRect(Rect.fromLTWH(cx + 60, cy - 60, 40, 80), paint);
    canvas.drawRect(Rect.fromLTWH(cx - 25, cy + 10, 50, 50), paint);
    for (int i = 0; i < 5; i++) {
      canvas.drawRect(Rect.fromLTWH(cx - 90 + (i * 45), cy - 70, 20, 10), paint);
    }
  }

  void _drawTree(Canvas canvas, double cx, double cy, Paint paint) {
    canvas.drawRect(Rect.fromLTWH(cx - 15, cy + 20, 30, 60), paint);
    canvas.drawCircle(Offset(cx, cy - 20), 50, paint);
    canvas.drawCircle(Offset(cx - 35, cy), 40, paint);
    canvas.drawCircle(Offset(cx + 35, cy), 40, paint);
    canvas.drawCircle(Offset(cx, cy + 15), 45, paint);
  }

  void _drawSunflower(Canvas canvas, double cx, double cy, Paint paint) {
    for (int i = 0; i < 12; i++) {
      final angle = (i * 30) * math.pi / 180;
      final x = cx + 45 * math.cos(angle);
      final y = cy + 45 * math.sin(angle);
      canvas.drawOval(Rect.fromCenter(center: Offset(x, y), width: 35, height: 50), paint);
    }
    canvas.drawCircle(Offset(cx, cy), 30, paint);
    canvas.drawLine(Offset(cx, cy + 30), Offset(cx, cy + 100), paint);
  }

  void _drawBee(Canvas canvas, double cx, double cy, Paint paint) {
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy), width: 80, height: 60), paint);
    for (int i = 0; i < 3; i++) {
      canvas.drawLine(Offset(cx - 30 + (i * 20), cy - 30), Offset(cx - 30 + (i * 20), cy + 30), paint..strokeWidth = 6);
    }
    canvas.drawOval(Rect.fromCenter(center: Offset(cx - 35, cy), width: 40, height: 35), paint);
    final wingLeft = Path()
      ..moveTo(cx - 20, cy - 30)
      ..quadraticBezierTo(cx - 50, cy - 60, cx - 30, cy - 40);
    canvas.drawPath(wingLeft, paint);
    final wingRight = Path()
      ..moveTo(cx + 20, cy - 30)
      ..quadraticBezierTo(cx + 50, cy - 60, cx + 30, cy - 40);
    canvas.drawPath(wingRight, paint);
  }

  void _drawDuck(Canvas canvas, double cx, double cy, Paint paint) {
    canvas.drawCircle(Offset(cx, cy), 50, paint);
    canvas.drawCircle(Offset(cx - 30, cy - 25), 30, paint);
    final beakPath = Path()
      ..moveTo(cx - 50, cy - 20)
      ..lineTo(cx - 70, cy - 25)
      ..lineTo(cx - 50, cy - 30);
    canvas.drawPath(beakPath, paint);
    canvas.drawCircle(Offset(cx - 35, cy - 30), 5, paint);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx + 30, cy + 40), width: 40, height: 25), paint);
  }

  void _drawOctopus(Canvas canvas, double cx, double cy, Paint paint) {
    canvas.drawCircle(Offset(cx, cy - 20), 55, paint);
    for (int i = 0; i < 8; i++) {
      final x = cx - 70 + (i * 20);
      final path = Path()
        ..moveTo(cx - 50 + (i * 14), cy + 20)
        ..quadraticBezierTo(x, cy + 60, x + 10, cy + 80);
      canvas.drawPath(path, paint);
    }
    canvas.drawCircle(Offset(cx - 20, cy - 30), 8, paint);
    canvas.drawCircle(Offset(cx + 20, cy - 30), 8, paint);
  }

  void _drawTurtle(Canvas canvas, double cx, double cy, Paint paint) {
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy), width: 100, height: 70), paint);
    canvas.drawCircle(Offset(cx - 60, cy - 10), 20, paint);
    canvas.drawCircle(Offset(cx - 10, cy - 10), 15, paint);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx - 70, cy + 20), width: 30, height: 15), paint);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx - 30, cy + 30), width: 25, height: 15), paint);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx + 30, cy + 30), width: 25, height: 15), paint);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx + 70, cy + 20), width: 30, height: 15), paint);
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 2; j++) {
        canvas.drawCircle(Offset(cx - 30 + (i * 30), cy - 15 + (j * 20)), 8, paint);
      }
    }
  }

  void _drawCrab(Canvas canvas, double cx, double cy, Paint paint) {
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy), width: 80, height: 60), paint);
    canvas.drawCircle(Offset(cx - 20, cy - 20), 12, paint);
    canvas.drawCircle(Offset(cx + 20, cy - 20), 12, paint);
    final clawLeft = Path()
      ..moveTo(cx - 40, cy)
      ..lineTo(cx - 70, cy - 20)
      ..moveTo(cx - 70, cy - 20)
      ..lineTo(cx - 75, cy - 10)
      ..moveTo(cx - 70, cy - 20)
      ..lineTo(cx - 80, cy - 25);
    canvas.drawPath(clawLeft, paint);
    final clawRight = Path()
      ..moveTo(cx + 40, cy)
      ..lineTo(cx + 70, cy - 20)
      ..moveTo(cx + 70, cy - 20)
      ..lineTo(cx + 75, cy - 10)
      ..moveTo(cx + 70, cy - 20)
      ..lineTo(cx + 80, cy - 25);
    canvas.drawPath(clawRight, paint);
    for (int i = 0; i < 3; i++) {
      canvas.drawLine(Offset(cx - 35 + (i * 15), cy + 30), Offset(cx - 40 + (i * 15), cy + 50), paint);
      canvas.drawLine(Offset(cx + 5 + (i * 15), cy + 30), Offset(cx + (i * 15), cy + 50), paint);
    }
  }

  void _drawCat(Canvas canvas, double cx, double cy, Paint paint) {
    canvas.drawCircle(Offset(cx, cy), 50, paint);
    final earLeft = Path()
      ..moveTo(cx - 40, cy - 30)
      ..lineTo(cx - 50, cy - 70)
      ..lineTo(cx - 20, cy - 40);
    canvas.drawPath(earLeft, paint);
    final earRight = Path()
      ..moveTo(cx + 40, cy - 30)
      ..lineTo(cx + 50, cy - 70)
      ..lineTo(cx + 20, cy - 40);
    canvas.drawPath(earRight, paint);
    canvas.drawCircle(Offset(cx - 18, cy - 10), 8, paint);
    canvas.drawCircle(Offset(cx + 18, cy - 10), 8, paint);
    canvas.drawCircle(Offset(cx, cy + 10), 6, paint);
    final mouthLeft = Path()
      ..moveTo(cx, cy + 10)
      ..quadraticBezierTo(cx - 10, cy + 20, cx - 15, cy + 15);
    canvas.drawPath(mouthLeft, paint);
    final mouthRight = Path()
      ..moveTo(cx, cy + 10)
      ..quadraticBezierTo(cx + 10, cy + 20, cx + 15, cy + 15);
    canvas.drawPath(mouthRight, paint);
  }

  void _drawDog(Canvas canvas, double cx, double cy, Paint paint) {
    canvas.drawCircle(Offset(cx, cy), 50, paint);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx - 55, cy - 15), width: 30, height: 50), paint);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx + 55, cy - 15), width: 30, height: 50), paint);
    canvas.drawCircle(Offset(cx - 18, cy - 10), 8, paint);
    canvas.drawCircle(Offset(cx + 18, cy - 10), 8, paint);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy + 15), width: 25, height: 20), paint);
    canvas.drawCircle(Offset(cx, cy + 5), 6, paint);
    final tongue = Path()
      ..moveTo(cx, cy + 25)
      ..lineTo(cx - 5, cy + 35)
      ..lineTo(cx + 5, cy + 35)
      ..close();
    canvas.drawPath(tongue, paint);
  }

  void _drawRabbit(Canvas canvas, double cx, double cy, Paint paint) {
    canvas.drawCircle(Offset(cx, cy), 50, paint);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx - 25, cy - 60), width: 20, height: 70), paint);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx + 25, cy - 60), width: 20, height: 70), paint);
    canvas.drawCircle(Offset(cx - 18, cy - 10), 8, paint);
    canvas.drawCircle(Offset(cx + 18, cy - 10), 8, paint);
    canvas.drawCircle(Offset(cx, cy + 10), 5, paint);
    canvas.drawLine(Offset(cx, cy + 10), Offset(cx - 15, cy + 18), paint);
    canvas.drawLine(Offset(cx, cy + 10), Offset(cx + 15, cy + 18), paint);
    canvas.drawCircle(Offset(cx, cy + 60), 25, paint);
  }

  void _drawMushroom(Canvas canvas, double cx, double cy, Paint paint) {
    canvas.drawArc(Rect.fromCenter(center: Offset(cx, cy - 20), width: 120, height: 100), math.pi, math.pi, false, paint);
    canvas.drawRect(Rect.fromLTWH(cx - 20, cy - 20, 40, 70), paint);
    for (int i = 0; i < 8; i++) {
      final x = cx - 50 + (i * 15);
      final y = cy - 40 + (i.isEven ? 0 : 10);
      canvas.drawCircle(Offset(x, y), 8, Paint()..color = Colors.white..style = PaintingStyle.fill);
    }
  }

  void _drawPalette(Canvas canvas, double cx, double cy, Paint paint) {
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy), width: 120, height: 100), paint);
    canvas.drawCircle(Offset(cx + 40, cy + 30), 15, Paint()..color = Colors.white..style = PaintingStyle.fill);
    final colors = [
      Offset(cx - 30, cy - 20),
      Offset(cx, cy - 25),
      Offset(cx + 25, cy - 15),
      Offset(cx - 25, cy + 5),
      Offset(cx + 5, cy + 10),
    ];
    for (var pos in colors) {
      canvas.drawCircle(pos, 12, paint);
    }
  }

  void _drawHeart(Canvas canvas, double cx, double cy, Paint paint) {
    final path = Path();
    path.moveTo(cx, cy + 50);
    path.cubicTo(cx - 80, cy - 20, cx - 80, cy - 60, cx - 40, cy - 60);
    path.cubicTo(cx - 20, cy - 60, cx, cy - 40, cx, cy - 20);
    path.cubicTo(cx, cy - 40, cx + 20, cy - 60, cx + 40, cy - 60);
    path.cubicTo(cx + 80, cy - 60, cx + 80, cy - 20, cx, cy + 50);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

