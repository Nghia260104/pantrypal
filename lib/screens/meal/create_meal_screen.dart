import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pantrypal/controllers/root_controller.dart';
import 'package:pantrypal/core/theme/theme_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CreateMealScreen extends StatelessWidget {
  final CreateMealController controller = Get.put(CreateMealController());
  final RootController rootController = Get.find<RootController>();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => rootController.handleBack(),
        ),
        title: Text("Create Meal"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0), // Add padding to the right
            child: ElevatedButton(
              onPressed: () {
                // Save logic here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.buttonColor, // Use buttonColor from ThemeColors
                foregroundColor: colors.buttonContentColor, // Use buttonContentColor for text
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Rounded rectangle shape
                ),
                // maximumSize: Size(80, 40), // Adjust horizontal size to make it smaller
              ),
              child: Text("Save"),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                    child: controller.selectedImage.value == null
                        ? Center(child: Icon(Icons.camera_alt_outlined, size: 50, color: colors.hintTextColor))
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(controller.selectedImage.value!.path),
                              fit: BoxFit.cover,
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
              SizedBox(height: 8),
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
                  hintStyle: TextStyle(
                    color: colors.hintTextColor,
                  ),
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
                  hintStyle: TextStyle(
                    color: colors.hintTextColor,
                  ),
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
                      controller.addRecipe();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.buttonColor, // Use buttonColor from ThemeColors
                      foregroundColor: colors.buttonContentColor, // Use buttonContentColor for text
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // Rounded rectangle shape
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
                    )
                  );
                }
                return Column(
                  children: controller.recipes.map((recipe) {
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
                              color: colors.secondaryButtonContentColor.withAlpha(50),
                              width: 1,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                margin: const EdgeInsets.only(top: 4.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            recipe.name.value,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: colors.textPrimaryColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
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
                                              color: colors.normalIconColor,  
                                            ),
                                            onPressed: () => controller.removeRecipe(recipe),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Quantity:"),
                                        Row(
                                          children: [
                                            Container(
                                              width: 32, // Reduced width
                                              height: 32, // Reduced height
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: colors.secondaryButtonContentColor
                                                      .withAlpha(50),
                                                  width: 1,
                                                ),
                                                shape: BoxShape.circle,
                                              ),
                                              child: IconButton(
                                                icon: Icon(
                                                  Icons.remove,
                                                  color: colors.secondaryButtonContentColor,
                                                  size: 20,
                                                ),
                                                onPressed: () => controller.decreaseQuantity(recipe),
                                                constraints: BoxConstraints(
                                                  minWidth: 32, // Match the container size
                                                  minHeight: 32, // Match the container size
                                                ),
                                                padding:
                                                    EdgeInsets.zero, // Remove extra padding
                                              ),
                                            ),
                                            Obx(() {
                                              return Padding(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                ),
                                                child: Text(
                                                  recipe.quantity.value.toString(),
                                                  style: TextStyle(
                                                    color: colors.textPrimaryColor,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              );
                                            }),
                                            Container(
                                              width: 32, // Reduced width
                                              height: 32, // Reduced height
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: colors.secondaryButtonContentColor
                                                      .withAlpha(50),
                                                  width: 1,
                                                ),
                                                shape: BoxShape.circle,
                                              ),
                                              child: IconButton(
                                                icon: Icon(
                                                  Icons.add,
                                                  color: colors.secondaryButtonContentColor,
                                                  size: 20,
                                                ),
                                                onPressed: () => controller.increaseQuantity(recipe),
                                                constraints: BoxConstraints(
                                                  minWidth: 32, // Match the container size
                                                  minHeight: 32, // Match the container size
                                                ),
                                                padding:
                                                    EdgeInsets.zero, // Remove extra padding
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
                        SizedBox(height: 8,),
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
                        children: List.generate(4, (index) {
                          return Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 4),
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  Text("Title $index"),
                                  Text("Value $index"),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class CreateMealController extends GetxController {
  var imagePath = ''.obs;
  var recipes = <Recipe>[].obs;
  var selectedImage = Rx<XFile?>(null);
  TextEditingController mealNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  void addRecipe() {
    // Implement add recipe logic
    // recipes.add(Recipe(name: "New Recipeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee", quantity: 1));
    recipes.add(Recipe(name: "New Recipe", quantity: 1));
  }

  void removeRecipe(Recipe recipe) {
    recipes.remove(recipe);
  }

  void decreaseQuantity(Recipe recipe) {
    // Implement decrease quantity logic
    if (recipe.quantity > 1) {
      recipe.quantity.value--;
    }
  }

  void increaseQuantity(Recipe recipe) {
    // Implement increase quantity logic
    if (recipe.quantity < 10) {
      recipe.quantity.value++;
    }
  }

  void saveMeal() {
    // Implement save meal logic
  }

  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    selectedImage.value = image;
  }
}

class Recipe {
  RxString name;
  RxInt quantity;

  Recipe({required String name, required int quantity})
      : name = name.obs,
        quantity = quantity.obs;
}