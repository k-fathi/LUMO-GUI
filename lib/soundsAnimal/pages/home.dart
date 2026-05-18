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
      backgroundColor: Colors.blue[50],
      // إلغاء الـ AppBar التقليدي لتوفير مساحة رأسية للراسبيري باي
      body: SafeArea(
        child: Column(
          children: [
            _buildCustomAppBar(),
            const BannerAdWidget(),
            _buildCategoryList(),
            const SizedBox(height: 6),
            Expanded(child: _buildAnimalGrid()),
          ],
        ),
      ),
    );
  }

  // إنشاء بار علوي مخصص مرن وموفر للمساحة
  Widget _buildCustomAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: Colors.blue.shade100,
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.arrow_back, color: Colors.blue, size: 20),
            ),
          ),
          const SizedBox(width: 14),
          Text(
            "Animal Sounds".tr(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3436),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList() {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, child) {
        return Container(
          height: 52, // تقليل الارتفاع من 100 إلى 52 ليصبح نحيفاً ومناسباً للراسبيري
          margin: const EdgeInsets.only(top: 6, bottom: 2),
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
      padding: const EdgeInsets.symmetric(horizontal: 12),
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue, width: 1.5),
      ),
      // تحويل العناصر إلى Row أفقي بدلاً من Column لمنع سحق العناصر رأسياً
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: isSelected ? Colors.white : Colors.blue),
          const SizedBox(width: 6),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.white : Colors.black87,
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
            crossAxisCount: 4,
            childAspectRatio: 1.15, // تعديل الـ Aspect Ratio ليتناسب مع الطول المتاح على الشاشة العريضة
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
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
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.blue.withOpacity(0.2), width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      )
                    ]
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          animal.imagePath,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          )
                      ),
                      child: Text(
                        animal.name.tr(),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3436),
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
}