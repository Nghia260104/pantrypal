import 'package:get/get.dart';
import 'package:pantrypal/models/meal_plan.dart';

class PlanController extends GetxController {
  final titles = ["Meal Planner", "Goals"];
  var currentKcal = 1200.obs;
  var goalKcal = 2000.obs;

  var selectedTab = 0.obs;

  // List of meal plans
  var mealPlans = <MealPlan>[].obs;

  List<Map<String, dynamic>> mealBoxes = [
    {"title": "Breakfast", "status": "Completed"},
    {"title": "Lunch", "status": "Current"},
    {"title": "Dinner", "status": "Upcoming"},
  ];

  @override
  void onInit() {
    super.onInit();
    fetchMealPlans(); // Fetch meal plans on initialization
  }

  // Fetch meal plans from the Hive database
  void fetchMealPlans() {
    mealPlans.assignAll(MealPlan.sortByTimeOfDay(MealPlan.all()));
  }

  // Add a new meal plan to the list
  void addMealPlan(MealPlan mealPlan) {
    fetchMealPlans();
  }

  void toggleTab(int index) => selectedTab.value = index;
}
