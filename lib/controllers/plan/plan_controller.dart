import 'package:get/get.dart';

class PlanController extends GetxController {
  final titles = ["Meal Planner", "Goals"];
  var currentKcal = 1200.obs;
  var goalKcal = 2000.obs;

  var selectedTab = 0.obs;

  List<Map<String, dynamic>> mealBoxes = [
    {"title": "Breakfast", "status": "Completed"},
    {"title": "Lunch", "status": "Current"},
    {"title": "Dinner", "status": "Upcoming"},
  ];

  @override
  void onInit() {
    super.onInit();
  }

  void toggleTab(int index) => selectedTab.value = index;
}
