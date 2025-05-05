import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pantrypal/models/ingredient_template.dart';
import 'package:pantrypal/models/inventory_item.dart';

class IngredientsController extends GetxController {
  var selectedFilter = 'All'.obs;
  var ingredientTemplates =
      <IngredientTemplate>[].obs; // Observable list for ingredient templates
  var items =
      <Map<String, dynamic>>[].obs; // Observable list for inventory items
  var checkedItems = <String>{}.obs;
  var colorsList = <Color>[Colors.red, Colors.yellow, Colors.green].obs;

  @override
  void onInit() {
    super.onInit();
    _loadIngredients();
    _loadIngredientTemplates(); // Load ingredient templates
  }

  Future<void> _loadIngredientTemplates() async {
    final templates = IngredientTemplate.all();
    ingredientTemplates.value = templates; // Populate the observable list
  }

  /// Loads ingredients from local storage or initializes with sample data.
  Future<void> _loadIngredients() async {
    final storedInventoryItems =
        InventoryItem.all(); // Retrieve all inventory items from Hive

    if (storedInventoryItems.isEmpty) {
      // // If no inventory items exist, initialize with sample data (optional)
      // final sampleInventory = [
      //   InventoryItem(
      //     id: 1,
      //     template: IngredientTemplate(
      //       id: 1,
      //       name: 'Milk',
      //       defaultUnit: 'liters',
      //       proteinPerUnit: 3.4,
      //       carbsPerUnit: 4.8,
      //       fatPerUnit: 3.3,
      //     ),
      //     quantity: 2.0,
      //     expirationDate: DateTime.now().add(const Duration(days: 7)),
      //     dateAdded: DateTime.now(),
      //   ),
      //   InventoryItem(
      //     id: 2,
      //     template: IngredientTemplate(
      //       id: 2,
      //       name: 'Eggs',
      //       defaultUnit: 'pieces',
      //       proteinPerUnit: 6.0,
      //       carbsPerUnit: 0.6,
      //       fatPerUnit: 5.3,
      //     ),
      //     quantity: 12.0,
      //     expirationDate: DateTime.now().add(const Duration(days: 14)),
      //     dateAdded: DateTime.now(),
      //   ),
      // ];

      // for (var inventoryItem in sampleInventory) {
      //   await InventoryItem.create(
      //     inventoryItem,
      //   ); // Save sample inventory items to Hive
      // }

      // items.value =
      //     sampleInventory.map((inventoryItem) {
      //       return {
      //         'id': inventoryItem.id.toString(),
      //         'name': inventoryItem.template.name,
      //         'quantity': inventoryItem.quantity.toString(),
      //         'unit': inventoryItem.template.defaultUnit,
      //         'expirationDate': inventoryItem.expirationDate,
      //         'addedDate': inventoryItem.dateAdded,
      //         'usebyDate': inventoryItem.expirationDate != null,
      //       };
      //     }).toList();
    } else {
      // Load inventory items from Hive
      items.value =
          storedInventoryItems.map((inventoryItem) {
            return {
              'id': inventoryItem.id.toString(),
              'name': inventoryItem.template.name,
              'quantity': inventoryItem.quantity.toString(),
              'unit': inventoryItem.template.defaultUnit,
              'expirationDate': inventoryItem.expirationDate,
              'addedDate': inventoryItem.dateAdded,
              'usebyDate': inventoryItem.expirationDate != null,
            };
          }).toList();
    }
  }

  void toggleCheckbox(String itemId) {
    if (checkedItems.contains(itemId)) {
      checkedItems.remove(itemId);
    } else {
      checkedItems.add(itemId);
    }
  }

  Color getStatusColor(int status) {
    return colorsList[status % colorsList.length];
  }

  List<Map<String, dynamic>> getFilteredItems() {
    final now = DateTime.now();
    if (selectedFilter.value == 'All') {
      return [
        {
          'section': 'Past its use-by date',
          'items':
              items
                  .where((item) => item['usebyDate'] == true)
                  .where((item) {
                    final daysLeft =
                        item['expirationDate'] != null
                            ? item['expirationDate'].difference(now).inDays
                            : 0;
                    return daysLeft <= 0; // Expired items
                  })
                  .map((item) {
                    return {
                      ...item,
                      'status': 'Expired',
                      'statusColor': 0, // Red
                    };
                  })
                  .toList(),
        },
        {
          'section': 'Less than 3 days left',
          'items':
              items
                  .where((item) => item['usebyDate'] == true)
                  .where((item) {
                    final daysLeft =
                        item['expirationDate'] != null
                            ? item['expirationDate'].difference(now).inDays
                            : 0;
                    return daysLeft > 0 &&
                        daysLeft <= 3; // Items expiring within 3 days
                  })
                  .map((item) {
                    final daysLeft =
                        item['expirationDate'] != null
                            ? item['expirationDate'].difference(now).inDays
                            : 0;
                    return {
                      ...item,
                      'status': 'Expires in $daysLeft day(s)',
                      'statusColor': 1, // Yellow
                    };
                  })
                  .toList(),
        },
        {
          'section': '3 or more days left',
          'items':
              items
                  .where((item) => item['usebyDate'] == true)
                  .where((item) {
                    final daysLeft =
                        item['expirationDate'] != null
                            ? item['expirationDate'].difference(now).inDays
                            : 0;
                    return daysLeft > 3; // Items with more than 3 days left
                  })
                  .map((item) {
                    final daysLeft =
                        item['expirationDate'] != null
                            ? item['expirationDate'].difference(now).inDays
                            : 0;
                    return {
                      ...item,
                      'status': 'Expires in $daysLeft day(s)',
                      'statusColor': 2, // Green
                    };
                  })
                  .toList(),
        },
        {
          'section': 'No use-by date',
          'items':
              items.where((item) => item['usebyDate'] == false).map((item) {
                final daysStored = now.difference(item['addedDate']).inDays;
                return {
                  ...item,
                  'status': 'Stored for $daysStored day(s)',
                  'statusColor': 2, // Green for no use-by date
                };
              }).toList(),
        },
      ];
    } else if (selectedFilter.value == 'Use-by Date') {
      return [
        {
          'section': 'Past its use-by date',
          'items':
              items
                  .where((item) => item['usebyDate'] == true)
                  .where((item) {
                    final daysLeft =
                        item['expirationDate'] != null
                            ? item['expirationDate'].difference(now).inDays
                            : 0;
                    return daysLeft <= 0; // Expired items
                  })
                  .map((item) {
                    return {
                      ...item,
                      'status': 'Expired',
                      'statusColor': 0, // Red
                    };
                  })
                  .toList(),
        },
        {
          'section': 'Less than 3 days left',
          'items':
              items
                  .where((item) => item['usebyDate'] == true)
                  .where((item) {
                    final daysLeft =
                        item['expirationDate'] != null
                            ? item['expirationDate'].difference(now).inDays
                            : 0;
                    return daysLeft > 0 &&
                        daysLeft <= 3; // Items expiring within 3 days
                  })
                  .map((item) {
                    final daysLeft =
                        item['expirationDate'] != null
                            ? item['expirationDate'].difference(now).inDays
                            : 0;
                    return {
                      ...item,
                      'status': 'Expires in $daysLeft day(s)',
                      'statusColor': 1, // yellow
                    };
                  })
                  .toList(),
        },
        {
          'section': '3 or more days left',
          'items':
              items
                  .where((item) => item['usebyDate'] == true)
                  .where((item) {
                    final daysLeft =
                        item['expirationDate'] != null
                            ? item['expirationDate'].difference(now).inDays
                            : 0;
                    return daysLeft > 3; // Items with more than 3 days left
                  })
                  .map((item) {
                    final daysLeft =
                        item['expirationDate'] != null
                            ? item['expirationDate'].difference(now).inDays
                            : 0;
                    return {
                      ...item,
                      'status': 'Expires in $daysLeft day(s)',
                      'statusColor': 2, // Green
                    };
                  })
                  .toList(),
        },
      ];
    } else if (selectedFilter.value == 'No use-by') {
      return [
        {
          'section': 'No use-by date',
          'items':
              items.where((item) => item['usebyDate'] == false).map((item) {
                final daysStored = now.difference(item['addedDate']).inDays;
                return {
                  ...item,
                  'status': 'Stored for $daysStored day(s)',
                  'statusColor': 2, // Green for no use-by date
                };
              }).toList(),
        },
      ];
    } else {
      return [];
    }
  }

  void deleteCheckedItems() async {
    // Remove items from Hive
    for (var itemId in checkedItems) {
      final id = int.parse(itemId); // Convert the string ID back to an integer
      await InventoryItem.getById(
        id,
      )?.delete(); // Delete the inventory item from Hive
    }

    // Remove items from the in-memory list
    items.removeWhere((item) => checkedItems.contains(item['id']));

    // Clear the checked items
    checkedItems.clear();
  }
}
