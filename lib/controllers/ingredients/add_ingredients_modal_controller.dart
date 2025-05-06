import 'package:get/get.dart';

class AddIngredientsModalController extends GetxController {
  final RxInt selectedTab =
      0.obs; // 0 for "Add to Pantry", 1 for "Create New Type"
  final RxString selectedIngredient = 'Choose ingredient'.obs;
  final RxString selectedQuantity = ''.obs;
  final RxString selectedUnit = 'Unit'.obs;
  final unitIndex = (-1).obs; // Index for the selected unit
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);

  final RxString newIngredientName = ''.obs;
  final RxString newUnit = 'kg'.obs;
  final RxString calories = ''.obs;
  final RxString protein = ''.obs;
  final RxString carbs = ''.obs;
  final RxString fat = ''.obs;
}