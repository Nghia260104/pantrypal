import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  var selectedMealIndex = 0.obs;
  var num = 1200.obs;

  String getCurrentDate() {
    final now = DateTime.now();
    return DateFormat('EEEE, MMMM dd').format(now);
  }

  List<Map<String, dynamic>> mealBoxes = [
    {"title": "Breakfast", "status": "Completed"},
    {"title": "Lunch", "status": "Current"},
    {"title": "Dinner", "status": "Upcoming"},
  ];
}