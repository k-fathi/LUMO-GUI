import 'package:flutter/material.dart';
import 'dart:math';
import 'package:get/get.dart';
import 'package:kids_world_app/screen/game/matching/puzzle_game_screen.dart';

// تأكدي من استيراد الشاشة الجديدة هنا
// import 'package:your_project/puzzle_game_screen.dart';

class ColorGameScreen extends StatefulWidget {
  const ColorGameScreen({super.key});

  @override
  State<ColorGameScreen> createState() => _ColorGameScreenState();
}

class _ColorGameScreenState extends State<ColorGameScreen>
    with TickerProviderStateMixin {
  int score = 0;
  int level = 1;
  List<ColorBall> balls = [];
  List<ColorBasket> baskets = [];
  late AnimationController _successController;
  late AnimationController _wrongController;
  int? wrongBasketIndex;

  final List<Map<String, dynamic>> colorData = [
    {'name': 'Red', 'color': Colors.red, 'emoji': '🔴'},
    {'name': 'Blue', 'color': Colors.blue, 'emoji': '🔵'},
    {'name': 'Green', 'color': Colors.green, 'emoji': '🟢'},
    {'name': 'Yellow', 'color': Colors.yellow, 'emoji': '🟡'},
    {'name': 'Orange', 'color': Colors.orange, 'emoji': '🟠'},
    {'name': 'Purple', 'color': Colors.purple, 'emoji': '🟣'},
    {'name': 'Pink', 'color': Colors.pink, 'emoji': '🩷'},
    {'name': 'Brown', 'color': Colors.brown, 'emoji': '🟤'},
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
    _initializeLevel();
  }

  void _initializeLevel() {
    balls.clear();
    baskets.clear();
    wrongBasketIndex = null;

    int colorCount = min(3 + (level - 1), 6);

    final shuffledColors = List<Map<String, dynamic>>.from(colorData)..shuffle();
    final selectedColors = shuffledColors.take(colorCount).toList();

    for (int i = 0; i < selectedColors.length; i++) {
      baskets.add(ColorBasket(
        id: i,
        name: selectedColors[i]['name'],
        color: selectedColors[i]['color'],
        emoji: selectedColors[i]['emoji'],
      ));
    }

    for (var colorInfo in selectedColors) {
      for (int i = 0; i < 2; i++) {
        balls.add(ColorBall(
          id: balls.length,
          name: colorInfo['name'],
          color: colorInfo['color'],
          emoji: colorInfo['emoji'],
          isMatched: false,
        ));
      }
    }

    balls.shuffle();
    setState(() {});
  }

  void _checkMatch(int ballIndex, int basketIndex) {
    final ball = balls[ballIndex];
    final basket = baskets[basketIndex];

    if (ball.name == basket.name && !ball.isMatched) {
      setState(() {
        ball.isMatched = true;
        basket.ballsMatched++;
        score += 10;
        wrongBasketIndex = null;
      });

      _successController.forward(from: 0);

      if (balls.every((b) => b.isMatched)) {
        Future.delayed(const Duration(milliseconds: 800), () {
          _showLevelCompleteDialog();
        });
      }
    } else {
      setState(() {
        wrongBasketIndex = basketIndex;
      });
      _wrongController.forward(from: 0);

      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          wrongBasketIndex = null;
        });
      });
    }
  }

  void _showLevelCompleteDialog() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 360;
    final isVerySmallHeight = screenHeight < 700;

    // المنطق الجديد للتحقق من انتهاء الـ 3 مستويات
    bool isFinishedAllLevels = (level == 3);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: isSmallScreen ? screenWidth * 0.9 : 400,
            maxHeight: isVerySmallHeight ? screenHeight * 0.7 : screenHeight * 0.6,
          ),
          padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [Colors.green.shade400, Colors.teal.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '🎉',
                  style: TextStyle(fontSize: isSmallScreen ? 50 : 70),
                ),
                SizedBox(height: isSmallScreen ? 10 : 16),
                Text(
                  isFinishedAllLevels ? 'Amazing Work!' : 'Level $level Complete!',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 24 : 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: isSmallScreen ? 6 : 8),
                Text(
                  isFinishedAllLevels ? 'Ready for Level Two?' : 'Score: $score points',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 18 : 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: isSmallScreen ? 16 : 24),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          level = 1;
                          score = 0;
                          _initializeLevel();
                        });
                      },
                      icon: Icon(Icons.refresh, size: isSmallScreen ? 20 : 24),
                      label: Text(
                        'Restart',
                        style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 16 : 20,
                          vertical: isSmallScreen ? 12 : 14,
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        if (isFinishedAllLevels) {
                          // الانتقال للشاشة الجديدة Level Two
                          Get.off(() => const PuzzleGameScreen());
                          print("Go to PuzzleGameScreen");
                        } else {
                          setState(() {
                            level++;
                            _initializeLevel();
                          });
                        }
                      },
                      icon: Icon(
                          isFinishedAllLevels ? Icons.extension : Icons.arrow_forward,
                          size: isSmallScreen ? 20 : 24
                      ),
                      label: Text(
                        isFinishedAllLevels ? 'Level Two' : 'Next Level',
                        style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 16 : 20,
                          vertical: isSmallScreen ? 12 : 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
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

    final basketSize = (screenWidth / 4.2).clamp(85.0, 110.0);
    final ballSize = (screenWidth / 4.8).clamp(70.0, 85.0);

    final unmatchedBalls = balls.where((b) => !b.isMatched).toList();

    return Scaffold(
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              color: Color(0xFFE17055), size: 24),
                        ),
                      ),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Color Match',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 20 : 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Level $level',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 13 : 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isSmallScreen ? 10 : 14,
                              vertical: isSmallScreen ? 6 : 8,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.orange.shade300, Colors.pink.shade300],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.orange.withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              '⭐ $score',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 16 : 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: isSmallScreen ? 6 : 10),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              icon: Icon(Icons.refresh, size: isSmallScreen ? 22 : 26),
                              color: Colors.blue,
                              padding: const EdgeInsets.all(8),
                              constraints: const BoxConstraints(),
                              onPressed: () {
                                setState(() {
                                  level = 1;
                                  score = 0;
                                  _initializeLevel();
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: isSmallScreen ? 12 : 16),

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
                          'Drag balls to matching baskets!',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 14 : 17,
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

                SizedBox(height: isVerySmallHeight ? 16 : 24),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 8 : 12),
                  child: Wrap(
                    spacing: isSmallScreen ? 8 : 12,
                    runSpacing: isSmallScreen ? 8 : 12,
                    alignment: WrapAlignment.center,
                    children: baskets.asMap().entries.map((entry) {
                      final index = entry.key;
                      final basket = entry.value;
                      final isWrong = wrongBasketIndex == index;

                      return DragTarget<int>(
                        onWillAcceptWithDetails: (details) {
                          final int ballIndex = details.data;
                          return !balls[ballIndex].isMatched;
                        },
                        onAcceptWithDetails: (details) {
                          final int ballIndex = details.data;
                          _checkMatch(ballIndex, index);
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
                                child: _buildBasket(
                                  basket,
                                  candidateData.isNotEmpty,
                                  isWrong,
                                  basketSize,
                                  isSmallScreen,
                                ),
                              );
                            },
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),

                SizedBox(height: isVerySmallHeight ? 20 : 30),

                Container(
                  margin: EdgeInsets.symmetric(horizontal: isSmallScreen ? 30 : 40),
                  height: isSmallScreen ? 2 : 3,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.purple.shade300,
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),

                SizedBox(height: isSmallScreen ? 12 : 16),

                Container(
                  constraints: BoxConstraints(minHeight: isVerySmallHeight ? 120 : 150),
                  padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 8 : 12),
                  child: Wrap(
                    spacing: isSmallScreen ? 8 : 12,
                    runSpacing: isSmallScreen ? 8 : 12,
                    alignment: WrapAlignment.center,
                    children: unmatchedBalls.map((ball) {
                      final ballIndex = balls.indexOf(ball);
                      return Draggable<int>(
                        data: ballIndex,
                        feedback: Material(
                          color: Colors.transparent,
                          child: _buildBall(ball, true, ballSize, isSmallScreen),
                        ),
                        childWhenDragging: _buildEmptySlot(ballSize, isSmallScreen),
                        child: _buildBall(ball, false, ballSize, isSmallScreen),
                      );
                    }).toList(),
                  ),
                ),

                SizedBox(height: isSmallScreen ? 20 : 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBasket(ColorBasket basket, bool isHovering, bool isWrong, double size, bool isSmall) {
    final isComplete = basket.ballsMatched >= 2;
    final fontSize = isSmall ? 12.0 : 14.0;
    final emojiSize = isSmall ? 28.0 : 32.0;
    final iconSize = isSmall ? 16.0 : 20.0;
    final circleSize = isSmall ? 50.0 : 60.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: size,
      height: size * 1.3,
      decoration: BoxDecoration(
        color: isWrong
            ? Colors.red.shade100
            : isComplete
            ? basket.color.withValues(alpha: 0.3)
            : isHovering
            ? Colors.blue.shade100
            : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isWrong
              ? Colors.red
              : isComplete
              ? Colors.green
              : isHovering
              ? Colors.blue
              : basket.color,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: isComplete
                ? Colors.green.withValues(alpha: 0.4)
                : basket.color.withValues(alpha: 0.3),
            blurRadius: isHovering || isComplete ? 12 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: circleSize,
            height: circleSize,
            decoration: BoxDecoration(
              color: basket.color.withValues(alpha: 0.3),
              shape: BoxShape.circle,
              border: Border.all(color: basket.color, width: 3),
            ),
            child: Center(
              child: Text(
                basket.emoji,
                style: TextStyle(fontSize: emojiSize),
              ),
            ),
          ),
          SizedBox(height: isSmall ? 6 : 8),
          Flexible(
            child: Text(
              basket.name,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: basket.color,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: isSmall ? 2 : 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                basket.ballsMatched >= 1 ? Icons.circle : Icons.circle_outlined,
                size: isSmall ? 10 : 12,
                color: basket.color,
              ),
              const SizedBox(width: 4),
              Icon(
                basket.ballsMatched >= 2 ? Icons.circle : Icons.circle_outlined,
                size: isSmall ? 10 : 12,
                color: basket.color,
              ),
            ],
          ),
          if (isComplete)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(
                Icons.check_circle,
                color: Colors.green,
                size: iconSize,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBall(ColorBall ball, bool isDragging, double size, bool isSmall) {
    final emojiSize = isSmall ? 32.0 : 36.0;
    final scaleFactor = isDragging ? 1.06 : 1.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: size * scaleFactor,
      height: size * scaleFactor,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            ball.color.withValues(alpha: 0.8),
            ball.color,
            ball.color.withValues(alpha: 0.6),
          ],
          center: const Alignment(-0.3, -0.3),
          radius: 0.8,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: ball.color.withValues(alpha: isDragging ? 0.6 : 0.4),
            blurRadius: isDragging ? 20 : 12,
            offset: Offset(0, isDragging ? 8 : 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          ball.emoji,
          style: TextStyle(fontSize: emojiSize),
        ),
      ),
    );
  }

  Widget _buildEmptySlot(double size, bool isSmall) {
    final iconSize = isSmall ? 26.0 : 30.0;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.grey.shade400,
          width: 2,
          style: BorderStyle.solid,
        ),
      ),
      child: Icon(
        Icons.circle_outlined,
        size: iconSize,
        color: Colors.grey.shade400,
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

class ColorBall {
  final dynamic id;
  final dynamic name;
  final Color color;
  final dynamic emoji;
  bool isMatched;
  ColorBall({required this.id, required this.name, required this.color, required this.emoji, this.isMatched = false});
}

class ColorBasket {
  final int id;
  final String name;
  final Color color;
  final String emoji;
  int ballsMatched;
  ColorBasket({required this.id, required this.name, required this.color, required this.emoji, this.ballsMatched = 0});
}