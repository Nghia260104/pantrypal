import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:intl/intl.dart';
import 'package:pantrypal/controllers/home/home_controller.dart';
import 'package:pantrypal/controllers/ingredients/ingredients_controller.dart';
import 'package:pantrypal/controllers/plan/plan_controller.dart';
import 'package:pantrypal/controllers/root_controller.dart';
import 'package:pantrypal/core/theme/theme_colors.dart';
import 'package:pantrypal/widgets/filled_bar.dart';
import 'package:pantrypal/widgets/rounded_box.dart';
import 'package:pantrypal/models/enums/meal_status.dart';

class HomeScreen extends StatelessWidget {
  // final PlanController planController = Get.put(
  //   PlanController(),
  // );
  final PlanController planController = Get.find<PlanController>();
  // final HomeController controller = Get.put(HomeController());
  final HomeController controller = Get.find<HomeController>();
  // final IngredientsController ingredientsController = Get.put(
  //   IngredientsController(),
  // );
  final IngredientsController ingredientsController =
      Get.find<IngredientsController>();
  final RootController rootController = Get.find<RootController>();

  final List<Map<String, dynamic>> quickAccess = [
    {"icon": Icons.flatware, "title": "Ingredients"},
    {"icon": Icons.fastfood, "title": "Meals"},
    {"icon": Icons.shopping_cart_outlined, "title": "Plan"},
  ];

  final List<String> nutritions = ["Protein", "", "Carbs", "", "Fat"];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    return Scaffold(
      backgroundColor: colors.backgroundColor,
      appBar: AppBar(
        backgroundColor: colors.appbarColor,
        elevation: 0,
        title: Text(
          "PantryPal",
          style: TextStyle(
            color: colors.pantrypalTitle,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(
                  Icons.shopping_cart_outlined,
                  color: colors.normalIconColor,
                ),
                onPressed: () {
                  // Handle shopping cart click
                },
                splashRadius: 24,
              ),
              Positioned(
                right: 6, // Position the badge on the top-right
                top: 6,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color:
                        colors
                            .highlightedContainerColor, // Badge background color
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '3', // Replace with the actual notification count
                    style: TextStyle(
                      color: colors.highlightedContentColor, // Badge text color
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Stack(
            children: [
              IconButton(
                icon: Icon(
                  Icons.notifications_outlined,
                  color: colors.normalIconColor,
                ),
                onPressed: () {
                  // Handle notifications click
                },
                splashRadius: 24,
              ),
              Positioned(
                right: 6, // Position the badge on the top-right
                top: 6,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color:
                        colors
                            .highlightedContainerColor, // Badge background color
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '5', // Replace with the actual notification count
                    style: TextStyle(
                      color: colors.highlightedContentColor, // Badge text color
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.settings_outlined, color: colors.normalIconColor),
            onPressed: () {
              // Handle settings click
            },
            splashRadius: 24,
          ),
        ],
      ),
      body: Obx(
        () => Column(
          // color: colors.backgroundColor,
          // color: Colors.white,
          children: [
            Divider(height: 1, color: colors.hintTextColor.withAlpha(50)),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Today's Overview
                    RoundedBox(
                      padding: EdgeInsets.all(16),
                      color: colors.mainContainerColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Today's Overview",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: colors.textPrimaryColor,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            controller.getCurrentDate(),
                            style: TextStyle(color: colors.hintTextColor),
                          ),
                          SizedBox(height: 8),
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
                              Obx(() {
                                final isGoalReached =
                                    planController.currentKcal.value >=
                                    planController.goalKcal.value;
                                return Row(
                                  children: [
                                    Text(
                                      "${planController.currentKcal.value} / ${planController.goalKcal.value} kcal ",
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
                            currentValue:
                                planController.currentKcal.value.toDouble(),
                            maxValue: planController.goalKcal.value.toDouble(),
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
                                      ? planController.currentProtein.value
                                      : (index == 2
                                          ? planController.currentCarbs.value
                                          : planController.currentFat.value);

                              // Calculate the nutrient goals dynamically
                              final double sliderValue =
                                  planController.goalKcal.value.toDouble();
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

                              final isGoalReached =
                                  currentValue >= nutrientGoal;
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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

                    // Alerts
                    Text(
                      "Alerts",
                      style: TextStyle(
                        color: colors.textPrimaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Obx(() {
                      final expiringSoonDescription =
                          ingredientsController.getExpiringSoonDescription();
                      final hasUpcomingMeals =
                          planController.hasUpcomingMeals();
                      final isMealPlanEmpty = planController.isMealPlanEmpty();

                      // If both alerts are hidden, display the fallback message
                      if (expiringSoonDescription == null &&
                          !hasUpcomingMeals &&
                          !isMealPlanEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                              "You have nothing to worry about!",
                              style: TextStyle(
                                color: colors.hintTextColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }

                      return Column(
                        children: [
                          // Expiry Alert
                          if (expiringSoonDescription != null)
                            GestureDetector(
                              onTap: () {
                                rootController.changeTab(
                                  1,
                                ); // Navigate to Ingredients tab
                              },
                              child: RoundedBox(
                                color: colors.expiredAlertColor,
                                outlineColor: colors.expiredAlertOutlineColor,
                                outlineStroke: 1,
                                padding: EdgeInsets.all(12),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor:
                                          colors.expiredAlertOutlineColor,
                                      child: Icon(
                                        Icons.warning_amber_rounded,
                                        color: colors.expiredAlertIconColor,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Expiring Soon",
                                            style: TextStyle(
                                              color: colors.textPrimaryColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            expiringSoonDescription,
                                            style: TextStyle(
                                              color: colors.hintTextColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          SizedBox(height: 4),
                          // Meal Prep Alert
                          if (hasUpcomingMeals)
                            GestureDetector(
                              onTap: () {
                                rootController.changeTab(3);
                              },
                              child: RoundedBox(
                                color: colors.mealPrepAlertColor,
                                outlineColor: colors.mealPrepAlertOutlineColor,
                                outlineStroke: 1,
                                padding: EdgeInsets.all(12),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor:
                                          colors.mealPrepAlertOutlineColor,
                                      child: Icon(
                                        Icons.fastfood,
                                        color: colors.mealPrepAlertIconColor,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Prepare your meal!",
                                            style: TextStyle(
                                              color: colors.textPrimaryColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "Before you get too lazy to eat...",
                                            style: TextStyle(
                                              color: colors.hintTextColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          // Create Meal Plan Alert
                          if (isMealPlanEmpty)
                            GestureDetector(
                              onTap: () {
                                rootController.changeTab(
                                  2,
                                ); // Navigate to Plan tab
                              },
                              child: RoundedBox(
                                color: colors.mealPrepAlertColor,
                                outlineColor: colors.mealPrepAlertOutlineColor,
                                outlineStroke: 1,
                                padding: EdgeInsets.all(14),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor:
                                          colors.mealPrepAlertOutlineColor,
                                      child: Icon(
                                        Icons.lightbulb_outline,
                                        color: colors.mealPrepAlertIconColor,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "You are what you eat...",
                                            style: TextStyle(
                                              color: colors.textPrimaryColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "Create a meal plan now!",
                                            style: TextStyle(
                                              color: colors.hintTextColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      );
                    }),
                    SizedBox(height: 16),

                    // Quick Access
                    Text(
                      "Quick Access",
                      style: TextStyle(
                        color: colors.textPrimaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(3, (index) {
                        return Material(
                          color:
                              colors
                                  .mainContainerColor, // Ensure the background is transparent
                          child: InkWell(
                            onTap: () {
                              rootController.changeTab(index + 1);
                            },
                            borderRadius: BorderRadius.circular(
                              8,
                            ), // Match the border radius of RoundedBox
                            splashColor: Colors.grey.withOpacity(
                              0.2,
                            ), // Ripple effect color
                            child: RoundedBox(
                              color: Colors.transparent,
                              width: MediaQuery.of(context).size.width / 3 - 16,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundColor:
                                        (index == 0
                                            ? colors
                                                .quickAccessIngredientOutlineColor
                                            : (index == 1
                                                ? colors
                                                    .quickAccessMealOutlineColor
                                                : colors
                                                    .quickAccessPlanOutlineColor)),
                                    child: Icon(
                                      quickAccess[index]["icon"],
                                      color:
                                          (index == 0
                                              ? colors
                                                  .quickAccessIngredientColor
                                              : (index == 1
                                                  ? colors.quickAccessMealColor
                                                  : colors
                                                      .quickAccessPlanColor)),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "${quickAccess[index]["title"]}",
                                    style: TextStyle(
                                      color: colors.textPrimaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 16),

                    // Today's Meals
                    Text(
                      "Today's Meals",
                      style: TextStyle(
                        color: colors.textPrimaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    RoundedBox(
                      color: colors.unselectedSecondaryTabColor,
                      outlineColor: colors.unselectedSecondaryTabColor,
                      padding: EdgeInsets.all(2),
                      borderRadius: 4,
                      outlineStroke: 0.5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(3, (index) {
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 2),
                              child: GestureDetector(
                                onTap: () {
                                  controller.selectedMealIndex.value = index;
                                },
                                child: Obx(
                                  () => RoundedBox(
                                    borderRadius: 4,
                                    outlineStroke: 0,
                                    outlineColor:
                                        controller.selectedMealIndex.value ==
                                                index
                                            ? colors.selectedSecondaryTabColor
                                            : colors
                                                .unselectedSecondaryTabColor,
                                    color:
                                        controller.selectedMealIndex.value ==
                                                index
                                            ? colors.selectedSecondaryTabColor
                                            : colors
                                                .unselectedSecondaryTabColor,
                                    child: Center(
                                      child: Text(
                                        (index == 0
                                            ? "All"
                                            : (index == 1
                                                ? "Upcoming"
                                                : "Completed")),
                                        style: TextStyle(
                                          color:
                                              controller
                                                          .selectedMealIndex
                                                          .value ==
                                                      index
                                                  ? colors
                                                      .selectedSecondaryTabTextColor
                                                  : colors
                                                      .unselectedSecondaryTabTextColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Meal List
                    Obx(() {
                      final filteredMealPlans = planController.filteredMealPlans(controller.selectedMealIndex.value);

                      if (filteredMealPlans.isEmpty) {
                        return Center(
                          child: Text(
                            "No meal plans available.",
                            style: TextStyle(
                              color: colors.hintTextColor,
                              fontSize: 16,
                            ),
                          ),
                        );
                      }

                      return Column(
                        children:
                            filteredMealPlans.expand((mealPlan) {
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
                                RoundedBox(
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
                                                  mealPlan.portions.map((
                                                    portion,
                                                  ) {
                                                    return Text(
                                                      portion.recipe.name,
                                                      style: TextStyle(
                                                        color:
                                                            colors
                                                                .textPrimaryColor,
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
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
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
                                SizedBox(height: 12), // Spacing after each box
                              ];
                            }).toList(),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
