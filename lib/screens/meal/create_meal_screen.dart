import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pantrypal/controllers/root_controller.dart';
import 'package:pantrypal/core/theme/theme_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:pantrypal/screens/meal/add_recipe_to_meal_modal.dart';

import 'package:pantrypal/models/recipe.dart' as ModelRecipe;
import 'package:pantrypal/controllers/meal/meal_controller.dart';

import 'package:pantrypal/models/meal.dart';
// import 'package:pantrypal/models/recipe.dart';
import 'package:pantrypal/models/recipe_portion.dart';

class CreateMealScreen extends StatelessWidget {
  final CreateMealController controller = Get.put(CreateMealController());
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
        title: Text("Create Meal"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 8.0,
            ), // Add padding to the right
            child: ElevatedButton(
              onPressed: () {
                controller.saveMeal();
                // rootController.handleBack();
                // Save logic here
              },
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
        onTap:
            () => FocusScope.of(context).unfocus(), // Dismiss keyboard on tap
        child: Column(
          children: [
            Divider(height: 1, color: colors.hintTextColor.withAlpha(75)),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: controller.pickImage,
                      child: Obx(() {
                        return Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color:
                                controller.selectedImage.value == null
                                    ? colors.imagePickerColor
                                    : Colors.transparent,
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
                                      child: Container(
                                        color: Colors.transparent,
                                        child: Image.file(
                                          File(
                                            controller
                                                .selectedImage
                                                .value!
                                                .path,
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
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
                      "Meal Information",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimaryColor,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Meal Name*",
                      style: TextStyle(
                        fontSize: 16,
                        color: colors.textPrimaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: controller.mealNameController,
                      decoration: InputDecoration(
                        hintText: "e.g., Lovely Breakfast",
                        hintStyle: TextStyle(color: colors.hintTextColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: colors.secondaryButtonContentColor.withAlpha(
                              50,
                            ),
                            width: 0.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: colors.secondaryButtonContentColor.withAlpha(
                              50,
                            ),
                            width: 0.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: colors.secondaryButtonContentColor.withAlpha(
                              50,
                            ),
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
                    SizedBox(height: 16),
                    Text(
                      "Description (Optional)",
                      style: TextStyle(
                        fontSize: 16,
                        color: colors.textPrimaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      maxLines: 3,
                      controller: controller.descriptionController,
                      decoration: InputDecoration(
                        hintText: "Briefly describe your meal",
                        hintStyle: TextStyle(color: colors.hintTextColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: colors.secondaryButtonContentColor.withAlpha(
                              50,
                            ),
                            width: 0.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: colors.secondaryButtonContentColor.withAlpha(
                              50,
                            ),
                            width: 0.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: colors.secondaryButtonContentColor.withAlpha(
                              50,
                            ),
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
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Recipes",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: colors.textPrimaryColor,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Save logic here
                            // controller.addRecipe();
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (context) => AddRecipeToMealModal(),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                colors
                                    .buttonColor, // Use buttonColor from ThemeColors
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
                          child: Text("Add"),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Obx(() {
                      if (controller.recipes.isEmpty) {
                        return Center(
                          child: Text(
                            "No recipes added yet",
                            style: TextStyle(
                              color: colors.hintTextColor,
                              fontSize: 16,
                            ),
                          ),
                        );
                      }
                      return Column(
                        children:
                            List.generate(controller.recipes.length, (index) {
                              final recipe = controller.recipes[index];
                              return Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: colors.secondaryButtonColor,
                                      borderRadius: BorderRadius.circular(8.0),
                                      // boxShadow: [
                                      //   BoxShadow(
                                      //     color: Colors.grey.withAlpha(127),
                                      //     spreadRadius: 1,
                                      //     blurRadius: 3,
                                      //     offset: const Offset(0, 2),
                                      //   ),
                                      // ],
                                      border: Border.all(
                                        color: colors
                                            .secondaryButtonContentColor
                                            .withAlpha(50),
                                        width: 1,
                                      ),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 60,
                                          height: 60,
                                          margin: const EdgeInsets.only(
                                            top: 4.0,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      recipe.name,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color:
                                                            colors
                                                                .textPrimaryColor,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 24,
                                                    width: 24,
                                                    child: IconButton(
                                                      padding: EdgeInsets.zero,
                                                      icon: Icon(
                                                        Icons.close,
                                                        color:
                                                            colors
                                                                .normalIconColor,
                                                      ),
                                                      onPressed:
                                                          () => controller
                                                              .removeRecipe(
                                                                index,
                                                              ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 4),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Quantity:",
                                                    style: TextStyle(
                                                      color:
                                                          colors
                                                              .textPrimaryColor,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        width:
                                                            32, // Reduced width
                                                        height:
                                                            32, // Reduced height
                                                        decoration: BoxDecoration(
                                                          border: Border.all(
                                                            color: colors
                                                                .secondaryButtonContentColor
                                                                .withAlpha(50),
                                                            width: 1,
                                                          ),
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        child: IconButton(
                                                          icon: Icon(
                                                            Icons.remove,
                                                            color:
                                                                colors
                                                                    .secondaryButtonContentColor,
                                                            size: 20,
                                                          ),
                                                          onPressed:
                                                              () => controller
                                                                  .decreaseQuantity(
                                                                    index,
                                                                  ),
                                                          constraints: BoxConstraints(
                                                            minWidth:
                                                                32, // Match the container size
                                                            minHeight:
                                                                32, // Match the container size
                                                          ),
                                                          padding:
                                                              EdgeInsets
                                                                  .zero, // Remove extra padding
                                                        ),
                                                      ),
                                                      Obx(() {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                horizontal: 12,
                                                              ),
                                                          child: Text(
                                                            controller
                                                                .recipeQuantities[index]
                                                                .toString(),
                                                            style: TextStyle(
                                                              color:
                                                                  colors
                                                                      .textPrimaryColor,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                      Container(
                                                        width:
                                                            32, // Reduced width
                                                        height:
                                                            32, // Reduced height
                                                        decoration: BoxDecoration(
                                                          border: Border.all(
                                                            color: colors
                                                                .secondaryButtonContentColor
                                                                .withAlpha(50),
                                                            width: 1,
                                                          ),
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        child: IconButton(
                                                          icon: Icon(
                                                            Icons.add,
                                                            color:
                                                                colors
                                                                    .secondaryButtonContentColor,
                                                            size: 20,
                                                          ),
                                                          onPressed:
                                                              () => controller
                                                                  .increaseQuantity(
                                                                    index,
                                                                  ),
                                                          constraints: BoxConstraints(
                                                            minWidth:
                                                                32, // Match the container size
                                                            minHeight:
                                                                32, // Match the container size
                                                          ),
                                                          padding:
                                                              EdgeInsets
                                                                  .zero, // Remove extra padding
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                ],
                              );
                            }).toList(),
                      );
                    }),
                    Obx(() {
                      if (controller.recipes.isEmpty) return SizedBox.shrink();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 16),
                          Text("Meal Summary"),
                          SizedBox(height: 8),
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Calories",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: colors.textPrimaryColor,
                                      ),
                                    ),
                                    Obx(
                                      () => Text(
                                        "${controller.totalCalories.value.toStringAsFixed(0)} cal",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: colors.textPrimaryColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Protein",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: colors.textPrimaryColor,
                                      ),
                                    ),
                                    Obx(
                                      () => Text(
                                        "${controller.totalProtein.value.toStringAsFixed(1)} g",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: colors.textPrimaryColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Carbs",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: colors.textPrimaryColor,
                                      ),
                                    ),
                                    Obx(
                                      () => Text(
                                        "${controller.totalCarbs.value.toStringAsFixed(1)} g",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: colors.textPrimaryColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Fat",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: colors.textPrimaryColor,
                                      ),
                                    ),
                                    Obx(
                                      () => Text(
                                        "${controller.totalFat.value.toStringAsFixed(1)} g",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: colors.textPrimaryColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CreateMealController extends GetxController {
  var imagePath = ''.obs;
  // var recipes = <Recipe>[].obs;
  var recipes = <ModelRecipe.Recipe>[].obs;
  var recipeQuantities = <int>[].obs; // Store quantities for each recipe
  var selectedImage = Rx<XFile?>(null);

  MealController mealController = Get.find<MealController>();

  TextEditingController mealNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  // Reactive variables for total nutrition
  var totalCalories = 0.0.obs;
  var totalProtein = 0.0.obs;
  var totalCarbs = 0.0.obs;
  var totalFat = 0.0.obs;

  // @override
  // void onInit() {
  //   super.onInit();
  //   // Recompute totals whenever recipes or quantities change
  //   // recipes.listen((_) => computeTotalNutrition());
  //   // recipeQuantities.listen((_) => computeTotalNutrition());
  // }

  // Method to compute total nutrition
  void computeTotalNutrition() {
    double calories = 0, protein = 0, carbs = 0, fat = 0;

    for (int i = 0; i < recipes.length; i++) {
      final recipe = recipes[i];
      final quantity = recipeQuantities[i];

      calories += recipe.calories * quantity;
      protein += recipe.protein * quantity;
      carbs += recipe.carbs * quantity;
      fat += recipe.fat * quantity;
    }

    totalCalories.value = calories;
    totalProtein.value = protein;
    totalCarbs.value = carbs;
    totalFat.value = fat;
  }

  // var recipePortions = <Map<String, dynamic>>[].obs;
  // var availableRecipes = <Recipe>[].obs; // List of available recipes

  // @override
  // void onInit() {
  //   super.onInit();
  //   loadAvailableRecipes();
  // }

  // void loadAvailableRecipes() {
  //   // Load recipes from the database or controller
  //   availableRecipes.assignAll(Recipe.all());
  // }

  void addRecipe(ModelRecipe.Recipe recipe) {
    recipes.add(recipe);
    recipeQuantities.add(1); // Default quantity
    computeTotalNutrition();
  }

  // void removeRecipe(Recipe recipe) {
  //   recipes.remove(recipe);
  // }

  void removeRecipe(int index) {
    recipes.removeAt(index);
    recipeQuantities.removeAt(index);
    computeTotalNutrition();
  }

  // void decreaseQuantity(Recipe recipe) {
  //   // Implement decrease quantity logic
  //   if (recipe.quantity > 1) {
  //     recipe.quantity.value--;
  //   }
  // }

  // void increaseQuantity(Recipe recipe) {
  //   // Implement increase quantity logic
  //   if (recipe.quantity < 10) {
  //     recipe.quantity.value++;
  //   }
  // }

  void increaseQuantity(int index) {
    recipeQuantities[index]++;
    computeTotalNutrition();
  }

  void decreaseQuantity(int index) {
    if (recipeQuantities[index] > 1) {
      recipeQuantities[index]--;
      computeTotalNutrition();
    }
  }

  bool validateMealForm() {
    if (mealNameController.text.trim().isEmpty) {
      Get.snackbar("Error", "Meal name is required.");
      return false;
    }

    if (recipes.isEmpty) {
      Get.snackbar("Error", "At least one recipe must be added to the meal.");
      return false;
    }

    return true; // Form is valid
  }

  Future<void> saveMeal() async {
    if (!validateMealForm()) {
      return; // Stop if the form is invalid
    }

    // Use default description if the field is empty
    final description =
        descriptionController.text.trim().isEmpty
            ? "No description for this meal..."
            : descriptionController.text.trim();

    // Create RecipePortions
    List<RecipePortion> portions = [];
    for (int i = 0; i < recipes.length; i++) {
      portions.add(
        RecipePortion(
          recipe: recipes[i],
          quantity: recipeQuantities[i].toDouble(),
        ),
      );
    }

    // Create and save the Meal
    final newMeal = Meal(
      id: 0, // Temporary ID, will be replaced by Hive
      name: mealNameController.text,
      description: description,
      portions: portions,
      image: selectedImage.value?.path,
    );

    final newMealId = await Meal.create(newMeal);

    if (newMealId == -1) {
      Get.snackbar("Error", "Failed to save meal.");
      return;
    } else {
      mealController.meals.add(
        Meal.getById(newMealId)!,
      ); // Add to the meal controller
    }

    Get.find<RootController>().handleBack();

    Get.snackbar("Success", "Meal saved successfully!");
    resetData();
  }

  void resetData() {
    recipes.clear();
    recipeQuantities.clear();
    mealNameController.clear();
    descriptionController.clear();
    selectedImage.value = null;
  }

  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    selectedImage.value = image;
  }
}

// class Recipe {
//   RxString name;
//   RxInt quantity;

//   Recipe({required String name, required int quantity})
//     : name = name.obs,
//       quantity = quantity.obs;
// }
