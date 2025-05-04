// lib/models/hive_manager.dart

import 'package:hive_ce_flutter/hive_flutter.dart';
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
}
