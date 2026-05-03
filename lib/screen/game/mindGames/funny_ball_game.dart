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
            const Icon(Icons.sports_esports, size: 80, color: Colors.orange),
            const SizedBox(height: 20),
            const Text(
              'Game Over!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Your Score: $score',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Missed: $missedBalls balls',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
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
                  child: const Text(
                    'Play Again',
                    style: TextStyle(fontSize: 16, color: Colors.white),
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
                  child: const Text(
                    'Exit',
                    style: TextStyle(fontSize: 16, color: Colors.white),
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
              // Header with score and controls
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, size: 28),
                          onPressed: () {
                            stopGame();
                            Navigator.pop(context);
                          },
                        ),
                        const Text(
                          '🎈 Funny Ball Game 🎈',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildScoreCard('Score', score, Colors.green),
                        _buildScoreCard('Missed', missedBalls, Colors.red),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Difficulty selector
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Difficulty: ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ...['Easy', 'Medium', 'Hard'].map((level) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: ChoiceChip(
                              label: Text(level),
                              selected: difficulty == level,
                              onSelected: isPlaying ? null : (selected) {
                                if (selected) {
                                  setState(() {
                                    difficulty = level;
                                  });
                                }
                              },
                              selectedColor: Colors.orange,
                              labelStyle: TextStyle(
                                color: difficulty == level ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }),
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
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              '🎯',
                              style: TextStyle(fontSize: 100),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Tap the falling balls!',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Don\'t let 10 balls escape!',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 40),
                            ElevatedButton(
                              onPressed: startGame,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 50,
                                  vertical: 20,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 8,
                              ),
                              child: const Text(
                                'START GAME',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
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
                                  stops: const [0.0, 0.6, 1.0],
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
                                  style: TextStyle(
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
                          child: const Icon(Icons.pause, size: 30),
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
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color, width: 2),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$value',
            style: TextStyle(
              fontSize: 24,
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
