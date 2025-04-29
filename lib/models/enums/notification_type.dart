import 'package:hive_ce/hive.dart';

part 'notification_type.g.dart';

@HiveType(typeId: 2)
enum NotificationType {
  @HiveField(0)
  Expiry,
  @HiveField(1)
  ShoppingReminder,
  @HiveField(2)
  Other,
}
