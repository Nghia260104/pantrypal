// lib/controllers/meal/meal_controller.dart

import 'package:get/get.dart';
import 'package:pantrypal/models/recipe.dart';
import 'package:pantrypal/models/meal.dart';

class MealController extends GetxController {
  /// Now holds recipes, not meals
  final RxList<Recipe> recipes = <Recipe>[].obs;
  final RxList<Meal> meals = <Meal>[].obs;
  final titles = ["My Meals", "My Recipes", "Favorites"];

  // tabs & favorites stay the same
  var selectedTab = 0.obs;
  var recipeFavoriteStatus = <int, bool>{}.obs;
  var mealFavoriteStatus = <int, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _loadRecipes();
    _loadMeals();
  }

  void _loadRecipes() {
    // loads all recipes from Hive
    recipes.assignAll(Recipe.all());

    // Populate the favoriteStatus map
    for (var recipe in recipes) {
      recipeFavoriteStatus[recipe.id] = recipe.isFavorite;
    }
  }

  void _loadMeals() {
    // Load all meals from Hive
    meals.assignAll(Meal.all());

    // Populate the favoriteStatus map for meals
    for (var meal in meals) {
      mealFavoriteStatus[meal.id] = meal.isFavorite;
    }
  }

  void toggleTab(int index) => selectedTab.value = index;

  void toggleRecipeFavorite(int recipeId) async {
    // Toggle the favorite status in the map
    recipeFavoriteStatus[recipeId] = !(recipeFavoriteStatus[recipeId] ?? false);

    // Find the recipe and toggle its favorite status in Hive
    final recipe = recipes.firstWhere((r) => r.id == recipeId);
    await recipe.toggleFavorite();

    // Refresh the recipes list to update the UI
    recipes.refresh();
  }
  // void toggleRecipeFavorite(int idx) =>
  //     recipeFavoriteStatus[idx] = !(recipeFavoriteStatus[idx] ?? false);

  void toggleMealFavorite(int mealId) async {
    mealFavoriteStatus[mealId] = !(mealFavoriteStatus[mealId] ?? false);

    final meal = meals.firstWhere((m) => m.id == mealId);
    await meal.toggleFavorite();
    meals.refresh();
  }
}
