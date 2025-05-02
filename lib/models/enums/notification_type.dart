import 'package:hive_ce/hive.dart';

part 'notification_type.g.dart';

@HiveType(typeId: 2)
enum NotificationType {
  @HiveField(0)
  Expiry, // General expiry notification

  @HiveField(1)
  ShoppingReminder, // Reminder for shopping

  @HiveField(2)
  Other, // Other notifications

  @HiveField(3)
  UpcomingMeal, // Notification for upcoming meals

  @HiveField(4)
  ExpiryWarning, // Warning for expiring inventory items

  @HiveField(5)
  ShoppingListReminder, // Reminder for missing ingredients in the shopping cart
}
