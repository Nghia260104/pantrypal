import 'package:hive_ce/hive.dart';
import 'recipe.dart';
import 'hive_manager.dart';

part 'meal.g.dart';

@HiveType(typeId: 7)
class Meal extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String description;

  @HiveField(3)
  List<Recipe> recipes;

  @HiveField(4)
  double calories = 0;

  @HiveField(5)
  double protein = 0;

  @HiveField(6)
  double carbs = 0;

  @HiveField(7)
  double fat = 0;

  Meal({
    required this.id,
    required this.name,
    this.description = "A generic meal. Nothing special.", // Default value
    required this.recipes,
  });

  static const String boxName = 'meals';

  /// Creates and stores a new [Meal] in Hive.
  static Future<int> create(Meal meal) async {
    final box = Hive.box<Meal>(boxName);

    // Get the next incremental ID
    final hiveManager = HiveManager();
    final id = await hiveManager.getNextId('lastMealId');

    // Assign the ID to the meal
    final newMeal = Meal(
      id: id,
      name: meal.name,
      description: meal.description,
      recipes: meal.recipes,
    );

    // Store the Meal in Hive
    await box.put(newMeal.id, newMeal);
    newMeal.computeNutrition();
    return id;
  }

  /// Returns the list of scheduled recipes.
  List<Recipe> getRecipes() => recipes;

  /// Updates the status of this meal and persists the change.
  // Future<void> updateStatus(MealStatus newStatus) async {
  //   status = newStatus;
  //   await save();
  // }

  /// Retrieves a [Meal] by its [id].
  static Meal? getById(int id) {
    final box = Hive.box<Meal>(boxName);
    return box.get(id);
  }

  /// Returns all stored [Meal]s.
  static List<Meal> all() {
    final box = Hive.box<Meal>(boxName);
    return box.values.toList();
  }

  // Delete a [Meal] by its [id].
  static Future<void> remove(int id) async {
    final box = Hive.box<Meal>(boxName);
    await box.delete(id);
  }

  /// Computes total nutrition across all recipes and stores the values.
  void computeNutrition() {
    double totalCalories = 0, totalProtein = 0, totalCarbs = 0, totalFat = 0;
    for (var recipe in recipes) {
      recipe.computeNutrition(); // Ensure recipe nutrition is up-to-date
      totalCalories += recipe.calories;
      totalProtein += recipe.protein;
      totalCarbs += recipe.carbs;
      totalFat += recipe.fat;
    }
    calories = totalCalories;
    protein = totalProtein;
    carbs = totalCarbs;
    fat = totalFat;

    save(); // Persist the updated values to Hive
  }
}
