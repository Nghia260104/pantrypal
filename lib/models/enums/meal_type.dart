import 'package:hive_ce/hive.dart';

part 'meal_type.g.dart';

@HiveType(typeId: 0)
enum MealType {
  @HiveField(0)
  Breakfast,
  @HiveField(1)
  Lunch,
  @HiveField(2)
  Dinner,
  @HiveField(3)
  Snack,
  @HiveField(4)
  Dessert,
}
