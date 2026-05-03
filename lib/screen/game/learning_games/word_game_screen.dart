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
          _showLevelChoiceDialog(); // رسالة الاختيار عند الـ 40
        } else {
          _nextLetter(); // انتقال تلقائي للسؤال التالي
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
        _showCompletionDialog(); // رسالة النهاية بعد إتمام كل الحروف
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
              const Text('🚀', style: TextStyle(fontSize: 60)),
              const SizedBox(height: 16),
              const Text(
                'Great Progress!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'You reached 40 points!\nDo you want to jump to Level Three or continue learning?',
                style: TextStyle(fontSize: 16, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
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
                child: const Text(
                  'Go to Level Three',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _nextLetter();
                },
                child: const Text(
                  'Continue Level Two',
                  style: TextStyle(
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
              const Text('🎉', style: TextStyle(fontSize: 70)),
              const SizedBox(height: 16),
              const Text(
                'Amazing!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'You learned the whole alphabet!\nReady for the next challenge?',
                style: TextStyle(fontSize: 18, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  Get.off(() => const AlphabetNumberPuzzleScreen());
                },
                icon: const Icon(Icons.extension, size: 28),
                label: const Text(
                  'Go to Level Three',
                  style: TextStyle(fontSize: 18),
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
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
                          icon: const Icon(Icons.arrow_back, size: 28),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ABC Learning',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Learn the Alphabet!',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.orange.shade300,
                                Colors.pink.shade300,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(25),
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
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Progress bar
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value:
                                  (currentLetterIndex + 1) /
                                  alphabetData.length,
                              minHeight: 12,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.green.shade400,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${currentLetterIndex + 1}/${alphabetData.length}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Main letter display
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade300, Colors.purple.shade300],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Letter',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Text(
                        currentData['letter'],
                        style: const TextStyle(
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Emoji display
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Text(
                  currentData['emoji'],
                  style: const TextStyle(fontSize: 80),
                ),
              ),

              const SizedBox(height: 30),

              // Question
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.orange.shade300, width: 3),
                ),
                child: Text(
                  '${currentData['letter']} is for...?',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 25),

              // Answer options with emojis
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: List.generate(currentData['options'].length, (
                    index,
                  ) {
                    final option = currentData['options'][index];
                    final optionEmoji = currentData['optionEmojis'][index];
                    final isSelected = selectedAnswer == option;
                    final isCorrectOption = option == currentData['word'];

                    Color buttonColor;
                    if (showResult && isSelected) {
                      buttonColor = isCorrect ? Colors.green : Colors.red;
                    } else if (showResult && isCorrectOption) {
                      buttonColor = Colors.green;
                    } else {
                      buttonColor = Colors.white;
                    }

                    return GestureDetector(
                      onTap: showResult ? null : () => _checkAnswer(option),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: buttonColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: showResult && (isSelected || isCorrectOption)
                                ? (isCorrect && isSelected
                                      ? Colors.green
                                      : Colors.red)
                                : Colors.purple.shade300,
                            width: 4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color:
                                    showResult &&
                                        (isSelected || isCorrectOption)
                                    ? Colors.white.withValues(alpha: 0.3)
                                    : Colors.purple.shade50,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Text(
                                  optionEmoji,
                                  style: const TextStyle(fontSize: 40),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                option,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      showResult &&
                                          (isSelected || isCorrectOption)
                                      ? Colors.white
                                      : Colors.purple,
                                ),
                              ),
                            ),
                            if (showResult && isSelected)
                              Icon(
                                isCorrect ? Icons.check_circle : Icons.cancel,
                                color: Colors.white,
                                size: 32,
                              )
                            else if (showResult && isCorrectOption)
                              const Icon(
                                Icons.check_circle,
                                color: Colors.white,
                                size: 32,
                              )
                            else
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.purple.shade300,
                                size: 24,
                              ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 20),

              // Navigation buttons (Keeping only Previous as Next is now automatic)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ElevatedButton.icon(
                      onPressed: currentLetterIndex > 0
                          ? _previousLetter
                          : null,
                      icon: const Icon(Icons.arrow_back, size: 24),
                      label: const Text(
                        'Previous',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade300,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        disabledBackgroundColor: Colors.grey.shade300,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
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
