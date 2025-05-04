import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:pantrypal/models/meal_plan.dart';
import 'package:pantrypal/models/enums/meal_status.dart';
import 'package:pantrypal/controllers/plan/plan_controller.dart';

class HomeController extends GetxController {
  // t cần update meal plan nên phải put cái plan controller ở đây

  // final PlanController planController = Get.find<PlanController>();
  final PlanController planController = Get.put(
    PlanController(),
  ); // Lazy initialization
  var selectedMealIndex = 0.obs;
  var num = 1200.obs;

  var mealPlans = <MealPlan>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchMealPlans();

    planController.mealPlans.listen((mealPlans) {
      // Update the meal plans in this controller when they change in PlanController
      fetchMealPlans();
    });
  }

  void fetchMealPlans() {
    mealPlans.assignAll(MealPlan.sortByTimeOfDay(MealPlan.all()));
  }

  List<MealPlan> get filteredMealPlans {
    if (selectedMealIndex.value == 0) {
      // All meal plans
      return mealPlans;
    } else if (selectedMealIndex.value == 1) {
      // Upcoming (includes Ongoing)
      return mealPlans
          .where(
            (mealPlan) =>
                mealPlan.status == MealStatus.Upcoming ||
                mealPlan.status == MealStatus.Ongoing,
          )
          .toList();
    } else {
      // Completed
      return mealPlans
          .where((mealPlan) => mealPlan.status == MealStatus.Completed)
          .toList();
    }
  }

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
