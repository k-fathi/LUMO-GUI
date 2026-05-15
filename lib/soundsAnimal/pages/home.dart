import 'package:kids_world_app/soundsAnimal/pages/quiz_start_page.dart';
import 'package:kids_world_app/soundsAnimal/providers/favorites_provider.dart';
import 'package:kids_world_app/soundsAnimal/widgets/banner_ad_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kids_world_app/soundsAnimal/models/animal.dart';
import 'package:kids_world_app/soundsAnimal/models/category.dart';
import 'package:kids_world_app/soundsAnimal/pages/animal_sound_page.dart';
import 'package:kids_world_app/soundsAnimal/repositories/animal_repository.dart';
import 'package:kids_world_app/soundsAnimal/providers/category_provider.dart';
import 'package:kids_world_app/soundsAnimal/transitions/page_transitions.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(),
      body: Column(
        children: [
          const BannerAdWidget(),
          _buildCategoryList(),
          Expanded(child: _buildAnimalGrid()),
        ],
      ),
    );
  }

  Widget _buildCategoryList() {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, child) {
        return Container(
          height: 100,
          margin: const EdgeInsets.only(top: 8),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: categoryProvider.categories.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return GestureDetector(
                  onTap: () => categoryProvider.selectCategory(null),
                  child: _buildCategoryCard(
                    icon: Icons.apps,
                    title: 'all'.tr(),
                    isSelected: categoryProvider.selectedCategoryId == null,
                  ),
                );
              }

              Category category = categoryProvider.categories[index - 1];
              bool isSelected =
                  category.id == categoryProvider.selectedCategoryId;

              return GestureDetector(
                onTap: () => categoryProvider.selectCategory(category.id),
                child: _buildCategoryCard(
                  icon: category.icon,
                  title: category.name.tr(),
                  isSelected: isSelected,
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildCategoryCard({
    required IconData icon,
    required String title,
    required bool isSelected,
  }) {
    return Container(
      width: 80,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue, width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 28, color: isSelected ? Colors.white : Colors.blue),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAnimalGrid() {
    return Consumer2<CategoryProvider, FavoritesProvider>(
      builder: (context, categoryProvider, favoritesProvider, child) {
        List<Animal> filteredAnimals =
            categoryProvider.selectedCategoryId == null
            ? AnimalRepository.animals
            : AnimalRepository.animals
                  .where(
                    (animal) => categoryProvider
                        .getAnimalIdsByCategory(
                          categoryProvider.selectedCategoryId!,
                        )
                        .contains(animal.index),
                  )
                  .toList();

        return GridView.builder(
          padding: const EdgeInsets.all(8),

          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, // ✅ 3 كروت
            childAspectRatio: 1, // ✅ مناسب للصورة
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),

          itemCount: filteredAnimals.length,

          itemBuilder: (BuildContext context, int index) {
            Animal animal = filteredAnimals[index];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageTransitions.createScaleTransition(
                    AnimalSoundPage(animal: animal),
                  ),
                );
              },
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.blue[100 * ((index % 8) + 1)],
                child: Column(
                  children: [
                    Expanded(
                      child: Image.asset(
                        animal.imagePath,
                        fit: BoxFit.contain, // ✅ عشان الصورة تبقى واضحة
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(
                        animal.name.tr(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  AppBar appBarWidget() {
    return AppBar(
      title: Text(
        "Animal Sounds".tr(),
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.extension),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const QuizStartPage()),
            );
          },
        ),
      ],
      backgroundColor: Colors.blue.shade100,
    );
  }
}
