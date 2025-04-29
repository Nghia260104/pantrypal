import 'package:hive_ce/hive.dart';

part 'meal_status.g.dart';

@HiveType(typeId: 1)
enum MealStatus {
  @HiveField(0)
  Upcoming,
  @HiveField(1)
  Ongoing,
  @HiveField(2)
  Completed,
}
