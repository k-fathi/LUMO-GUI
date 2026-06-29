import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DayLearnScreen extends StatefulWidget {
  const DayLearnScreen({super.key});

  @override
  State<DayLearnScreen> createState() => _DayLearnScreenState();
}

class _DayLearnScreenState extends State<DayLearnScreen> with SingleTickerProviderStateMixin {
  String? selectedDay;
  late AnimationController _animationController;

  final List<Map<String, dynamic>> days = [
    {
      'name': 'Saturday',
      'short': 'Sat',
      'color': const Color(0xFF6C5CE7),
      'icon': Icons.beach_access,
      'emoji': '🏖️',
    },
    {
      'name': 'Sunday',
      'short': 'Sun',
      'color': const Color(0xFFFF7675),
      'icon': Icons.home,
      'emoji': '🏡',
    },
    {
      'name': 'Monday',
      'short': 'Mon',
      'color': Colors.lightGreen,
      'icon': Icons.wb_sunny,
      'emoji': '🌅',
    },
    {
      'name': 'Tuesday',
      'short': 'Tue',
      'color': Colors.teal,
      'icon': Icons.brightness_5,
      'emoji': '🌞',
    },
    {
      'name': 'Wednesday',
      'short': 'Wed',
      'color': const Color(0xFFFFA07A),
      'icon': Icons.wb_cloudy,
      'emoji': '☁️',
    },
    {
      'name': 'Thursday',
      'short': 'Thu',
      'color': const Color(0xFFFF6B9D),
      'icon': Icons.flash_on,
      'emoji': '⚡',
    },
    {
      'name': 'Friday',
      'short': 'Fri',
      'color': const Color(0xFFFCB040),
      'icon': Icons.celebration,
      'emoji': '🎉',
    },

  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  Future<void> _speak(String dayName) async {
    setState(() {
      selectedDay = dayName;
    });
    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    final List<String> args = ['-s', '170', '-p', '70', '-v', 'en-us+f4', dayName];

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

  @override
  void dispose() {
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
              const Color(0xFF4ECDC4).withValues(alpha: 0.1),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView( // ✅ التغيير الأول
            child: Column(
              children: [
                _buildHeader(),
                _buildInstructions(),
                _buildDaysList(), // ✅ شيلنا Expanded
              ],
            ),
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
              child: Icon(Icons.arrow_back, color: Color(0xFF4ECDC4)),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Learn Days',
                  style: TextStyle(fontFamily: 'Poppins',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2D3436),
                  ),
                ),
                Text(
                  'Tap any day to hear its name!',
                  style: TextStyle(fontFamily: 'Poppins',
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
              color: const Color(0xFF4ECDC4),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4ECDC4).withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(Icons.volume_up, color: Colors.white, size: 24),
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
          colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4ECDC4).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.calendar_today, color: Colors.white, size: 28),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '7 Days in a Week',
                  style: TextStyle(fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Learn all the days of the week!',
                  style: TextStyle(fontFamily: 'Poppins',
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDaysList() {
    return ListView.builder(
      shrinkWrap: true, // ✅ التغيير الثاني
      physics: const NeverScrollableScrollPhysics(), // ✅ التغيير الثالث
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: days.length,
      itemBuilder: (context, index) {
        final day = days[index];
        final isSelected = selectedDay == day['name'];

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(bottom: 16),
          child: GestureDetector(
            onTap: () => _speak(day['name']),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    day['color'],
                    (day['color'] as Color).withValues(alpha: 0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: (day['color'] as Color).withValues(alpha: 0.4),
                    blurRadius: isSelected ? 20 : 12,
                    offset: Offset(0, isSelected ? 8 : 4),
                  ),
                ],
                border: Border.all(
                  color: isSelected ? Colors.white : Colors.transparent,
                  width: 3,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(fontFamily: 'Poppins',
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          day['name'],
                          style: TextStyle(fontFamily: 'Poppins',
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          day['short'],
                          style: TextStyle(fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        day['emoji'],
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 40),
                      ),
                      SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(day['icon'], color: Colors.white, size: 28),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}