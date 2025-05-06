import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:pantrypal/controllers/ingredients/ingredients_controller.dart';
import 'package:pantrypal/controllers/meal/meal_controller.dart';
import 'package:pantrypal/controllers/root_controller.dart';
import 'package:pantrypal/models/recipe.dart';
import 'package:pantrypal/models/ingredient_template.dart';
import 'package:pantrypal/models/recipe_ingredient.dart';

class CreateRecipeController extends GetxController {
  final IngredientsController ingredientsController =
      Get.find<IngredientsController>();
  var selectedImage = Rx<XFile?>(null);
  TextEditingController recipeNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController cookingTimeController = TextEditingController();
  TextEditingController instructionsController = TextEditingController();
  // var recipeName = ''.obs;
  // var description = ''.obs;
  // var cookingTime = ''.obs;
  var difficulty = 'Easy'.obs;
  var ingredients = <Map<String, dynamic>>[].obs;
  var unitsList = <RxList<String>>[].obs;
  var ingredientTemplatesMap = <String, List<IngredientTemplate>>{};
  // var units =
  //     [
  //       "g",
  //       "kg",
  //       "ml",
  //       "l",
  //       "tbsp",
  //       "tsp",
  //       "cup",
  //       "oz",
  //     ].obs; // List of units for ingredients

  final ingredientTemplates = <IngredientTemplate>[]; // Load from database
  final uniqueIngredientNames = <String>[]; // Unique ingredient names

  @override
  void onInit() {
    super.onInit();
    loadIngredientTemplates(); // Load ingredient templates on initialization

    ingredientsController.ingredientTemplates.listen((templates) {
      // Update the ingredient templates when they change
      loadIngredientTemplates();
      print("Ingredient templates updated");
    });
  }

  void loadIngredientTemplates() {
    ingredientTemplates.assignAll(IngredientTemplate.all());
    // Group ingredient templates by name
    ingredientTemplatesMap.clear();
    for (var ingredient in ingredientTemplates) {
      ingredientTemplatesMap.putIfAbsent(ingredient.name, () => []);
      ingredientTemplatesMap[ingredient.name]!.add(ingredient);
    }
    // uniqueIngredientNames.clear();
    uniqueIngredientNames.assignAll(ingredientTemplatesMap.keys.toList());
  }

  /// Groups ingredient templates by name.
  List<IngredientTemplate> getTemplatesByName(String name) {
    return ingredientTemplates
        .where((template) => template.name == name)
        .toList();
  }

  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    selectedImage.value = image;
  }

  void addIngredient() {
    if (ingredientTemplates.isEmpty) {
      Get.snackbar("Error", "No ingredient templates available.");
      return;
    }
    ingredients.add({
      "name": "Ingredient Name".obs, // Ingredient name
      "quantity": "".obs, // Default quantity
      "unit": "Unit".obs, // Selected unit
      "unitIndex": (-1).obs, // Index of the selected unit
    });
    unitsList.add(<String>[].obs);
  }

  void removeIngredient(int index) {
    ingredients.removeAt(index);
    unitsList.removeAt(index);
  }

  /// Validates the recipe name.
  bool validateRecipeName() {
    if (recipeNameController.text.isEmpty) {
      Get.snackbar("Error", "Recipe name is required.");
      return false;
    }
    return true;
  }

  /// Validates the ingredients list.
  bool validateIngredients() {
    if (ingredients.isEmpty) {
      Get.snackbar("Error", "At least one ingredient is required.");
      return false;
    }

    for (var ingredient in ingredients) {
      // final template = ingredient["template"].value as IngredientTemplate?;
      final quantity = double.tryParse(ingredient["quantity"].value) ?? 0;
      final unitIndex = ingredient["unitIndex"].value;

      // if (template == null) {
      //   Get.snackbar("Error", "Each ingredient must have a valid template.");
      //   return false;
      // }

      if (unitIndex == -1) {
        Get.snackbar("Error", "Each ingredient must have a valid unit.");
        return false;
      }

      if (quantity <= 0) {
        Get.snackbar("Error", "Each ingredient must have a valid quantity.");
        return false;
      }
    }

    return true;
  }

  /// Validates the entire recipe form.
  bool validateRecipeForm() {
    if (recipeNameController.text.isEmpty || ingredients.isEmpty) {
      Get.snackbar("Error", "Recipe name and ingredients are required.");
      return false;
    }
    return true;
  }

  Future<void> saveRecipe() async {
    // Validate inputs
    if (!validateRecipeForm()) return; // Return if validation fails

    // Map ingredients to RecipeIngredient objects
    final recipeIngredients =
        ingredients.map((ingredient) {
          // final template = ingredient["template"].value as IngredientTemplate?;
          final templateList = ingredientTemplatesMap[ingredient["name"].value];
          if (templateList == null || templateList.isEmpty) {
            throw Exception("Invalid ingredient template.");
          }
          final template =
              templateList[ingredient["unitIndex"]
                  .value]; // Get the first template
          final quantity = double.tryParse(ingredient["quantity"].value) ?? 0;

          if (quantity <= 0) {
            throw Exception("Invalid ingredient quantity.");
          }

          return RecipeIngredient(template: template, quantity: quantity);
        }).toList();

    final recipeController = Get.find<MealController>();

    // Create and save the recipe
    final newRecipe = Recipe(
      id: 0, // Temporary ID, will be replaced by the database
      name: recipeNameController.text,
      instructions: instructionsController.text,
      duration: int.tryParse(cookingTimeController.text) ?? 0,
      difficulty: difficulty.value,
      briefDescription: descriptionController.text,
      ingredientRequirements: recipeIngredients,
    );

    final newRecipeId = await Recipe.create(newRecipe);

    if (newRecipeId == -1) {
      Get.snackbar("Error", "Failed to save recipe.");
      return;
    } else {
      recipeController.recipes.add(
        Recipe.getById(newRecipeId)!,
      ); // Add to the meal controller
    }

    Get.find<RootController>().handleBack();
    Get.snackbar("Success", "Recipe saved successfully!");
    resetData(); // Reset the form data
    // rootController.handleBack(); // Navigate back to the previous screen

    return; // Return the ID of the saved recipe
  }

  void resetData() {
    selectedImage.value = null;
    recipeNameController.text = '';
    descriptionController.text = '';
    cookingTimeController.text = '';
    instructionsController.text = '';
    difficulty.value = 'Easy';
    ingredients.clear();
    unitsList.clear();
  }
}