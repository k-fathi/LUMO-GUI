import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class FreeDrawScreen extends StatefulWidget {
  const FreeDrawScreen({super.key});

  @override
  State<FreeDrawScreen> createState() => _FreeDrawScreenState();
}

class _FreeDrawScreenState extends State<FreeDrawScreen> {
  List<DrawingPoint?> drawingPoints = [];
  Color selectedColor = Colors.black;
  double strokeWidth = 5.0;
  bool isEraser = false;

  // Available colors for drawing
  final List<Color> colors = [
    Colors.black,
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.brown,
    Colors.cyan,
    Colors.lime,
    Colors.indigo,
    Colors.teal,
    Colors.amber,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildToolbar(),
            Expanded(
              child: _buildCanvas(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
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
                    'Drawing Zone',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2D3436),
                    ),
                  ),
                  Text(
                    'Draw anything you like!',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: const Color(0xFF636E72),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              // Undo button
              IconButton(
                onPressed: drawingPoints.isEmpty ? null : _undo,
                icon: const Icon(Icons.undo),
                color: const Color(0xFFE17055),
                iconSize: 28,
              ),
              // Clear all button
              IconButton(
                onPressed: drawingPoints.isEmpty ? null : _showClearDialog,
                icon: const Icon(Icons.delete_outline),
                color: Colors.red,
                iconSize: 28,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Color palette
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: colors.length,
              itemBuilder: (context, index) {
                final color = colors[index];
                final isSelected = selectedColor == color && !isEraser;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedColor = color;
                      isEraser = false;
                    });
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? const Color(0xFFE17055) : Colors.grey.shade300,
                        width: isSelected ? 4 : 2,
                      ),
                      boxShadow: [
                        if (isSelected)
                          BoxShadow(
                            color: color.withValues(alpha: 0.5),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                      ],
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 24)
                        : null,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          // Tools row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Eraser
              _buildToolButton(
                icon: Icons.cleaning_services,
                label: 'Eraser',
                isSelected: isEraser,
                color: Colors.grey,
                onTap: () {
                  setState(() {
                    isEraser = true;
                  });
                },
              ),
              // Pen
              _buildToolButton(
                icon: Icons.edit,
                label: 'Pen',
                isSelected: !isEraser,
                color: const Color(0xFFE17055),
                onTap: () {
                  setState(() {
                    isEraser = false;
                  });
                },
              ),
              // Stroke width selector
              _buildStrokeWidthSelector(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToolButton({
    required IconData icon,
    required String label,
    required bool isSelected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? color : Colors.grey.shade600,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? color : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStrokeWidthSelector() {
    return PopupMenuButton<double>(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFE17055).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFE17055),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.line_weight,
              color: const Color(0xFFE17055),
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              '${strokeWidth.toInt()}px',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFE17055),
              ),
            ),
          ],
        ),
      ),
      itemBuilder: (context) => [
        _buildStrokeWidthItem(2.0, 'Thin'),
        _buildStrokeWidthItem(5.0, 'Normal'),
        _buildStrokeWidthItem(8.0, 'Thick'),
        _buildStrokeWidthItem(12.0, 'Bold'),
        _buildStrokeWidthItem(16.0, 'Extra Bold'),
      ],
      onSelected: (value) {
        setState(() {
          strokeWidth = value;
        });
      },
    );
  }

  PopupMenuItem<double> _buildStrokeWidthItem(double width, String label) {
    return PopupMenuItem<double>(
      value: width,
      child: Row(
        children: [
          Container(
            width: 40,
            height: width,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(width / 2),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: strokeWidth == width ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCanvas() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: GestureDetector(
          onPanStart: (details) {
            setState(() {
              drawingPoints.add(
                DrawingPoint(
                  details.localPosition,
                  Paint()
                    ..color = isEraser ? Colors.white : selectedColor
                    ..isAntiAlias = true
                    ..strokeWidth = isEraser ? strokeWidth * 3 : strokeWidth
                    ..strokeCap = StrokeCap.round,
                ),
              );
            });
          },
          onPanUpdate: (details) {
            setState(() {
              drawingPoints.add(
                DrawingPoint(
                  details.localPosition,
                  Paint()
                    ..color = isEraser ? Colors.white : selectedColor
                    ..isAntiAlias = true
                    ..strokeWidth = isEraser ? strokeWidth * 3 : strokeWidth
                    ..strokeCap = StrokeCap.round,
                ),
              );
            });
          },
          onPanEnd: (details) {
            setState(() {
              drawingPoints.add(null);
            });
          },
          child: CustomPaint(
            painter: DrawingPainter(drawingPoints),
            child: Container(),
          ),
        ),
      ),
    );
  }

  void _undo() {
    setState(() {
      if (drawingPoints.isNotEmpty) {
        // Find the last null point (end of stroke)
        int lastNullIndex = -1;
        for (int i = drawingPoints.length - 1; i >= 0; i--) {
          if (drawingPoints[i] == null) {
            if (lastNullIndex == -1) {
              lastNullIndex = i;
            } else {
              // Remove from this null to the end
              drawingPoints.removeRange(i + 1, drawingPoints.length);
              return;
            }
          }
        }
        // If no previous null found, clear all
        drawingPoints.clear();
      }
    });
  }

  void _showClearDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Clear Drawing?',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Are you sure you want to clear your drawing? This cannot be undone.',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                drawingPoints.clear();
              });
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Clear All',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

// Drawing point class
class DrawingPoint {
  final Offset offset;
  final Paint paint;

  DrawingPoint(this.offset, this.paint);
}

// Custom painter for drawing
class DrawingPainter extends CustomPainter {
  final List<DrawingPoint?> drawingPoints;

  DrawingPainter(this.drawingPoints);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < drawingPoints.length - 1; i++) {
      if (drawingPoints[i] != null && drawingPoints[i + 1] != null) {
        canvas.drawLine(
          drawingPoints[i]!.offset,
          drawingPoints[i + 1]!.offset,
          drawingPoints[i]!.paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
