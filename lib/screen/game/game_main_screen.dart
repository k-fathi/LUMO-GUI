// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:kids_world_app/soundsAnimal/screen/game/matching/color_game_screen.dart';
// import 'package:kids_world_app/soundsAnimal/screen/game/mindGames/funny_ball_game.dart';
// import 'package:kids_world_app/soundsAnimal/screen/game/learningGames/math_fun_game.dart';
// import 'package:kids_world_app/soundsAnimal/screen/game/matching/puzzle_game_screen.dart';
// import 'package:kids_world_app/soundsAnimal/screen/game/learningGames/alphabet_number_puzzle_screen.dart';
// import 'package:kids_world_app/soundsAnimal/screen/game/mindGames/which_has_more_game.dart';
// import 'package:kids_world_app/soundsAnimal/screen/game/learningGames/word_game_screen.dart';
// import 'mindGames/big_or_small_game.dart';
// import 'learningGames/count_choose_game.dart';
// import 'matching/match_pair_game.dart';
//
// class GameMainScreen extends StatelessWidget {
//   const GameMainScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Top greeting section
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       GestureDetector(
//                         onTap: (){
//                           Navigator.pop(context);
//                         },
//                         child: Container(
//                           padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                           decoration: BoxDecoration(
//                             color: Colors.orange.shade50,
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Row(
//                             children: [
//                               Icon(Icons.arrow_back),
//                             ],
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 24,),
//                       Text(
//                         'Learn by Game',
//                         style: GoogleFonts.poppins(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black87,
//                         ),
//                       ),
//                     ],
//                   ),
//
//                 ],
//               ),
//
//               SizedBox(height: 30),
//
//               // Cards grid
//               Expanded(
//                 child: GridView.count(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 15,
//                   mainAxisSpacing: 15,
//                   childAspectRatio: 1.1,
//                   children: [
//                     _buildCategoryCard(
//                       title: 'Puzzle Game',
//                       icon: 'assets/images/puzzle_game_icon.png',
//                       bgColor: Color(0xFFE8F5E9),
//                       onTap: () {
//                         Get.to(() => PuzzleGameScreen(),transition: Transition.fadeIn);
//                       },
//                     ),
//                     _buildCategoryCard(
//                       title: 'Alpha N Puzzle',
//                       icon: 'assets/images/alpha_puzzle_game.png',
//                       bgColor: Color(0xFFFFF6ED),
//                       onTap: () {
//                         Get.to(() => AlphabetNumberPuzzleScreen(),transition: Transition.fadeIn);
//                       },
//                     ),
//                     _buildCategoryCard(
//                       title: 'Color Game',
//                       icon: 'assets/images/color_game_icon.png',
//                       bgColor: Color(0xFFF7F1FF),
//                       onTap: () {
//                         Get.to(() => ColorGameScreen(),transition: Transition.fadeIn);
//                       },
//                     ),
//                     _buildCategoryCard(
//                       title: 'Funny Ball',
//                       icon: 'assets/images/ball_game_icon.png',
//                       bgColor: Color(0xFFE5F3FC),
//                       onTap: () {
//                         Get.to(() => FunnyBallGame(),transition: Transition.fadeIn);
//                       },
//                     ),
//                     _buildCategoryCard(
//                       title: 'Play Stickers',
//                       icon: 'assets/images/sticker_game_icon.png',
//                       bgColor: Color(0xFFF1FFDE),
//                       onTap: () {
//                         // Get.to(() => StickerGameScreen(),transition: Transition.fadeIn);
//                       },
//                     ),
//                     _buildCategoryCard(
//                       title: 'Fake Call',
//                       icon: 'assets/images/fake_call_icon.png',
//                       bgColor: Color(0xFFFBF2E9),
//                       onTap: () {
//                         // Get.to(() => FakeCallGame(),transition: Transition.fadeIn);
//                       },
//                     ),
//                     _buildCategoryCard(
//                       title: 'Word Game',
//                       icon: 'assets/images/word_game_icon.png',
//                       bgColor: Color(0xFFF7F1FF),
//                       onTap: () {
//                         Get.to(() => WordGameScreen(),transition: Transition.fadeIn);
//                       },
//                     ),
//                     _buildCategoryCard(
//                       title: 'Clock Hero',
//                       icon: 'assets/images/clock_game_icon.png',
//                       bgColor: Color(0xFFFFF9E3),
//                       onTap: () {
//                         // Get.to(() => ClockHeroGame(),transition: Transition.fadeIn);
//                       },
//                     ),
//                     _buildCategoryCard(
//                       title: 'Math Fun',
//                       icon: 'assets/images/math_game_icon.png',
//                       bgColor: Color(0xFFE5F3FC),
//                       onTap: () {
//                         Get.to(() => MathFunGame(),transition: Transition.fadeIn);
//                       },
//                     ),
//                      _buildCategoryCard(
//                       title: 'Find More',
//                       icon: 'assets/images/more_find_icon.png',
//                        bgColor: Color(0xFFFFF6ED),
//                       onTap: () {
//                         Get.to(() => WhichHasMoreGame(),transition: Transition.fadeIn);
//                       },
//                     ),
//                     _buildCategoryCard(
//                       title: 'Find Bigger',
//                       icon: 'assets/images/find_big_icon.png',
//                       bgColor: Color(0xFFF1FFDE),
//                       onTap: () {
//                         Get.to(() => BigOrSmallGame(),transition: Transition.fadeIn);
//                       },
//                     ),
//                     _buildCategoryCard(
//                       title: 'Match Pair',
//                       icon: 'assets/images/match_pair_icon.png',
//                       bgColor: Color(0xFFFFF3E0),
//                       onTap: () {
//                         Get.to(() => MatchPairsGame(),transition: Transition.fadeIn);
//                       },
//                     ),
//
//                     _buildCategoryCard(
//                       title: 'Count choose',
//                       icon: 'assets/images/count_game_icon.png',
//                       bgColor: Color(0xFFEBF6F0),
//                       onTap: () {
//                         Get.to(() => CountChooseGame(),transition: Transition.fadeIn);
//                       },
//                     ),
//
//
//
//                   ],
//                 ),
//               ),
//
//               SizedBox(height: 20),
//
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCategoryCard({
//     required String title,
//     required dynamic icon,
//     required Color bgColor,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           color: bgColor,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withValues(alpha: 0.05),
//               blurRadius: 10,
//               offset: Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(
//               icon,
//               height: 70,
//               width: 70,
//             ),
//             SizedBox(height: 10),
//             Text(
//               title,
//               style: GoogleFonts.poppins(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.grey.shade700,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
// }