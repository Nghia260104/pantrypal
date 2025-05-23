import 'package:get/get.dart';
import 'package:pantrypal/controllers/dropdown_controller.dart';
import 'dart:io';
import 'package:flutter/services.dart';

class RootController extends GetxController {
  // Optional for bottom nav index tracking
  var selectedIndex = 0.obs;
  var currentNavId = 1.obs;
  final mainNavId = 1;
  final dropdownController = Get.put(DropdownController());

  void changeTab(int index) {
    clearNavigatorStack(currentNavId.value);
    dropdownController.closeOverlay();

    selectedIndex.value = index;
    currentNavId.value = index + 1;
  }

  void clearNavigatorStack(int id) {
    final navigatorState = Get.nestedKey(id)?.currentState;
    if (navigatorState != null) {
      while (navigatorState.canPop()) {
        navigatorState.pop();
      }
    }
  }

  Future<bool> handleBack() async {
    int navId = currentNavId.value; // or just currentNavId if not observable
    final navigator = Get.nestedKey(navId)?.currentState;
    if (navigator?.canPop() ?? false) {
      // Get.back(id: currentNavId.value);
      navigator?.pop();
      return false; // Do not exit app
    } else {
      // If at root of current stack
      if (navId != mainNavId) {
        // Switch back to main tab maybe?
        changeTab(0);
        return false;
      }
      if (Platform.isAndroid) {
        print("Exiting app");
        SystemNavigator.pop();
      } else if (Platform.isIOS) {
        exit(0); // iOS will reject this in production, though
      }
      return true; // Exit app
    }
  }
}
