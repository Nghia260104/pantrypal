import 'package:hive_ce/hive.dart';
// import 'ingredient_template.dart';
import 'inventory_item.dart';
import 'recipe.dart';
import 'meal.dart';
import 'shopping_cart.dart';
import 'notification_model.dart';
import 'enums/notification_type.dart';

class MealPlanner {
  bool canMake(Recipe recipe) {
    final inventory = InventoryItem.all();
    for (var req in recipe.ingredientRequirements) {
      final available = inventory
          .where((item) => item.template.id == req.template.id)
          .fold<double>(0, (sum, item) => sum + item.quantity);
      if (available < req.quantity) return false;
    }
    return true;
  }

  List<Map<String, dynamic>> shoppingList(Recipe recipe) {
    final inventory = InventoryItem.all();
    return recipe.ingredientRequirements
        .map((req) {
          final available = inventory
              .where((item) => item.template.id == req.template.id)
              .fold<double>(0, (sum, item) => sum + item.quantity);
          final needed = req.quantity - available;
          return {'template': req.template, 'needed': needed > 0 ? needed : 0};
        })
        .where((entry) => (entry['needed'] as double) > 0)
        .toList();
  }

  Future<void> scheduleMeal(Meal meal) async {
    final box = Hive.box<Meal>(Meal.boxName);
    await box.put(meal.id, meal);
  }

  List<InventoryItem> expiringSoon([int days = 3]) {
    final cutoff = DateTime.now().add(Duration(days: days));
    return InventoryItem.all()
        .where(
          (item) =>
              item.expirationDate != null &&
              item.expirationDate!.isBefore(cutoff),
        )
        .toList();
  }

  void notifyExpiry([int days = 3]) {
    final expiring = expiringSoon(days);
    for (var item in expiring) {
      NotificationModel.create(
        NotificationModel(
          id: DateTime.now().millisecondsSinceEpoch,
          message:
              'Your ${item.template.name} will expire on ${item.expirationDate}',
          dateTime: DateTime.now(),
          type: NotificationType.Expiry,
        ),
      );
    }
  }

  void notifyUpcomingMeal([int minutes = 30]) {
    final now = DateTime.now();
    final upcoming = Meal.all().where(
      (m) =>
          m.dateTime.isAfter(now) &&
          m.dateTime.isBefore(now.add(Duration(minutes: minutes))),
    );
    for (var m in upcoming) {
      NotificationModel.create(
        NotificationModel(
          id: DateTime.now().millisecondsSinceEpoch,
          message: 'Your ${m.type} is starting at ${m.dateTime}',
          dateTime: now,
          type: NotificationType.Other,
        ),
      );
    }
  }

  Future<ShoppingCart> getCart() async {
    return await ShoppingCart.getCart();
  }
}
