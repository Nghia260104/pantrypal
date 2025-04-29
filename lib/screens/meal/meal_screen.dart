import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pantrypal/controllers/root_controller.dart';
import 'package:pantrypal/core/theme/theme_colors.dart';
import 'package:pantrypal/screens/meal/meal_detail_screen.dart';
import 'package:pantrypal/widgets/rounded_box.dart';

class MealController extends GetxController {
  var selectedTab = 0.obs;
  var favoriteStatus = <int, bool>{}.obs;

  void toggleTab(int index) {
    selectedTab.value = index;
  }

  void toggleFavorite(int index) {
    favoriteStatus[index] = !(favoriteStatus[index] ?? false);
  }
}

class MealScreen extends StatelessWidget {
  final MealController controller = Get.put(MealController());
  final RootController rootController = Get.find<RootController>();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Meal Suggestions"),
      ),
      body: Obx(() =>
        Stack(
          children: [
            Column(
              children: [
                Divider(height: 1, color: colors.hintTextColor.withValues(alpha: 0.3)),
                Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(3, (index) {
                      final titles = ["Suggestions", "My Recipes", "Favorites"];
                      final isSelected = controller.selectedTab.value == index;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            controller.toggleTab(index);
                          },
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              RoundedBox(
                                padding: const EdgeInsets.all(12),
                                borderRadius: 0,
                                width: double.infinity,
                                outlineStroke: 0,
                                outlineColor: isSelected ? colors.appbarColor : Colors.transparent,
                                color: isSelected ? colors.appbarColor : Colors.transparent,
                                child: Center(
                                  child: Text(
                                    titles[index],
                                    style: TextStyle(
                                      color: isSelected ? colors.selectedNavColor : colors.hintTextColor,
                                    ),
                                  ),
                                ),
                              ),
                              if (isSelected)
                                Container(
                                  height: 2,
                                  decoration: BoxDecoration(
                                    color: colors.selectedNavColor,
                                  ),
                                  // width: double.infinity,
                                ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: 10, // Example item count
                    itemBuilder: (context, index) {
                      if (index == 9) {
                        // Add a SizedBox at the end
                        return const SizedBox(height: 70); // Adjust the height as needed
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: GestureDetector(
                          onTap: () {
                            // handle onTap function
                            print('Tapped on item $index');
                            Get.to(MealDetailScreen(), id: rootController.currentNavId.value);
                          },
                          child: RoundedBox(
                            padding: EdgeInsets.all(0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        height: 150,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: colors.hintTextColor,
                                        ),
                                      ),
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: RoundedBox(
                                          color: Colors.black.withOpacity(0.5),
                                          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                                          borderRadius: 32,
                                          child: Text(
                                            'Label',
                                            style: const TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // const SizedBox(height: 8),
                                  RoundedBox(
                                    color: colors.appbarColor,
                                    padding: EdgeInsets.all(0),
                                    borderRadius: 0,
                                    outlineStroke: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Title',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 20,
                                                  color: colors.textPrimaryColor,
                                                ),
                                              ),
                                              Obx(() => GestureDetector(
                                                  onTap: () => controller.toggleFavorite(index),
                                                  child: Icon(
                                                    controller.favoriteStatus[index] == true
                                                        ? Icons.star
                                                        : Icons.star_border,
                                                    color: controller.favoriteStatus[index] == true
                                                        ? colors.favoriteColor
                                                        : colors.hintTextColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'Description',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: colors.hintTextColor,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: List.generate(3, (boxIndex) {
                                              return Padding(
                                                padding: const EdgeInsets.only(right: 8.0),
                                                child: RoundedBox(
                                                  borderRadius: 32,
                                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                                                  child: Text(
                                                    'Box ${boxIndex + 1}',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: colors.textPrimaryColor,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      );
                    },
                  ),
                ),
              ],
            ),
            if (controller.selectedTab.value == 1)
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  child: FloatingActionButton(
                    onPressed: () {
                      // Handle add button press
                    },
                    backgroundColor: colors.buttonColor,
                    child: Icon(Icons.add, color: colors.buttonContentColor),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}