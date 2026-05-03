import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class MatchPairsGame extends StatefulWidget {
  const MatchPairsGame({super.key});

  @override
  State<MatchPairsGame> createState() => _MatchPairsGameState();
}

class _MatchPairsGameState extends State<MatchPairsGame> {
  int score = 0;
  final Map<String, String> pairs = {
    // Fruits
    '🍎': 'Apple',
    '🍌': 'Banana',
    '🍊': 'Orange',
    '🍇': 'Grapes',
    '🍓': 'Strawberry',
    '🍉': 'Watermelon',
    '🍒': 'Cherry',
    '🍑': 'Peach',
    '🥝': 'Kiwi',
    '🍍': 'Pineapple',

    // Animals
    '🐶': 'Dog',
    '🐱': 'Cat',
    '🐭': 'Mouse',
    '🐰': 'Rabbit',
    '🦊': 'Fox',
    '🐻': 'Bear',
    '🐼': 'Panda',
    '🐨': 'Koala',
    '🐯': 'Tiger',
    '🦁': 'Lion',

    // Alphabet A-Z
    'A': 'Apple',
    'B': 'Ball',
    'C': 'Cat',
    'D': 'Dog',
    'E': 'Elephant',
    'F': 'Fish',
    'G': 'Goat',
    'H': 'Hat',
    'I': 'Ice Cream',
    'J': 'Juice',
    'K': 'Kite',
    'L': 'Lion',
    'M': 'Monkey',
    'N': 'Nest',
    'O': 'Orange',
    'P': 'Pig',
    'Q': 'Queen',
    'R': 'Rabbit',
    'S': 'Sun',
    'T': 'Tiger',
    'U': 'Umbrella',
    'V': 'Van',
    'W': 'Watch',
    'X': 'Xylophone',
    'Y': 'Yak',
    'Z': 'Zebra',

    // Numbers 1-10
    '1️⃣': 'One',
    '2️⃣': 'Two',
    '3️⃣': 'Three',
    '4️⃣': 'Four',
    '5️⃣': 'Five',
    '6️⃣': 'Six',
    '7️⃣': 'Seven',
    '8️⃣': 'Eight',
    '9️⃣': 'Nine',
    '🔟': 'Ten',

    // Colors
    '❤️': 'Red',
    '💛': 'Yellow',
    '💚': 'Green',
    '💙': 'Blue',
    '💜': 'Purple',
    '🧡': 'Orange',
    '🤍': 'White',
    '🖤': 'Black',

    // Vehicles
    '🚗': 'Car',
    '🚕': 'Taxi',
    '🚙': 'SUV',
    '🚌': 'Bus',
    '🚎': 'Trolley',
    '🏎️': 'Race Car',
    '🚓': 'Police Car',
    '🚑': 'Ambulance',
    '🚒': 'Fire Truck',
    '🚐': 'Van',

    // Sports
    '⚽': 'Soccer',
    '🏀': 'Basketball',
    '⚾': 'Baseball',
    '🎾': 'Tennis',
    '🏐': 'Volleyball',
    '🏈': 'Football',
    '🎱': 'Pool',
    '🏓': 'Ping Pong',
  };

  late List<String> leftItems;
  late List<String> rightItems;
  late dynamic currentPairs;
  final Map<dynamic, dynamic> matched = {};

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    // Select 8 random pairs from the full collection
    final allKeys = pairs.keys.toList()..shuffle();
    final selectedKeys = allKeys.take(8).toList();

    currentPairs = {
      for (var key in selectedKeys) key: pairs[key]!
    };

    leftItems = currentPairs.keys.toList()..shuffle();
    rightItems = currentPairs.values.toList()..shuffle();
    matched.clear();
    for (var item in leftItems) {
      matched[item] = false;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Match the Pairs',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text('Score: $score', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
          IconButton(icon: const Icon(Icons.refresh), onPressed: () {
            score = 0;
            _initializeGame();
          }),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Drag and match!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: leftItems.length,
                      itemBuilder: (context, index) {
                        final item = leftItems[index];
                        final isMatched = matched[item] ?? false;
                        if (isMatched) return const SizedBox(height: 80);
                        return Draggable<String>(
                          data: item,
                          feedback: Material(
                            color: Colors.transparent,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade300,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(item, style: const TextStyle(fontSize: 32)),
                            ),
                          ),
                          childWhenDragging: Opacity(
                            opacity: 0.3,
                            child: _buildItemCard(item, Colors.blue),
                          ),
                          child: _buildItemCard(item, Colors.blue),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: ListView.builder(
                      itemCount: rightItems.length,
                      itemBuilder: (context, index) {
                        final target = rightItems[index];
                        final matchedKey = matched.entries.where((e) => currentPairs[e.key] == target && e.value).firstOrNull?.key;
                        return DragTarget<String>(
                          builder: (context, candidateData, rejectedData) {
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: matchedKey != null
                                    ? Colors.green.shade200
                                    : (candidateData.isNotEmpty ? Colors.yellow.shade200 : Colors.pink.shade100),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: matchedKey != null ? Colors.green : Colors.pink,
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(target, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                  if (matchedKey != null) ...[
                                    const SizedBox(width: 12),
                                    const Icon(Icons.check_circle, color: Colors.green),
                                  ],
                                ],
                              ),
                            );
                          },
                          onWillAcceptWithDetails: (details) {
                            try {
                              final String src = details.data;
                              return currentPairs[src] == target && !(matched[src] ?? false);
                            } catch (_) {
                              return false;
                            }
                          },
                          onAcceptWithDetails: (details) {
                            try {
                              final String src = details.data;
                              setState(() {
                                matched[src] = true;
                                score++;
                              });
                            } catch (_) {
                              // ignore malformed data
                            }
                           ScaffoldMessenger.of(context).showSnackBar(
                             const SnackBar(content: Text('Perfect Match! 🎉'), backgroundColor: Colors.green, duration: Duration(milliseconds: 600)),
                           );
                           if (matched.values.every((v) => v)) {
                             Future.delayed(const Duration(milliseconds: 700), () {
                               Get.dialog(
                                 Dialog(
                                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                   child: Container(
                                     padding: const EdgeInsets.all(20),
                                     decoration: BoxDecoration(
                                       borderRadius: BorderRadius.circular(20),
                                       gradient: LinearGradient(
                                         colors: [Color(0xFF7F00FF), Color(0xFFE100FF)],
                                         begin: Alignment.topLeft,
                                         end: Alignment.bottomRight,
                                       ),
                                     ),
                                     child: Column(
                                       mainAxisSize: MainAxisSize.min,
                                       children: [
                                         const Icon(Icons.celebration, size: 58, color: Colors.white),
                                         const SizedBox(height: 12),
                                         Text(
                                           'Congratulations!',
                                           style: GoogleFonts.poppins(
                                             fontSize: 22,
                                             fontWeight: FontWeight.w700,
                                             color: Colors.white,
                                           ),
                                         ),
                                         const SizedBox(height: 8),
                                         Text(
                                           'You matched all pairs!\nScore: $score',
                                           style: const TextStyle(color: Colors.white70),
                                           textAlign: TextAlign.center,
                                         ),
                                         const SizedBox(height: 16),
                                         Row(
                                           mainAxisAlignment: MainAxisAlignment.center,
                                           children: [
                                             ElevatedButton(
                                               onPressed: () {
                                                 Get.back();
                                                 score = 0;
                                                 _initializeGame();
                                               },
                                               style: ElevatedButton.styleFrom(
                                                 backgroundColor: Colors.white,
                                                 foregroundColor: Colors.purple,
                                                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                               ),
                                               child: Text('Play Again', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                                             ),
                                             const SizedBox(width: 12),
                                             OutlinedButton(
                                               onPressed: () => Get.back(),
                                               style: OutlinedButton.styleFrom(
                                                 side: const BorderSide(color: Colors.white70),
                                                 foregroundColor: Colors.white,
                                               ),
                                               child: Text('Close', style: GoogleFonts.poppins(color: Colors.white)),
                                             ),
                                           ],
                                         ),
                                       ],
                                     ),
                                   ),
                                 ),
                                 barrierDismissible: false,
                               );
                              });
                             }
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemCard(String item, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 2),
      ),
      child: Center(
        child: Text(item, style: const TextStyle(fontSize: 32)),
      ),
    );
  }
}
