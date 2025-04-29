import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pantrypal/screens/meal/meal_screen.dart';
import 'package:pantrypal/screens/place_holder_screen.dart';
import 'package:pantrypal/widgets/custom_bottom_nav_bar.dart';
import 'package:pantrypal/controllers/root_controller.dart';
import 'package:pantrypal/screens/home/home_screen.dart';
import 'package:pantrypal/core/theme/theme_colors.dart';

class RootScreen extends StatelessWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RootController());
    final colors = Theme.of(context).extension<ThemeColors>()!;

    return PopScope(
      onPopInvoked: (didPop) async => await controller.handleBack(),
      child: Scaffold(
        backgroundColor: colors.appbarColor,
        body: Obx(() => IndexedStack(
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
                  page: () => const PlaceHolderScreen(title: '2',),
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
                  page: () => const PlaceHolderScreen(title: '4',),
                );
              },
            ),
            // Add more root-level tabs here
          ],
        )),
        bottomNavigationBar: Obx(() => CustomBottomNavBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeTab,
        )),
      )
    );
  }
}
