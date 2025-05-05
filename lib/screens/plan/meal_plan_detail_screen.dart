import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pantrypal/controllers/root_controller.dart';
import 'package:pantrypal/core/theme/theme_colors.dart';
import 'package:pantrypal/widgets/rounded_box.dart';
import 'package:pantrypal/controllers/plan/plan_controller.dart';
import 'package:intl/intl.dart';

class MealPlanDetailController extends GetxController {}

class MealPlanDetailScreen extends StatelessWidget {
  final int mealPlanId;

  MealPlanDetailScreen({required this.mealPlanId});

  final MealPlanDetailController controller = Get.put(
    MealPlanDetailController(),
  );
  final PlanController planController = Get.find<PlanController>();
  final RootController rootController = Get.find<RootController>();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final mealPlan = planController.mealPlans.firstWhere(
      (mealPlan) => mealPlan.id == mealPlanId,
    );

    return Scaffold(
      backgroundColor: colors.backgroundColor,
      appBar: AppBar(
        backgroundColor: colors.appbarColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => rootController.handleBack(),
        ),
        title: Text(
          "Plan Detail",
          style: TextStyle(
            color: colors.textPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // RoundedBox for Details and Nutritional Information
            RoundedBox(
              padding: EdgeInsets.all(16),
              color: colors.mainContainerColor,
              borderRadius: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date, Time, and Type Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Date
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Date",
                              style: TextStyle(
                                fontSize: 14,
                                color: colors.hintTextColor,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              DateFormat(
                                'dd-MM-yyyy',
                              ).format(mealPlan.dateTime),
                              style: TextStyle(
                                fontSize: 15,
                                color: colors.textPrimaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),

                      // Time
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Time",
                              style: TextStyle(
                                fontSize: 14,
                                color: colors.hintTextColor,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              mealPlan.formattedTime,
                              style: TextStyle(
                                fontSize: 15,
                                color: colors.textPrimaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),

                      // Type
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Type",
                              style: TextStyle(
                                fontSize: 14,
                                color: colors.hintTextColor,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              mealPlan.type.name,
                              style: TextStyle(
                                fontSize: 15,
                                color: colors.textPrimaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Separation Line
                  Divider(color: colors.warningStatusColor, thickness: 1),
                  SizedBox(height: 16),

                  // Nutritional Information Section
                  Text(
                    "Nutritional Information",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colors.textPrimaryColor,
                    ),
                  ),
                  SizedBox(height: 16),

                  // Calories
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Calories",
                        style: TextStyle(
                          fontSize: 16,
                          color: colors.textPrimaryColor,
                        ),
                      ),
                      Text(
                        "${mealPlan.calories.round()} kcal",
                        style: TextStyle(
                          fontSize: 16,
                          color: colors.textPrimaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Protein, Carbs, and Fat
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Protein
                      Expanded(
                        child: RoundedBox(
                          padding: EdgeInsets.all(12),
                          color: colors.proteinDisplayColor,
                          borderRadius: 8,
                          child: Column(
                            children: [
                              Text(
                                "Protein",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: colors.hintTextColor,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "${mealPlan.protein.toStringAsFixed(1)} g",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: colors.textPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 8),

                      // Carbs
                      Expanded(
                        child: RoundedBox(
                          padding: EdgeInsets.all(12),
                          color: colors.carbsDisplayColor,
                          borderRadius: 8,
                          child: Column(
                            children: [
                              Text(
                                "Carbs",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: colors.hintTextColor,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "${mealPlan.carbs.toStringAsFixed(1)} g",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: colors.textPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 8),

                      // Fat
                      Expanded(
                        child: RoundedBox(
                          padding: EdgeInsets.all(12),
                          color: colors.fatDisplayColor,
                          borderRadius: 8,
                          child: Column(
                            children: [
                              Text(
                                "Fat",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: colors.hintTextColor,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "${mealPlan.fat.toStringAsFixed(1)} g",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: colors.textPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),

            // Recipes Section
            Text(
              "Recipes",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colors.textPrimaryColor,
              ),
            ),
            SizedBox(height: 16),

            // Recipe List
            Expanded(
              child: ListView.builder(
                itemCount: mealPlan.portions.length,
                itemBuilder: (context, index) {
                  final portion = mealPlan.portions[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
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
                          SizedBox(height: 8),

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
                          SizedBox(height: 16),

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
                                outlineColor: colors.secondaryButtonContentColor
                                    .withAlpha(127),
                                outlineStroke: 0.5,
                                borderRadius: 50,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: 16,
                                      color: colors.secondaryButtonContentColor,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      "${portion.recipe.duration} min",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color:
                                            colors.secondaryButtonContentColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 8),

                              // Serving Box
                              RoundedBox(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 4,
                                ),
                                color: colors.secondaryButtonColor,
                                outlineColor: colors.secondaryButtonContentColor
                                    .withAlpha(127),
                                outlineStroke: 0.5,
                                borderRadius: 50,
                                child: Text(
                                  "${portion.quantity.round()} serving(s)",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: colors.secondaryButtonContentColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),

            // Delete Meal Plan Button
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
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationModal(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;

    showDialog(
      context: context,
      barrierDismissible: true,
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
            'Are you sure you want to delete this plan?',
            style: TextStyle(fontSize: 16, color: colors.hintTextColor),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(fontSize: 16, color: colors.textPrimaryColor),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                planController.deleteMealPlan(mealPlanId);
                Navigator.of(context).pop();
                rootController.handleBack();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.dangerButtonColor,
                foregroundColor: colors.dangerButtonContentColor,
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
