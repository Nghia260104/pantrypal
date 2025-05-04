import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pantrypal/controllers/meal/meal_controller.dart';
import 'package:pantrypal/core/theme/theme_colors.dart';
import 'package:pantrypal/widgets/rounded_box.dart';

import 'package:pantrypal/models/recipe.dart' as ModelRecipe;

class ApplyTemplateToMealPlanModal extends StatelessWidget {
  final ApplyTemplateToMealPlanController controller = Get.put(
    ApplyTemplateToMealPlanController(),
  );

  // @override
  // Widget build(BuildContext context) {
  //   final double maxHeight = MediaQuery.of(context).size.height * 0.7;

  // return Padding(
  //   padding: const EdgeInsets.all(16.0),
  //   child: Container(
  //     constraints: BoxConstraints(maxHeight: maxHeight),
  //     child: Column(
  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             GestureDetector(
  //               onTap: () => Get.back(),
  //               child: Icon(Icons.close),
  //             ),
  //             Text(
  //               "Add Recipe to Meal",
  //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //             ),
  //             SizedBox(width: 24), // Placeholder for alignment
  //           ],
  //         ),
  //         SizedBox(height: 16),
  //         Obx(() => TabBar(
  //               controller: controller.tabController,
  //               tabs: [
  //                 Tab(text: "All"),
  //                 Tab(text: "Favorites"),
  //               ],
  //             )),
  //         SizedBox(height: 16),
  //         Expanded(
  //           child: Obx(() => ListView.separated(
  //                 itemCount: controller.recipes.length,
  //                 separatorBuilder: (_, __) => SizedBox(height: 8),
  //                 itemBuilder: (context, index) {
  //                   final recipe = controller.recipes[index];
  //                   return Container(
  //                     padding: EdgeInsets.all(12),
  //                     decoration: BoxDecoration(
  //                       color: Colors.white,
  //                       borderRadius: BorderRadius.circular(12),
  //                       boxShadow: [
  //                         BoxShadow(
  //                           color: Colors.black12,
  //                           blurRadius: 4,
  //                           offset: Offset(0, 2),
  //                         ),
  //                       ],
  //                     ),
  //                     child: Row(
  //                       crossAxisAlignment: CrossAxisAlignment.center,
  //                       children: [
  //                         Container(
  //                           width: 50,
  //                           height: 50,
  //                           color: Colors.grey[300],
  //                         ),
  //                         SizedBox(width: 12),
  //                         Expanded(
  //                           child: Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               Text(
  //                                 recipe.title,
  //                                 maxLines: 2,
  //                                 overflow: TextOverflow.ellipsis,
  //                                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //                               ),
  //                               SizedBox(height: 4),
  //                               Text(
  //                                 recipe.description,
  //                                 maxLines: 1,
  //                                 overflow: TextOverflow.ellipsis,
  //                                 style: TextStyle(fontSize: 14, color: Colors.grey[600]),
  //                               ),
  //                               SizedBox(height: 8),
  //                               Row(
  //                                 children: recipe.tags.map((tag) {
  //                                   return Container(
  //                                     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  //                                     margin: EdgeInsets.only(right: 8),
  //                                     decoration: BoxDecoration(
  //                                       color: Colors.blue[100],
  //                                       borderRadius: BorderRadius.circular(16),
  //                                     ),
  //                                     child: Text(
  //                                       tag,
  //                                       style: TextStyle(fontSize: 12, color: Colors.blue[800]),
  //                                     ),
  //                                   );
  //                                 }).toList(),
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                         ElevatedButton(
  //                           onPressed: () => controller.addRecipeToMeal(recipe),
  //                           child: Text("Add"),
  //                         ),
  //                       ],
  //                     ),
  //                   );
  //                 },
  //               )),
  //         ),
  //       ],
  //     ),
  //   ),
  // );
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Dismiss the keyboard
      },
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight:
                MediaQuery.of(context).size.height *
                0.7, // Limit modal height to 70% of screen height
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Modal Header with Close Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 24), // Placeholder for alignment
                    Text(
                      'Add Recipe to Meal',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimaryColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(), // Close modal
                      child: Icon(Icons.close, color: colors.hintTextColor),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(2, (index) {
                      final isSelected = controller.selectedTab.value == index;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            controller.toggleTab(index);
                          },
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              RoundedBox(
                                padding: const EdgeInsets.all(12),
                                borderRadius: 0,
                                width: double.infinity,
                                outlineStroke: 0,
                                outlineColor:
                                    isSelected
                                        ? colors.appbarColor
                                        : Colors.transparent,
                                color:
                                    isSelected
                                        ? colors.appbarColor
                                        : Colors.transparent,
                                child: Center(
                                  child: Text(
                                    controller.titles[index],
                                    style: TextStyle(
                                      color:
                                          isSelected
                                              ? colors.selectedNavColor
                                              : colors.hintTextColor,
                                    ),
                                  ),
                                ),
                              ),
                              if (isSelected)
                                Container(
                                  height: 2,
                                  decoration: BoxDecoration(
                                    color: colors.selectedNavColor,
                                  ),
                                  // width: double.infinity,
                                ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 8),
                Flexible(
                  child: Obx(
                    () => ListView.separated(
                      shrinkWrap: true,
                      itemCount: controller.recipes.length,
                      separatorBuilder: (_, __) => SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final recipe = controller.recipes[index];
                        return GestureDetector(
                          onTap: () {
                            controller.applyTemplateToMealPlan(recipe);
                            // Get.back(); // Close modal after adding
                          },
                          child: Container(
                            padding: EdgeInsets.only(
                              left: 12,
                              right: 4,
                              top: 12,
                              bottom: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  color: Colors.grey[300],
                                  margin: const EdgeInsets.only(top: 4.0),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        recipe.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        recipe.briefDescription,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        children:
                                            recipe.tags.map((tag) {
                                              return Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 2,
                                                ),
                                                margin: EdgeInsets.only(
                                                  right: 8,
                                                ),
                                                decoration: BoxDecoration(
                                                  color:
                                                      colors
                                                          .secondaryButtonColor,
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  border: Border.all(
                                                    color: colors
                                                        .secondaryButtonContentColor
                                                        .withAlpha(50),
                                                    width: 1.0,
                                                  ),
                                                ),
                                                child: Text(
                                                  tag,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color:
                                                        colors
                                                            .secondaryButtonContentColor,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ApplyTemplateToMealPlanController extends GetxController{
  // var recipes = <Recipe>[].obs;

  final MealController mealController = Get.find<MealController>();
  var recipes = <ModelRecipe.Recipe>[].obs;
  var selectedTab = 0.obs;
  final titles = ["All", "Favorites"];

  @override
  void onInit() {
    super.onInit();
    fetchRecipes();

    mealController.recipes.listen((templates) {
      // Update the ingredient templates when they change
      fetchRecipes();
    });
  }

  void toggleTab(int index) => selectedTab.value = index;

  void fetchRecipes() {
    // Simulate fetching recipes
    // recipes.value = [
    //   Recipe(
    //     title: "Spaghetti Carbonara",
    //     description: "A classic Italian pasta dish.",
    //     tags: ["Pasta", "Italian"],
    //   ),
    //   Recipe(
    //     title: "Chicken Salad",
    //     description: "A healthy and delicious salad.",
    //     tags: ["Salad", "Healthy"],
    //   ),
    // ];
    recipes.assignAll(ModelRecipe.Recipe.all());
  }

  // void addRecipeToMeal(Recipe recipe) {
  //   // Handle adding recipe to meal
  //   print("Added ${recipe.title} to meal");
  // }

  void applyTemplateToMealPlan(ModelRecipe.Recipe recipe) {
    // Get.find<CreateMealController>().addRecipe(recipe);
    Get.back(); // Close modal after adding
  }
}

// class Recipe {
//   final String title;
//   final String description;
//   final List<String> tags;

//   Recipe({required this.title, required this.description, required this.tags});
// }
