import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pantrypal/controllers/meal/meal_controller.dart';
import 'package:pantrypal/controllers/root_controller.dart';
import 'package:pantrypal/core/theme/theme_colors.dart';
import 'package:pantrypal/widgets/custom_dropdown_button.dart';
import 'package:pantrypal/models/ingredient_template.dart';
import 'package:pantrypal/models/recipe.dart';
import 'package:pantrypal/models/recipe_ingredient.dart';
import 'package:pantrypal/widgets/rounded_box.dart';
import 'package:pantrypal/controllers/ingredients/ingredients_controller.dart';

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
    });
  }

  void loadIngredientTemplates() {
    ingredientTemplates.assignAll(IngredientTemplate.all());
    // Group ingredient templates by name
    for (var ingredient in ingredientTemplates) {
      ingredientTemplatesMap.putIfAbsent(ingredient.name, () => []);
      ingredientTemplatesMap[ingredient.name]!.add(ingredient);
    }
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

class CreateRecipeScreen extends StatelessWidget {
  final CreateRecipeController controller = Get.put(CreateRecipeController());
  // final MealController mealController = Get.find<MealController>();
  final RootController rootController = Get.find<RootController>();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;

    return Scaffold(
      backgroundColor: colors.backgroundColor,
      appBar: AppBar(
        backgroundColor: colors.appbarColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => rootController.handleBack(),
        ),
        title: Text(
          "Create Recipe",
          style: TextStyle(
            color: colors.textPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 8.0,
            ), // Add padding to the right
            child: ElevatedButton(
              onPressed: () {
                controller.saveRecipe();
                rootController.handleBack();
              }, // Save recipe logic,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    colors.buttonColor, // Use buttonColor from ThemeColors
                foregroundColor:
                    colors
                        .buttonContentColor, // Use buttonContentColor for text
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    8,
                  ), // Rounded rectangle shape
                ),
                // maximumSize: Size(80, 40), // Adjust horizontal size to make it smaller
              ),
              child: Text("Save"),
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // Dismiss keyboard
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: controller.pickImage,
                  child: Obx(() {
                    return Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: colors.imagePickerColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child:
                          controller.selectedImage.value == null
                              ? Center(
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  size: 50,
                                  color: colors.hintTextColor,
                                ),
                              )
                              : ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Center(
                                  child: Image.file(
                                    File(controller.selectedImage.value!.path),
                                    fit: BoxFit.cover,
                                  ),
                                )
                              ),
                    );
                  }),
                ),
                Obx(() {
                  return controller.selectedImage.value == null
                      ? Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "Tap to add a photo",
                            style: TextStyle(
                              color: colors.hintTextColor,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      )
                      : SizedBox.shrink();
                }),
                SizedBox(height: 16),
                Text(
                  "Recipe Name",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: colors.textPrimaryColor,
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  // onChanged: (value) => controller.recipeName.value = value,
                  controller: controller.recipeNameController,
                  decoration: InputDecoration(
                    hintText: "e.g. Spaghetti Bolognese",
                    hintStyle: TextStyle(color: colors.hintTextColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: colors.secondaryButtonContentColor.withAlpha(50),
                        width: 0.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: colors.secondaryButtonContentColor.withAlpha(50),
                        width: 0.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: colors.secondaryButtonContentColor.withAlpha(50),
                        width: 0.5,
                      ),
                    ),
                    fillColor: colors.secondaryButtonColor,
                    filled: true,
                  ),
                  style: TextStyle(color: colors.secondaryButtonContentColor),
                ),
                SizedBox(height: 16),
                Text(
                  "Description",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: colors.textPrimaryColor,
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  maxLines: 3,
                  // onChanged: (value) => controller.description.value = value,
                  controller: controller.descriptionController,
                  decoration: InputDecoration(
                    hintText: "Briefly describe your recipe",
                    hintStyle: TextStyle(color: colors.hintTextColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: colors.secondaryButtonContentColor.withAlpha(50),
                        width: 0.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: colors.secondaryButtonContentColor.withAlpha(50),
                        width: 0.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: colors.secondaryButtonContentColor.withAlpha(50),
                        width: 0.5,
                      ),
                    ),
                    fillColor: colors.secondaryButtonColor,
                    filled: true,
                  ),
                  style: TextStyle(color: colors.secondaryButtonContentColor),
                ),
                SizedBox(height: 16),
                Text(
                  "Preparation and Cooking Time",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: colors.textPrimaryColor,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: controller.cookingTimeController,
                        // onChanged:
                        //     (value) => controller.cookingTime.value = value,
                        decoration: InputDecoration(
                          hintText: "Time",
                          hintStyle: TextStyle(color: colors.hintTextColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: colors.secondaryButtonContentColor
                                  .withAlpha(50),
                              width: 0.5,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: colors.secondaryButtonContentColor
                                  .withAlpha(50),
                              width: 0.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: colors.secondaryButtonContentColor
                                  .withAlpha(50),
                              width: 0.5,
                            ),
                          ),
                          fillColor: colors.secondaryButtonColor,
                          filled: true,
                        ),
                        style: TextStyle(
                          color: colors.secondaryButtonContentColor,
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Text(
                      "min",
                      style: TextStyle(
                        fontSize: 16,
                        color: colors.textPrimaryColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  "Difficulty",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: colors.textPrimaryColor,
                  ),
                ),
                SizedBox(height: 8),
                CustomDropdownButton(
                  selectedValue: controller.difficulty,
                  items: ["Easy", "Medium", "Hard"],
                  onChanged: (value) {
                    controller.difficulty.value = value;
                  },
                  textStyle: TextStyle(
                    color: colors.secondaryButtonContentColor,
                    fontSize: 16,
                  ),
                  buttonColor: colors.secondaryButtonColor,
                  selectedColor: colors.buttonColor,
                  selectedText: TextStyle(
                    color: colors.buttonContentColor,
                    fontSize: 16,
                  ),
                  outlineColor: colors.secondaryButtonContentColor.withAlpha(
                    50,
                  ),
                  outlineStroke: 0.5,
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Ingredients",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: colors.textPrimaryColor,
                      ),
                    ),
                    TextButton(
                      onPressed: controller.addIngredient,
                      child: Text(
                        "+ Add",
                        style: TextStyle(
                          color: colors.textPrimaryColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                Obx(() {
                  return Column(
                    children:
                        controller.ingredients.asMap().entries.map((entry) {
                          int index = entry.key;
                          Map<String, dynamic> ingredient = entry.value;

                          final RxString name = ingredient["name"];
                          final RxString quantity = ingredient["quantity"];
                          final RxString unit = ingredient["unit"];
                          final RxInt unitIndex = ingredient["unitIndex"];
                          // final RxInt unitIndex = (-1).obs;
                          // print(ingredient["unitIndex"]);
                          return Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Ingredient Name Dropdown (Expanded)
                                  Expanded(
                                    // child: DropdownButton<String>(
                                    //   value: template.value?.name,
                                    //   items:
                                    //       controller.uniqueIngredientNames.map((
                                    //         name,
                                    //       ) {
                                    //         return DropdownMenuItem(
                                    //           value: name,
                                    //           child: Text(name),
                                    //         );
                                    //       }).toList(),
                                    //   onChanged: (value) {
                                    //     if (value != null) {
                                    //       final templates = controller
                                    //           .getTemplatesByName(value);
                                    //       template.value = templates.first;

                                    //       // Update the units dynamically
                                    //       controller.units.assignAll(
                                    //         templates
                                    //             .map((t) => t.defaultUnit)
                                    //             .toSet()
                                    //             .toList(),
                                    //       );

                                    //       // Set the default unit to the first one in the list
                                    //       unit.value = controller.units.first;
                                    //     }
                                    //   },
                                    // ),
                                    child: CustomDropdownButton(
                                      selectedValue: name,
                                      items: controller.uniqueIngredientNames,
                                      onChanged: (value) {
                                        name.value = value;
                                        var curUnitsList =
                                            controller.unitsList[index];
                                        curUnitsList.clear();
                                        final curList =
                                            controller
                                                .ingredientTemplatesMap[value]!;
                                        for (
                                          int i = 0;
                                          i < curList.length;
                                          i++
                                        ) {
                                          curUnitsList.add(
                                            curList[i].defaultUnit,
                                          );
                                        }
                                      },
                                      textStyle: TextStyle(
                                        color:
                                            colors.secondaryButtonContentColor,
                                        fontSize: 16,
                                      ),
                                      buttonColor: colors.secondaryButtonColor,
                                      selectedColor: colors.buttonColor,
                                      selectedText: TextStyle(
                                        color: colors.buttonContentColor,
                                        fontSize: 16,
                                      ),
                                      outlineColor: colors
                                          .secondaryButtonContentColor
                                          .withAlpha(50),
                                      outlineStroke: 0.5,
                                    ),
                                  ),
                                  SizedBox(width: 8),

                                  // Quantity Input (Fixed Width)
                                  RoundedBox(
                                    width: 60,
                                    height: 49,
                                    padding: EdgeInsets.zero,
                                    color: colors.secondaryButtonColor,
                                    child: TextField(
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        quantity.value = value;
                                      },
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      decoration: InputDecoration(
                                        hintText: "Qty",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          borderSide: BorderSide(
                                            color: colors
                                                .secondaryButtonContentColor
                                                .withAlpha(50),
                                            width: 0.5,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          borderSide: BorderSide(
                                            color: colors
                                                .secondaryButtonContentColor
                                                .withAlpha(50),
                                            width: 0.5,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          borderSide: BorderSide(
                                            color: colors
                                                .secondaryButtonContentColor
                                                .withAlpha(50),
                                            width: 0.5,
                                          ),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 14,
                                        ),
                                        fillColor: colors.secondaryButtonColor,
                                        filled: true,
                                      ),
                                      controller: TextEditingController(
                                          text: quantity.value,
                                        )
                                        ..selection =
                                            TextSelection.fromPosition(
                                              TextPosition(
                                                offset: quantity.value.length,
                                              ),
                                            ),
                                    ),
                                  ),
                                  SizedBox(width: 8),

                                  // Unit Dropdown (Fixed Width)
                                  SizedBox(
                                    width: 80,
                                    child: CustomDropdownButton(
                                      selectedValue: unit,
                                      selectedIndex: unitIndex,
                                      items: controller.unitsList[index],
                                      onChanged: (value) {
                                        unit.value = value;
                                      },
                                      isEnabled:
                                          (name.value != "Ingredient Name"),
                                      disabledTextStyle: TextStyle(
                                        color: colors.hintTextColor,
                                        fontSize: 16,
                                      ),
                                      textStyle: TextStyle(
                                        color:
                                            colors.secondaryButtonContentColor,
                                        fontSize: 16,
                                      ),
                                      buttonColor: colors.secondaryButtonColor,
                                      selectedColor: colors.buttonColor,
                                      selectedText: TextStyle(
                                        color: colors.buttonContentColor,
                                        fontSize: 16,
                                      ),
                                      outlineColor: colors
                                          .secondaryButtonContentColor
                                          .withAlpha(50),
                                      outlineStroke: 0.5,
                                    ),
                                  ),
                                  SizedBox(width: 8),

                                  // Delete Button (Reduced Size)
                                  SizedBox(
                                    width: 32,
                                    height: 32,
                                    child: IconButton(
                                      icon: Icon(Icons.close, size: 18),
                                      onPressed:
                                          () => controller.removeIngredient(
                                            index,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ), // Add spacing after each ingredient item
                            ],
                          );
                        }).toList(),
                  );
                }),
                SizedBox(height: 8),
                Text(
                  "Instructions",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: colors.textPrimaryColor,
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  maxLines: 3,
                  controller: controller.instructionsController,
                  decoration: InputDecoration(
                    hintText: "Instructions",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: colors.secondaryButtonContentColor.withAlpha(50),
                        width: 0.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: colors.secondaryButtonContentColor.withAlpha(50),
                        width: 0.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: colors.secondaryButtonContentColor.withAlpha(50),
                        width: 0.5,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 12,
                    ), // Adjust padding
                    fillColor: colors.secondaryButtonColor,
                    filled: true,
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Save recipe logic here
                    controller.saveRecipe();
                    rootController.handleBack();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        colors.buttonColor, // Use buttonColor from ThemeColors
                    foregroundColor:
                        colors
                            .buttonContentColor, // Use buttonContentColor for text
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text("Save Recipe"),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
