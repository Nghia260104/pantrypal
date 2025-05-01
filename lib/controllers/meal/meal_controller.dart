// lib/controllers/meal/meal_controller.dart

import 'package:get/get.dart';
import 'package:pantrypal/models/recipe.dart';

class MealController extends GetxController {
  /// Now holds recipes, not meals
  final RxList<Recipe> recipes = <Recipe>[].obs;

  // tabs & favorites stay the same
  var selectedTab = 0.obs;
  var favoriteStatus = <int, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _loadRecipes();
  }

  void _loadRecipes() {
    // loads all recipes from Hive
    recipes.assignAll(Recipe.all());

    // Populate the favoriteStatus map
    for (var recipe in recipes) {
      favoriteStatus[recipe.id] = recipe.isFavorite;
    }
  }

  void toggleTab(int index) => selectedTab.value = index;

  void toggleFavorite(int recipeId) async {
    // Toggle the favorite status in the map
    favoriteStatus[recipeId] = !(favoriteStatus[recipeId] ?? false);

    // Find the recipe and toggle its favorite status in Hive
    final recipe = recipes.firstWhere((r) => r.id == recipeId);
    await recipe.toggleFavorite();

    // Refresh the recipes list to update the UI
    recipes.refresh();
  }
}
