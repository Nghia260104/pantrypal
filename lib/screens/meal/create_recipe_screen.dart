import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pantrypal/widgets/custom_dropdown_button.dart';

class CreateRecipeController extends GetxController {
  var selectedImage = Rx<XFile?>(null);
  var recipeName = ''.obs;
  var description = ''.obs;
  var cookingTime = ''.obs;
  var difficulty = 'Easy'.obs;
  var ingredients = <Map<String, dynamic>>[].obs;

  final ingredientNames = ["Ingredient 1", "Ingredient 2", "Ingredient 3"];
  final units = ["Unit 1", "Unit 2", "Unit 3"];

  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    selectedImage.value = image;
  }

  void addIngredient() {
    ingredients.add({
      "name": "Ingredient name".obs,
      "quantity": "",
      "unit": "Unit".obs,
    });
  }

  void removeIngredient(int index) {
    ingredients.removeAt(index);
  }
}

class CreateRecipeScreen extends StatelessWidget {
  final CreateRecipeController controller = Get.put(CreateRecipeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Create Recipe"),
        actions: [
          TextButton(
            onPressed: () {
              // Save logic here
            },
            child: Text("Save", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: controller.pickImage,
                child: Obx(() {
                  return Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: controller.selectedImage.value == null
                        ? Center(child: Icon(Icons.camera_alt, size: 50))
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
                          child: Text("Tap to add a photo"),
                        ),
                      )
                    : SizedBox.shrink();
              }),
              SizedBox(height: 16),
              Text("Recipe Name"),
              TextField(
                onChanged: (value) => controller.recipeName.value = value,
                decoration: InputDecoration(
                  hintText: "<Some food you recommend>",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text("Description"),
              TextField(
                maxLines: 3,
                onChanged: (value) => controller.description.value = value,
                decoration: InputDecoration(
                  hintText: "Description",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text("Preparation and Cooking Time"),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) => controller.cookingTime.value = value,
                      decoration: InputDecoration(
                        hintText: "Time",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text("min"),
                ],
              ),
              SizedBox(height: 16),
              Text("Difficulty"),
              CustomDropdownButton(
                selectedValue: controller.difficulty,
                items: ["Easy", "Medium", "Hard"],
                onChanged: (value) {
                  controller.difficulty.value = value;
                },
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Ingredients"),
                  TextButton(
                    onPressed: controller.addIngredient,
                    child: Text("+ Add"),
                  ),
                ],
              ),
              Obx(() {
                return Column(
                  children: controller.ingredients.asMap().entries.map((entry) {
                    int index = entry.key;
                    Map<String, dynamic> ingredient = entry.value;

                    // Access the reactive values directly
                    final RxString ingredientName = ingredient["name"];
                    final RxString ingredientUnit = ingredient["unit"];

                    return Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Ingredient Name Dropdown (Expanded)
                            Expanded(
                              child: CustomDropdownButton(
                                selectedValue: ingredientName, // Use RxString directly
                                items: controller.ingredientNames,
                                onChanged: (value) {
                                  ingredientName.value = value; // Update RxString
                                },
                              ),
                            ),
                            SizedBox(width: 8),
                            // Quantity Input (Fixed Width)
                            SizedBox(
                              width: 60,
                              height: 48,
                              child: TextField(
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                textAlignVertical: TextAlignVertical.center,
                                decoration: InputDecoration(
                                  hintText: "Qty",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 12), // Adjust padding
                                ),
                                onChanged: (value) {
                                  ingredient["quantity"] = value; // Update quantity
                                },
                                controller: TextEditingController(
                                  text: ingredient["quantity"],
                                )..selection = TextSelection.fromPosition(
                                    TextPosition(offset: ingredient["quantity"].length),
                                  ),
                              ),
                            ),
                            SizedBox(width: 8),
                            // Unit Dropdown (Fixed Width)
                            SizedBox(
                              width: 80,
                              child: CustomDropdownButton(
                                selectedValue: ingredientUnit, // Use RxString directly
                                items: controller.units,
                                isEnabled: ingredientName.value != "Ingredient name", // Disable if "Ingredient name"
                                onChanged: (value) {
                                  ingredientUnit.value = value; // Update RxString
                                },
                              ),
                            ),
                            SizedBox(width: 8),
                            // Delete Button (Reduced Size)
                            SizedBox(
                              width: 32,
                              height: 32,
                              child: IconButton(
                                icon: Icon(Icons.close, size: 18), // Reduced icon size
                                onPressed: () => controller.removeIngredient(index),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16), // Add spacing after each ingredient item
                      ],
                    );
                  }).toList(),
                );
              }),
              SizedBox(height: 16),
              Text("Instructions"),
              TextField(
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Instructions",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Save recipe logic here
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text("Save Recipe"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}