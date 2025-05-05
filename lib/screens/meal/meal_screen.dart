import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pantrypal/controllers/root_controller.dart';
import 'package:pantrypal/core/theme/theme_colors.dart';
import 'package:pantrypal/screens/meal/create_meal_screen.dart';
import 'package:pantrypal/screens/meal/create_recipe_screen.dart';
import 'package:pantrypal/screens/meal/meal_detail_screen.dart';
import 'package:pantrypal/screens/meal/recipe_detail_screen.dart';
import 'package:pantrypal/widgets/rounded_box.dart';
import 'package:pantrypal/controllers/meal/meal_controller.dart';
import 'package:pantrypal/widgets/custom_dropdown_button.dart'; // Ensure this is the correct path

class MealScreen extends StatelessWidget {
  final MealController controller = Get.put(MealController());
  final RootController rootController = Get.find<RootController>();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.appbarColor,
        title: const Text(
          "Meal Suggestions",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
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
                    if (controller.selectedTab.value == 1) {
                      return _buildMyRecipesTab(colors);
                    } else if (controller.selectedTab.value == 0) {
                      return _buildMyMealsTab(colors);
                    } else {
                      // return _buildMyRecipesTab(colors);
                      return _buildFavoritesTab(colors);
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
                      } else {
                        Get.to(
                          CreateMealScreen(),
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

  Widget _buildMyRecipesTab(ThemeColors colors, {bool isFavorites = false}) {
    // Filter the recipes list if in the Favorites tab
    final list =
        isFavorites
            ? controller.recipes
                .where(
                  (recipe) =>
                      controller.recipeFavoriteStatus[recipe.id] == true,
                )
                .toList()
            : controller.recipes;
    if (list.isEmpty) {
      return Center(
        child: Text(
          isFavorites
              ? "No favorite recipes available"
              : "No recipes available",
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: GestureDetector(
            onTap: () {
              // e.g. navigate to recipe detail
              print('Tapped on recipe ${recipe.id}');
              Get.to(
                RecipeDetailScreen(recipeId: recipe.id),
                id: rootController.currentNavId.value,
              );
            },
            child: RoundedBox(
              padding: EdgeInsets.zero,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                          top: 8, // Adjust the vertical position
                          right: 8, // Adjust the horizontal position
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ), // Padding inside the label
                            decoration: BoxDecoration(
                              color:
                                  colors
                                      .buttonColor, // Background color for the label
                              borderRadius: BorderRadius.circular(
                                16,
                              ), // Fully rounded corners
                            ),
                            child: Text(
                              "${recipe.calories.round()} kcal", // The label text
                              style: TextStyle(
                                color: colors.buttonContentColor, // Text color
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title + favorite
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  recipe.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20,
                                    color: colors.textPrimaryColor,
                                  ),
                                ),
                                Obx(
                                  () => GestureDetector(
                                    onTap:
                                        () => controller.toggleRecipeFavorite(
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
                                              ? colors.favoriteColor
                                              : colors.hintTextColor,
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
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  child: Text(
                                    recipe.difficulty,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: colors.textPrimaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Duration
                                RoundedBox(
                                  borderRadius: 32,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  child: Text(
                                    '${recipe.duration} min',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: colors.textPrimaryColor,
                                      fontWeight: FontWeight.w600,
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
  }

  Widget _buildMyMealsTab(ThemeColors colors, {bool isFavorites = false}) {
    // final list = [];
    // if (list.isEmpty) {
    //   return Center(
    //     child: Text("No meals available", style: TextStyle(color: colors.hintTextColor)),
    //   );
    // }
    // Filter the meals list if in the Favorites tab
    final meals =
        isFavorites
            ? controller.meals
                .where((meal) => controller.mealFavoriteStatus[meal.id] == true)
                .toList()
            : controller.meals;

    if (meals.isEmpty) {
      return Center(
        child: Text(
          isFavorites ? "No favorite meals available" : "No meals available",
          style: TextStyle(color: colors.hintTextColor),
        ),
      );
    }

    // final lengthTest = 3;
    return ListView.builder(
      itemCount: meals.length + 1,
      itemBuilder: (context, index) {
        if (index == meals.length) {
          return const SizedBox(height: 80);
        }
        // final recipe = list[index];
        final meal = meals[index];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: GestureDetector(
            onTap: () {
              // e.g. navigate to meal detail
              print('Tapped on meal $index');
              Get.to(
                MealDetailScreen(mealId: meal.id),
                id: rootController.currentNavId.value,
              );
            },
            child: RoundedBox(
              padding: EdgeInsets.zero,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                            // image:
                            //     meal.image != null
                            //         ? DecorationImage(
                            //           image: FileImage(File(meal.image!)),
                            //           fit: BoxFit.cover,
                            //         )
                            //         : null,
                          ),
                        ),
                        // Label in a rounded rectangle
                        Positioned(
                          top: 8, // Adjust the vertical position
                          right: 8, // Adjust the horizontal position
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ), // Padding inside the label
                            decoration: BoxDecoration(
                              color:
                                  colors
                                      .buttonColor, // Background color for the label
                              borderRadius: BorderRadius.circular(
                                16,
                              ), // Fully rounded corners
                            ),
                            child: Text(
                              "${meal.calories.round()} kcal", // The label text
                              style: TextStyle(
                                color: colors.buttonContentColor, // Text color
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title + favorite
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  meal.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20,
                                    color: colors.textPrimaryColor,
                                  ),
                                ),
                                Obx(
                                  () => GestureDetector(
                                    onTap:
                                        () => controller.toggleMealFavorite(
                                          meal.id,
                                        ),
                                    child: Icon(
                                      controller.mealFavoriteStatus[meal.id] ==
                                              true
                                          ? Icons.star
                                          : Icons.star_border,
                                      color:
                                          controller.mealFavoriteStatus[meal
                                                      .id] ==
                                                  true
                                              ? colors.favoriteColor
                                              : colors.hintTextColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 2),

                            // Brief description
                            Text(
                              meal.description,
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
                              meal.portions
                                  .map((portion) => portion.recipe.name)
                                  .join(
                                    ", ",
                                  ), // Join the recipes into a single string
                              style: TextStyle(
                                fontSize: 14,
                                color: colors.textPrimaryColor,
                              ),
                              maxLines: 1, // Limit to one line
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

  Widget _buildFavoritesTab(ThemeColors colors) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Display the number of items
            Obx(
              () => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '${controller.getFilteredFavorites().length} item(s)',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: colors.textPrimaryColor,
                  ),
                ),
              ),
            ),
            // Dropdown button for filter selection
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomDropdownButton(
                selectedValue:
                    controller.selectedFilter, // Pass the reactive variable
                items: ["Meals", "Recipes"], // Dropdown items
                onChanged: (value) {
                  controller.selectedFilter.value =
                      value; // Update the selected filter
                },
                width: 150, // Set the width of the dropdown button
                height: 45, // Set the height of the dropdown button
                textStyle: TextStyle(
                  fontSize: 16,
                  color: colors.hintTextColor,
                ), // Customize text style
                selectedText: TextStyle(
                  fontSize: 16,
                  color: colors.buttonContentColor,
                ),
                selectedColor: colors.buttonColor,
                buttonColor:
                    colors
                        .secondaryButtonColor, // Set the button background color
                outlineColor:
                    colors.secondaryButtonContentColor, // Set the outline color
                iconColor:
                    colors
                        .secondaryButtonContentColor, // Set the dropdown arrow color
                outlineStroke: 0.5,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Expanded(
          child: Obx(() {
            if (controller.selectedFilter.value == "Meals") {
              return _buildMyMealsTab(colors, isFavorites: true);
            } else {
              return _buildMyRecipesTab(colors, isFavorites: true);
            }
          }),
        ),
      ],
    );
  }
}
