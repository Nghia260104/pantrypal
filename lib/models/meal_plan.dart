import 'package:hive_ce/hive.dart';
import 'meal.dart';
import 'recipe.dart';
import 'enums/meal_type.dart';
import 'enums/meal_status.dart';
import 'hive_manager.dart';
import 'recipe_portion.dart';

part 'meal_plan.g.dart';

@HiveType(typeId: 11)
class MealPlan extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  DateTime dateTime;

  @HiveField(2)
  MealType type;

  @HiveField(3)
  MealStatus status;

  @HiveField(4)
  List<RecipePortion> portions;

  @HiveField(5)
  double calories = 0;

  @HiveField(6)
  double protein = 0;

  @HiveField(7)
  double carbs = 0;

  @HiveField(8)
  double fat = 0;

  MealPlan({
    required this.id,
    required this.dateTime,
    required this.type,
    required this.status,
    required this.portions,
  });

  static const String boxName = 'meal_plans';

  /// Schedules a new MealPlan and stores it in Hive.
  static Future<MealPlan> schedule({
    required List<RecipePortion> portions,
    required DateTime dateTime,
    required MealType type,
  }) async {
    final box = Hive.box<MealPlan>(boxName);

    // Get the next incremental ID
    final id = await HiveManager().getNextId('lastMealPlanId');

    final mealPlan = MealPlan(
      id: id,
      dateTime: dateTime,
      type: type,
      status: MealStatus.Upcoming,
      portions: portions,
    );

    // Store the MealPlan in Hive
    await box.put(mealPlan.id, mealPlan);
    mealPlan.computeNutrition(); // Compute nutrition after storing
    return mealPlan;
  }

  /// Applies a template (Meal) to this MealPlan.
  void applyTemplate(Meal template) {
    portions.clear();
    portions.addAll(template.portions);
  }

  /// Adds a recipe to the MealPlan.
  Future<void> addPortion(RecipePortion portion) async {
    portions.add(portion);
    await save();
  }

  /// Removes a recipe from the MealPlan.
  Future<void> removePortion(RecipePortion portion) async {
    portions.remove(portion);
    await save();
  }

  /// Updates the status of this MealPlan.
  Future<void> updateStatus(MealStatus newStatus) async {
    status = newStatus;
    await save();
  }

  /// Retrieves a MealPlan by its ID.
  static MealPlan? getById(int id) {
    final box = Hive.box<MealPlan>(boxName);
    return box.get(id);
  }

  /// Returns all stored MealPlans.
  static List<MealPlan> all() {
    final box = Hive.box<MealPlan>(boxName);
    return box.values.toList();
  }

  /// Computes total nutrition across all recipes and stores the values.
  void computeNutrition() {
    double totalCalories = 0, totalProtein = 0, totalCarbs = 0, totalFat = 0;
    for (var portion in portions) {
      portion.recipe
          .computeNutrition(); // Ensure recipe nutrition is up-to-date
      totalCalories += portion.recipe.calories * portion.quantity;
      totalProtein += portion.recipe.protein * portion.quantity;
      totalCarbs += portion.recipe.carbs * portion.quantity;
      totalFat += portion.recipe.fat * portion.quantity;
    }
    calories = totalCalories;
    protein = totalProtein;
    carbs = totalCarbs;
    fat = totalFat;

    save(); // Persist the updated values to Hive
  }
}
