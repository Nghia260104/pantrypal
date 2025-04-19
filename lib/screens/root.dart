import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pantrypal/screens/place_holder_screen.dart';
import 'package:pantrypal/widgets/custom_bottom_nav_bar.dart';
import 'package:pantrypal/controllers/root_controller.dart';

class RootScreen extends StatelessWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RootController());

    return Scaffold(
    //   appBar: CustomAppBar(
    //     title: 'App',
    //     onBack: () {
    //       if (Get.nestedKey(1)!.currentState!.canPop()) {
    //         Get.back(id: 1);
    //       }
    //     },
    //   ),
      body: Obx(() => IndexedStack(
        index: controller.selectedIndex.value,
        children: [
          Navigator(
            key: Get.nestedKey(1),
            onGenerateRoute: (settings) {
              return GetPageRoute(
                settings: settings,
                page: () => const PlaceHolderScreen(title: '1',),
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
                page: () => const PlaceHolderScreen(title: '3',),
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
    );
  }
}
