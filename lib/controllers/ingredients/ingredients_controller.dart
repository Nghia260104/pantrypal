import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IngredientsController extends GetxController {
  var selectedFilter = 'All'.obs;
  var items = <Map<String, dynamic>>[
    {'id': '1', 'name': 'Milk', 'addedDate': DateTime.now().subtract(const Duration(days: 5)), 'usebyDate': true},
    {'id': '2', 'name': 'Eggs', 'addedDate': DateTime.now().subtract(const Duration(days: 2)), 'usebyDate': true},
    {'id': '3', 'name': 'Bread', 'addedDate': DateTime.now().subtract(const Duration(days: 1)), 'usebyDate': true},
    {'id': '4', 'name': 'Butter', 'addedDate': DateTime.now(), 'usebyDate': false},
    {'id': '5', 'name': 'Cheese', 'addedDate': DateTime.now().subtract(const Duration(days: 10)), 'usebyDate': true},
  ].obs; // Example data
  var checkedItems = <String>{}.obs;
  var colorsList = <Color>[Colors.red, Colors.yellow, Colors.green].obs;

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
          'items': items.where((item) => item['usebyDate'] && item['addedDate'].isBefore(now.subtract(const Duration(days: 7)))).map((item) {
            return {
              ...item,
              'status': 'Past its use-by date',
              'statusColor': 0,
            };
          }).toList(),
        },
        {
          'section': 'Less than 3 days left',
          'items': items.where((item) => item['usebyDate'] && item['addedDate'].isAfter(now.subtract(const Duration(days: 7))) && item['addedDate'].isBefore(now.subtract(const Duration(days: 3)))).map((item) {
            final daysLeft = 7 - now.difference(item['addedDate']).inDays;
            return {
              ...item,
              'status': '$daysLeft day(s) left',
              'statusColor': 1,
            };
          }).toList(),
        },
        {
          'section': '3 or more days left',
          'items': items.where((item) => item['usebyDate'] && item['addedDate'].isAfter(now.subtract(const Duration(days: 3)))).map((item) {
            final daysLeft = 7 - now.difference(item['addedDate']).inDays;
            return {
              ...item,
              'status': '$daysLeft day(s) left',
              'statusColor': 2,
            };
          }).toList(),
        },
        {
          'section': 'No use-by date',
          'items': items.where((item) => !item['usebyDate']).map((item) {
            final daysStored = now.difference(item['addedDate']).inDays;
            return {
              ...item,
              'status': 'Stored in $daysStored day(s)',
              'statusColor': 2,
            };
          }).toList(),
        },
      ];
    } else if (selectedFilter.value == 'Use-by Date') {
      return [
        {
          'section': 'Past its use-by date',
          'items': items.where((item) => item['usebyDate'] && item['addedDate'].isBefore(now.subtract(const Duration(days: 7)))).map((item) {
            return {
              ...item,
              'status': 'Past its use-by date',
              'statusColor': 0,
            };
          }).toList(),
        },
        {
          'section': 'Less than 3 days left',
          'items': items.where((item) => item['usebyDate'] && item['addedDate'].isAfter(now.subtract(const Duration(days: 7))) && item['addedDate'].isBefore(now.subtract(const Duration(days: 3)))).map((item) {
            final daysLeft = 7 - now.difference(item['addedDate']).inDays;
            return {
              ...item,
              'status': '$daysLeft day(s) left',
              'statusColor': 1,
            };
          }).toList(),
        },
        {
          'section': '3 or more days left',
          'items': items.where((item) => item['usebyDate'] && item['addedDate'].isAfter(now.subtract(const Duration(days: 3)))).map((item) {
            final daysLeft = 7 - now.difference(item['addedDate']).inDays;
            return {
              ...item,
              'status': '$daysLeft day(s) left',
              'statusColor': 2,
            };
          }).toList(),
        },
      ];
    } else {
      return [
        {
          'section': 'No use-by date',
          'items': items.where((item) => !item['usebyDate']).map((item) {
            final daysStored = now.difference(item['addedDate']).inDays;
            return {
              ...item,
              'status': 'Stored in $daysStored day(s)',
              'statusColor': 2,
            };
          }).toList(),
        },
      ];
    }
  }

  void deleteCheckedItems() {
    items.removeWhere((item) => checkedItems.contains(item['id']));
    checkedItems.clear();
  }
}