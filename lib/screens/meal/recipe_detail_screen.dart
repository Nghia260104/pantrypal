import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pantrypal/controllers/root_controller.dart';
import 'package:pantrypal/controllers/meal/meal_controller.dart';
import 'package:pantrypal/core/theme/theme_colors.dart';
import 'package:pantrypal/widgets/rounded_box.dart';

class RecipeDetailController extends GetxController {
  var isFavorite = false.obs;
  var servings = 1.obs;
  var selectedTab = 0.obs; // 0 for Ingredients, 1 for Instructions

  void toggleFavorite() {
    isFavorite.value = !isFavorite.value;
  }

  void incrementServings() {
    servings.value++;
  }

  void decrementServings() {
    if (servings.value > 1) {
      servings.value--;
    }
  }

  void switchTab(int index) {
    selectedTab.value = index;
  }
}

class RecipeDetailScreen extends StatelessWidget {
  final int recipeId;

  RecipeDetailScreen({required this.recipeId});

  final RecipeDetailController controller = Get.put(RecipeDetailController());
  final MealController mealController = Get.find<MealController>();
  final RootController rootController = Get.find<RootController>();

  late final recipe;

  final List<String> nutritions = ["Protein", "", "Carbs", "", "Fat"];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    recipe = mealController.recipes.firstWhere(
      (recipe) => recipe.id == recipeId,
    );

    return Scaffold(
      backgroundColor: colors.backgroundColor,
      body: Column(
        children: [
          // Image Section
          Stack(
            children: [
              Container(
                height: 250,
                color: Colors.grey,
                width: double.infinity,
              ),
              Positioned(
                top: 40,
                left: 16,
                child: GestureDetector(
                  onTap: () => rootController.handleBack(),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color:
                          colors
                              .secondaryButtonColor, // Semi-transparent background
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      color: colors.secondaryButtonContentColor,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 40,
                right: 16,
                child: Obx(() {
                  final isFavorite =
                      mealController.recipeFavoriteStatus[recipeId] ?? false;
                  return GestureDetector(
                    onTap: () => mealController.toggleRecipeFavorite(recipeId),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: colors.secondaryButtonColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFavorite ? Icons.star : Icons.star_border,
                        color:
                            isFavorite
                                ? colors.favoriteColor
                                : colors.secondaryButtonContentColor,
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),

          // Scrollable Content Section
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Meal Title
                  Text(
                    recipe.name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: colors.textPrimaryColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    recipe.briefDescription,
                    style: TextStyle(fontSize: 16, color: colors.hintTextColor),
                  ),
                  SizedBox(height: 16),

                  // Time and Difficulty
                  Row(
                    children: [
                      Icon(Icons.access_time, color: colors.hintTextColor),
                      SizedBox(width: 4),
                      Text(
                        "${recipe.duration} min",
                        style: TextStyle(color: colors.hintTextColor),
                      ),
                      SizedBox(width: 16),
                      Icon(Icons.flatware, color: colors.hintTextColor),
                      SizedBox(width: 4),
                      Text(
                        recipe.difficulty,
                        style: TextStyle(color: colors.hintTextColor),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Servings
                  RoundedBox(
                    padding: const EdgeInsets.all(16),
                    color: colors.secondaryButtonColor,
                    outlineColor: colors.secondaryButtonContentColor,
                    outlineStroke: 0.5,
                    borderRadius: 8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Servings",
                          style: TextStyle(
                            color: colors.textPrimaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Row(
                          children: [
                            // Decrement Button with Outline
                            Container(
                              width: 32, // Reduced width
                              height: 32, // Reduced height
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: colors.secondaryButtonContentColor
                                      .withAlpha(50),
                                  width: 1,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.remove,
                                  color: colors.secondaryButtonContentColor,
                                  size: 20,
                                ),
                                onPressed: controller.decrementServings,
                                constraints: BoxConstraints(
                                  minWidth: 32, // Match the container size
                                  minHeight: 32, // Match the container size
                                ),
                                padding:
                                    EdgeInsets.zero, // Remove extra padding
                              ),
                            ),
                            SizedBox(width: 8),
                            Obx(
                              () => Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Text(
                                  "${controller.servings.value}",
                                  style: TextStyle(
                                    color: colors.textPrimaryColor,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            // Increment Button with Outline
                            Container(
                              width: 32, // Reduced width
                              height: 32, // Reduced height
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: colors.secondaryButtonContentColor
                                      .withAlpha(50),
                                  width: 1,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.add,
                                  color: colors.secondaryButtonContentColor,
                                  size: 20,
                                ),
                                onPressed: controller.incrementServings,
                                constraints: BoxConstraints(
                                  minWidth: 32, // Match the container size
                                  minHeight: 32, // Match the container size
                                ),
                                padding:
                                    EdgeInsets.zero, // Remove extra padding
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),

                  // Nutritional Information
                  RoundedBox(
                    padding: const EdgeInsets.all(16),
                    color: colors.secondaryButtonColor,
                    outlineColor: colors.secondaryButtonContentColor,
                    outlineStroke: 0.5,
                    borderRadius: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Nutritional Information (per serving)",
                          style: TextStyle(
                            color: colors.textPrimaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Calories",
                              style: TextStyle(
                                color: colors.textPrimaryColor,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "${recipe.calories.round()} kcal",
                              style: TextStyle(
                                color: colors.textPrimaryColor,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(5, (index) {
                            if (index == 1 || index == 3) {
                              return SizedBox(width: 16);
                            }
                            return Expanded(
                              child: RoundedBox(
                                color:
                                    (index == 0
                                        ? colors.proteinDisplayColor
                                        : (index == 2
                                            ? colors.carbsDisplayColor
                                            : colors.fatDisplayColor)),
                                outlineColor:
                                    (index == 0
                                        ? colors.proteinDisplayColor
                                        : (index == 2
                                            ? colors.carbsDisplayColor
                                            : colors.fatDisplayColor)),
                                outlineStroke: 0,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      nutritions[index],
                                      style: TextStyle(
                                        color: colors.hintTextColor,
                                      ),
                                    ),
                                    Text(
                                      "${(index == 0 ? recipe.protein : (index == 2 ? recipe.carbs : recipe.fat)).round()} g",
                                      style: TextStyle(
                                        color: colors.textPrimaryColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),

                  // Tabs
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(2, (index) {
                        final titles = ["Ingredients", "Instructions"];
                        final isSelected =
                            controller.selectedTab.value == index;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              controller.switchTab(index);
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
                                          : colors.unselectedSecondaryTabColor,
                                  child: Center(
                                    child: Text(
                                      titles[index],
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
                  SizedBox(height: 16),

                  // Tab Content
                  Obx(() {
                    if (controller.selectedTab.value == 0) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: List.generate(
                              recipe.ingredientRequirements.length,
                              (index) => Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        recipe
                                            .ingredientRequirements[index]
                                            .template
                                            .name,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: colors.textPrimaryColor,
                                        ),
                                      ),
                                      Text(
                                        "${recipe.ingredientRequirements[index].quantity} ${recipe.ingredientRequirements[index].template.defaultUnit}",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: colors.hintTextColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(),
                                  SizedBox(height: 8),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50),
                              backgroundColor: colors.buttonColor,
                            ),
                            child: Text(
                              "Add Ingredients to Shopping List",
                              style: TextStyle(
                                color: colors.buttonContentColor,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(recipe.instructions, textAlign: TextAlign.left),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50),
                              backgroundColor: colors.buttonColor,
                            ),
                            child: Text(
                              "Add to Meal Plan",
                              style: TextStyle(
                                color: colors.buttonContentColor,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  }),
                  SizedBox(height: 64),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
