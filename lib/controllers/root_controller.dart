import 'package:get/get.dart';
import 'package:flutter/material.dart';

class RootController extends GetxController {
  // Optional for bottom nav index tracking
  var selectedIndex = 0.obs;
  var currentNavId = 1.obs;

  void changeTab(int index) {
    selectedIndex.value = index;
    currentNavId.value = index + 1;
  }
}
