import 'package:hive_ce/hive.dart';
import 'meal_plan.dart';
import 'notification_model.dart';

part 'nutrition_goal.g.dart';

@HiveType(typeId: 13)
class NutritionGoal extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  DateTime startDate;

  @HiveField(2)
  DateTime? endDate;

  @HiveField(3)
  double targetCalories;

  @HiveField(4)
  double targetProtein;

  @HiveField(5)
  double targetCarbs;

  @HiveField(6)
  double targetFat;

  NutritionGoal({
    required this.id,
    required this.startDate,
    this.endDate,
    required this.targetCalories,
    required this.targetProtein,
    required this.targetCarbs,
    required this.targetFat,
  });

  static const String boxName = 'nutritionGoal';

  void setTargets({
    required double calories,
    required double protein,
    required double carbs,
    required double fat,
  }) {
    targetCalories = calories;
    targetProtein = protein;
    targetCarbs = carbs;
    targetFat = fat;
    save();
  }

  void updateTargets({
    double? calories,
    double? protein,
    double? carbs,
    double? fat,
  }) {
    if (calories != null) targetCalories = calories;
    if (protein != null) targetProtein = protein;
    if (carbs != null) targetCarbs = carbs;
    if (fat != null) targetFat = fat;
    save();
  }

  bool isActive(DateTime onDate) {
    return startDate.isBefore(onDate) &&
        (endDate == null || endDate!.isAfter(onDate));
  }

  void evaluate(List<MealPlan> plans) {
    // Evaluate the meal plans against the goal
    // Logic to compare actual vs target nutrition
  }

  List<NotificationModel> getNotifications(List<MealPlan> plans) {
    // Generate notifications based on the evaluation
    return [];
  }

  static NutritionGoal? getById(int id) {
    return Hive.box<NutritionGoal>('nutrition_goals').get(id);
  }

  static List<NutritionGoal> all() {
    return Hive.box<NutritionGoal>('nutrition_goals').values.toList();
  }

  static void remove(int id) {
    Hive.box<NutritionGoal>('nutrition_goals').delete(id);
  }
}
