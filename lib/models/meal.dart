import 'package:hive_ce/hive.dart';
import 'recipe.dart';
import 'hive_manager.dart';
import 'recipe_portion.dart'; // Import the RecipePortion class

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
  List<RecipePortion> portions; // Updated to use RecipePortion

  @HiveField(4)
  double calories = 0;

  @HiveField(5)
  double protein = 0;

  @HiveField(6)
  double carbs = 0;

  @HiveField(7)
  double fat = 0;

  @HiveField(8)
  bool isFavorite; // Mutable attribute for favorite status

  @HiveField(9) // New field for the image
  String? image; // Optional image attribute

  Meal({
    required this.id,
    required this.name,
    this.description = "A generic meal. Nothing special.", // Default value
    required this.portions, // Updated to use RecipePortion
    this.isFavorite = false, // Default value is false
    this.image, // Optional image attribute
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
      portions: meal.portions, // Updated to use portions
      image: meal.image, // Optional image attribute
    );

    // Store the Meal in Hive
    await box.put(newMeal.id, newMeal);
    newMeal.computeNutrition();
    return id;
  }

  /// Returns the list of scheduled recipes.
  List<RecipePortion> getRecipes() => portions;

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

  // Add a recipe to the Meal.
  Future<void> addPortion(RecipePortion portion) async {
    portions.add(portion);
    await save(); // Persist the change to Hive
  }

  // Delete a [Meal] by its [id].
  static Future<void> remove(int id) async {
    final box = Hive.box<Meal>(boxName);
    await box.delete(id);
  }

  Future<void> toggleFavorite() async {
    isFavorite = !isFavorite;
    await save(); // Persist the change to Hive
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
