import 'package:flutter/material.dart';
import 'package:get/get.dart';
// تأكدي من عمل import لشاشة المستوى الثالث
import 'alphabet_number_puzzle_screen.dart';

class WordGameScreen extends StatefulWidget {
  const WordGameScreen({super.key});

  @override
  State<WordGameScreen> createState() => _WordGameScreenState();
}

class _WordGameScreenState extends State<WordGameScreen>
    with SingleTickerProviderStateMixin {
  int currentLetterIndex = 0;
  int score = 0;
  String selectedAnswer = '';
  bool showResult = false;
  bool isCorrect = false;
  bool hasShownLevelThreePrompt =
      false; // للتأكد أن الرسالة تظهر مرة واحدة فقط عند 40
  late AnimationController _animationController;

  final List<Map<String, dynamic>> alphabetData = [
    {
      'letter': 'A',
      'word': 'Apple',
      'emoji': '🍎',
      'options': ['Apple', 'Ball', 'Cat'],
      'optionEmojis': ['🍎', '⚽', '🐱'],
    },
    {
      'letter': 'B',
      'word': 'Ball',
      'emoji': '⚽',
      'options': ['Apple', 'Ball', 'Dog'],
      'optionEmojis': ['🍎', '⚽', '🐶'],
    },
    {
      'letter': 'C',
      'word': 'Cat',
      'emoji': '🐱',
      'options': ['Ball', 'Cat', 'Egg'],
      'optionEmojis': ['⚽', '🐱', '🥚'],
    },
    {
      'letter': 'D',
      'word': 'Dog',
      'emoji': '🐶',
      'options': ['Cat', 'Dog', 'Fish'],
      'optionEmojis': ['🐱', '🐶', '🐠'],
    },
    {
      'letter': 'E',
      'word': 'Elephant',
      'emoji': '🐘',
      'options': ['Dog', 'Elephant', 'Goat'],
      'optionEmojis': ['🐶', '🐘', '🐐'],
    },
    {
      'letter': 'F',
      'word': 'Fish',
      'emoji': '🐠',
      'options': ['Elephant', 'Fish', 'Hat'],
      'optionEmojis': ['🐘', '🐠', '🎩'],
    },
    {
      'letter': 'G',
      'word': 'Grapes',
      'emoji': '🍇',
      'options': ['Fish', 'Grapes', 'Ice'],
      'optionEmojis': ['🐠', '🍇', '🧊'],
    },
    {
      'letter': 'H',
      'word': 'Hat',
      'emoji': '🎩',
      'options': ['Grapes', 'Hat', 'Jug'],
      'optionEmojis': ['🍇', '🎩', '🏺'],
    },
    {
      'letter': 'I',
      'word': 'Ice Cream',
      'emoji': '🍦',
      'options': ['Hat', 'Ice Cream', 'Kite'],
      'optionEmojis': ['🎩', '🍦', '🪁'],
    },
    {
      'letter': 'J',
      'word': 'Juice',
      'emoji': '🧃',
      'options': ['Ice Cream', 'Juice', 'Lion'],
      'optionEmojis': ['🍦', '🧃', '🦁'],
    },
    {
      'letter': 'K',
      'word': 'Kite',
      'emoji': '🪁',
      'options': ['Juice', 'Kite', 'Moon'],
      'optionEmojis': ['🧃', '🪁', '🌙'],
    },
    {
      'letter': 'L',
      'word': 'Lion',
      'emoji': '🦁',
      'options': ['Kite', 'Lion', 'Nest'],
      'optionEmojis': ['🪁', '🦁', '🪺'],
    },
    {
      'letter': 'M',
      'word': 'Monkey',
      'emoji': '🐵',
      'options': ['Lion', 'Monkey', 'Orange'],
      'optionEmojis': ['🦁', '🐵', '🍊'],
    },
    {
      'letter': 'N',
      'word': 'Nest',
      'emoji': '🪺',
      'options': ['Monkey', 'Nest', 'Pizza'],
      'optionEmojis': ['🐵', '🪺', '🍕'],
    },
    {
      'letter': 'O',
      'word': 'Orange',
      'emoji': '🍊',
      'options': ['Nest', 'Orange', 'Queen'],
      'optionEmojis': ['🪺', '🍊', '👸'],
    },
    {
      'letter': 'P',
      'word': 'Pizza',
      'emoji': '🍕',
      'options': ['Orange', 'Pizza', 'Robot'],
      'optionEmojis': ['🍊', '🍕', '🤖'],
    },
    {
      'letter': 'Q',
      'word': 'Queen',
      'emoji': '👸',
      'options': ['Pizza', 'Queen', 'Sun'],
      'optionEmojis': ['🍕', '👸', '☀️'],
    },
    {
      'letter': 'R',
      'word': 'Rabbit',
      'emoji': '🐰',
      'options': ['Queen', 'Rabbit', 'Tree'],
      'optionEmojis': ['👸', '🐰', '🌳'],
    },
    {
      'letter': 'S',
      'word': 'Sun',
      'emoji': '☀️',
      'options': ['Rabbit', 'Sun', 'Umbrella'],
      'optionEmojis': ['🐰', '☀️', '☂️'],
    },
    {
      'letter': 'T',
      'word': 'Tiger',
      'emoji': '🐯',
      'options': ['Sun', 'Tiger', 'Van'],
      'optionEmojis': ['☀️', '🐯', '🚐'],
    },
    {
      'letter': 'U',
      'word': 'Umbrella',
      'emoji': '☂️',
      'options': ['Tiger', 'Umbrella', 'Watch'],
      'optionEmojis': ['🐯', '☂️', '⌚'],
    },
    {
      'letter': 'V',
      'word': 'Van',
      'emoji': '🚐',
      'options': ['Umbrella', 'Van', 'Xylophone'],
      'optionEmojis': ['☂️', '🚐', '🎹'],
    },
    {
      'letter': 'W',
      'word': 'Watch',
      'emoji': '⌚',
      'options': ['Van', 'Watch', 'Yoyo'],
      'optionEmojis': ['🚐', '⌚', '🪀'],
    },
    {
      'letter': 'X',
      'word': 'Xylophone',
      'emoji': '🎹',
      'options': ['Watch', 'Xylophone', 'Zebra'],
      'optionEmojis': ['⌚', '🎹', '🦓'],
    },
    {
      'letter': 'Y',
      'word': 'Yoyo',
      'emoji': '🪀',
      'options': ['Xylophone', 'Yoyo', 'Apple'],
      'optionEmojis': ['🎹', '🪀', '🍎'],
    },
    {
      'letter': 'Z',
      'word': 'Zebra',
      'emoji': '🦓',
      'options': ['Yoyo', 'Zebra', 'Ball'],
      'optionEmojis': ['🪀', '🦓', '⚽'],
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  void _checkAnswer(String answer) {
    final currentData = alphabetData[currentLetterIndex];

    setState(() {
      selectedAnswer = answer;
      isCorrect = answer == currentData['word'];
      showResult = true;

      if (isCorrect) {
        score += 10;
        _animationController.forward(from: 0);
      }
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (isCorrect) {
        if (score == 260 && !hasShownLevelThreePrompt) {
          _showLevelChoiceDialog();
        } else {
          _nextLetter();
        }
      } else {
        setState(() {
          showResult = false;
          selectedAnswer = '';
        });
      }
    });
  }

  void _nextLetter() {
    setState(() {
      if (currentLetterIndex < alphabetData.length - 1) {
        currentLetterIndex++;
        showResult = false;
        selectedAnswer = '';
      } else {
        _showCompletionDialog();
      }
    });
  }

  void _previousLetter() {
    setState(() {
      if (currentLetterIndex > 0) {
        currentLetterIndex--;
      }
      showResult = false;
      selectedAnswer = '';
    });
  }

  void _showLevelChoiceDialog() {
    hasShownLevelThreePrompt = true;
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
              colors: [Colors.blue.shade400, Colors.purple.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('🚀', style: TextStyle(fontFamily: 'Poppins', fontSize: 60)),
              SizedBox(height: 16),
              Text(
                'Great Progress!',
                style: TextStyle(fontFamily: 'Poppins', 
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),
              Text(
                'You reached 40 points!\nDo you want to jump to Level Three or continue learning?',
                style: TextStyle(fontFamily: 'Poppins', fontSize: 16, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Get.off(() => const AlphabetNumberPuzzleScreen());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  'Go to Level Three',
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _nextLetter();
                },
                child: Text(
                  'Continue Level Two',
                  style: TextStyle(fontFamily: 'Poppins', 
                    color: Colors.white,
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
              colors: [Colors.purple.shade300, Colors.pink.shade300],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('🎉', style: TextStyle(fontFamily: 'Poppins', fontSize: 70)),
              SizedBox(height: 16),
              Text(
                'Amazing!',
                style: TextStyle(fontFamily: 'Poppins', 
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'You learned the whole alphabet!\nReady for the next challenge?',
                style: TextStyle(fontFamily: 'Poppins', fontSize: 18, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  Get.off(() => const AlphabetNumberPuzzleScreen());
                },
                icon: Icon(Icons.extension, size: 28),
                label: Text(
                  'Go to Level Three',
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
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
    final currentData = alphabetData[currentLetterIndex];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ─────────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, size: 26),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'ABC Learning',
                            style: TextStyle(fontFamily: 'Poppins', 
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple,
                            ),
                          ),
                          Text(
                            'Learn the Alphabet!',
                            style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.orange.shade300,
                              Colors.pink.shade300,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withValues(alpha: 0.3),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: Text(
                          '⭐ $score',
                          style: TextStyle(fontFamily: 'Poppins', 
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: (currentLetterIndex + 1) /
                                alphabetData.length,
                            minHeight: 10,
                            backgroundColor: Colors.grey.shade200,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.green.shade400,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        '${currentLetterIndex + 1}/${alphabetData.length}',
                        style: TextStyle(fontFamily: 'Poppins', 
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── Two-column body ─────────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ── LEFT SIDE: letter, emoji, question, previous btn ────
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Letter card
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.blue.shade300,
                                    Colors.purple.shade300,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        Colors.purple.withValues(alpha: 0.3),
                                    blurRadius: 14,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'Letter',
                                    style: TextStyle(fontFamily: 'Poppins', 
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.2,
                                          ),
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      currentData['letter'],
                                      style: TextStyle(fontFamily: 'Poppins', 
                                        fontSize: 60,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.purple,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 16),

                            // Emoji
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Text(
                                currentData['emoji'],
                                style: TextStyle(fontFamily: 'Poppins', fontSize: 60),
                              ),
                            ),

                            SizedBox(height: 16),

                            // Question
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade100,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: Colors.orange.shade300,
                                  width: 2.5,
                                ),
                              ),
                              child: Text(
                                '${currentData['letter']} is for...?',
                                style: TextStyle(fontFamily: 'Poppins', 
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),

                            SizedBox(height: 16),

                            // Previous button
                            Align(
                              alignment: Alignment.centerLeft,
                              child: ElevatedButton.icon(
                                onPressed: currentLetterIndex > 0
                                    ? _previousLetter
                                    : null,
                                icon: Icon(Icons.arrow_back, size: 20),
                                label: Text(
                                  'Previous',
                                  style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade300,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  disabledBackgroundColor:
                                      Colors.grey.shade300,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(width: 16),

                    // ── RIGHT SIDE: 3 answer option boxes ──────────────────
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          currentData['options'].length,
                          (index) {
                            final option = currentData['options'][index];
                            final optionEmoji =
                                currentData['optionEmojis'][index];
                            final isSelected = selectedAnswer == option;
                            final isCorrectOption =
                                option == currentData['word'];

                            Color buttonColor;
                            if (showResult && isSelected) {
                              buttonColor =
                                  isCorrect ? Colors.green : Colors.red;
                            } else if (showResult && isCorrectOption) {
                              buttonColor = Colors.green;
                            } else {
                              buttonColor = Colors.white;
                            }

                            return GestureDetector(
                              onTap: showResult
                                  ? null
                                  : () => _checkAnswer(option),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.only(bottom: 14),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: buttonColor,
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: showResult &&
                                            (isSelected || isCorrectOption)
                                        ? (isCorrect && isSelected
                                              ? Colors.green
                                              : Colors.red)
                                        : Colors.purple.shade300,
                                    width: 3,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.08,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 46,
                                      height: 46,
                                      decoration: BoxDecoration(
                                        color: showResult &&
                                                (isSelected || isCorrectOption)
                                            ? Colors.white.withValues(
                                                alpha: 0.3,
                                              )
                                            : Colors.purple.shade50,
                                        borderRadius:
                                            BorderRadius.circular(12),
                                      ),
                                      child: Center(
                                        child: Text(
                                          optionEmoji,
                                          style: TextStyle(fontFamily: 'Poppins', fontSize: 28),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        option,
                                        style: TextStyle(fontFamily: 'Poppins', 
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: showResult &&
                                                  (isSelected ||
                                                      isCorrectOption)
                                              ? Colors.white
                                              : Colors.purple,
                                        ),
                                      ),
                                    ),
                                    if (showResult && isSelected)
                                      Icon(
                                        isCorrect
                                            ? Icons.check_circle
                                            : Icons.cancel,
                                        color: Colors.white,
                                        size: 24,
                                      )
                                    else if (showResult && isCorrectOption)
                                      Icon(
                                        Icons.check_circle,
                                        color: Colors.white,
                                        size: 24,
                                      )
                                    else
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.purple.shade300,
                                        size: 18,
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
