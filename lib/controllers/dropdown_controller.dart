import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DropdownController extends GetxController {
  Rx<OverlayEntry?> activeOverlay = Rx<OverlayEntry?>(null);

  void showOverlay(Rx<OverlayEntry?> entry, BuildContext context) {
    // closeOverlay();
    activeOverlay = entry;
    Overlay.of(context).insert(entry.value!);
  }

  void closeOverlay() {
    activeOverlay.value?.remove();
    activeOverlay.value = null;
  }

  @override
  void onClose() {
    closeOverlay(); // Cleanup when controller is destroyed
    super.onClose();
  }
}
