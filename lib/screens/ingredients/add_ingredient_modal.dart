import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pantrypal/controllers/ingredients/add_ingredients_modal_controller.dart';
import 'package:pantrypal/widgets/custom_dropdown_button.dart';
import 'package:pantrypal/core/theme/theme_colors.dart';
import 'package:pantrypal/controllers/ingredients/ingredients_controller.dart';
import 'package:pantrypal/models/ingredient_template.dart';
import 'package:pantrypal/models/inventory_item.dart';

class AddIngredientModal extends StatelessWidget {
  final controller = Get.find<IngredientsController>();
  final curController = Get.find<AddIngredientsModalController>();

  void closeModal(BuildContext context) {
    Navigator.of(context).pop();
  }

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
                      'Add Ingredient',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimaryColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => closeModal(context), // Close modal
                      child: Icon(Icons.close, color: colors.hintTextColor),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Tabs
                Obx(() {
                  return Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => curController.selectedTab.value = 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color:
                                  curController.selectedTab.value == 0
                                      ? colors.buttonColor
                                      : colors.backgroundColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                'Add to Pantry',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      curController.selectedTab.value == 0
                                          ? colors.buttonContentColor
                                          : colors.hintTextColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => curController.selectedTab.value = 1,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color:
                                  curController.selectedTab.value == 1
                                      ? colors.buttonColor
                                      : colors.backgroundColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                'Add New Type',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      curController.selectedTab.value == 1
                                          ? colors.buttonContentColor
                                          : colors.hintTextColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
                const SizedBox(height: 16),

                // Scrollable Content
                Flexible(
                  child: SingleChildScrollView(
                    child: Obx(() {
                      return curController.selectedTab.value == 0
                          ? _buildAddToPantryContent(context, colors)
                          : _buildAddNewTypeContent(context, colors);
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Content for "Add to Pantry" Tab
  Widget _buildAddToPantryContent(BuildContext context, ThemeColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Ingredient Dropdown
        Text(
          'Ingredient',
          style: TextStyle(fontSize: 16, color: colors.textPrimaryColor),
        ),
        const SizedBox(height: 8),
        CustomDropdownButton(
          selectedValue: curController.selectedIngredient,
          items:
              // controller.ingredientTemplates
              //     .map((template) => template.name)
              //     .toList(),
              controller.uniqueIngredientNames,
          onChanged: (value) {
            curController.selectedIngredient.value = value;
            curController.unitIndex.value = -1;
            curController.selectedUnit.value = 'Unit';
          },
          width: double.infinity,
          // height: 45,
          buttonColor: colors.secondaryButtonColor,
          outlineColor: colors.secondaryButtonContentColor.withAlpha(50),
          textStyle: TextStyle(fontSize: 16, color: colors.textPrimaryColor),
          selectedColor: colors.buttonColor,
          selectedText: TextStyle(
            color: colors.buttonContentColor,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 16),

        // Quantity
        Text(
          'Quantity',
          style: TextStyle(fontSize: 16, color: colors.textPrimaryColor),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: colors.secondaryButtonColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: colors.secondaryButtonContentColor.withAlpha(50),
                  ),
                ),
                child: TextField(
                  onChanged: (value) {
                    if (double.tryParse(value) != null) {
                      curController.selectedQuantity.value = value;
                    }
                  },
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter quantity',
                    hintStyle: TextStyle(color: colors.hintTextColor),
                  ),
                  style: TextStyle(
                    fontSize: 16,
                    color: colors.textPrimaryColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 100,
              child: CustomDropdownButton(
                selectedValue: curController.selectedUnit,
                selectedIndex: curController.unitIndex,
                items: 
                (curController.selectedIngredient.value != "Choose ingredient" &&
                        curController.selectedIngredient.value.isNotEmpty) 
                  ? [
                    for (
                      var template in controller.ingredientTemplatesMap[
                        curController.selectedIngredient.value
                      ]!
                    ) template.defaultUnit
                  ]
                  : [], // Example units
                onChanged: (value) => curController.selectedUnit.value = value,
                buttonColor: colors.secondaryButtonColor,
                outlineColor: colors.secondaryButtonContentColor.withAlpha(50),
                textStyle: TextStyle(
                  fontSize: 16,
                  color: colors.textPrimaryColor,
                ),
                selectedColor: colors.buttonColor,
                selectedText: TextStyle(
                  color: colors.buttonContentColor,
                  fontSize: 16,
                ),
                isEnabled:
                    (curController.selectedIngredient.value != "Choose ingredient" &&
                        curController.selectedIngredient.value.isNotEmpty),
                disabledTextStyle: TextStyle(
                  color: colors.hintTextColor,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Expiration Date
        Text(
          'Expiration Date',
          style: TextStyle(fontSize: 16, color: colors.textPrimaryColor),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    curController.selectedDate.value = pickedDate;
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: colors.secondaryButtonColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: colors.secondaryButtonContentColor.withAlpha(50),
                    ),
                  ),
                  // width: double.infinity,
                  child: Obx(() {
                    return Text(
                      curController.selectedDate.value != null
                          ? '${curController.selectedDate.value!.toLocal()}'.split(' ')[0]
                          : 'Select Date',
                      style: TextStyle(fontSize: 16, color: colors.textPrimaryColor),
                    );
                  }),
                ),
              ),
            ),
            SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                curController.selectedDate.value = null;
              },
              child: Icon(
                Icons.clear,
                color: colors.hintTextColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Confirm Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              if (curController.selectedIngredient.value.isEmpty ||
                  curController.selectedQuantity.value.isEmpty ||
                  curController.selectedUnit.value == 'Unit') {
                Get.snackbar(
                  'Error',
                  'Please fill in all fields',
                  snackPosition: SnackPosition.BOTTOM,
                );
                return;
              }

              // Add to Pantry Logic
              final controller = Get.find<IngredientsController>();

              try {
                // final template = controller.ingredientTemplates.firstWhere(
                //   (template) => template.name == selectedIngredient.value,
                // );
                final template = controller.ingredientTemplatesMap[
                  curController.selectedIngredient.value]![curController.unitIndex.value];

                // Create a new inventory item
                final newItem = InventoryItem(
                  id: 0,
                  template: template,
                  quantity: double.parse(curController.selectedQuantity.value),
                  expirationDate: curController.selectedDate.value,
                  dateAdded: DateTime.now(),
                );

                // Save to Hive
                final assignedId = await InventoryItem.create(newItem);

                // Update the controller
                final existingItemIndex = controller.items.indexWhere(
                  (item) =>
                      item['name'] == newItem.template.name &&
                      item['expirationDate'] == newItem.expirationDate,
                );

                if (existingItemIndex != -1) {
                  // Merge with the existing item
                  final existingItem = controller.items[existingItemIndex];
                  final updatedQuantity =
                      double.parse(existingItem['quantity']) + newItem.quantity;

                  controller.items[existingItemIndex] = {
                    ...existingItem,
                    'quantity': updatedQuantity.toString(),
                  };
                } else {
                  // Add as a new item
                  controller.items.add({
                    'id': assignedId.toString(),
                    'name': newItem.template.name,
                    'quantity': newItem.quantity.toString(),
                    'unit': newItem.template.defaultUnit,
                    'expirationDate': newItem.expirationDate,
                    'addedDate': newItem.dateAdded,
                    'usebyDate': newItem.expirationDate != null,
                  });
                }

                // Close modal
                closeModal(context);
              } catch (e) {
                Get.snackbar(
                  'Error',
                  'Selected ingredient template not found',
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.buttonColor,
              foregroundColor: colors.buttonContentColor,
            ),
            child: const Text('Add to Pantry'),
          ),
        ),
      ],
    );
  }

  // Content for "Create New Type" Tab
  Widget _buildAddNewTypeContent(BuildContext context, ThemeColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Ingredient Name
        Text(
          'Ingredient Name',
          style: TextStyle(fontSize: 16, color: colors.textPrimaryColor),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: colors.secondaryButtonColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: colors.secondaryButtonContentColor.withAlpha(50),
            ),
          ),
          child: TextField(
            onChanged: (value) => curController.newIngredientName.value = value,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Enter ingredient name',
              hintStyle: TextStyle(color: colors.hintTextColor),
            ),
            style: TextStyle(color: colors.textPrimaryColor),
          ),
        ),
        const SizedBox(height: 16),

        // Unit Dropdown
        Text(
          'Unit ("Unit" will be replaced with "item")',
          style: TextStyle(fontSize: 16, color: colors.textPrimaryColor),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: colors.secondaryButtonColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: colors.secondaryButtonContentColor.withAlpha(50),
            ),
          ),
          child: TextField(
            onChanged: (value) {
              curController.newUnit.value = value;
              if (value.toUpperCase() == 'UNIT') {
                curController.newUnit.value = 'item';
                curController.unitController.text = 'item';
                curController.unitController.selection = TextSelection.fromPosition(
                  TextPosition(offset: curController.unitController.text.length),
                );
              }
            },
            // onSubmitted: (value) {
            //   if (value.toUpperCase() == 'UNIT') {
            //     curController.newUnit.value = 'item';
            //     curController.unitController.text = 'item';
            //   }
            // },
            // onEditingComplete: () {
            //    if (curController.newUnit.value.toUpperCase() == 'UNIT') {
            //     curController.newUnit.value = 'item';
            //     curController.unitController.text = 'item';
            //     print('Unit changed to item');
            //   }
            // },
            controller: curController.unitController,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Enter your unit',
              hintStyle: TextStyle(color: colors.hintTextColor),
            ),
            style: TextStyle(color: colors.textPrimaryColor),
          ),
        ),
        const SizedBox(height: 16),

        // Nutritional Info
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Protein (g)',
                    style: TextStyle(
                      fontSize: 16,
                      color: colors.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: colors.secondaryButtonColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: colors.secondaryButtonContentColor.withAlpha(50),
                      ),
                    ),
                    child: TextField(
                      onChanged: (value) {
                        if (double.tryParse(value) != null) {
                          curController.protein.value = value;
                        }
                      },
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter protein',
                        hintStyle: TextStyle(color: colors.hintTextColor),
                      ),
                      style: TextStyle(
                        fontSize: 16,
                        color: colors.textPrimaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Carbs (g)',
                    style: TextStyle(
                      fontSize: 16,
                      color: colors.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: colors.secondaryButtonColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: colors.secondaryButtonContentColor.withAlpha(50),
                      ),
                    ),
                    child: TextField(
                      onChanged: (value) {
                        if (double.tryParse(value) != null) {
                          curController.carbs.value = value;
                        }
                      },
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter carbs',
                        hintStyle: TextStyle(color: colors.hintTextColor),
                      ),
                      style: TextStyle(
                        fontSize: 16,
                        color: colors.textPrimaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Fat Input
        Text(
          'Fat (g)',
          style: TextStyle(fontSize: 16, color: colors.textPrimaryColor),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: colors.secondaryButtonColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: colors.secondaryButtonContentColor.withAlpha(50),
            ),
          ),
          child: TextField(
            onChanged: (value) {
              if (double.tryParse(value) != null) {
                curController.fat.value = value;
              }
            },
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Enter fat',
              hintStyle: TextStyle(color: colors.hintTextColor),
            ),
            style: TextStyle(fontSize: 16, color: colors.textPrimaryColor),
          ),
        ),
        const SizedBox(height: 16),

        // Buttons
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  // Validate input
                  if (curController.newIngredientName.value.isEmpty ||
                      curController.protein.value.isEmpty ||
                      curController.carbs.value.isEmpty ||
                      curController.fat.value.isEmpty) {
                    Get.snackbar(
                      'Error',
                      'Please fill in all fields',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    return;
                  }

                  // Create new ingredient
                  final newIngredient = IngredientTemplate(
                    id: 0, // Unique ID
                    name: curController.newIngredientName.value,
                    defaultUnit: curController.newUnit.value,
                    proteinPerUnit: double.parse(curController.protein.value),
                    carbsPerUnit: double.parse(curController.carbs.value),
                    fatPerUnit: double.parse(curController.fat.value),
                  );

                  // Save to Hive
                  final assignedId = await IngredientTemplate.create(
                    newIngredient,
                  );

                  // Update the controller
                  final controller = Get.find<IngredientsController>();
                  controller.ingredientTemplatesMap.putIfAbsent(newIngredient.name, () => []);
                  controller.ingredientTemplatesMap[newIngredient.name]!.add(
                    IngredientTemplate(
                      id: assignedId, // Use the assigned ID
                      name: newIngredient.name,
                      defaultUnit: newIngredient.defaultUnit,
                      proteinPerUnit: newIngredient.proteinPerUnit,
                      carbsPerUnit: newIngredient.carbsPerUnit,
                      fatPerUnit: newIngredient.fatPerUnit,
                    ),
                  );
                  controller.ingredientTemplates.add(
                    IngredientTemplate(
                      id: assignedId, // Use the assigned ID
                      name: newIngredient.name,
                      defaultUnit: newIngredient.defaultUnit,
                      proteinPerUnit: newIngredient.proteinPerUnit,
                      carbsPerUnit: newIngredient.carbsPerUnit,
                      fatPerUnit: newIngredient.fatPerUnit,
                    ),
                  );
                  controller.uniqueIngredientNames.clear();
                  controller.uniqueIngredientNames.assignAll(
                    controller.ingredientTemplatesMap.keys.toList()
                  );

                  // Close modal
                  closeModal(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.buttonColor,
                  foregroundColor: colors.buttonContentColor,
                ),
                child: const Text('Create Type'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
