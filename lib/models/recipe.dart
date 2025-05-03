import 'package:flutter/foundation.dart';
import 'package:hive_ce/hive.dart';
import 'hive_manager.dart';
import 'recipe_ingredient.dart';

part 'recipe.g.dart';

@HiveType(typeId: 6)
class Recipe extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String instructions;

  @HiveField(3)
  final int duration; // in minutes

  @HiveField(4)
  final String difficulty;

  @HiveField(5)
  final String briefDescription;

  @HiveField(6)
  final List<RecipeIngredient> ingredientRequirements;

  @HiveField(7)
  bool isFavorite; // Mutable attribute for favorite status

  @HiveField(8)
  double calories = 0;

  @HiveField(9)
  double protein = 0;

  @HiveField(10)
  double carbs = 0;

  @HiveField(11)
  double fat = 0;

  @HiveField(12) // New field for the image
  String? image; // Optional image attribute

  Recipe({
    required this.id,
    required this.name,
    required this.instructions,
    required this.duration,
    required this.difficulty,
    required this.briefDescription,
    required this.ingredientRequirements,
    this.isFavorite = false, // Default value is false
    this.image, // Optional image attribute
  });

  static const String boxName = 'recipes';

  /// Creates and stores a new [Recipe] in Hive.
  static Future<int> create(Recipe recipe) async {
    final box = Hive.box<Recipe>(boxName);

    // Get the next incremental ID
    final hiveManager = HiveManager();
    final id = await hiveManager.getNextId('lastRecipeId');

    // Assign the ID to the recipe
    final newRecipe = Recipe(
      id: id,
      name: recipe.name,
      instructions: recipe.instructions,
      duration: recipe.duration,
      difficulty: recipe.difficulty,
      briefDescription: recipe.briefDescription,
      ingredientRequirements: recipe.ingredientRequirements,
      image: recipe.image, // Optional image attribute
    );

    await box.put(newRecipe.id, newRecipe);
    newRecipe.computeNutrition(); // Compute nutrition values
    return id;
  }

  /// Retrieves a [Recipe] by its [id].
  static Recipe? getById(int id) {
    final box = Hive.box<Recipe>(boxName);
    return box.get(id);
  }

  /// Returns all stored [Recipe]s.
  static List<Recipe> all() {
    final box = Hive.box<Recipe>(boxName);
    return box.values.toList();
  }

  /// Deletes a [Recipe] by its [id].
  static Future<void> remove(int id) async {
    final box = Hive.box<Recipe>(boxName);
    await box.delete(id); // Remove the recipe using its ID as the key
  }

  /// Adds an ingredient to this recipe and saves the change.
  Future<void> addIngredient(RecipeIngredient ingredient) async {
    ingredientRequirements.add(ingredient);
    await save();
  }

  Future<void> toggleFavorite() async {
    isFavorite = !isFavorite; // Toggle the value
    await save(); // Save the updated state to Hive
  }

  /// Computed property to generate tags dynamically
  List<String> get tags {
    return [
      difficulty, // Add difficulty as the first tag
      '${duration.toString()} min', // Add duration as the second tag
    ];
  }

  /// Returns the list of ingredients.
  List<RecipeIngredient> getIngredients() => ingredientRequirements;

  /// Computes total nutrition across all ingredients and stores the values.
  void computeNutrition() {
    double totalCalories = 0, totalProtein = 0, totalCarbs = 0, totalFat = 0;
    for (var ri in ingredientRequirements) {
      totalCalories += ri.template.caloriesPerUnit * ri.quantity;
      totalProtein += ri.template.proteinPerUnit * ri.quantity;
      totalCarbs += ri.template.carbsPerUnit * ri.quantity;
      totalFat += ri.template.fatPerUnit * ri.quantity;
    }
    calories = totalCalories;
    protein = totalProtein;
    carbs = totalCarbs;
    fat = totalFat;

    if (isInBox) {
      save(); // Persist the updated values to Hive
    }
  }
}
