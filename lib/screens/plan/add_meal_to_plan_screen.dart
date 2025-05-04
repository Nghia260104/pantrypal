import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pantrypal/controllers/root_controller.dart';
import 'package:pantrypal/core/theme/theme_colors.dart';
import 'package:pantrypal/models/recipe.dart' as ModelRecipe;
import 'package:pantrypal/models/meal_plan.dart';
import 'package:pantrypal/models/recipe_portion.dart';
import 'package:pantrypal/models/enums/meal_type.dart';
import 'package:pantrypal/controllers/plan/plan_controller.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:pantrypal/screens/plan/add_recipe_to_meal_plan_modal.dart';
import 'package:pantrypal/screens/plan/apply_template_to_meal_plan_modal.dart';
// import 'dart:io';

import 'package:pantrypal/widgets/custom_dropdown_button.dart';

class Recipe {
  RxString name;
  RxString description;
  RxInt calories;
  RxInt duration;
  RxInt servings;

  Recipe({
    required String name,
    required String description,
    required int calories,
    required int duration,
    int servings = 1,
  }) : name = name.obs,
       description = description.obs,
       calories = calories.obs,
       duration = duration.obs,
       servings = servings.obs;
}

class AddMealToPlanController extends GetxController {
  // var recipes = <Recipe>[].obs;
  // var recipes = <ModelRecipe.Recipe>[].obs;
  var recipeQuantities = <int>[].obs; // Store quantities for each recipe
  var selectedDate = DateTime.now().obs;
  var selectedTime = TimeOfDay(hour: 7, minute: 0).obs;
  var mealType = "Breakfast".obs;
  var recipes = <ModelRecipe.Recipe>[].obs; // List of selected recipes
  var mealTypeList = ["Breakfast", "Lunch", "Dinner", "Snack", "Dessert"];

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

  void applyTemplate(List<RecipePortion> portions) {
    recipes.clear();
    recipeQuantities.clear();
    for (var portion in portions) {
      recipes.add(portion.recipe);
      recipeQuantities.add(portion.quantity.toInt());
    }
    computeTotalNutrition();
  }

  // void addRecipe() {
  //   recipes.add(
  //     Recipe(
  //       name: "Recipe ${recipes.length + 1}",
  //       description: "Description of Recipe ${recipes.length + 1}",
  //       calories: 200,
  //       duration: 30,
  //     ),
  //   );
  // }

  // void removeRecipe(Recipe recipe) {
  //   recipes.remove(recipe);
  // }

  void removeRecipe(int index) {
    recipes.removeAt(index);
    recipeQuantities.removeAt(index);
    computeTotalNutrition();
  }

  // }
  // void removeRecipe(int index) {
  //   recipes.removeAt(index);
  //   recipeQuantities.removeAt(index);
  //   computeTotalNutrition();
  // }

  void increaseQuantity(int index) {
    recipeQuantities[index]++;
    computeTotalNutrition();
    // recipes[index].servings.value++;
  }

  void decreaseQuantity(int index) {
    if (recipeQuantities[index] > 1) {
      recipeQuantities[index]--;
      computeTotalNutrition();
    }
  }

  bool validateMealPlanForm() {
    if (recipes.isEmpty) {
      Get.snackbar(
        "Error",
        "At least one recipe must be added to the meal plan.",
      );
      return false;
    }
    return true; // Form is valid
  }

  Future<void> saveMealPlan() async {
    if (!validateMealPlanForm()) {
      return; // Stop if the form is invalid
    }

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

    // Create and save the MealPlan
    final mealPlan = await MealPlan.schedule(
      portions: portions,
      dateTime: selectedDate.value,
      type: MealType.values.firstWhere(
        (type) => type.toString() == "MealType.${mealType.value}",
      ),
      timeOfDay: selectedTime.value,
    );

    // if (mealPlan == null) {
    //   Get.snackbar("Error", "Failed to save meal plan.");
    //   return;
    // }

    // Notify PlanController to update the list
    Get.find<PlanController>().addMealPlan(mealPlan);
    Get.find<RootController>().handleBack();

    Get.snackbar("Success", "Meal plan saved successfully!");
    resetData();
  }

  void resetData() {
    recipes.clear();
    recipeQuantities.clear();
    selectedDate.value = DateTime.now();
    selectedTime.value = TimeOfDay(hour: 7, minute: 0);
    mealType.value = "Breakfast";
  }
}

class AddMealToPlanScreen extends StatelessWidget {
  final AddMealToPlanController controller = Get.put(AddMealToPlanController());
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
        title: Text("Add to Meal Plan"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 8.0,
            ), // Add padding to the right
            child: ElevatedButton(
              onPressed: () {
                controller.saveMealPlan();
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
                    Text(
                      "Date",
                      style: TextStyle(
                        fontSize: 18,
                        color: colors.textPrimaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        // final pickedDate = await showDatePicker(
                        //   context: context,
                        //   initialDate: DateTime.now(),
                        //   firstDate: DateTime(2000),
                        //   lastDate: DateTime(2100),
                        // );
                        // if (pickedDate != null) {
                        //   controller.selectedDate.value = pickedDate;
                        // }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: colors.secondaryButtonColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: colors.secondaryButtonContentColor.withAlpha(
                              50,
                            ),
                          ),
                        ),
                        width: double.infinity,
                        child: Obx(() {
                          return Text(
                            DateFormat(
                              'EEEE, MMMM d, yyyy',
                            ).format(controller.selectedDate.value.toLocal()),
                            style: TextStyle(
                              fontSize: 16,
                              color: colors.textPrimaryColor,
                            ),
                          );
                        }),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Time",
                      style: TextStyle(
                        fontSize: 18,
                        color: colors.textPrimaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    GestureDetector(
                      onTap: () async {
                        final pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          // Update the selected time in the controller
                          controller.selectedTime.value = pickedTime;
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: colors.secondaryButtonColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: colors.secondaryButtonContentColor.withAlpha(
                              50,
                            ),
                          ),
                        ),
                        width: double.infinity,
                        child: Obx(() {
                          // Format the selected time
                          final selectedTime = controller.selectedTime.value;
                          final formattedTime = selectedTime.format(
                            context,
                          ); // Format time as "hh:mm AM/PM"
                          return Text(
                            formattedTime,
                            style: TextStyle(
                              fontSize: 16,
                              color: colors.secondaryButtonContentColor,
                            ),
                          );
                        }),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Time
                    Text(
                      "Meal Type",
                      style: TextStyle(
                        fontSize: 18,
                        color: colors.textPrimaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    CustomDropdownButton(
                      selectedValue: controller.mealType,
                      items: controller.mealTypeList,
                      onChanged: (value) {
                        controller.mealType.value = value;
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
                      outlineColor: colors.secondaryButtonContentColor
                          .withAlpha(50),
                      outlineStroke: 0.5,
                    ),
                    SizedBox(height: 16),

                    // Recipes list
                    Text(
                      "Recipes",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: colors.textPrimaryColor,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // controller.addRecipe();
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder:
                                    (context) => AddRecipeToMealPlanModal(),
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
                              minimumSize: Size(
                                0,
                                50,
                              ), // Adjust horizontal size to make it smaller
                            ),
                            child: Text(
                              "Add Recipe",
                              style: TextStyle(
                                fontSize: 16,
                                color: colors.buttonContentColor,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder:
                                    (context) => ApplyTemplateToMealPlanModal(),
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
                                borderRadius: BorderRadius.circular(8),
                              ),
                              minimumSize: Size(0, 50),
                            ),
                            child: Text(
                              "Apply Template",
                              style: TextStyle(
                                fontSize: 16,
                                color: colors.buttonContentColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
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
                                                        fontSize: 20,
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
                                              Text(
                                                recipe.briefDescription,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: colors.hintTextColor,
                                                  fontSize: 16,
                                                  // fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text("Quantity:"),
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
