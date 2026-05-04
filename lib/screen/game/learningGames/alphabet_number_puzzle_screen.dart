import 'package:flutter/material.dart';
import 'dart:math';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AlphabetNumberPuzzleScreen extends StatefulWidget {
  const AlphabetNumberPuzzleScreen({super.key});

  @override
  State<AlphabetNumberPuzzleScreen> createState() => _AlphabetNumberPuzzleScreenState();
}

class _AlphabetNumberPuzzleScreenState extends State<AlphabetNumberPuzzleScreen>
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
      'name': 'Uppercase A-Z',
      'icon': '🔤',
      'color': Colors.blue,
      'type': 'uppercase',
    },
    {
      'name': 'Lowercase a-z',
      'icon': '🔡',
      'color': Colors.green,
      'type': 'lowercase',
    },
    {
      'name': 'Numbers 1-20',
      'icon': '🔢',
      'color': Colors.orange,
      'type': 'numbers_20',
    },
    {
      'name': 'Numbers 1-50',
      'icon': '💯',
      'color': Colors.purple,
      'type': 'numbers_50',
    },
    {
      'name': 'Numbers 1-100',
      'icon': '💯',
      'color': Colors.teal,
      'type': 'numbers_100',
    },
  ];

  @override
  void initState() {
    super.initState();
    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _wrongController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _initializeGame();
  }

  List<Map<String, String>> _generateItems() {
    final theme = themes[selectedTheme];
    final type = theme['type'];
    List<Map<String, String>> items = [];

    switch (type) {
      case 'uppercase':
        for (int i = 65; i <= 90; i++) {
          items.add({
            'display': String.fromCharCode(i),
            'name': String.fromCharCode(i),
          });
        }
        break;
      case 'lowercase':
        for (int i = 97; i <= 122; i++) {
          items.add({
            'display': String.fromCharCode(i),
            'name': String.fromCharCode(i),
          });
        }
        break;
      case 'numbers_20':
        for (int i = 1; i <= 20; i++) {
          items.add({
            'display': i.toString(),
            'name': i.toString(),
          });
        }
        break;
      case 'numbers_50':
        for (int i = 1; i <= 50; i++) {
          items.add({
            'display': i.toString(),
            'name': i.toString(),
          });
        }
        break;
      case 'numbers_100':
        for (int i = 1; i <= 100; i++) {
          items.add({
            'display': i.toString(),
            'name': i.toString(),
          });
        }
        break;
    }

    return items;
  }

  void _initializeGame() {
    setState(() {
      matches.clear();
      score = 0;
      attempts = 0;
      wrongTargetIndex = null;

      final allItems = _generateItems();
      allItems.shuffle();

      // Select 4 items for the game
      final selectedItems = allItems.take(4).toList();

      // Create target items (top row)
      targetItems = selectedItems
          .asMap()
          .entries
          .map((e) => MatchItem(
        id: e.key,
        display: e.value['display']!,
        name: e.value['name']!,
        isMatched: false,
      ))
          .toList();

      // Create source items (bottom row) - shuffled
      final shuffledTargets = List<MatchItem>.from(targetItems)..shuffle();
      sourceItems = shuffledTargets
          .asMap()
          .entries
          .map((e) => MatchItem(
        id: e.value.id,
        display: e.value.display,
        name: e.value.name,
        isMatched: false,
      ))
          .toList();
    });
  }

  void _checkMatch(dynamic targetIndex, dynamic sourceIndex) {
    setState(() {
      attempts++;
    });

    final targetItem = targetItems[targetIndex];
    final sourceItem = sourceItems[sourceIndex];

    if (targetItem.id == sourceItem.id) {
      // Correct match!
      setState(() {
        matches[targetIndex] = sourceIndex;
        targetItems[targetIndex].isMatched = true;
        sourceItems[sourceIndex].isMatched = true;
        score += 10;
        wrongTargetIndex = null;
      });

      _successController.forward(from: 0);

      // Check if all matched
      if (matches.length == targetItems.length) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          _showCompletionDialog();
        });
      }
    } else {
      // Wrong match
      setState(() {
        wrongTargetIndex = targetIndex;
      });
      _wrongController.forward(from: 0);

      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          wrongTargetIndex = null;
        });
      });
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
            gradient: LinearGradient(
              colors: [Colors.green.shade400, Colors.teal.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '🎉',
                style: TextStyle(fontSize: 70),
              ),
              const SizedBox(height: 16),
              const Text(
                'Awesome!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'You matched them all!',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '⭐ Score: $score points',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _initializeGame();
                    },
                    icon: const Icon(Icons.refresh, size: 28),
                    label: const Text(
                      'Play Again',
                      style: TextStyle(fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        selectedTheme = (selectedTheme + 1) % themes.length;
                        _initializeGame();
                      });
                    },
                    icon: const Icon(Icons.arrow_forward, size: 28),
                    label: const Text(
                      'Next',
                      style: TextStyle(fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    ),
                  ),
                ],
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

    // Responsive sizing
    final itemSize = (screenWidth / 4.5).clamp(70.0, 90.0);
    final themeHeight = isVerySmallHeight ? 70.0 : (isSmallScreen ? 85.0 : 95.0);

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
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F7FA),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.arrow_back,
                    color: Color(0xFFE17055), size: 20),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Alpha N Puzzle',
                    style: GoogleFonts.poppins(
                      fontSize: isSmallScreen ? 16 : 20,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2D3436),
                    ),
                  ),
                  Text(
                    'Match the items!',
                    style: GoogleFonts.poppins(
                      fontSize: isSmallScreen ? 10 : 12,
                      color: const Color(0xFF636E72),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        elevation: 0,
        actions: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 8 : 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.green, width: 2),
            ),
            child: Text(
              '⭐ $score',
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Container(
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(Icons.refresh, size: isSmallScreen ? 22 : 26),
              color: Colors.blue,
              onPressed: _initializeGame,
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade50,
              Colors.purple.shade50,
              Colors.pink.shade50,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [

              // Theme selector
              Container(
                height: themeHeight,
                padding: EdgeInsets.symmetric(vertical: isVerySmallHeight ? 6 : 8),
                color: Colors.white.withValues(alpha: 0.7),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: themes.length,
                  itemBuilder: (context, index) {
                    final theme = themes[index];
                    final isSelected = selectedTheme == index;
                    final themeWidth = (screenWidth / 4.8).clamp(70.0, 90.0);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedTheme = index;
                          _initializeGame();
                        });
                      },
                      child: Container(
                        width: themeWidth,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: isSelected ? theme['color'] : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: theme['color'],
                            width: isSelected ? 3 : 2,
                          ),
                          boxShadow: isSelected
                              ? [
                            BoxShadow(
                              color: theme['color'].withOpacity(0.5),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ]
                              : [],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              theme['icon'],
                              style: TextStyle(fontSize: isSmallScreen ? 28 : 32),
                            ),
                            const SizedBox(height: 3),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2),
                              child: Text(
                                theme['name'],
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 9 : 11,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? Colors.white : Colors.black87,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
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

              SizedBox(height: isSmallScreen ? 12 : 16),

              // Instructions
              Container(
                margin: EdgeInsets.symmetric(horizontal: isSmallScreen ? 12 : 16),
                padding: EdgeInsets.all(isSmallScreen ? 10 : 14),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.blue.shade300, width: 2.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '👆',
                      style: TextStyle(fontSize: isSmallScreen ? 22 : 26),
                    ),
                    SizedBox(width: isSmallScreen ? 8 : 12),
                    Flexible(
                      child: Text(
                        'Drag and drop to match!',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 15 : 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: isSmallScreen ? 16 : 24),

              // Target items (top row)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 4 : 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: targetItems.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    final isWrong = wrongTargetIndex == index;

                    return Flexible(
                      child: DragTarget<int>(
                        onWillAcceptWithDetails: (details) {
                          final int sourceIndex = details.data;
                          // ensure indexes are valid and items not already matched
                          if (sourceIndex < 0 || sourceIndex >= sourceItems.length) return false;
                          return !item.isMatched && !sourceItems[sourceIndex].isMatched;
                        },
                        onAcceptWithDetails: (details) {
                          final int sourceIndex = details.data;
                          if (sourceIndex < 0 || sourceIndex >= sourceItems.length) return;
                          _checkMatch(index, sourceIndex);
                        },
                        builder: (context, candidateData, rejectedData) {
                          return AnimatedBuilder(
                            animation: isWrong ? _wrongController : _successController,
                            builder: (context, child) {
                              final shake = isWrong
                                  ? sin(_wrongController.value * pi * 6) * 8
                                  : 0.0;
                              return Transform.translate(
                                offset: Offset(shake, 0),
                                child: _buildTargetSlot(
                                  item,
                                  candidateData.isNotEmpty,
                                  isWrong,
                                  itemSize,
                                  isSmallScreen,
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),

              const Spacer(),

              // Arrow indicator
              Column(
                children: [
                  Icon(
                    Icons.arrow_downward,
                    size: isSmallScreen ? 30 : 40,
                    color: Colors.purple.shade300,
                  ),
                  Text(
                    'Match Below',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple.shade400,
                    ),
                  ),
                  Icon(
                    Icons.arrow_downward,
                    size: isSmallScreen ? 30 : 40,
                    color: Colors.purple.shade300,
                  ),
                ],
              ),

              const Spacer(),

              // Source items (bottom row)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 4 : 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: sourceItems.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;

                    if (item.isMatched) {
                      return Flexible(
                        child: _buildEmptySlot(itemSize, isSmallScreen),
                      );
                    }

                    return Flexible(
                      child: Draggable<int>(
                        data: index,
                        feedback: Material(
                          color: Colors.transparent,
                          child: _buildDraggableItem(item, true, itemSize, isSmallScreen),
                        ),
                        childWhenDragging: _buildEmptySlot(itemSize, isSmallScreen),
                        child: _buildDraggableItem(item, false, itemSize, isSmallScreen),
                      ),
                    );
                  }).toList(),
                ),
              ),

              SizedBox(height: isSmallScreen ? 20 : 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTargetSlot(MatchItem item, bool isHovering, bool isWrong, double size, bool isSmall) {
    final fontSize = isSmall ? 42.0 : 52.0;
    final iconSize = isSmall ? 22.0 : 28.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: size,
      height: size * 1.4,
      margin: const EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: item.isMatched
              ? [Colors.green.shade200, Colors.green.shade300]
              : isWrong
              ? [Colors.red.shade200, Colors.red.shade300]
              : isHovering
              ? [Colors.blue.shade200, Colors.blue.shade300]
              : [Colors.purple.shade100, Colors.purple.shade200],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: item.isMatched
              ? Colors.green
              : isWrong
              ? Colors.red
              : isHovering
              ? Colors.blue
              : Colors.purple.shade300,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: item.isMatched
                ? Colors.green.withValues(alpha: 0.5)
                : isWrong
                ? Colors.red.withValues(alpha: 0.5)
                : isHovering
                ? Colors.blue.withValues(alpha: 0.5)
                : Colors.purple.withValues(alpha: 0.3),
            blurRadius: item.isMatched || isHovering ? 12 : 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              item.display,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          if (item.isMatched)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Icon(
                Icons.check_circle,
                color: Colors.white,
                size: iconSize,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDraggableItem(MatchItem item, bool isDragging, double size, bool isSmall) {
    final fontSize = isSmall ? 42.0 : 52.0;
    final scaleFactor = isDragging ? 1.05 : 1.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: size * scaleFactor,
      height: (size * 1.4) * scaleFactor,
      margin: const EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.orange.shade300,
            Colors.pink.shade300,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.orange,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withValues(alpha: isDragging ? 0.6 : 0.4),
            blurRadius: isDragging ? 16 : 8,
            offset: Offset(0, isDragging ? 6 : 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          item.display,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptySlot(double size, bool isSmall) {
    final iconSize = isSmall ? 32.0 : 40.0;

    return Container(
      width: size,
      height: size * 1.4,
      margin: const EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.green.shade200,
          width: 3,
          style: BorderStyle.solid,
        ),
      ),
      child: Icon(
        Icons.check_circle,
        size: iconSize,
        color: Colors.green.shade300,
      ),
    );
  }

  @override
  void dispose() {
    _successController.dispose();
    _wrongController.dispose();
    super.dispose();
  }
}

class MatchItem {
  final int id;
  final String display;
  final String name;
  bool isMatched;

  MatchItem({
    required this.id,
    required this.display,
    required this.name,
    this.isMatched = false,
  });
}