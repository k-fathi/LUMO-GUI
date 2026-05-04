import 'package:flutter/material.dart';
import 'dart:math';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'match_pair_game.dart';

// تأكدي من استيراد ملف ليفل 3 هنا ليعمل الانتقال تلقائياً
// import 'package:kids_world_app/soundsAnimal/screen/game/learningGames/match_pair_game.dart';

class PuzzleGameScreen extends StatefulWidget {
  const PuzzleGameScreen({super.key});

  @override
  State<PuzzleGameScreen> createState() => _PuzzleGameScreenState();
}

class _PuzzleGameScreenState extends State<PuzzleGameScreen>
    with TickerProviderStateMixin {
  int selectedTheme = 0;
  List<MatchItem> targetItems = [];
  List<MatchItem> sourceItems = [];
  Map<int, int?> matches = {};
  int score = 0;
  int attempts = 0;
  late AnimationController _successController;
  late AnimationController _wrongController;
  int? wrongTargetIndex;

  final List<Map<String, dynamic>> themes = [
    {
      'name': 'Animals',
      'icon': '🦁',
      'color': Colors.orange,
      'items': [
        {'emoji': '🐶', 'name': 'Dog'}, {'emoji': '🐱', 'name': 'Cat'},
        {'emoji': '🐮', 'name': 'Cow'}, {'emoji': '🐷', 'name': 'Pig'},
        {'emoji': '🦁', 'name': 'Lion'}, {'emoji': '🐘', 'name': 'Elephant'},
        {'emoji': '🦒', 'name': 'Giraffe'}, {'emoji': '🐼', 'name': 'Panda'},
        {'emoji': '🐸', 'name': 'Frog'}, {'emoji': '🦊', 'name': 'Fox'},
      ]
    },
    {
      'name': 'Fruits',
      'icon': '🍎',
      'color': Colors.red,
      'items': [
        {'emoji': '🍎', 'name': 'Apple'}, {'emoji': '🍌', 'name': 'Banana'},
        {'emoji': '🍊', 'name': 'Orange'}, {'emoji': '🍇', 'name': 'Grapes'},
        {'emoji': '🍓', 'name': 'Strawberry'}, {'emoji': '🍉', 'name': 'Watermelon'},
        {'emoji': '🍑', 'name': 'Peach'}, {'emoji': '🍒', 'name': 'Cherry'},
        {'emoji': '🥝', 'name': 'Kiwi'}, {'emoji': '🍍', 'name': 'Pineapple'},
      ]
    },
    {
      'name': 'Vehicles',
      'icon': '🚗',
      'color': Colors.blue,
      'items': [
        {'emoji': '🚗', 'name': 'Car'}, {'emoji': '🚕', 'name': 'Taxi'},
        {'emoji': '🚌', 'name': 'Bus'}, {'emoji': '🚎', 'name': 'Trolley'},
        {'emoji': '🚓', 'name': 'Police'}, {'emoji': '🚑', 'name': 'Ambulance'},
        {'emoji': '🚒', 'name': 'Firetruck'}, {'emoji': '✈️', 'name': 'Plane'},
        {'emoji': '🚁', 'name': 'Helicopter'}, {'emoji': '🚂', 'name': 'Train'},
      ]
    },
    {
      'name': 'Shapes',
      'icon': '🔷',
      'color': Colors.purple,
      'items': [
        {'emoji': '🔴', 'name': 'Red Circle'}, {'emoji': '🟦', 'name': 'Blue Square'},
        {'emoji': '🔺', 'name': 'Triangle'}, {'emoji': '⭐', 'name': 'Star'},
        {'emoji': '💎', 'name': 'Diamond'}, {'emoji': '🟡', 'name': 'Yellow Circle'},
        {'emoji': '🟢', 'name': 'Green Circle'}, {'emoji': '🟣', 'name': 'Purple Circle'},
        {'emoji': '🟠', 'name': 'Orange Circle'}, {'emoji': '⬛', 'name': 'Black Square'},
      ]
    },
    {
      'name': 'Food',
      'icon': '🍕',
      'color': Colors.amber,
      'items': [
        {'emoji': '🍕', 'name': 'Pizza'}, {'emoji': '🍔', 'name': 'Burger'},
        {'emoji': '🌭', 'name': 'Hot Dog'}, {'emoji': '🍟', 'name': 'Fries'},
        {'emoji': '🍿', 'name': 'Popcorn'}, {'emoji': '🍩', 'name': 'Donut'},
        {'emoji': '🍰', 'name': 'Cake'}, {'emoji': '🍪', 'name': 'Cookie'},
        {'emoji': '🍦', 'name': 'Ice Cream'}, {'emoji': '🧁', 'name': 'Cupcake'},
      ]
    },
  ];

  @override
  void initState() {
    super.initState();
    _successController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _wrongController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _initializeGame();
  }

  void _initializeGame() {
    setState(() {
      matches.clear();
      wrongTargetIndex = null;
      final theme = themes[selectedTheme];
      final items = theme['items'] as List<Map<String, dynamic>>;
      final shuffledItems = List<Map<String, dynamic>>.from(items)..shuffle();
      final selectedItems = shuffledItems.take(4).toList();

      targetItems = selectedItems.asMap().entries.map((e) => MatchItem(id: e.key, emoji: e.value['emoji'], name: e.value['name'])).toList();
      final shuffledTargets = List<MatchItem>.from(targetItems)..shuffle();
      sourceItems = shuffledTargets.asMap().entries.map((e) => MatchItem(id: e.value.id, emoji: e.value.emoji, name: e.value.name)).toList();
    });
  }

  void _checkMatch(int targetIndex, int sourceIndex) {
    setState(() { attempts++; });
    if (targetItems[targetIndex].id == sourceItems[sourceIndex].id) {
      setState(() {
        matches[targetIndex] = sourceIndex;
        targetItems[targetIndex].isMatched = true;
        sourceItems[sourceIndex].isMatched = true;
        score += 10;
        wrongTargetIndex = null;
      });
      _successController.forward(from: 0);

      if (matches.length == targetItems.length) {
        Future.delayed(const Duration(milliseconds: 800), () {
          if (selectedTheme < themes.length - 1) {
            setState(() { selectedTheme++; _initializeGame(); });
          } else {
            _showCompletionDialog();
          }
        });
      }
    } else {
      setState(() { wrongTargetIndex = targetIndex; });
      _wrongController.forward(from: 0);
      Future.delayed(const Duration(milliseconds: 500), () { setState(() { wrongTargetIndex = null; }); });
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(colors: [Colors.green.shade400, Colors.teal.shade400]),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🎉', style: TextStyle(fontSize: 70)),
              const SizedBox(height: 16),
              Text('Awesome!', style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
              const Text('Level Two Completed!', style: TextStyle(fontSize: 18, color: Colors.white70)),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  // إغلاق الديالوج والذهاب فوراً لليفل 3
                  Navigator.pop(context);
                  Get.off(() => const MatchPairsGame());
                },
                icon: const Icon(Icons.arrow_forward_rounded, size: 28),
                label: const Text('Go to Level Three', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.green.shade700,
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 360;
    final isVerySmallHeight = screenHeight < 700;
    final itemSize = (screenWidth / 5).clamp(65.0, 85.0);
    final themeHeight = isVerySmallHeight ? 70.0 : (isSmallScreen ? 80.0 : 90.0);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: const Color(0xFFF5F7FA), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.arrow_back, color: Color(0xFFE17055), size: 20),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Puzzle', style: GoogleFonts.poppins(fontSize: isSmallScreen ? 16 : 20, fontWeight: FontWeight.w700, color: const Color(0xFF2D3436))),
                  Text('Match the items!', style: GoogleFonts.poppins(fontSize: isSmallScreen ? 10 : 12, color: const Color(0xFF636E72))),
                ],
              ),
            ),
          ],
        ),
        elevation: 0,
        actions: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 8 : 12, vertical: 6),
            decoration: BoxDecoration(color: Colors.green.shade100, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.green, width: 2)),
            child: Text('⭐ $score', style: TextStyle(fontSize: isSmallScreen ? 14 : 16, fontWeight: FontWeight.bold, color: Colors.green)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.purple.shade50, Colors.pink.shade50],
            begin: Alignment.topLeft, end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Theme Selector (Original UI)
              Container(
                height: themeHeight,
                padding: const EdgeInsets.symmetric(vertical: 6),
                color: Colors.white.withOpacity(0.7),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: themes.length,
                  itemBuilder: (context, index) {
                    final theme = themes[index];
                    final isSelected = selectedTheme == index;
                    return Container(
                      width: (screenWidth / 5.2).clamp(65.0, 85.0),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: isSelected ? theme['color'] : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: theme['color'], width: 2),
                        boxShadow: isSelected ? [BoxShadow(color: theme['color'].withOpacity(0.5), blurRadius: 10, offset: const Offset(0, 3))] : [],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(theme['icon'], style: TextStyle(fontSize: isVerySmallHeight ? 24 : (isSmallScreen ? 26 : 30))),
                          Text(theme['name'], style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black87), textAlign: TextAlign.center),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 14),
              // Target Items (Top Row)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: targetItems.asMap().entries.map((entry) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: DragTarget<int>(
                          onAcceptWithDetails: (details) => _checkMatch(entry.key, details.data),
                          builder: (context, candidateData, rejectedData) {
                            return AnimatedBuilder(
                              animation: wrongTargetIndex == entry.key ? _wrongController : _successController,
                              builder: (context, child) {
                                final shake = wrongTargetIndex == entry.key ? sin(_wrongController.value * pi * 6) * 8 : 0.0;
                                return Transform.translate(
                                  offset: Offset(shake, 0),
                                  child: _buildTargetSlot(entry.value, candidateData.isNotEmpty, wrongTargetIndex == entry.key, itemSize, isSmallScreen, isVerySmallHeight),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const Spacer(),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.arrow_downward, size: 28, color: Colors.purple.shade300),
                  Text('Match Below', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.purple.shade400)),
                ],
              ),
              const Spacer(),
              // Source Items (Bottom Row)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: sourceItems.asMap().entries.map((entry) {
                    if (entry.value.isMatched) return Expanded(child: _buildEmptySlot(itemSize, isSmallScreen, isVerySmallHeight));
                    return Expanded(
                      child: Draggable<int>(
                        data: entry.key,
                        feedback: Material(color: Colors.transparent, child: _buildDraggableItem(entry.value, itemSize, isSmallScreen, isVerySmallHeight)),
                        childWhenDragging: _buildEmptySlot(itemSize, isSmallScreen, isVerySmallHeight),
                        child: _buildDraggableItem(entry.value, itemSize, isSmallScreen, isVerySmallHeight),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTargetSlot(MatchItem item, bool isHovering, bool isWrong, double size, bool isSmall, bool isVerySmallHeight) {
    return Container(
      height: isVerySmallHeight ? (size * 1.2) : (size * 1.3),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: item.isMatched ? [Colors.green.shade200, Colors.green.shade300] :
          isWrong ? [Colors.red.shade200, Colors.red.shade300] :
          isHovering ? [Colors.blue.shade200, Colors.blue.shade300] :
          [Colors.purple.shade100, Colors.purple.shade200],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: item.isMatched ? Colors.green : isWrong ? Colors.red : isHovering ? Colors.blue : Colors.purple.shade300, width: 2.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(item.emoji, style: TextStyle(fontSize: isSmall ? 32 : 40)),
          Text(item.name, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center),
          if (item.isMatched) const Icon(Icons.check_circle, color: Colors.white, size: 20),
        ],
      ),
    );
  }

  Widget _buildDraggableItem(MatchItem item, double size, bool isSmall, bool isVerySmallHeight) {
    return Container(
      height: isVerySmallHeight ? (size * 1.2) : (size * 1.3),
      width: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.orange.shade300, Colors.pink.shade300]),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.orange, width: 2.5),
        boxShadow: [BoxShadow(color: Colors.orange.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(item.emoji, style: TextStyle(fontSize: isSmall ? 32 : 40)),
          Text(item.name, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildEmptySlot(double size, bool isSmall, bool isVerySmallHeight) {
    return Container(
      height: isVerySmallHeight ? (size * 1.2) : (size * 1.3),
      decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.green.shade200, width: 2.5)),
      child: Icon(Icons.check_circle, size: 30, color: Colors.green.shade300),
    );
  }

  @override
  void dispose() { _successController.dispose(); _wrongController.dispose(); super.dispose(); }
}

class MatchItem {
  final int id; final String emoji; final String name; bool isMatched;
  MatchItem({required this.id, required this.emoji, required this.name, this.isMatched = false});
}