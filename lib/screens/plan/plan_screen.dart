import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pantrypal/controllers/root_controller.dart';
import 'package:pantrypal/core/theme/theme_colors.dart';
import 'package:pantrypal/screens/plan/add_meal_to_plan_screen.dart';
// import 'package:pantrypal/screens/meal/create_meal_screen.dart';
// import 'package:pantrypal/screens/meal/create_recipe_screen.dart';
// import 'package:pantrypal/screens/meal/meal_detail_screen.dart';
// import 'package:pantrypal/screens/meal/recipe_detail_screen.dart';
import 'package:pantrypal/widgets/rounded_box.dart';
import 'package:pantrypal/controllers/plan/plan_controller.dart';
import 'package:pantrypal/widgets/filled_bar.dart';

class PlanScreen extends StatelessWidget {
  final RootController rootController = Get.find<RootController>();
  final PlanController controller = Get.put(PlanController());

  final List<String> nutritions = ["Protein", "", "Carbs", "", "Fat"];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;

    return Scaffold(
      backgroundColor: colors.backgroundColor,
      appBar: AppBar(
        backgroundColor: colors.appbarColor,
        title: const Text("Plan"),
      ),
      body: Column(
        children: [
          Divider(
            height: 1,
            color: colors.hintTextColor.withValues(alpha: 0.3),
          ),
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(2, (index) {
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
          // const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              if (controller.selectedTab.value == 0) {
                return _buildMealPlannerTab(colors);
              } else {
                return _buildGoalsTab(colors);
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalsTab(ThemeColors colors) {
    return Obx(
      () => Container(
        color: colors.backgroundColor,
        child: Padding(
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Today's Overview
                Text(
                  "Today's Overview",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimaryColor,
                  ),
                ),
                SizedBox(height: 16),
                RoundedBox(
                  padding: EdgeInsets.all(16),
                  color: colors.mainContainerColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Calories",
                            style: TextStyle(
                              color: colors.textPrimaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "${controller.currentKcal.value} / ${controller.goalKcal.value} kcal",
                            style: TextStyle(color: colors.textPrimaryColor),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      FilledBar(
                        currentValue: controller.currentKcal.value.toDouble(),
                        maxValue: controller.goalKcal.value.toDouble(),
                        height: 8,
                        fillColor: colors.progressColor,
                        backgroundColor: colors.backgroundColor,
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(5, (index) {
                          if (index == 1 || index == 3) {
                            return SizedBox(width: 16,);
                          }
                          return Expanded(
                            child: RoundedBox(
                              color: (index == 0 ? colors.proteinDisplayColor : 
                              (index == 2 ? colors.carbsDisplayColor : colors.fatDisplayColor)),
                              outlineColor: (index == 0 ? colors.proteinDisplayColor : 
                              (index == 2 ? colors.carbsDisplayColor : colors.fatDisplayColor)),
                              outlineStroke: 0,
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              child: Column(
                                children: [
                                  Text(
                                    nutritions[index],
                                    style: TextStyle(color: colors.hintTextColor),
                                  ),
                                  Text(
                                    "${(index + 1) * 10}g",
                                    style: TextStyle(color: colors.textPrimaryColor, fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "/ ${(index + 1) * 20}g",
                                    style: TextStyle(color: colors.hintTextColor),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMealPlannerTab(ThemeColors colors) {
    return Container(
      color: colors.backgroundColor,
      child: Padding(
        padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Meal List
              Text(
                "Today's Meal List",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimaryColor,
                ),
              ),
              SizedBox(height: 16),
              Column(
                children: controller.mealBoxes.expand((meal) {
                  final statusTextColor =
                      meal["status"] == "Completed"
                          ? colors.completedTextColor
                          : meal["status"] == "Current"
                          ? colors.currentTextColor
                          : colors.upcomingTextColor;
                  final statusColor =
                      meal["status"] == "Completed"
                          ? colors.completedColor
                          : meal["status"] == "Current"
                          ? colors.currentColor
                          : colors.upcomingColor;

                  return [
                    RoundedBox(
                      padding: EdgeInsets.all(12),
                      color: colors.mainContainerColor,
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                meal["title"] as String,
                                style: TextStyle(
                                  color: colors.textPrimaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "${meal["time"]} • ${meal["kcal"]} kcal",
                                style: TextStyle(
                                  color: colors.hintTextColor,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Random",
                                style: TextStyle(
                                  color: colors.textPrimaryColor,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor,
                            ),
                            child: Text(
                              meal["status"] as String,
                              style: TextStyle(
                                color: statusTextColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12), // 👈 spacing after each box
                  ];
                }).toList(),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Save recipe logic here
                  // controller.saveRecipe();
                  // rootController.handleBack();
                  Get.to(AddMealToPlanScreen(), id: rootController.currentNavId.value);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      colors.buttonColor, // Use buttonColor from ThemeColors
                  foregroundColor:
                      colors
                          .buttonContentColor, // Use buttonContentColor for text
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text(
                  "Add Meal",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colors.buttonContentColor,
                  ),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
