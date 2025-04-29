import 'package:hive_ce/hive.dart';
import 'enums/notification_type.dart';

part 'notification_model.g.dart';

@HiveType(typeId: 8)
class NotificationModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String message;

  @HiveField(2)
  final DateTime dateTime;

  @HiveField(3)
  final NotificationType type;

  @HiveField(4)
  bool isRead;

  NotificationModel({
    required this.id,
    required this.message,
    required this.dateTime,
    required this.type,
    this.isRead = false,
  });

  static const String boxName = 'notifications';

  static Future<void> create(NotificationModel notification) async {
    final box = Hive.box<NotificationModel>(boxName);
    await box.put(notification.id, notification);
  }

  Future<void> markRead() async {
    isRead = true;
    await save();
  }

  static List<NotificationModel> getUnread() {
    final box = Hive.box<NotificationModel>(boxName);
    return box.values.where((n) => !n.isRead).toList();
  }

  static List<NotificationModel> all() {
    final box = Hive.box<NotificationModel>(boxName);
    return box.values.toList();
  }
}
