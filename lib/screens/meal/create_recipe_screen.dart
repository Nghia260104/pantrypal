import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pantrypal/controllers/root_controller.dart';
import 'package:pantrypal/core/theme/theme_colors.dart';
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
                  "Recipe Name",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: colors.textPrimaryColor,
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  onChanged: (value) => controller.recipeName.value = value,
                  decoration: InputDecoration(
                    hintText: "e.g. Spaghetti Bolognese",
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
                  onChanged: (value) => controller.description.value = value,
                  decoration: InputDecoration(
                    hintText: "Briefly describe your recipe",
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
                        onChanged: (value) => controller.cookingTime.value = value,
                        decoration: InputDecoration(
                          hintText: "Time",
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
                  outlineColor: colors.secondaryButtonContentColor.withAlpha(50),
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
                                  outlineColor: colors.secondaryButtonContentColor.withAlpha(50),
                                  outlineStroke: 0.5,
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
                                    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 12), // Adjust padding
                                    fillColor: colors.secondaryButtonColor,
                                    filled: true,
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
                                  outlineColor: colors.secondaryButtonContentColor.withAlpha(50),
                                  outlineStroke: 0.5,
                                  disabledTextStyle: TextStyle(
                                    color: colors.hintTextColor,
                                    fontSize: 16,
                                  ),
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
                          SizedBox(height: 8), // Add spacing after each ingredient item
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
                    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 12), // Adjust padding
                    fillColor: colors.secondaryButtonColor,
                    filled: true,
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Save recipe logic here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.buttonColor, // Use buttonColor from ThemeColors
                    foregroundColor: colors.buttonContentColor, // Use buttonContentColor for text
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