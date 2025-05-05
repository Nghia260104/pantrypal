import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pantrypal/controllers/root_controller.dart';
import 'package:pantrypal/core/theme/theme_colors.dart';
import 'package:pantrypal/widgets/rounded_box.dart';

class MealPlanDetailController extends GetxController {
}

class MealPlanDetailScreen extends StatelessWidget {
  // final int mealId;

  // MealDetailScreen({required this.mealId});

  final MealPlanDetailController controller = Get.put(MealPlanDetailController());
  // final MealController mealController = Get.find<MealController>();
  final RootController rootController = Get.find<RootController>();

  late final meal;

  final List<String> nutritions = ["Protein", "", "Carbs", "", "Fat"];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    // final meal = mealController.meals.firstWhere((meal) => meal.id == mealId);
    // controller.setMeal(meal);
    return Scaffold(
      backgroundColor: colors.backgroundColor,
      appBar: AppBar(
        backgroundColor: colors.appbarColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => rootController.handleBack(),
        ),
        title: Text(
          "Meal Type",
          style: TextStyle(
            color: colors.textPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Scrollable Content Section
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: colors.secondaryButtonColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: colors.secondaryButtonContentColor.withAlpha(
                          50,
                        ),
                      ),
                    ),
                    width: double.infinity,
                    child: Text(
                      // DateFormat(
                      //   'EEEE, MMMM d, yyyy',
                      // ).format(controller.selectedDate.value.toLocal()),
                      "Date",
                      style: TextStyle(
                        fontSize: 16,
                        color: colors.textPrimaryColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: colors.secondaryButtonColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: colors.secondaryButtonContentColor.withAlpha(
                          50,
                        ),
                      ),
                    ),
                    width: double.infinity,
                    child: Text(
                        "Time",
                        style: TextStyle(
                          fontSize: 16,
                          color: colors.secondaryButtonContentColor,
                        ),
                      ),
                  ),
                  SizedBox(height: 32),

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
                              "${meal.calories.round().toString()} kcal",
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
                                      "${(index == 0 ? meal.protein : (index == 2 ? meal.carbs : meal.fat)).toStringAsFixed(1)} g",
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
                    children:
                        meal.portions.map((portion) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: 12,
                            ), // Padding between items
                            child: RoundedBox(
                              padding: const EdgeInsets.all(16),
                              color: colors.secondaryButtonColor,
                              outlineColor: colors.secondaryButtonContentColor
                                  .withAlpha(127),
                              outlineStroke: 0.5,
                              borderRadius: 8,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Recipe Name
                                  Text(
                                    portion.recipe.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: colors.textPrimaryColor,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ), // Spacing between name and description
                                  // Recipe Description
                                  Text(
                                    portion.recipe.briefDescription,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: colors.hintTextColor,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ), // Spacing between description and row
                                  // Duration and Serving Row
                                  Row(
                                    children: [
                                      // Duration Box
                                      RoundedBox(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 4,
                                        ),
                                        color: colors.secondaryButtonColor,
                                        outlineColor: colors
                                            .secondaryButtonContentColor
                                            .withAlpha(127),
                                        outlineStroke: 0.5,
                                        borderRadius: 50,
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.access_time,
                                              size: 16,
                                              color:
                                                  colors
                                                      .secondaryButtonContentColor,
                                            ),
                                            SizedBox(
                                              width: 6,
                                            ), // Spacing between icon and text
                                            Text(
                                              "${portion.recipe.duration.toString()} min",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color:
                                                    colors
                                                        .secondaryButtonContentColor,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ), // Spacing between duration and serving
                                      // Serving Box
                                      RoundedBox(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 4,
                                        ),
                                        color: colors.secondaryButtonColor,
                                        outlineColor: colors
                                            .secondaryButtonContentColor
                                            .withAlpha(127),
                                        outlineStroke: 0.5,
                                        borderRadius: 50,
                                        child: Row(
                                          children: [
                                            Text(
                                              "${portion.quantity.round().toString()} serving(s)",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color:
                                                    colors
                                                        .secondaryButtonContentColor,
                                                fontWeight: FontWeight.w500,
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
                        }).toList(),
                  ),
                  SizedBox(height: 16), // Spacing between list and button
                  ElevatedButton(
                    onPressed: () => _showDeleteConfirmationModal(context),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor: colors.dangerButtonColor,
                    ),
                    child: Text(
                      "Delete Meal Plan",
                      style: TextStyle(
                        color: colors.dangerButtonContentColor,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(height: 64),
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
            'Delete Meal Plan',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colors.textPrimaryColor,
            ),
          ),
          content: Text(
            'Are you sure you want to delete this meal?',
            style: TextStyle(fontSize: 16, color: colors.hintTextColor),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the modal
              },
              child: Text(
                'Cancel',
                style: TextStyle(fontSize: 16, color: colors.textPrimaryColor),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // mealController.deleteMeal(mealId);
                Navigator.of(context).pop(); // Close the modal
                // rootController
                //     .handleBack(); // Navigate back to the previous screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    colors.dangerButtonColor, // Highlight the delete button
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
