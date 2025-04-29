// lib/models/hive_manager.dart

import 'package:hive_ce_flutter/hive_flutter.dart';

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

    // 3. Open boxes (using the static boxName from each model)
    await Hive.openBox<IngredientTemplate>(IngredientTemplate.boxName);
    await Hive.openBox<InventoryItem>(InventoryItem.boxName);
    await Hive.openBox<Recipe>(Recipe.boxName);
    await Hive.openBox<Meal>(Meal.boxName);
    await Hive.openBox<NotificationModel>(NotificationModel.boxName);
    await Hive.openBox<ShoppingCart>(ShoppingCart.boxName);

    // Done — now your boxes are ready to use throughout the app.
  }
}
