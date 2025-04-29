import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:intl/intl.dart';
import 'package:pantrypal/controllers/home/home_controller.dart';
import 'package:pantrypal/controllers/root_controller.dart';
import 'package:pantrypal/core/theme/theme_colors.dart';
import 'package:pantrypal/widgets/filled_bar.dart';
import 'package:pantrypal/widgets/rounded_box.dart';

class HomeScreen extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());
  final RootController rootController = Get.find<RootController>();

  final List<Map<String, dynamic>> quickAccess = [
    {"icon": Icons.flatware, "title": "Ingredients"},
    {"icon": Icons.fastfood, "title": "Meals"},
    {"icon": Icons.shopping_cart_outlined, "title": "Plan"},
  ];

  final List<String> nutritions = [
    "Protein", "", "Carbs", "", "Fat",
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    return Scaffold(
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
        () => Container(
          color: colors.backgroundColor,
          // color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
            child: SingleChildScrollView(
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
                            Text(
                              "${controller.num.value} / 2000 kcal",
                              style: TextStyle(color: colors.textPrimaryColor),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        FilledBar(
                          currentValue: 1200,
                          maxValue: 2000,
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
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Handle onTap
                        },
                        child: RoundedBox(
                          color: colors.expiredAlertColor,
                          outlineColor: colors.expiredAlertOutlineColor,
                          outlineStroke: 1,
                          padding: EdgeInsets.all(14),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor:
                                    colors.expiredAlertOutlineColor,
                                child: Icon(
                                  Icons.flatware,
                                  color: colors.expiredAlertIconColor,
                                ),
                              ),
                              SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Expiring Soon",
                                    style: TextStyle(
                                      color: colors.textPrimaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Description for alert ",
                                    style: TextStyle(
                                      color: colors.hintTextColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                          // Handle onTap
                        },
                        child: RoundedBox(
                          color: colors.mealPrepAlertColor,
                          outlineColor: colors.mealPrepAlertOutlineColor,
                          padding: EdgeInsets.all(12),
                          outlineStroke: 1,
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Meal Prep Reminder",
                                    style: TextStyle(
                                      color: colors.textPrimaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Description for alert ",
                                    style: TextStyle(
                                      color: colors.hintTextColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
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
                            colors.mainContainerColor, // Ensure the background is transparent
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
                                            ? colors.quickAccessIngredientColor
                                            : (index == 1
                                                ? colors.quickAccessMealColor
                                                : colors.quickAccessPlanColor)),
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
                                          : colors.unselectedSecondaryTabColor,
                                  color:
                                      controller.selectedMealIndex.value ==
                                              index
                                          ? colors.selectedSecondaryTabColor
                                          : colors.unselectedSecondaryTabColor,
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
                  Column(
                    children:
                        controller.mealBoxes.expand((meal) {
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
