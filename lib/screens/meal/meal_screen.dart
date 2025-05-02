import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pantrypal/controllers/root_controller.dart';
import 'package:pantrypal/core/theme/theme_colors.dart';
import 'package:pantrypal/screens/meal/create_recipe_screen.dart';
import 'package:pantrypal/screens/meal/meal_detail_screen.dart';
import 'package:pantrypal/widgets/rounded_box.dart';
import 'package:pantrypal/controllers/meal/meal_controller.dart';

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
      body: Obx(
        () => Stack(
          children: [
            Column(
              children: [
                Divider(
                  height: 1,
                  color: colors.hintTextColor.withValues(alpha: 0.3),
                ),
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(3, (index) {
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
                                outlineColor:
                                    isSelected
                                        ? colors.appbarColor
                                        : Colors.transparent,
                                color:
                                    isSelected
                                        ? colors.appbarColor
                                        : Colors.transparent,
                                child: Center(
                                  child: Text(
                                    controller.titles[index],
                                    style: TextStyle(
                                      color:
                                          isSelected
                                              ? colors.selectedNavColor
                                              : colors.hintTextColor,
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
                  child: Obx(() {
                    if (controller.selectedTab.value != 0) {
                      final list = controller.recipes;
                      if (list.isEmpty) {
                        return Center(
                          child: Text(
                            "No recipes available",
                            style: TextStyle(color: colors.hintTextColor),
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: list.length + 1,
                        itemBuilder: (context, index) {
                          if (index == list.length) {
                            return const SizedBox(height: 80);
                          }
                          final recipe = list[index];

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                // e.g. navigate to recipe detail
                                print('Tapped on recipe ${recipe.id}');
                                Get.to(
                                  MealDetailScreen(recipeId: recipe.id),
                                  id: rootController.currentNavId.value,
                                );
                              },
                              child: RoundedBox(
                                padding: EdgeInsets.zero,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // IMAGE PLACEHOLDER
                                      Stack(
                                        children: [
                                          // Image Placeholder
                                          Container(
                                            height: 150,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: colors.hintTextColor,
                                            ),
                                          ),
                                          // Label in a rounded rectangle
                                          Positioned(
                                            top:
                                                8, // Adjust the vertical position
                                            right:
                                                8, // Adjust the horizontal position
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 4,
                                                  ), // Padding inside the label
                                              decoration: BoxDecoration(
                                                color:
                                                    colors
                                                        .buttonColor, // Background color for the label
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      16,
                                                    ), // Fully rounded corners
                                              ),
                                              child: Text(
                                                "Label", // The label text
                                                style: TextStyle(
                                                  color:
                                                      colors
                                                          .buttonContentColor, // Text color
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      // INFO PANEL
                                      RoundedBox(
                                        color: colors.appbarColor,
                                        padding: EdgeInsets.zero,
                                        outlineStroke: 0,
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Title + favorite
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    recipe.name,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 20,
                                                      color:
                                                          colors
                                                              .textPrimaryColor,
                                                    ),
                                                  ),
                                                  Obx(
                                                    () => GestureDetector(
                                                      onTap:
                                                          () => controller
                                                              .toggleRecipeFavorite(
                                                                recipe.id,
                                                              ),
                                                      child: Icon(
                                                        controller.recipeFavoriteStatus[recipe
                                                                    .id] ==
                                                                true
                                                            ? Icons.star
                                                            : Icons.star_border,
                                                        color:
                                                            controller.recipeFavoriteStatus[recipe
                                                                        .id] ==
                                                                    true
                                                                ? colors
                                                                    .favoriteColor
                                                                : colors
                                                                    .hintTextColor,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              const SizedBox(height: 2),

                                              // Brief description
                                              Text(
                                                recipe.briefDescription,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: colors.hintTextColor,
                                                ),
                                              ),

                                              const SizedBox(height: 4),

                                              // Two info boxes: difficulty & duration
                                              Row(
                                                children: [
                                                  // Difficulty
                                                  RoundedBox(
                                                    borderRadius: 32,
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 12,
                                                          vertical: 4,
                                                        ),
                                                    child: Text(
                                                      recipe.difficulty,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color:
                                                            colors
                                                                .textPrimaryColor,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  // Duration
                                                  RoundedBox(
                                                    borderRadius: 32,
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 12,
                                                          vertical: 4,
                                                        ),
                                                    child: Text(
                                                      '${recipe.duration} min',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color:
                                                            colors
                                                                .textPrimaryColor,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      // final list = [];
                      // if (list.isEmpty) {
                      //   return Center(
                      //     child: Text("No meals available", style: TextStyle(color: colors.hintTextColor)),
                      //   );
                      // }
                      final lengthTest = 3;
                      return ListView.builder(
                        itemCount: lengthTest + 1,
                        itemBuilder: (context, index) {
                          if (index == lengthTest) {
                            return const SizedBox(height: 80);
                          }
                          // final recipe = list[index];

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                // e.g. navigate to recipe detail
                                print('Tapped on meal $index');
                                // Get.to(MealDetailScreen(), id: rootController.currentNavId.value);
                              },
                              child: RoundedBox(
                                padding: EdgeInsets.zero,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // IMAGE PLACEHOLDER
                                      Stack(
                                        children: [
                                          // Image Placeholder
                                          Container(
                                            height: 150,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: colors.hintTextColor,
                                            ),
                                          ),
                                          // Label in a rounded rectangle
                                          Positioned(
                                            top:
                                                8, // Adjust the vertical position
                                            right:
                                                8, // Adjust the horizontal position
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 4,
                                                  ), // Padding inside the label
                                              decoration: BoxDecoration(
                                                color:
                                                    colors
                                                        .buttonColor, // Background color for the label
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      16,
                                                    ), // Fully rounded corners
                                              ),
                                              child: Text(
                                                "Label", // The label text
                                                style: TextStyle(
                                                  color:
                                                      colors
                                                          .buttonContentColor, // Text color
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      // INFO PANEL
                                      RoundedBox(
                                        color: colors.appbarColor,
                                        padding: EdgeInsets.zero,
                                        outlineStroke: 0,
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Title + favorite
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "We have already died",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 20,
                                                      color:
                                                          colors
                                                              .textPrimaryColor,
                                                    ),
                                                  ),
                                                  Obx(
                                                    () => GestureDetector(
                                                      onTap:
                                                          () => controller
                                                              .toggleMealFavorite(
                                                                index,
                                                              ),
                                                      child: Icon(
                                                        controller.mealFavoriteStatus[index] ==
                                                                true
                                                            ? Icons.star
                                                            : Icons.star_border,
                                                        color:
                                                            controller.mealFavoriteStatus[index] ==
                                                                    true
                                                                ? colors
                                                                    .favoriteColor
                                                                : colors
                                                                    .hintTextColor,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              const SizedBox(height: 2),

                                              // Brief description
                                              Text(
                                                "At least we died together",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: colors.hintTextColor,
                                                ),
                                              ),

                                              const SizedBox(height: 4),

                                              // "includes" text
                                              Text(
                                                "Includes:",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: colors.hintTextColor,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ), // Add spacing between "includes" and recipes list
                                              // Recipes list
                                              Text(
                                                "1001 reasons we die", // Join the recipes into a single string
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color:
                                                      colors.textPrimaryColor,
                                                ),
                                                maxLines:
                                                    1, // Limit to one line
                                                overflow:
                                                    TextOverflow
                                                        .ellipsis, // Add ellipsis if text overflows
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  }),
                ),
              ],
            ),
            if (controller.selectedTab.value == 1 ||
                controller.selectedTab.value == 0)
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 12,
                  ),
                  child: FloatingActionButton(
                    onPressed: () {
                      // Handle add button press
                      if (controller.selectedTab.value == 1) {
                        Get.to(
                          CreateRecipeScreen(),
                          id: rootController.currentNavId.value,
                        );
                      }
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
