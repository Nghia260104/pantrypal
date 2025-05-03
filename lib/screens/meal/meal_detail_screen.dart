import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pantrypal/controllers/root_controller.dart';
import 'package:pantrypal/controllers/meal/meal_controller.dart';
import 'package:pantrypal/core/theme/theme_colors.dart';
import 'package:pantrypal/widgets/rounded_box.dart';

class MealDetailController extends GetxController {
  var isFavorite = false.obs;

  void toggleFavorite() {
    isFavorite.value = !isFavorite.value;
  }
}

class MealDetailScreen extends StatelessWidget {

  final MealDetailController controller = Get.put(MealDetailController());
  final MealController mealController = Get.find<MealController>();
  final RootController rootController = Get.find<RootController>();

  final List<String> nutritions = ["Protein", "", "Carbs", "", "Fat"];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;

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
                  // final isFavorite =
                  //     mealController.recipeFavoriteStatus[recipeId] ?? false;
                  return GestureDetector(
                    onTap: () => {
                      // Toggle favorite status
                      controller.toggleFavorite(),
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: colors.secondaryButtonColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        controller.isFavorite.value ? Icons.star : Icons.star_border,
                        color:
                            controller.isFavorite.value
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
                    "Meal name",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: colors.textPrimaryColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Description of the meal goes here. It can be a bit longer to provide more details about the recipe.",
                    style: TextStyle(fontSize: 16, color: colors.hintTextColor),
                  ),
                  SizedBox(height: 16),
                  SizedBox(height: 16),

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
                          "Nutritional Information",
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
                              "? kcal",
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
                                      "${(index == 0 ? 1: (index == 2 ? 1 : 1)).round()} g",
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
                  Text(
                    "Recipes",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colors.textPrimaryColor,
                    ),
                  ),
                  SizedBox(height: 16), // Spacing between title and list

                  // Recipe List
                  Column(
                    children: List.generate(3, (index) {
                      // final recipe = mealController.recipes[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12), // Padding between items
                        child: RoundedBox(
                          padding: const EdgeInsets.all(16),
                          color: colors.secondaryButtonColor,
                          outlineColor: colors.secondaryButtonContentColor.withAlpha(127),
                          outlineStroke: 0.5,
                          borderRadius: 8,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Recipe Name
                              Text(
                                "Recipe Name",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: colors.textPrimaryColor,
                                ),
                              ),
                              SizedBox(height: 8), // Spacing between name and description

                              // Recipe Description
                              Text(
                                "Recipe description goes here. It can be a bit longer to provide more details about the recipe.",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: colors.hintTextColor,
                                ),
                              ),
                              SizedBox(height: 16), // Spacing between description and row

                              // Duration and Serving Row
                              Row(
                                children: [
                                  // Duration Box
                                  RoundedBox(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 6,
                                    ),
                                    color: colors.secondaryButtonColor,
                                    outlineColor: colors.secondaryButtonContentColor.withAlpha(127),
                                    outlineStroke: 0.5,
                                    borderRadius: 50,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.access_time,
                                          size: 16,
                                          color: colors.secondaryButtonContentColor,
                                        ),
                                        SizedBox(width: 4), // Spacing between icon and text
                                        Text(
                                          "? min",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: colors.secondaryButtonContentColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 8), // Spacing between duration and serving

                                  // Serving Box
                                  RoundedBox(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 6,
                                    ),
                                    color: colors.secondaryButtonColor,
                                    outlineColor: colors.secondaryButtonContentColor.withAlpha(127),
                                    outlineStroke: 0.5,
                                    borderRadius: 50,
                                    child: Row(
                                      children: [
                                        Text(
                                          "? serving",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: colors.secondaryButtonContentColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 16), // Spacing between list and button
                  ElevatedButton(
                    onPressed: () => _showDeleteConfirmationModal(context),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor: colors.dangerButtonColor,
                    ),
                    child: Text(
                      "Delete Meal",
                      style: TextStyle(
                        color: colors.dangerButtonContentColor,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(height: 64,),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void _showDeleteConfirmationModal(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;

    showDialog(
      context: context,
      barrierDismissible: true, // Allow dismissing the modal by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            'Delete Items',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colors.textPrimaryColor,
            ),
          ),
          content: Text(
            'Are you sure you want to delete this meal?',
            style: TextStyle(
              fontSize: 16,
              color: colors.hintTextColor,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the modal
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 16,
                  color: colors.textPrimaryColor,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle delete action
                // controller.deleteCheckedItems(); // Call the delete method in the controller
                Navigator.of(context).pop(); // Close the modal
                rootController.handleBack(); // Navigate back to the previous screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.dangerButtonColor, // Highlight the delete button
                foregroundColor: colors.dangerButtonContentColor, // Text color
              ),
              child: Text(
                'Delete',
                style: TextStyle(
                  color: colors.dangerButtonContentColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
