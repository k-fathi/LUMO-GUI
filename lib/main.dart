// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:kids_world_app/screen/main/main_screen.dart';
// import 'package:kids_world_app/screen/splash/splash_screen.dart';
// import 'package:kids_world_app/utils/timer_controller.dart';
//
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // Initialize the timer globally
//   Get.put(TimerController());
//
//   // قفل الاتجاه على الطولي فقط
//   // SystemChrome.setPreferredOrientations([
//   //   DeviceOrientation.portraitUp,
//   //   DeviceOrientation.portraitDown,
//   // ]);
//
//   runApp(const KidsWorldApp());
// }
//
// class KidsWorldApp extends StatelessWidget {
//   const KidsWorldApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       title: 'Kids World',
//       getPages: [
//         GetPage(name: '/', page: () => const SplashFaceScreen()),
//         GetPage(name: '/MainScreen', page: () => const MainScreen()),
//       ],
//       debugShowCheckedModeBanner: false,
//
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         scaffoldBackgroundColor: const Color(0xFFE8E8E8),
//         fontFamily: 'SF Pro',
//       ),
//
//       builder: (context, child) {
//         return Stack(
//           children: [
//             if (child != null) child,
//             const Positioned(
//               top: 50, // Positioned safely below the status bar
//               right: 20,
//               child: IgnorePointer(
//                 child: GlobalTimerWidget(),
//               ),
//             ),
//           ],
//         );
//       },
//
//       home: const SplashFaceScreen(),
//     );
//   }
// }
//
// class GlobalTimerWidget extends StatelessWidget {
//   const GlobalTimerWidget({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final timerController = Get.find<TimerController>();
//
//     return Obx(() {
//       if (!timerController.isVisible.value) {
//         return const SizedBox.shrink();
//       }
//
//       final String timeStr = timerController.formattedTime;
//       return Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//         decoration: BoxDecoration(
//           color: Colors.black.withOpacity(0.5),
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Icon(Icons.timer, color: Colors.white, size: 16),
//             const SizedBox(width: 6),
//             Text(
//               timeStr,
//               style: GoogleFonts.poppins(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 14,
//                 decoration: TextDecoration.none,
//               ),
//             ),
//           ],
//         ),
//       );
//     });
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kids_world_app/screen/main/main_screen.dart';
import 'package:kids_world_app/screen/splash/splash_screen.dart';
import 'package:provider/provider.dart';

import 'package:kids_world_app/soundsAnimal/providers/settings_provider.dart';

class AlwaysScrollbarBehavior extends MaterialScrollBehavior {
  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return Scrollbar(
      controller: details.controller,
      thumbVisibility: true,
      trackVisibility: true,
      thickness: 8.0,
      radius: const Radius.circular(4),
      interactive: true,
      child: child,
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => SettingsProvider())],
      child: const KidsWorldApp(),
    ),
  );
}

class KidsWorldApp extends StatelessWidget {
  const KidsWorldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Kids World',
      scrollBehavior: AlwaysScrollbarBehavior(),
      getPages: [
        GetPage(name: '/', page: () => const SplashFaceScreen()),
        GetPage(name: '/MainScreen', page: () => const MainScreen()),
      ],

      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFE8E8E8),

        // Main app font
        fontFamily: 'SF Pro',

        // Emoji fallback font for Raspberry Pi / Linux
        fontFamilyFallback: const ['Noto Color Emoji'],
      ),

      home: const SplashFaceScreen(),
    );
  }
}
