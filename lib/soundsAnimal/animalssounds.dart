import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:kids_world_app/soundsAnimal/pages/home.dart';
import 'package:kids_world_app/soundsAnimal/providers/category_provider.dart';
import 'package:kids_world_app/soundsAnimal/providers/favorites_provider.dart';
import 'package:kids_world_app/soundsAnimal/providers/quiz_provider.dart';
import 'package:kids_world_app/soundsAnimal/providers/search_provider.dart';
import 'package:kids_world_app/soundsAnimal/providers/settings_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnimalSoundsScreen extends StatelessWidget {
  const AnimalSoundsScreen({super.key});

  Future<void> showParentAlert(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final hasShownAlert = prefs.getBool('has_shown_parent_alert') ?? false;

    if (!hasShownAlert) {
      if (context.mounted) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('Alert'),
            content: const Text('For parents only'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                  prefs.setBool('has_shown_parent_alert', true);
                },
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showParentAlert(context);
    });

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => QuizProvider()),
      ],
      child: const _AnimalSoundsView(),
    );
  }
}

class _AnimalSoundsView extends StatelessWidget {
  const _AnimalSoundsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [

            /// 🔙 زرار رجوع + عنوان
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),

            /// 👇 المحتوى
            const Expanded(
              child: HomePage(),
            ),
          ],
        ),
      ),
    );
  }
}