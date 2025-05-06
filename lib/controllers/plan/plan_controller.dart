import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pantrypal/models/meal_plan.dart';
import 'package:pantrypal/models/nutrition_goal.dart';
import 'package:pantrypal/models/enums/meal_status.dart';
import 'package:pantrypal/models/enums/meal_type.dart';
import 'dart:async';

class PlanController extends GetxController {
  final titles = ["Meal Planner", "Goals"];
  var currentKcal = 0.obs;
  var currentProtein = 0.0.obs;
  var currentCarbs = 0.0.obs;
  var currentFat = 0.0.obs;
  var goalKcal = 2000.obs; // Default goal calories
  var isEditing = false.obs;
  // var hasUpcomingMeals = false.obs;
  // var isMealPlanEmpty = false.obs;
  final minGoalKcal = 500;
  final maxGoalKcal = 5000;

  final TextEditingController goalKcalController = TextEditingController();

  var selectedTab = 0.obs;

  // List of meal plans
  var mealPlans = <MealPlan>[].obs;
  Timer? _mealPlanStatusUpdater;

  List<Map<String, dynamic>> mealBoxes = [
    {"title": "Breakfast", "status": "Completed"},
    {"title": "Lunch", "status": "Current"},
    {"title": "Dinner", "status": "Upcoming"},
  ];

  @override
  void onInit() {
    super.onInit();
    fetchMealPlans(); // Fetch meal plans on initialization
    // goalKcalController.text = goalKcal.value.toString();
    _initializeDailyGoal(); // Initialize the daily nutrition goal
    _startMealPlanStatusUpdater(); // Start the periodic updater
  }

  @override
  void onClose() {
    _mealPlanStatusUpdater
        ?.cancel(); // Cancel the timer when the controller is disposed
    super.onClose();
  }

  // Start the periodic updater for meal plan statuses and nutritional progress
  void _startMealPlanStatusUpdater() {
    // Execute the update immediately
    _updateMealPlanStatusAndProgress();

    // Start the periodic timer
    _mealPlanStatusUpdater = Timer.periodic(Duration(minutes: 1), (timer) {
      _updateMealPlanStatusAndProgress();
    });
  }

  // Update meal plan statuses and nutritional progress
  void _updateMealPlanStatusAndProgress() {
    final now = TimeOfDay.now();
    final currentMinutes = now.hour * 60 + now.minute;

    // Fetch all meal plans from the Hive database
    final mealPlans = MealPlan.all();

    // Initialize variables to track nutritional progress
    double totalCalories = 0;
    double totalProtein = 0;
    double totalCarbs = 0;
    double totalFat = 0;

    for (var mealPlan in mealPlans) {
      final mealMinutes =
          mealPlan.timeOfDay.hour * 60 + mealPlan.timeOfDay.minute;
      final isBreakfastLunchDinner =
          mealPlan.type == MealType.Breakfast ||
          mealPlan.type == MealType.Lunch ||
          mealPlan.type == MealType.Dinner;

      // Determine the Ongoing period
      final ongoingDuration = isBreakfastLunchDinner ? 60 : 30;

      if (currentMinutes < mealMinutes) {
        // Before the meal time
        mealPlan.status = MealStatus.Upcoming;
      } else if (currentMinutes >= mealMinutes &&
          currentMinutes <= mealMinutes + ongoingDuration) {
        // Within the Ongoing period
        mealPlan.status = MealStatus.Ongoing;
      } else {
        // After the Ongoing period
        mealPlan.status = MealStatus.Completed;
      }

      // If the meal plan is completed and is for today, add its nutritional values
      final today = DateTime.now();
      if (mealPlan.status == MealStatus.Completed &&
          mealPlan.dateTime.year == today.year &&
          mealPlan.dateTime.month == today.month &&
          mealPlan.dateTime.day == today.day) {
        totalCalories += mealPlan.calories;
        totalProtein += mealPlan.protein;
        totalCarbs += mealPlan.carbs;
        totalFat += mealPlan.fat;
      }

      // Save the updated status to Hive
      mealPlan.save();
    }

    // Update the observable list with the queried meal plans
    fetchMealPlans();

    // Update the nutritional progress
    updateNutritionalProgress(
      totalCalories: totalCalories,
      totalProtein: totalProtein,
      totalCarbs: totalCarbs,
      totalFat: totalFat,
    );
  }

  // Fetch meal plans from the Hive database
  void fetchMealPlans({DateTime? date, MealStatus? status}) {
    final today = DateTime.now();
    final targetDate = date ?? today;

    // Query meal plans dynamically based on the provided date and status
    final queriedMealPlans =
        MealPlan.all().where((mealPlan) {
          final isSameDate =
              mealPlan.dateTime.year == targetDate.year &&
              mealPlan.dateTime.month == targetDate.month &&
              mealPlan.dateTime.day == targetDate.day;

          final matchesStatus = status == null || mealPlan.status == status;

          return isSameDate && matchesStatus;
        }).toList();

    // Update the observable list with the queried meal plans
    mealPlans.assignAll(MealPlan.sortByTimeOfDay(queriedMealPlans));
  }

  // Initialize the daily nutrition goal
  void _initializeDailyGoal() {
    // Wait until the Hive box is ready
    // while (!Hive.isBoxOpen(NutritionGoal.boxName)) {
    //   await Future.delayed(Duration(milliseconds: 100));
    // }

    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);

    // Check if a nutrition goal exists for today
    final existingGoal = NutritionGoal.all().firstWhereOrNull(
      (goal) => goal.startDate == todayStart,
    );

    if (existingGoal != null) {
      // Use the existing goal
      goalKcal.value = existingGoal.targetCalories.toInt();
      goalKcalController.text = goalKcal.value.toString();
    } else {
      // Use the default value, but do not create a new goal yet
      goalKcal.value = 2000; // Default value
      goalKcalController.text = goalKcal.value.toString();
    }
  }

  // Update the daily nutrition goal in the database
  void updateDailyGoal(int newGoalKcal) async {
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);

    // Find the existing goal for today
    final existingGoal = NutritionGoal.all().firstWhereOrNull(
      (goal) => goal.startDate == todayStart,
    );

    if (existingGoal != null) {
      // Update the existing goal
      existingGoal.updateTargets(calories: newGoalKcal.toDouble());
    } else {
      // Create a new goal using the create method
      await NutritionGoal.create(
        startDate: todayStart,
        endDate: todayStart,
        targetCalories: newGoalKcal.toDouble(),
      );
    }

    // Update the controller's goal value
    goalKcal.value = newGoalKcal;
    goalKcalController.text = newGoalKcal.toString();
  }

  // Add a new meal plan to the list
  void addMealPlan(MealPlan mealPlan) {
    fetchMealPlans();
  }

  void toggleTab(int index) => selectedTab.value = index;

  // Update nutritional progress
  void updateNutritionalProgress({
    required double totalCalories,
    required double totalProtein,
    required double totalCarbs,
    required double totalFat,
  }) {
    currentKcal.value = totalCalories.toInt();
    currentProtein.value = totalProtein;
    currentCarbs.value = totalCarbs;
    currentFat.value = totalFat;
  }

  void deleteMealPlan(int mealPlanId) async {
    // mealFavoriteStatus[mealId] = false;
    final mealPlan = mealPlans.firstWhere((m) => m.id == mealPlanId);
    await mealPlan.delete();
    mealPlans.removeWhere((m) => m.id == mealPlanId);
  }

  /// Check if there is at least one upcoming meal for today
  bool hasUpcomingMeals() {
    final today = DateTime.now();
    return mealPlans.any(
      (mealPlan) =>
          mealPlan.status == MealStatus.Upcoming &&
          mealPlan.dateTime.year == today.year &&
          mealPlan.dateTime.month == today.month &&
          mealPlan.dateTime.day == today.day,
    );
  }

  /// Check if the meal plan list is empty
  bool isMealPlanEmpty() {
    final today = DateTime.now();
    return mealPlans
        .where(
          (mealPlan) =>
              mealPlan.dateTime.year == today.year &&
              mealPlan.dateTime.month == today.month &&
              mealPlan.dateTime.day == today.day,
        )
        .isEmpty;
  }

  List<MealPlan> filteredMealPlans(int selectedMealIndex) {
    if (selectedMealIndex == 0) {
      // All meal plans
      return mealPlans;
    } else if (selectedMealIndex == 1) {
      // Upcoming (includes Ongoing)
      return mealPlans
          .where(
            (mealPlan) =>
                mealPlan.status == MealStatus.Upcoming ||
                mealPlan.status == MealStatus.Ongoing,
          )
          .toList();
    } else {
      // Completed
      return mealPlans
          .where((mealPlan) => mealPlan.status == MealStatus.Completed)
          .toList();
    }
  }
}
