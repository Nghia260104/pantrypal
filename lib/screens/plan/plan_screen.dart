import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pantrypal/controllers/root_controller.dart';
import 'package:pantrypal/core/theme/theme_colors.dart';
import 'package:pantrypal/screens/plan/add_meal_to_plan_screen.dart';
// import 'package:pantrypal/screens/meal/create_meal_screen.dart';
// import 'package:pantrypal/screens/meal/create_recipe_screen.dart';
import 'package:pantrypal/screens/plan/meal_plan_detail_screen.dart';
// import 'package:pantrypal/screens/meal/recipe_detail_screen.dart';
// import 'package:pantrypal/models/meal_plan.dart';
import 'package:pantrypal/widgets/rounded_box.dart';
import 'package:pantrypal/controllers/plan/plan_controller.dart';
import 'package:pantrypal/widgets/filled_bar.dart';
import 'package:pantrypal/models/enums/meal_status.dart';

class PlanScreen extends StatelessWidget {
  final RootController rootController = Get.find<RootController>();

  // Lazy initialization of PlanController
  // cái put nằm trong HomeController, t cần cái đó để update lại meal plan mỗi khi có meal plan mới

  // final PlanController controller = Get.put(PlanController());
  final PlanController controller = Get.find<PlanController>();

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Daily Goals",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimaryColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Handle edit button tap
                        // print("Edit button tapped");
                        controller.isEditing.value =
                            !controller.isEditing.value;
                      },
                      child: Container(
                        padding: const EdgeInsets.all(
                          8,
                        ), // Padding inside the rounded box
                        decoration: BoxDecoration(
                          color:
                              controller.isEditing.value
                                  ? colors.buttonColor
                                  : colors
                                      .secondaryButtonColor, // Background color
                          borderRadius: BorderRadius.circular(
                            50,
                          ), // Fully rounded
                          border:
                              controller.isEditing.value
                                  ? null
                                  : Border.all(
                                    color: colors.secondaryButtonContentColor
                                        .withAlpha(50),
                                    width: 1.0,
                                  ),
                        ),
                        child: Icon(
                          Icons.edit, // Edit icon
                          size: 20,
                          color:
                              controller.isEditing.value
                                  ? colors.buttonContentColor
                                  : colors
                                      .secondaryButtonContentColor, // Icon color
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                RoundedBox(
                  padding: EdgeInsets.all(16),
                  color: colors.mainContainerColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Row with "Calories" Text and TextField
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "You'd like to get:",
                            style: TextStyle(
                              color: colors.textPrimaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          Row(
                            children: [
                              Obx(() {
                                return SizedBox(
                                  width:
                                      70, // Set a fixed width for the text field
                                  child: TextField(
                                    enabled:
                                        controller
                                            .isEditing
                                            .value, // Enable only if editing
                                    keyboardType: TextInputType.number,
                                    controller: controller.goalKcalController,
                                    onChanged: (value) {
                                      final intValue = int.tryParse(value) ?? 0;
                                      if (intValue < controller.minGoalKcal) {
                                        controller.goalKcalController.text =
                                            controller.minGoalKcal.toString();
                                        controller.goalKcal.value =
                                            controller.minGoalKcal;
                                      } else if (intValue >
                                          controller.maxGoalKcal) {
                                        controller.goalKcalController.text =
                                            controller.maxGoalKcal.toString();
                                        controller.goalKcal.value =
                                            controller.maxGoalKcal;
                                      } else {
                                        controller.goalKcalController.text =
                                            intValue.toString();
                                        controller.goalKcal.value = intValue;
                                      }
                                      controller.updateDailyGoal(
                                        controller.goalKcal.value,
                                      ); // Update the goal in the database
                                    },
                                    decoration: InputDecoration(
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 8,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color:
                                              colors
                                                  .secondaryButtonContentColor,
                                          width: 1.0,
                                        ),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color: colors
                                              .secondaryButtonContentColor
                                              .withAlpha(50),
                                          width: 1.0,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color: colors
                                              .secondaryButtonContentColor
                                              .withAlpha(100),
                                          width: 1.0,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color: colors.buttonColor,
                                          width: 1.0,
                                        ),
                                      ),
                                      fillColor:
                                          controller.isEditing.value
                                              ? colors.secondaryButtonColor
                                                  .withOpacity(0.1)
                                              : colors.secondaryButtonColor,
                                      filled: true,
                                    ),
                                    style: TextStyle(
                                      color: colors.textPrimaryColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                );
                              }),
                              SizedBox(width: 8),
                              Text(
                                "kcal",
                                style: TextStyle(
                                  color: colors.hintTextColor,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Slider (Visible only when editing)
                      Obx(() {
                        if (!controller.isEditing.value)
                          return SizedBox.shrink();
                        return Slider(
                          value: controller.goalKcal.value.toDouble(),
                          min: controller.minGoalKcal.toDouble(),
                          max: controller.maxGoalKcal.toDouble(),
                          onChanged: (value) {
                            controller.goalKcal.value = value.toInt();
                            controller.goalKcalController.text =
                                value.toInt().toString();
                            controller.updateDailyGoal(
                              value.toInt(),
                            ); // Update the goal in the database
                          },
                          activeColor: colors.progressColor,
                          inactiveColor: colors.backgroundColor,
                        );
                      }),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                // Today's Overview
                Text(
                  "Today's Overview",
                  style: TextStyle(
                    fontSize: 20,
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
                              fontSize: 16,
                            ),
                          ),
                          Obx(() {
                            final isGoalReached =
                                controller.currentKcal.value >=
                                controller.goalKcal.value;
                            return Row(
                              children: [
                                Text(
                                  "${controller.currentKcal.value} / ${controller.goalKcal.value} kcal ",
                                  style: TextStyle(
                                    color:
                                        isGoalReached
                                            ? Colors.green
                                            : colors.textPrimaryColor,
                                  ),
                                ),
                                if (isGoalReached)
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 16,
                                  ),
                              ],
                            );
                          }),
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
                            return SizedBox(width: 16);
                          }

                          // Get the current progress for each nutrient
                          final double currentValue =
                              index == 0
                                  ? controller.currentProtein.value
                                  : (index == 2
                                      ? controller.currentCarbs.value
                                      : controller.currentFat.value);

                          // Calculate the nutrient goals dynamically based on the slider value (X)
                          final double sliderValue =
                              controller.goalKcal.value.toDouble();
                          final double nutrientGoal =
                              index == 0
                                  ? sliderValue *
                                      0.5 /
                                      4 // Protein: 50% of calories, divided by 4
                                  : (index == 2
                                      ? sliderValue *
                                          0.3 /
                                          4 // Carbs: 30% of calories, divided by 4
                                      : sliderValue *
                                          0.2 /
                                          9); // Fat: 20% of calories, divided by 9

                          final isGoalReached = currentValue >= nutrientGoal;
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${nutritions[index]} ",
                                        style: TextStyle(
                                          color: colors.hintTextColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      if (isGoalReached)
                                        Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                          size: 16,
                                        ),
                                    ],
                                  ),
                                  Text(
                                    "${currentValue.toStringAsFixed(1)}",
                                    style: TextStyle(
                                      color: colors.textPrimaryColor,
                                      fontSize: 16,
                                      fontWeight:
                                          isGoalReached
                                              ? FontWeight.bold
                                              : FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    "/ ${nutrientGoal.toStringAsFixed(1)}g",
                                    style: TextStyle(
                                      color: colors.hintTextColor,
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMealPlannerTab(ThemeColors colors) {
    final today = DateTime.now();
    final todayMealPlans =
        controller.mealPlans.where((mealPlan) {
          return mealPlan.dateTime.year == today.year &&
              mealPlan.dateTime.month == today.month &&
              mealPlan.dateTime.day == today.day;
        }).toList();
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
              // Meal Plans List
              if (todayMealPlans.isEmpty)
                Center(
                  child: Text(
                    "No meal plans scheduled for today.",
                    style: TextStyle(color: colors.hintTextColor, fontSize: 16),
                  ),
                )
              else
                Column(
                  children:
                      todayMealPlans.expand((mealPlan) {
                        final statusTextColor =
                            mealPlan.status == MealStatus.Completed
                                ? colors.completedTextColor
                                : mealPlan.status == MealStatus.Ongoing
                                ? colors.currentTextColor
                                : colors.upcomingTextColor;
                        final statusColor =
                            mealPlan.status == MealStatus.Completed
                                ? colors.completedColor
                                : mealPlan.status == MealStatus.Ongoing
                                ? colors.currentColor
                                : colors.upcomingColor;

                        return [
                          GestureDetector(
                            onTap: () {
                              // Navigate to MealPlanDetailScreen with the mealPlanId
                              Get.to(
                                MealPlanDetailScreen(mealPlanId: mealPlan.id),
                                id: rootController.currentNavId.value,
                              );
                            },
                            child: RoundedBox(
                              padding: EdgeInsets.all(12),
                              color: colors.mainContainerColor,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Left Section: Meal Details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Meal Type
                                        Text(
                                          mealPlan.type.name,
                                          style: TextStyle(
                                            color: colors.textPrimaryColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 4),

                                        // Time and Calories
                                        Text(
                                          "${mealPlan.formattedTime} • ${mealPlan.calories.round()} kcal",
                                          style: TextStyle(
                                            color: colors.hintTextColor,
                                            fontSize: 14,
                                          ),
                                        ),
                                        SizedBox(height: 4),

                                        // List of Recipe Names
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children:
                                              mealPlan.portions.map((portion) {
                                                return Text(
                                                  portion.recipe.name,
                                                  style: TextStyle(
                                                    color:
                                                        colors.textPrimaryColor,
                                                    fontSize: 14,
                                                  ),
                                                );
                                              }).toList(),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Right Section: Status Badge
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: statusColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      mealPlan.status.name,
                                      style: TextStyle(
                                        color: statusTextColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 12), // Spacing after each box
                        ];
                      }).toList(),
                ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Save recipe logic here
                  // controller.saveRecipe();
                  // rootController.handleBack();
                  Get.to(
                    AddMealToPlanScreen(),
                    id: rootController.currentNavId.value,
                  );
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
                  "Add Meal Plan",
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
