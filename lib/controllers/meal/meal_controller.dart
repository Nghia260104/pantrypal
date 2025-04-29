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
  }

  void toggleTab(int index) => selectedTab.value = index;

  void toggleFavorite(int idx) =>
      favoriteStatus[idx] = !(favoriteStatus[idx] ?? false);
}
