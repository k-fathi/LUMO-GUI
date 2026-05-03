// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:kids_world_app/screen/learn/level_3/animal_learn_screen.dart';
// import 'package:kids_world_app/screen/learn/level_1/arabic_learn_screen.dart';
// import 'package:kids_world_app/screen/learn/level_2/color_learn_screen.dart';
// import 'package:kids_world_app/screen/learn/level_3/daily_life_learn_screen_new.dart';
// import 'package:kids_world_app/screen/learn/level_2/month_learn_screen.dart';
// import 'package:kids_world_app/screen/learn/level_1/number_learn_screen.dart';
// import 'package:kids_world_app/screen/learn/level_3/shape_learn_screen.dart';
// import 'level_1/alphabet_learning_screen.dart';
// import 'level_2/day_learn_screen.dart';
//
// class MainLearnScreen extends StatelessWidget {
//   const MainLearnScreen({super.key});
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
//                         'Learn & Fun',
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
//                       title: 'Alphabet',
//                       icon: 'assets/images/alphabet_icon.png',
//                       bgColor: Color(0xFFFFF6ED),
//                       onTap: () {
//                         Get.to(() => AlphabetLearningScreen(),transition: Transition.fadeIn);
//                       },
//                     ),
//                     _buildCategoryCard(
//                       title: 'Numbers',
//                       icon: 'assets/images/number_icon.png',
//                       bgColor: Color(0xFFF7F1FF),
//                       onTap: () {
//                         Get.to(() => NumberLearnScreen(),transition: Transition.fadeIn);
//                       },
//                     ),
//                     _buildCategoryCard(
//                       title: 'Bengali',
//                       icon: 'assets/images/bengali_icon.png',
//                       bgColor: Color(0xFFEBF6F0),
//                       onTap: () {
//
//                       },
//                     ),
//                     _buildCategoryCard(
//                       title: 'Arabic',
//                       icon: 'assets/images/arabic_icon.png',
//                       bgColor: Color(0xFFFBF2E9),
//                       onTap: () {
//                         Get.to(() => ArabicLearnScreen(),transition: Transition.fadeIn);
//                       },
//                     ),
//                     _buildCategoryCard(
//                       title: 'Colors',
//                       icon: 'assets/images/colors_icon.png',
//                       bgColor: Color(0xFFE5F3FC),
//                       onTap: () {
//                         Get.to(() => ColorLearnScreen(),transition: Transition.fadeIn);
//                       },
//                     ),
//                     _buildCategoryCard(
//                       title: 'Shapes',
//                       icon: 'assets/images/shape_icon.png',
//                       bgColor: Color(0xFFF1FFDE),
//                       onTap: () {
//                         Get.to(() => ShapeLearnScreen(),transition: Transition.fadeIn);
//                       },
//                     ),
//                     _buildCategoryCard(
//                       title: 'Animals',
//                       icon: 'assets/images/animal_icon.png',
//                       bgColor: Color(0xFFFBF2E9),
//                       onTap: () {
//                         Get.to(() => AnimalLearnScreen(),transition: Transition.fadeIn);
//                       },
//                     ),
//                     _buildCategoryCard(
//                       title: 'Days',
//                       icon: 'assets/images/day_icon.png',
//                       bgColor: Color(0xFFF7F1FF),
//                       onTap: () {
//                         Get.to(() => DayLearnScreen(),transition: Transition.fadeIn);
//                       },
//                     ),
//                     _buildCategoryCard(
//                       title: 'Months',
//                       icon: 'assets/images/month_icon.png',
//                       bgColor: Color(0xFFFFF9E3),
//                       onTap: () {
//                         Get.to(() => MonthLearnScreen(),transition: Transition.fadeIn);
//                       },
//                     ),
//                     _buildCategoryCard(
//                       title: 'Daily Life',
//                       icon: 'assets/images/daily_life_icon.png',
//                       bgColor: Color(0xFFE5F3FC),
//                       onTap: () {
//                         Get.to(() => DailyLifeLearnScreen(),transition: Transition.fadeIn);
//                       },
//                     ),
//
//
//
//
//
//
//
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
//     required String icon,
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