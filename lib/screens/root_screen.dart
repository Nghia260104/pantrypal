import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pantrypal/controllers/home/home_controller.dart';
import 'package:pantrypal/screens/ingredients/ingredients_screen.dart';
import 'package:pantrypal/screens/meal/meal_screen.dart';
// import 'package:pantrypal/screens/place_holder_screen.dart';
import 'package:pantrypal/screens/plan/plan_screen.dart';
import 'package:pantrypal/widgets/custom_bottom_nav_bar.dart';
import 'package:pantrypal/controllers/root_controller.dart';
import 'package:pantrypal/screens/home/home_screen.dart';
import 'package:pantrypal/core/theme/theme_colors.dart';
import 'package:pantrypal/controllers/plan/plan_controller.dart';
import 'package:pantrypal/controllers/ingredients/ingredients_controller.dart';
import 'package:pantrypal/controllers/meal/meal_controller.dart';
// import 'dart:io';
// import 'package:flutter/services.dart';

class RootScreen extends StatelessWidget {
  // const RootScreen({super.key});
  final controller = Get.put(RootController());
  final HomeController homeController = Get.put(HomeController());
  final PlanController planController = Get.put(PlanController());
  final IngredientsController ingredientController = Get.put(IngredientsController());
  final MealController mealController = Get.put(MealController());

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async => await controller.handleBack(),
      child: Scaffold(
        backgroundColor: colors.appbarColor,
        body: Obx(
          () => IndexedStack(
            index: controller.selectedIndex.value,
            children: [
              Navigator(
                key: Get.nestedKey(1),
                onGenerateRoute: (settings) {
                  return GetPageRoute(
                    settings: settings,
                    page: () => HomeScreen(),
                  );
                },
              ),
              Navigator(
                key: Get.nestedKey(2),
                onGenerateRoute: (settings) {
                  return GetPageRoute(
                    settings: settings,
                    page: () => IngredientsScreen(),
                  );
                },
              ),
              Navigator(
                key: Get.nestedKey(3),
                onGenerateRoute: (settings) {
                  return GetPageRoute(
                    settings: settings,
                    page: () => MealScreen(),
                  );
                },
              ),
              Navigator(
                key: Get.nestedKey(4),
                onGenerateRoute: (settings) {
                  return GetPageRoute(
                    settings: settings,
                    page: () => PlanScreen(),
                  );
                },
              ),
              // Add more root-level tabs here
            ],
          ),
        ),
        bottomNavigationBar: Obx(
          () => CustomBottomNavBar(
            currentIndex: controller.selectedIndex.value,
            onTap: controller.changeTab,
          ),
        ),
      ),
    );
  }
}
