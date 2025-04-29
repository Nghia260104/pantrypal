import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pantrypal/widgets/custom_dropdown_button.dart';
import 'package:pantrypal/core/theme/theme_colors.dart';

class AddIngredientModal extends StatelessWidget {
  final RxInt selectedTab = 0.obs; // 0 for "Add to Pantry", 1 for "Create New Type"
  final RxString selectedIngredient = ''.obs;
  final RxString selectedQuantity = '1'.obs;
  final RxString selectedUnit = 'kg'.obs;
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);

  final RxString newIngredientName = ''.obs;
  final RxString newUnit = 'kg'.obs;
  final RxString calories = ''.obs;
  final RxString protein = ''.obs;
  final RxString carbs = ''.obs;
  final RxString fat = ''.obs;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Dismiss the keyboard
      },
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: SingleChildScrollView(
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
                      onTap: () => Navigator.of(context).pop(), // Close modal
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
                          onTap: () => selectedTab.value = 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: selectedTab.value == 0
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
                                  color: selectedTab.value == 0
                                      ? colors.buttonContentColor
                                      : colors.hintTextColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => selectedTab.value = 1,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: selectedTab.value == 1
                                  ? colors.buttonColor
                                  : colors.backgroundColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                'Create New Type',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: selectedTab.value == 1
                                      ? colors.buttonContentColor
                                      : colors.hintTextColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
                const SizedBox(height: 16),

                // Tab Content
                Obx(() {
                  return selectedTab.value == 0
                      ? _buildAddToPantryContent(context, colors)
                      : _buildCreateNewTypeContent(context, colors);
                }),
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
          selectedValue: selectedIngredient,
          items: ['Apple', 'Banana', 'Carrot', 'Potato', 'A', 'B', 'C'], // Example items
          onChanged: (value) => selectedIngredient.value = value,
          width: double.infinity,
          height: 45,
          buttonColor: colors.secondaryButtonColor,
          outlineColor: colors.secondaryButtonContentColor.withAlpha(50),
          // outlineStroke: 0.5,
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
                  border: Border.all(color: colors.secondaryButtonContentColor.withAlpha(50)),
                ),
                child: TextField(
                    onChanged: (value) {
                      // Validate and update the quantity
                      if (double.tryParse(value) != null) {
                        selectedQuantity.value = value;
                      }
                    },
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter quantity',
                      hintStyle: TextStyle(
                        color: colors.hintTextColor,
                      ),
                    ),
                    style: TextStyle(fontSize: 16, color: colors.textPrimaryColor),
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 100,
              child: CustomDropdownButton(
                selectedValue: selectedUnit,
                items: ['kg', 'g', 'lb'], // Example units
                onChanged: (value) => selectedUnit.value = value,
                buttonColor: colors.secondaryButtonColor,
                outlineColor: colors.secondaryButtonContentColor.withAlpha(50),
                // outlineStroke: 0.5,
                textStyle: TextStyle(fontSize: 16, color: colors.textPrimaryColor),
                selectedColor: colors.buttonColor,
                selectedText: TextStyle(
                  color: colors.buttonContentColor,
                  fontSize: 16
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
        GestureDetector(
          onTap: () async {
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (pickedDate != null) {
              selectedDate.value = pickedDate;
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: colors.secondaryButtonColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colors.secondaryButtonContentColor.withAlpha(50)),
            ),
            width: double.infinity,
            child: Obx(() {
              return Text(
                selectedDate.value != null
                    ? '${selectedDate.value!.toLocal()}'.split(' ')[0]
                    : 'Select Date',
                style: TextStyle(fontSize: 16, color: colors.textPrimaryColor),
              );
            }),
          ),
        ),
        const SizedBox(height: 16),

        // Confirm Button
        SizedBox(
          width: double.infinity, // Make the button take the full width
          child: ElevatedButton(
            onPressed: () {
              // Handle Add to Pantry logic
              Navigator.of(context).pop(); // Close modal
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
  Widget _buildCreateNewTypeContent(BuildContext context, ThemeColors colors) {
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
            border: Border.all(color: colors.secondaryButtonContentColor.withAlpha(50)),
          ),
          child: TextField(
            onChanged: (value) => newIngredientName.value = value,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Enter ingredient name',
              hintStyle: TextStyle(
                color: colors.hintTextColor,
              )
            ),
            style: TextStyle(
              color: colors.textPrimaryColor,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Unit Dropdown
        Text(
          'Unit',
          style: TextStyle(fontSize: 16, color: colors.textPrimaryColor),
        ),
        const SizedBox(height: 8),
        CustomDropdownButton(
          selectedValue: newUnit,
          items: ['kg', 'g', 'lb'], // Example units
          onChanged: (value) => newUnit.value = value,
          buttonColor: colors.secondaryButtonColor,
          outlineColor: colors.secondaryButtonContentColor.withAlpha(50),
          // outlineStroke: 0.5,
          textStyle: TextStyle(fontSize: 16, color: colors.textPrimaryColor),
          selectedColor: colors.buttonColor,
          selectedText: TextStyle(
            color: colors.buttonContentColor,
            fontSize: 16
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
                    'Calories (per unit)',
                    style: TextStyle(fontSize: 16, color: colors.textPrimaryColor),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: colors.secondaryButtonColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: colors.secondaryButtonContentColor.withAlpha(50)),
                    ),
                    child: TextField(
                      onChanged: (value) {
                        if (double.tryParse(value) != null) {
                          calories.value = value;
                        }
                      },
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter calories',
                        hintStyle: TextStyle(color: colors.hintTextColor),
                      ),
                      style: TextStyle(fontSize: 16, color: colors.textPrimaryColor),
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
                    'Protein (g)',
                    style: TextStyle(fontSize: 16, color: colors.textPrimaryColor),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: colors.secondaryButtonColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: colors.secondaryButtonContentColor.withAlpha(50)),
                    ),
                    child: TextField(
                      onChanged: (value) {
                        if (double.tryParse(value) != null) {
                          protein.value = value;
                        }
                      },
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter protein',
                        hintStyle: TextStyle(color: colors.hintTextColor),
                      ),
                      style: TextStyle(fontSize: 16, color: colors.textPrimaryColor),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Carbs (g)',
                    style: TextStyle(fontSize: 16, color: colors.textPrimaryColor),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: colors.secondaryButtonColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: colors.secondaryButtonContentColor.withAlpha(50)),
                    ),
                    child: TextField(
                      onChanged: (value) {
                        if (double.tryParse(value) != null) {
                          carbs.value = value;
                        }
                      },
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter carbs',
                        hintStyle: TextStyle(color: colors.hintTextColor),
                      ),
                      style: TextStyle(fontSize: 16, color: colors.textPrimaryColor),
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
                    'Fat (g)',
                    style: TextStyle(fontSize: 16, color: colors.textPrimaryColor),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: colors.secondaryButtonColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: colors.secondaryButtonContentColor.withAlpha(50)),
                    ),
                    child: TextField(
                      onChanged: (value) {
                        if (double.tryParse(value) != null) {
                          fat.value = value;
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
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Buttons
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Handle Create Type logic
                  Navigator.of(context).pop(); // Close modal
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.secondaryButtonColor,
                  foregroundColor: colors.secondaryButtonContentColor,
                ),
                child: const Text('Create Type'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Handle Create & Add to Pantry logic
                  Navigator.of(context).pop(); // Close modal
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.buttonColor,
                  foregroundColor: colors.buttonContentColor,
                ),
                child: const Text(
                  'Create & Add to Pantry',
                  textAlign: TextAlign.center, // Center-align the text
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}