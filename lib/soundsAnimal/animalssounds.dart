import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:kids_world_app/soundsAnimal/pages/home.dart';
import 'package:kids_world_app/soundsAnimal/providers/category_provider.dart';
import 'package:kids_world_app/soundsAnimal/providers/favorites_provider.dart';
import 'package:kids_world_app/soundsAnimal/providers/quiz_provider.dart';
import 'package:kids_world_app/soundsAnimal/providers/search_provider.dart';
import 'package:kids_world_app/soundsAnimal/providers/settings_provider.dart';

class AnimalSoundsScreen extends StatelessWidget {
  const AnimalSoundsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            const Expanded(child: HomePage()),
          ],
        ),
      ),
    );
  }
}
