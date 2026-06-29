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
      body: SafeArea(
        child: SingleChildScrollView( // 🟢 جعل الشاشة بالكامل تسكرول عمودياً بطول الشاشة
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              _buildCustomAppBar(),
              const BannerAdWidget(),
              _buildCategoryList(),
              const SizedBox(height: 6),
              _buildAnimalGrid(), // تم إزالة الـ Expanded لتعمل بشكل صحيح داخل الـ SingleChildScrollView
            ],
          ),
        ),
      ),
    );
  }

  // بار علوي مخصص مرن وموفر للمساحة
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

  // قائمة التصنيفات الأفقية مع ميزة إخفاء شريط التمرير (Scrollbar)
  Widget _buildCategoryList() {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, child) {
        return Container(
          height: 52, // الارتفاع النحيف المناسب للراسبيري باي والشاشات العريضة
          margin: const EdgeInsets.only(top: 6, bottom: 2),
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              scrollbars: false, // 👈 إخفاء شريط التمرير الأفقي تماماً
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(), // 👈 حركة سحب مرنة تختفي فور التوقف
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
          ),
        );
      },
    );
  }

  // بطاقة التصنيف (محتفظة بشكلها الأصلي وتتحول للأزرق الصريح عند الضغط)
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

  // شبكة عرض الحيوانات المدمجة مع الاسكرول الرئيسي للشاشة
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
          shrinkWrap: true, // 👈 تجعل الشبكة تأخذ حجم محتواها بدقة
          physics: const NeverScrollableScrollPhysics(), // 👈 تعطيل اسكرول الشبكة الداخلي ليعمل اسكرول الشاشة الرئيسي
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 24), // مسافة أمان مريحة في الأسفل عند التمرير
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 1.15,
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
                  border: Border.all(
                    color: Colors.blue.withOpacity(0.2),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
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
                        ),
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