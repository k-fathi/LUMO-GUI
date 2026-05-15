import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class DailyLifeLearnScreen extends StatefulWidget {
  const DailyLifeLearnScreen({super.key});

  @override
  State<DailyLifeLearnScreen> createState() => _DailyLifeLearnScreenState();
}

class _DailyLifeLearnScreenState extends State<DailyLifeLearnScreen>
    with SingleTickerProviderStateMixin {
  String? selectedItem;
  String selectedCategory = 'Weather';
  late AnimationController _animationController;

  final Map<String, List<Map<String, dynamic>>> dailyLifeCategories = {
    'Weather': [
      {'name': 'Sunny', 'emoji': '☀️', 'icon': Icons.wb_sunny, 'color': const Color(0xFFF39C12), 'description': 'Bright and warm!'},
      {'name': 'Rainy', 'emoji': '🌧️', 'icon': Icons.umbrella, 'color': const Color(0xFF3498DB), 'description': 'Take an umbrella!'},
      {'name': 'Cloudy', 'emoji': '☁️', 'icon': Icons.cloud, 'color': const Color(0xFF16A085), 'description': 'Clouds in the sky!'},
      {'name': 'Snowy', 'emoji': '❄️', 'icon': Icons.ac_unit, 'color': const Color(0xFF2980B9), 'description': 'Cold and snowy!'},
      {'name': 'Windy', 'emoji': '💨', 'icon': Icons.air, 'color': const Color(0xFF1ABC9C), 'description': 'Hold your hat!'},
      {'name': 'Stormy', 'emoji': '⛈️', 'icon': Icons.thunderstorm, 'color': const Color(0xFF5B4EBF), 'description': 'Stay inside safe!'},
    ],
    'Emotions': [
      {'name': 'Happy', 'emoji': '😊', 'icon': Icons.sentiment_very_satisfied, 'color': const Color(0xFFF39C12), 'description': 'Feeling great!'},
      {'name': 'Sad', 'emoji': '😢', 'icon': Icons.sentiment_dissatisfied, 'color': const Color(0xFF3498DB), 'description': 'It\'s okay to cry'},
      {'name': 'Angry', 'emoji': '😠', 'icon': Icons.sentiment_very_dissatisfied, 'color': const Color(0xFFE74C3C), 'description': 'Take deep breaths'},
      {'name': 'Scared', 'emoji': '😨', 'icon': Icons.warning_amber_rounded, 'color': const Color(0xFF8E44AD), 'description': 'It\'s okay to fear'},
      {'name': 'Excited', 'emoji': '🤩', 'icon': Icons.star, 'color': const Color(0xFFE67E22), 'description': 'So much fun!'},
      {'name': 'Loved', 'emoji': '🥰', 'icon': Icons.favorite, 'color': const Color(0xFFE91E63), 'description': 'Feeling special!'},
    ],
    'Good Habits': [
      {'name': 'Brush Teeth', 'emoji': '🪥', 'icon': Icons.clean_hands, 'color': const Color(0xFF16A085), 'description': 'Twice a day!'},
      {'name': 'Wash Hands', 'emoji': '🧼', 'icon': Icons.wash, 'color': const Color(0xFF1ABC9C), 'description': 'Stay clean!'},
      {'name': 'Eat Healthy', 'emoji': '🥗', 'icon': Icons.restaurant, 'color': const Color(0xFF27AE60), 'description': 'Fruits & veggies!'},
      {'name': 'Sleep Early', 'emoji': '😴', 'icon': Icons.bedtime, 'color': const Color(0xFF5B4EBF), 'description': 'Good night sleep!'},
      {'name': 'Share', 'emoji': '🤝', 'icon': Icons.group, 'color': const Color(0xFFE67E22), 'description': 'Sharing is caring!'},
      {'name': 'Be Kind', 'emoji': '💖', 'icon': Icons.volunteer_activism, 'color': const Color(0xFFE91E63), 'description': 'Help others!'},
      {'name': 'Exercise', 'emoji': '🏃', 'icon': Icons.directions_run, 'color': const Color(0xFFD35400), 'description': 'Stay active!'},
      {'name': 'Read Books', 'emoji': '📚', 'icon': Icons.menu_book, 'color': const Color(0xFFF39C12), 'description': 'Learn everyday!'},
    ],
    'Community Helpers': [
      {'name': 'Doctor', 'emoji': '👨‍⚕️', 'icon': Icons.medical_services, 'color': const Color(0xFF3498DB), 'description': 'Keeps us healthy!'},
      {'name': 'Teacher', 'emoji': '👩‍🏫', 'icon': Icons.school, 'color': const Color(0xFF5B4EBF), 'description': 'Helps us learn!'},
      {'name': 'Firefighter', 'emoji': '👨‍🚒', 'icon': Icons.local_fire_department, 'color': const Color(0xFFE74C3C), 'description': 'Fights fires!'},
      {'name': 'Police Officer', 'emoji': '👮', 'icon': Icons.local_police, 'color': const Color(0xFF2874A6), 'description': 'Keeps us safe!'},
      {'name': 'Farmer', 'emoji': '👨‍🌾', 'icon': Icons.agriculture, 'color': const Color(0xFF27AE60), 'description': 'Grows our food!'},
      {'name': 'Chef', 'emoji': '👨‍🍳', 'icon': Icons.restaurant_menu, 'color': const Color(0xFFF39C12), 'description': 'Cooks delicious food!'},
      {'name': 'Pilot', 'emoji': '👨‍✈️', 'icon': Icons.flight, 'color': const Color(0xFF1ABC9C), 'description': 'Flies airplanes!'},
      {'name': 'Mail Carrier', 'emoji': '📬', 'icon': Icons.mail, 'color': const Color(0xFFE67E22), 'description': 'Delivers letters!'},
    ],
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  Future<void> _speak(String text) async {
    setState(() => selectedItem = text);
    _animationController.forward().then((_) => _animationController.reverse());

    // إعدادات الصوت الأنثوي السريع المطلوبة
    final List<String> args = ['-s', '165', '-p', '50', '-v', 'en-us+f3', text];

    try {
      if (Platform.isWindows) {
        await Process.run('espeak', args);
      } else if (Platform.isLinux) {
        // محاولة espeak-ng الأساسية في لينكس/راسبيري
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

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Weather': return const Color(0xFF3498DB);
      case 'Emotions': return const Color(0xFFE91E63);
      case 'Good Habits': return const Color(0xFF27AE60);
      case 'Community Helpers': return const Color(0xFFF39C12);
      default: return const Color(0xFF5B4EBF);
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Weather': return Icons.wb_sunny;
      case 'Emotions': return Icons.sentiment_satisfied_alt;
      case 'Good Habits': return Icons.favorite;
      case 'Community Helpers': return Icons.people;
      default: return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [const Color(0xFF6C5CE7).withOpacity(0.1), Colors.white],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildInstructions(),
              _buildCategoryTabs(),
              Expanded(child: _buildSelectedCategoryContent()),
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
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: const Icon(Icons.arrow_back, color: Color(0xFF6C5CE7)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Daily Life Skills', style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700, color: const Color(0xFF2D3436))),
                Text('Learn important life skills!', style: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFF636E72))),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF6C5CE7),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: const Color(0xFF6C5CE7).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2))],
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
        gradient: const LinearGradient(colors: [Color(0xFF6C5CE7), Color(0xFF5F4FCD)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: const Color(0xFF6C5CE7).withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.lightbulb, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Learn Daily Skills', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                const SizedBox(height: 2),
                Text('Tap any item to learn more!', style: GoogleFonts.poppins(fontSize: 12, color: Colors.white.withOpacity(0.9))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dailyLifeCategories.length,
        itemBuilder: (context, index) {
          final category = dailyLifeCategories.keys.elementAt(index);
          final isSelected = selectedCategory == category;
          return GestureDetector(
            onTap: () => setState(() => selectedCategory = category),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                gradient: isSelected ? LinearGradient(colors: [_getCategoryColor(category), _getCategoryColor(category).withOpacity(0.8)]) : null,
                color: isSelected ? null : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isSelected ? _getCategoryColor(category) : Colors.grey.shade300, width: 2),
              ),
              child: Row(
                children: [
                  Icon(_getCategoryIcon(category), color: isSelected ? Colors.white : Colors.grey.shade600, size: 20),
                  const SizedBox(width: 8),
                  Text(category, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : Colors.grey.shade700)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSelectedCategoryContent() {
    final items = dailyLifeCategories[selectedCategory]!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(selectedCategory, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700, color: _getCategoryColor(selectedCategory))),
        ),
        const SizedBox(height: 12),
        Expanded(child: _buildItemsGrid(items)),
      ],
    );
  }

  Widget _buildItemsGrid(List<Map<String, dynamic>> items) {
    return Center(
      child: GridView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5, // تم التثبيت كما كان في كودك الأصلي
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.0,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final isSelected = selectedItem == item['name'];
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            child: GestureDetector(
              onTap: () => _speak(item['name']),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [item['color'], (item['color'] as Color).withOpacity(0.7)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: (item['color'] as Color).withOpacity(0.4), blurRadius: isSelected ? 16 : 8, offset: Offset(0, isSelected ? 6 : 3))],
                  border: Border.all(color: isSelected ? Colors.white : Colors.transparent, width: 3),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(child: FittedBox(fit: BoxFit.scaleDown, child: Text(item['emoji'], style: const TextStyle(fontSize: 32)))),
                      const SizedBox(height: 4),
                      FittedBox(fit: BoxFit.scaleDown, child: Text(item['name'], textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white))),
                      const SizedBox(height: 2),
                      FittedBox(fit: BoxFit.scaleDown, child: Text(item['description'], textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.w500, color: Colors.white.withOpacity(0.9)))),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}