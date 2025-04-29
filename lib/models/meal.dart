import 'package:hive_ce/hive.dart';
import 'recipe.dart';
import '../models/enums/meal_type.dart';
import '../models/enums/meal_status.dart';

part 'meal.g.dart';

@HiveType(typeId: 7)
class Meal extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  MealType type;

  @HiveField(2)
  DateTime dateTime;

  @HiveField(3)
  MealStatus status;

  @HiveField(4)
  final List<Recipe> recipes;

  Meal({
    required this.id,
    required this.type,
    required this.dateTime,
    required this.status,
    required this.recipes,
  });

  static const String boxName = 'meals';

  /// Schedules a new [Meal] and stores it in Hive.
  static Future<Meal> scheduleRecipes({
    required int id,
    required List<Recipe> recipes,
    required DateTime dateTime,
    required MealType type,
  }) async {
    final meal = Meal(
      id: id,
      type: type,
      dateTime: dateTime,
      status: MealStatus.Upcoming,
      recipes: recipes,
    );
    final box = Hive.box<Meal>(boxName);
    await box.put(meal.id, meal);
    return meal;
  }

  /// Returns the list of scheduled recipes.
  List<Recipe> getRecipes() => recipes;

  /// Updates the status of this meal and persists the change.
  Future<void> updateStatus(MealStatus newStatus) async {
    status = newStatus;
    await save();
  }

  /// Retrieves a [Meal] by its [id].
  static Meal? getById(int id) {
    final box = Hive.box<Meal>(boxName);
    return box.get(id);
  }

  /// Returns all stored [Meal]s.
  static List<Meal> all() {
    final box = Hive.box<Meal>(boxName);
    return box.values.toList();
  }
}
