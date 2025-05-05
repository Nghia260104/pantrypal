import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pantrypal/screens/ingredients/add_ingredient_modal.dart';
import 'package:pantrypal/widgets/custom_dropdown_button.dart';
import 'package:pantrypal/core/theme/theme_colors.dart';
import 'package:pantrypal/controllers/ingredients/ingredients_controller.dart';

class IngredientsScreen extends StatelessWidget {
  final IngredientsController controller = Get.put(IngredientsController());

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    controller.colorsList.value = [
      colors.badStatusColor,
      colors.warningStatusColor,
      colors.goodStatusColor,
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.appbarColor,
        title: Text(
          'Inventory',
          style: TextStyle(
            color: colors.textPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: colors.backgroundColor,
      body: Stack(
        children: [
          Column(
            children: [
              Divider(height: 1, color: colors.hintTextColor.withAlpha(75)),
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(
                      () => Text(
                        '${controller.items.length} item(s)',
                        style: TextStyle(
                          fontSize: 18,
                          color: colors.textPrimaryColor,
                        ),
                      ),
                    ),
                    CustomDropdownButton(
                      selectedValue:
                          controller
                              .selectedFilter, // Pass the reactive variable
                      items: [
                        'All',
                        'Use-by Date',
                        'No use-by-date',
                      ], // Dropdown items
                      onChanged: (value) {
                        controller.selectedFilter.value =
                            value; // Update the selected filter
                      },
                      width: 150, // Set the width of the dropdown button
                      height: 45, // Set the height of the dropdown button
                      textStyle: TextStyle(
                        fontSize: 16,
                        color: colors.hintTextColor,
                      ), // Customize text style
                      selectedText: TextStyle(
                        fontSize: 16,
                        color: colors.buttonContentColor,
                      ),
                      selectedColor: colors.buttonColor,
                      buttonColor:
                          colors
                              .secondaryButtonColor, // Set the button background color
                      outlineColor:
                          colors
                              .secondaryButtonContentColor, // Set the outline color
                      iconColor:
                          colors
                              .secondaryButtonContentColor, // Set the dropdown arrow color
                      outlineStroke: 0.5,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: Obx(() {
                  final sections = controller.getFilteredItems();
                  return ListView.builder(
                    itemCount:
                        sections.length +
                        1, // Add 1 to include the SizedBox at the end
                    itemBuilder: (context, index) {
                      if (index == sections.length) {
                        // Add a SizedBox at the end
                        return const SizedBox(
                          height: 80,
                        ); // Adjust the height as needed
                      }

                      final section = sections[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                section['section'],
                                style: TextStyle(
                                  fontSize: 18,
                                  color: colors.hintTextColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            ...section['items'].map<Widget>((item) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: colors.secondaryButtonColor,
                                    borderRadius: BorderRadius.circular(8.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withAlpha(127),
                                        spreadRadius: 1,
                                        blurRadius: 3,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 4,
                                    vertical: 6,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 50,
                                        height: 50,
                                        margin: const EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item['name'],
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                                color: colors.textPrimaryColor,
                                              ),
                                            ),
                                            Text(
                                              item['status'],
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: controller
                                                    .getStatusColor(
                                                      item['statusColor'],
                                                    ),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap:
                                            () => controller.toggleCheckbox(
                                              item['id'],
                                            ),
                                        child: Obx(() {
                                          final isChecked = controller
                                              .checkedItems
                                              .contains(item['id']);
                                          return Container(
                                            width: 18,
                                            height: 18,
                                            decoration: BoxDecoration(
                                              color:
                                                  isChecked
                                                      ? colors.buttonColor
                                                      : Colors.transparent,
                                              border: Border.all(
                                                color: colors.buttonColor,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                            ),
                                            child:
                                                isChecked
                                                    ? Icon(
                                                      Icons.check,
                                                      color:
                                                          colors
                                                              .buttonContentColor,
                                                      size: 14,
                                                    )
                                                    : null,
                                          );
                                        }),
                                      ),
                                      const SizedBox(width: 8.0),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                            SizedBox(height: 8),
                          ],
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      final checkedItems =
                          controller.checkedItems
                              .toList(); // Get the list of checked items
                      if (checkedItems.isNotEmpty) {
                        _showDeleteConfirmationModal(
                          context,
                          checkedItems,
                        ); // Show the modal
                      } else {
                        Get.rawSnackbar(
                          messageText: Center(
                            child: Text(
                              'No items selected',
                              style: TextStyle(
                                fontSize: 16,
                                color: colors.dangerButtonContentColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: colors.warningStatusColor,
                          margin: const EdgeInsets.only(
                            bottom: 80,
                            left: 16,
                            right: 16,
                          ), // Position above the bottom navigation
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ), // Add padding inside the box
                          borderRadius: 16, // Rounded corners
                          maxWidth:
                              200, // Make it fit within 90% of the screen width
                          boxShadows: [
                            BoxShadow(
                              color: Colors.black.withAlpha(50),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                          duration: const Duration(milliseconds: 1250),
                          isDismissible: true,
                        );
                      }
                    },
                    backgroundColor: colors.dangerButtonColor,
                    child: Icon(
                      Icons.delete,
                      color: colors.dangerButtonContentColor,
                    ),
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      // Handle add button press
                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) => AddIngredientModal(),
                      );
                    },
                    backgroundColor: colors.buttonColor,
                    child: Icon(Icons.add, color: colors.buttonContentColor),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationModal(
    BuildContext context,
    List<String> checkedItems,
  ) {
    final colors = Theme.of(context).extension<ThemeColors>()!;

    showDialog(
      context: context,
      barrierDismissible: true, // Allow dismissing the modal by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            'Delete Items',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colors.textPrimaryColor,
            ),
          ),
          content: Text(
            'Are you sure you want to delete ${checkedItems.length} selected item(s)?',
            style: TextStyle(fontSize: 16, color: colors.hintTextColor),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the modal
              },
              child: Text(
                'Cancel',
                style: TextStyle(fontSize: 16, color: colors.textPrimaryColor),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle delete action
                controller
                    .deleteCheckedItems(); // Call the delete method in the controller
                Navigator.of(context).pop(); // Close the modal
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    colors.dangerButtonColor, // Highlight the delete button
                foregroundColor: colors.dangerButtonContentColor, // Text color
              ),
              child: Text(
                'Delete',
                style: TextStyle(
                  color: colors.dangerButtonContentColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
