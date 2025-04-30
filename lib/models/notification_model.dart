import 'package:hive_ce/hive.dart';
import 'enums/notification_type.dart';
import 'hive_manager.dart';

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

  static Future<int> create(NotificationModel notification) async {
    final box = Hive.box<NotificationModel>(boxName);

    // Get the next incremental ID
    final hiveManager = HiveManager();
    final id = await hiveManager.getNextId('lastNotificationId');

    // Assign the ID to the notification
    final newNotification = NotificationModel(
      id: id,
      message: notification.message,
      dateTime: notification.dateTime,
      type: notification.type,
      isRead: notification.isRead,
    );

    await box.put(newNotification.id, newNotification);

    return id;
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
