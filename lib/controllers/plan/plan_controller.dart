import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pantrypal/models/meal_plan.dart';

class PlanController extends GetxController {
  final titles = ["Meal Planner", "Goals"];
  var currentKcal = 1200.obs;
  var goalKcal = 2000.obs;
  var isEditing = false.obs;

  final minGoalKcal = 500;
  final maxGoalKcal = 5000;

  final TextEditingController goalKcalController = TextEditingController();

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
    goalKcalController.text = goalKcal.value.toString();
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

  void deleteMealPlan(int mealPlanId) async {
    // mealFavoriteStatus[mealId] = false;
    final mealPlan = mealPlans.firstWhere((m) => m.id == mealPlanId);
    await mealPlan.delete();
    mealPlans.removeWhere((m) => m.id == mealPlanId);
  }
}
