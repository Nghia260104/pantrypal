// lib/models/hive_manager.dart

import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:pantrypal/controllers/home/home_controller.dart';
import 'package:pantrypal/models/meal_plan.dart';

// Enums
import 'enums/meal_type.dart';
import 'enums/meal_status.dart';
import 'enums/notification_type.dart';

// Models
import 'ingredient_template.dart';
import 'inventory_item.dart';
import 'recipe_ingredient.dart';
import 'recipe.dart';
import 'meal.dart';
import 'notification_model.dart';
import 'cart_item.dart';
import 'shopping_cart.dart';
import 'recipe_portion.dart';
import 'nutrition_goal.dart';

// To update meal plan statuses periodically
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pantrypal/controllers/plan/plan_controller.dart';

class HiveManager {
  /// Call once at app startup:
  ///   await HiveManager.init();
  static Future<void> init() async {
    // 1. Initialize Hive for Flutter
    await Hive.initFlutter();

    // 2. Register adapters in order of typeId
    Hive.registerAdapter(MealTypeAdapter());
    Hive.registerAdapter(MealStatusAdapter());
    Hive.registerAdapter(NotificationTypeAdapter());

    Hive.registerAdapter(IngredientTemplateAdapter());
    Hive.registerAdapter(InventoryItemAdapter());
    Hive.registerAdapter(RecipeIngredientAdapter());
    Hive.registerAdapter(RecipeAdapter());
    Hive.registerAdapter(MealAdapter());
    Hive.registerAdapter(NotificationModelAdapter());
    Hive.registerAdapter(CartItemAdapter());
    Hive.registerAdapter(ShoppingCartAdapter());
    Hive.registerAdapter(MealPlanAdapter());
    Hive.registerAdapter(RecipePortionAdapter());
    Hive.registerAdapter(NutritionGoalAdapter());

    // 3. Open boxes (using the static boxName from each model)
    await Hive.openBox<IngredientTemplate>(IngredientTemplate.boxName);
    await Hive.openBox<InventoryItem>(InventoryItem.boxName);
    await Hive.openBox<Recipe>(Recipe.boxName);
    await Hive.openBox<Meal>(Meal.boxName);
    await Hive.openBox<MealPlan>(MealPlan.boxName);
    await Hive.openBox<NotificationModel>(NotificationModel.boxName);
    await Hive.openBox<ShoppingCart>(ShoppingCart.boxName);
    await Hive.openBox<NutritionGoal>(NutritionGoal.boxName);

    // 4. Open the 'counter' box for managing incremental IDs
    await initializeCounters();

    // Start the MealPlan status updater
    startMealPlanStatusUpdater();

    // Done — now your boxes are ready to use throughout the app.
  }

  static Future<void> initializeCounters() async {
    final counterBox = await Hive.openBox('counter');

    // Initialize counters for IngredientTemplate
    if (!counterBox.containsKey('lastIngredientTemplateId')) {
      final ingredientTemplateBox = Hive.box<IngredientTemplate>(
        IngredientTemplate.boxName,
      );
      final lastId =
          ingredientTemplateBox.values.isNotEmpty
              ? ingredientTemplateBox.values
                  .map((e) => e.id)
                  .reduce((a, b) => a > b ? a : b)
              : 0;
      counterBox.put('lastIngredientTemplateId', lastId);
    }

    // Initialize counters for InventoryItem
    if (!counterBox.containsKey('lastInventoryItemId')) {
      final inventoryItemBox = Hive.box<InventoryItem>(InventoryItem.boxName);
      final lastId =
          inventoryItemBox.values.isNotEmpty
              ? inventoryItemBox.values
                  .map((e) => e.id)
                  .reduce((a, b) => a > b ? a : b)
              : 0;
      counterBox.put('lastInventoryItemId', lastId);
    }

    // Initialize counters for ShoppingCart
    if (!counterBox.containsKey('lastShoppingCartId')) {
      final shoppingCartBox = Hive.box<ShoppingCart>(ShoppingCart.boxName);
      final lastId =
          shoppingCartBox.values.isNotEmpty
              ? shoppingCartBox.values
                  .map((e) => e.id)
                  .reduce((a, b) => a > b ? a : b)
              : 0;
      counterBox.put('lastShoppingCartId', lastId);
    }

    // Initialize counters for Recipe
    if (!counterBox.containsKey('lastRecipeId')) {
      final recipeBox = Hive.box<Recipe>(Recipe.boxName);
      final lastId =
          recipeBox.values.isNotEmpty
              ? recipeBox.values
                  .map((e) => e.id)
                  .reduce((a, b) => a > b ? a : b)
              : 0;
      counterBox.put('lastRecipeId', lastId);
    }

    // Initialize counters for NotificationModel
    if (!counterBox.containsKey('lastNotificationId')) {
      final notificationBox = Hive.box<NotificationModel>(
        NotificationModel.boxName,
      );
      final lastId =
          notificationBox.values.isNotEmpty
              ? notificationBox.values
                  .map((e) => e.id)
                  .reduce((a, b) => a > b ? a : b)
              : 0;
      counterBox.put('lastNotificationId', lastId);
    }

    // Initialize counters for Meal
    if (!counterBox.containsKey('lastMealId')) {
      final mealBox = Hive.box<Meal>(Meal.boxName);
      final lastId =
          mealBox.values.isNotEmpty
              ? mealBox.values.map((e) => e.id).reduce((a, b) => a > b ? a : b)
              : 0;
      counterBox.put('lastMealId', lastId);
    }

    // Initialize counters for MealPlan
    if (!counterBox.containsKey('lastMealPlanId')) {
      final mealPlanBox = Hive.box<MealPlan>(MealPlan.boxName);
      final lastId =
          mealPlanBox.values.isNotEmpty
              ? mealPlanBox.values
                  .map((e) => e.id)
                  .reduce((a, b) => a > b ? a : b)
              : 0;
      counterBox.put('lastMealPlanId', lastId);
    }

    // Initialize counters for NutritionGoal
    if (!counterBox.containsKey('lastNutritionGoalId')) {
      final nutritionGoalBox = Hive.box<NutritionGoal>(NutritionGoal.boxName);
      final lastId =
          nutritionGoalBox.values.isNotEmpty
              ? nutritionGoalBox.values
                  .map((e) => e.id)
                  .reduce((a, b) => a > b ? a : b)
              : 0;
      counterBox.put('lastNutritionGoalId', lastId);
    }
  }

  Future<int> getNextId(String key) async {
    final counterBox = Hive.box('counter');
    final currentId = counterBox.get(key, defaultValue: 0) as int;
    final nextId = currentId + 1;
    await counterBox.put(key, nextId);
    return nextId;
  }

  static void startMealPlanStatusUpdater() {
    // Execute the callback immediately
    _updateMealPlanStatusAndProgress();

    // Start the periodic timer
    Timer.periodic(Duration(minutes: 1), (timer) async {
      _updateMealPlanStatusAndProgress();
    });
  }

  // Helper function to update meal plan statuses and progress
  static Future<void> _updateMealPlanStatusAndProgress() async {
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
      await mealPlan.save();
    }

    // Update the PlanController's mealPlans list
    final planController = Get.find<PlanController>();
    final homeController = Get.find<HomeController>();
    planController.fetchMealPlans();

    // Update the nutritional progress in PlanController
    planController.updateNutritionalProgress(
      totalCalories: totalCalories,
      totalProtein: totalProtein,
      totalCarbs: totalCarbs,
      totalFat: totalFat,
    );
    homeController.fetchMealPlans();
  }
}
