// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// // import 'package:kids_world_app/screen/main/main_screen.dart';
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
//               style: TextStyle(fontFamily: 'Poppins',
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
import 'package:kids_world_app/controllers/timer_controller.dart';

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

  // Register TimerController globally in Get
  Get.put(TimerController());

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
        fontFamily: 'Poppins',

        // Fallback fonts for emoji and unsupported characters
        fontFamilyFallback: const ['Noto Color Emoji', 'sans-serif'],
      ),

      builder: (context, child) {
        return Stack(
          children: [
            child ?? const SizedBox.shrink(),
            const Positioned(top: 24, right: 24, child: GlobalTimerWidget()),
          ],
        );
      },

      home: const SplashFaceScreen(),
    );
  }
}

class GlobalTimerWidget extends StatefulWidget {
  const GlobalTimerWidget({super.key});

  @override
  State<GlobalTimerWidget> createState() => _GlobalTimerWidgetState();
}

class _GlobalTimerWidgetState extends State<GlobalTimerWidget> {
  // Controls whether the full timer pill is expanded (visible) or
  // collapsed into a thin bar on the right edge.
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final timerController = Get.find<TimerController>();

    return Obx(() {
      if (!timerController.isRunning.value) {
        return const SizedBox.shrink();
      }

      // Collapsed state: a thin, semi-transparent vertical line on the right edge.
// The tappable area is padded wider than the visible line so it stays
// easy to tap without looking bulky.
      if (!_isExpanded) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = true;
            });
          },
          behavior: HitTestBehavior.translucent,
          child: Container(
            width: 18,
            height: 48,
            alignment: Alignment.centerRight,
            color: Colors.transparent,
            child: Container(
              width: 3,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFFFAB91).withOpacity(0.5),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        );

      }

      // Expanded state: original full timer pill (unchanged logic).
      final String timeStr = timerController.formattedTime;
      return Material(
        color: Colors.transparent,
        child: GestureDetector(
          // Tapping the pill itself (outside the End button) collapses it
          // back into the thin bar. The End button below stops propagation
          // via its own GestureDetector, so it keeps working normally.
          onTap: () {
            setState(() {
              _isExpanded = false;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF8A65), Color(0xFFFF5722)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.timer_outlined, color: Colors.white, size: 18),
                const SizedBox(width: 6),
                Text(
                  timeStr,
                  style: TextStyle(fontFamily: 'Poppins',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () async {
                    final confirm = await Get.dialog<bool>(
                      AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        title: Text(
                          'End Part',
                          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                        ),
                        content: Text(
                          'Are you want to end this part now?',
                          style: TextStyle(fontFamily: 'Poppins', fontSize: 15),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Get.back(result: false),
                            child: Text(
                              'No',
                              style: TextStyle(fontFamily: 'Poppins',
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () => Get.back(result: true),
                            child: Text(
                              'Yes',
                              style: TextStyle(fontFamily: 'Poppins',
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      Get.find<TimerController>().endSegmentManually();
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'End',
                      style: TextStyle(fontFamily: 'Poppins',
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
