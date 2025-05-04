import 'package:hive_ce/hive.dart';
import 'meal.dart';
// import 'recipe.dart';
import 'enums/meal_type.dart';
import 'enums/meal_status.dart';
import 'hive_manager.dart';
import 'recipe_portion.dart';
import 'package:flutter/material.dart';

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

  @HiveField(9)
  late String timeOfDayString; // Store TimeOfDay as a String in HH:mm format

  MealPlan({
    required this.id,
    required this.dateTime,
    required this.type,
    required this.status,
    required this.portions,
    required this.timeOfDayString, // Accept TimeOfDay
  });

  static const String boxName = 'meal_plans';

  TimeOfDay get timeOfDay {
    final parts = timeOfDayString.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  set timeOfDay(TimeOfDay value) {
    timeOfDayString =
        '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
  }

  /// Schedules a new MealPlan and stores it in Hive.
  static Future<MealPlan> schedule({
    required List<RecipePortion> portions,
    required DateTime dateTime,
    required MealType type,
    required TimeOfDay timeOfDay, // Accept TimeOfDay
  }) async {
    final box = Hive.box<MealPlan>(boxName);

    // Get the next incremental ID
    final id = await HiveManager().getNextId('lastMealPlanId');

    // Calculate the initial status
    final now = TimeOfDay.now();
    final currentMinutes = now.hour * 60 + now.minute;
    final mealMinutes = timeOfDay.hour * 60 + timeOfDay.minute;

    final isBreakfastLunchDinner =
        type == MealType.Breakfast ||
        type == MealType.Lunch ||
        type == MealType.Dinner;

    // Determine the Ongoing period
    final ongoingDuration = isBreakfastLunchDinner ? 60 : 30;

    MealStatus initialStatus;
    if (currentMinutes < mealMinutes) {
      initialStatus = MealStatus.Upcoming;
    } else if (currentMinutes >= mealMinutes &&
        currentMinutes <= mealMinutes + ongoingDuration) {
      initialStatus = MealStatus.Ongoing;
    } else {
      initialStatus = MealStatus.Completed;
    }

    final mealPlan = MealPlan(
      id: id,
      dateTime: dateTime,
      type: type,
      status: initialStatus,
      portions: portions,
      timeOfDayString:
          '${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}', // Convert TimeOfDay to String
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

  String get formattedTime {
    final hour = timeOfDay.hourOfPeriod == 0 ? 12 : timeOfDay.hourOfPeriod;
    final minute = timeOfDay.minute.toString().padLeft(2, '0');
    final period = timeOfDay.period == DayPeriod.am ? "AM" : "PM";
    return "$hour:$minute $period";
  }

  /// Sorts a list of MealPlan objects by their TimeOfDay.
  static List<MealPlan> sortByTimeOfDay(List<MealPlan> mealPlans) {
    mealPlans.sort((a, b) {
      final aMinutes = a.timeOfDay.hour * 60 + a.timeOfDay.minute;
      final bMinutes = b.timeOfDay.hour * 60 + b.timeOfDay.minute;
      return aMinutes.compareTo(bMinutes); // Sort by TimeOfDay
    });
    return mealPlans;
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
