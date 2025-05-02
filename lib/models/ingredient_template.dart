import 'package:hive_ce/hive.dart';
import 'hive_manager.dart';
part 'ingredient_template.g.dart';

@HiveType(typeId: 3)
class IngredientTemplate extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String defaultUnit;

  @HiveField(3)
  final double caloriesPerUnit;

  @HiveField(4)
  final double proteinPerUnit;

  @HiveField(5)
  final double carbsPerUnit;

  @HiveField(6)
  final double fatPerUnit;

  IngredientTemplate({
    required this.id,
    required this.name,
    required this.defaultUnit,
    required this.proteinPerUnit,
    required this.carbsPerUnit,
    required this.fatPerUnit,
  }) : caloriesPerUnit =
           (4 * proteinPerUnit) + (4 * carbsPerUnit) + (9 * fatPerUnit);

  static const String boxName = 'ingredient_templates';

  /// Creates and stores a new [IngredientTemplate] in Hive.
  static Future<int> create(IngredientTemplate template) async {
    final box = Hive.box<IngredientTemplate>(boxName);

    // Get the next incremental ID
    final hiveManager = HiveManager();
    final id = await hiveManager.getNextId('lastIngredientTemplateId');

    // Assign the ID to the template
    final newTemplate = IngredientTemplate(
      id: id,
      name: template.name,
      defaultUnit: template.defaultUnit,
      proteinPerUnit: template.proteinPerUnit,
      carbsPerUnit: template.carbsPerUnit,
      fatPerUnit: template.fatPerUnit,
    );

    await box.put(newTemplate.id, newTemplate);

    return id;
  }

  /// Retrieves an [IngredientTemplate] by its [id].
  static IngredientTemplate? getById(int id) {
    final box = Hive.box<IngredientTemplate>(boxName);
    return box.get(id);
  }

  /// Returns all stored [IngredientTemplate]s.
  static List<IngredientTemplate> all() {
    final box = Hive.box<IngredientTemplate>(boxName);
    return box.values.toList();
  }

  static String getUnit(int id) {
    final box = Hive.box<IngredientTemplate>(boxName);
    final template = box.get(id);
    return template?.defaultUnit ?? 'unit'; // Default to 'unit' if not found
  }
}
