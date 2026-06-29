import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';
import 'dart:math';

class FunnyBallGame extends StatefulWidget {
  const FunnyBallGame({super.key});

  @override
  State<FunnyBallGame> createState() => _FunnyBallGameState();
}

class _FunnyBallGameState extends State<FunnyBallGame> with TickerProviderStateMixin {
  final FlutterTts flutterTts = FlutterTts();
  final Random random = Random();

  List<Ball> balls = [];
  int score = 0;
  int missedBalls = 0;
  bool isPlaying = false;
  Timer? ballSpawnTimer;
  Timer? ballMoveTimer;

  String difficulty = 'Easy'; // Easy, Medium, Hard

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  void _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.3);
  }

  void _speak(String text) async {
    await flutterTts.speak(text);
  }

  void startGame() {
    setState(() {
      isPlaying = true;
      score = 0;
      missedBalls = 0;
      balls.clear();
    });

    _speak('Let\'s play!');

    // Spawn balls based on difficulty
    int spawnInterval = difficulty == 'Easy' ? 1500 : (difficulty == 'Medium' ? 1000 : 700);

    ballSpawnTimer = Timer.periodic(Duration(milliseconds: spawnInterval), (timer) {
      if (balls.length < 15) {
        _spawnBall();
      }
    });

    // Move balls down
    ballMoveTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        for (var ball in balls) {
          ball.y += ball.speed;
        }

        // Remove balls that fell off screen
        balls.removeWhere((ball) {
          if (ball.y > MediaQuery.of(context).size.height) {
            missedBalls++;
            if (missedBalls >= 10) {
              _gameOver();
            }
            return true;
          }
          return false;
        });
      });
    });
  }

  void _spawnBall() {
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.orange,
      Colors.purple,
      Colors.pink,
      Colors.teal,
      Colors.cyan,
      Colors.lime,
    ];

    final emojis = ['⚽', '🏀', '🏈', '⚾', '🎾', '🏐', '🎱', '🏓', '🥎', '🪀'];

    double speed = difficulty == 'Easy' ? 2.0 : (difficulty == 'Medium' ? 3.5 : 5.0);

    setState(() {
      balls.add(Ball(
        x: random.nextDouble() * (MediaQuery.of(context).size.width - 80),
        y: -60,
        color: colors[random.nextInt(colors.length)],
        emoji: emojis[random.nextInt(emojis.length)],
        speed: speed + random.nextDouble() * 1.5,
        size: 50.0 + random.nextDouble() * 30,
      ));
    });
  }

  void _popBall(Ball ball) {
    setState(() {
      balls.remove(ball);
      score += 10;
    });

    if (score % 50 == 0) {
      _speak('Great job! Score $score!');
    }
  }

  void _gameOver() {
    ballSpawnTimer?.cancel();
    ballMoveTimer?.cancel();

    setState(() {
      isPlaying = false;
    });

    _speak('Game over! Your score is $score');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.sports_esports, size: 80, color: Colors.orange),
            SizedBox(height: 20),
            Text(
              'Game Over!',
              style: TextStyle(fontFamily: 'Poppins', 
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Your Score: $score',
              style: TextStyle(fontFamily: 'Poppins', 
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Missed: $missedBalls balls',
              style: TextStyle(fontFamily: 'Poppins', fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    startGame();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    'Play Again',
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 16, color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    'Exit',
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void stopGame() {
    ballSpawnTimer?.cancel();
    ballMoveTimer?.cancel();
    setState(() {
      isPlaying = false;
      balls.clear();
    });
  }

  @override
  void dispose() {
    ballSpawnTimer?.cancel();
    ballMoveTimer?.cancel();
    flutterTts.stop();
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
              Colors.blue[100]!,
              Colors.purple[100]!,
              Colors.pink[100]!,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Compact Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, size: 22),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            stopGame();
                            Navigator.pop(context);
                          },
                        ),
                        SizedBox(width: 4),
                        Text(
                          '🎈 Funny Ball Game 🎈',
                          style: TextStyle(fontFamily: 'Poppins', 
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Difficulty: ',
                          style: TextStyle(fontFamily: 'Poppins', 
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ...['Easy', 'Medium', 'Hard'].map((level) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: ChoiceChip(
                              label: Text(
                                level,
                                style: TextStyle(fontFamily: 'Poppins', fontSize: 10),
                              ),
                              selected: difficulty == level,
                              onSelected: isPlaying
                                  ? null
                                  : (selected) {
                                      if (selected) {
                                        setState(() {
                                          difficulty = level;
                                        });
                                      }
                                    },
                              selectedColor: Colors.orange,
                              visualDensity: VisualDensity.compact,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              labelStyle: TextStyle(fontFamily: 'Poppins', 
                                color: difficulty == level
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                    SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildScoreCard('Score', score, Colors.green),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text('🎯', style: TextStyle(fontFamily: 'Poppins', fontSize: 28)),
                        ),
                        _buildScoreCard('Missed', missedBalls, Colors.red),
                      ],
                    ),
                  ],
                ),
              ),

              // Game area
              Expanded(
                child: Stack(
                  children: [
                    // Game instructions or start screen
                    if (!isPlaying && balls.isEmpty)
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 32),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Tap the falling balls!',
                                  style: TextStyle(fontFamily: 'Poppins', 
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Don\'t let 10 balls escape!',
                                  style: TextStyle(fontFamily: 'Poppins', 
                                    fontSize: 15,
                                    color: Colors.black54,
                                  ),
                                ),
                                SizedBox(height: 24),
                                ElevatedButton(
                                  onPressed: startGame,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 40,
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    elevation: 8,
                                  ),
                                  child: Text(
                                    'START GAME',
                                    style: TextStyle(fontFamily: 'Poppins', 
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                    // Falling balls
                    ...balls.map((ball) {
                      return Positioned(
                        left: ball.x,
                        top: ball.y,
                        child: GestureDetector(
                          onTap: () => _popBall(ball),
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.8, end: 1.0),
                            duration: const Duration(milliseconds: 500),
                            builder: (context, scale, child) {
                              return Transform.scale(
                                scale: scale,
                                child: child,
                              );
                            },
                            child: Container(
                              width: ball.size,
                              height: ball.size,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    ball.color.withValues(alpha: 0.8),
                                    ball.color,
                                    ball.color.withValues(alpha: 0.6),
                                  ],
                                  stops: [0.0, 0.6, 1.0],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: ball.color.withValues(alpha: 0.5),
                                    blurRadius: 15,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  ball.emoji,
                                  style: TextStyle(fontFamily: 'Poppins', 
                                    fontSize: ball.size * 0.6,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),

                    // Pause button during game
                    if (isPlaying)
                      Positioned(
                        bottom: 20,
                        right: 20,
                        child: FloatingActionButton(
                          onPressed: () {
                            stopGame();
                            _speak('Game paused');
                          },
                          backgroundColor: Colors.orange,
                          child: Icon(Icons.pause, size: 30),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreCard(String label, int value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(fontFamily: 'Poppins', 
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 2),
          Text(
            '$value',
            style: TextStyle(fontFamily: 'Poppins', 
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class Ball {
  double x;
  double y;
  Color color;
  String emoji;
  double speed;
  double size;

  Ball({
    required this.x,
    required this.y,
    required this.color,
    required this.emoji,
    required this.speed,
    required this.size,
  });
}
