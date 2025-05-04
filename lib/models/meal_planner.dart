// import 'package:hive_ce/hive.dart';
// import 'ingredient_template.dart';
import 'enums/meal_status.dart';
import 'inventory_item.dart';
import 'recipe.dart';
// import 'meal.dart';
import 'meal_plan.dart';
import 'shopping_cart.dart';
import 'notification_model.dart';
import 'enums/notification_type.dart';
// import 'nutrition_goal.dart';

class MealPlanner {
  /// Checks if a recipe can be made with available inventory.
  bool canMake(Recipe recipe, double quantity) {
    for (var ingredient in recipe.ingredientRequirements) {
      final available =
          InventoryItem.getByTemplateId(ingredient.template.id)?.quantity ?? 0;
      if (available < ingredient.quantity * quantity) {
        return false;
      }
    }
    return true;
  }

  /// Generates a shopping list for missing ingredients.
  List<Map<String, dynamic>> shoppingList(Recipe recipe, double quantity) {
    final missingIngredients = <Map<String, dynamic>>[];
    for (var ingredient in recipe.ingredientRequirements) {
      final available =
          InventoryItem.getByTemplateId(ingredient.template.id)?.quantity ?? 0;
      final needed = ingredient.quantity * quantity;
      if (available < needed) {
        missingIngredients.add({
          'template': ingredient.template,
          'needed': needed - available,
        });
      }
    }
    return missingIngredients;
  }

  /// Schedules a MealPlan and handles related tasks.
  Future<void> schedulePlan(MealPlan mealPlan) async {
    // Check if all recipe portions can be made
    for (var portion in mealPlan.portions) {
      final recipe = portion.recipe;
      final quantity = portion.quantity;

      if (!canMake(recipe, quantity)) {
        // Add missing ingredients to the shopping cart
        final cart = await ShoppingCart.getCart();
        for (var item in shoppingList(recipe, quantity)) {
          await cart.addItem(item['template'], item['needed']);
        }
      }
    }

    // Save the MealPlan
    await MealPlan.schedule(
      portions: mealPlan.portions, // Updated to use portions
      dateTime: mealPlan.dateTime,
      type: mealPlan.type,
      timeOfDay: mealPlan.timeOfDay, // Updated to use timeOfDay
    );
  }

  /// Returns a list of inventory items expiring soon.
  List<InventoryItem> expiringSoon({int days = 3}) {
    final now = DateTime.now();
    return InventoryItem.all().where((item) {
      final expirationDate = item.expirationDate;
      return expirationDate != null &&
          expirationDate.difference(now).inDays <= days;
    }).toList();
  }

  /// Notifies the user about expiring inventory items.
  Future<void> notifyExpiry({int days = 3}) async {
    final expiringItems = expiringSoon(days: days);
    if (expiringItems.isNotEmpty) {
      await NotificationModel.create(
        NotificationModel(
          id: 0,
          message: '${expiringItems.length} items are expiring soon!',
          dateTime: DateTime.now(),
          type: NotificationType.ExpiryWarning,
        ),
      );
    }
  }

  /// Notifies the user about upcoming meals.
  Future<void> notifyUpcomingMeal({int minutes = 30}) async {
    final now = DateTime.now();
    final upcomingMeals =
        MealPlan.all().where((mealPlan) {
          return mealPlan.dateTime.difference(now).inMinutes <= minutes &&
              mealPlan.status == MealStatus.Upcoming;
        }).toList();

    if (upcomingMeals.isNotEmpty) {
      await NotificationModel.create(
        NotificationModel(
          id: 0,
          message: '${upcomingMeals.length} meals are starting soon!',
          dateTime: DateTime.now(),
          type: NotificationType.UpcomingMeal,
        ),
      );
    }
  }

  /// Retrieves the shopping cart.
  Future<ShoppingCart> getCart() async {
    return await ShoppingCart.getCart();
  }

  List<MealPlan> getTodayMeals() {
    // Return today's meal plans
    return [];
  }

  // NutritionGoal? getActiveGoal() {
  //   final today = DateTime.now();
  //   return NutritionGoal.all().firstWhere(
  //     (goal) => goal.isActive(today),
  //     orElse: () => null,
  //   );
  // }

  // List<NotificationModel> checkGoalsForToday() {
  //   final todayMeals = getTodayMeals();
  //   // final activeGoal = getActiveGoal();
  //   //   if (activeGoal == null) return [];

  //   //   return activeGoal.getNotifications(todayMeals);
  // }
}
