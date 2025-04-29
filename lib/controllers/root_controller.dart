import 'package:get/get.dart';

class RootController extends GetxController {
  // Optional for bottom nav index tracking
  var selectedIndex = 0.obs;
  var currentNavId = 1.obs;
  final mainNavId = 0;

  void changeTab(int index) {
    clearNavigatorStack(currentNavId.value);
    
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
      Get.back(id: currentNavId.value);
      return false; // Do not exit app
    } else {
      // If at root of current stack
      if (navId != mainNavId) {
        // Switch back to main tab maybe?
        changeTab(mainNavId);
        return false;
      }
      return true; // Allow app to close
    }
  }
}
