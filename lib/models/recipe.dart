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

  Recipe({
    required this.id,
    required this.name,
    required this.instructions,
    required this.duration,
    required this.difficulty,
    required this.briefDescription,
    required this.ingredientRequirements,
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
    );

    await box.put(newRecipe.id, newRecipe);

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

  /// Returns the list of ingredients.
  List<RecipeIngredient> getIngredients() => ingredientRequirements;

  /// Computes total nutrition across all ingredients.
  Map<String, double> computeNutrition() {
    double calories = 0, protein = 0, carbs = 0, fat = 0;
    for (var ri in ingredientRequirements) {
      calories += ri.template.caloriesPerUnit * ri.quantity;
      protein += ri.template.proteinPerUnit * ri.quantity;
      carbs += ri.template.carbsPerUnit * ri.quantity;
      fat += ri.template.fatPerUnit * ri.quantity;
    }
    return {
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
    };
  }
}
