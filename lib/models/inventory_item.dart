import 'package:hive_ce/hive.dart';
import 'ingredient_template.dart';

part 'inventory_item.g.dart';

@HiveType(typeId: 4)
class InventoryItem extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final IngredientTemplate template;

  @HiveField(2)
  final double quantity;

  @HiveField(3)
  final DateTime? expirationDate;

  @HiveField(4)
  final DateTime dateAdded;

  InventoryItem({
    required this.id,
    required this.template,
    required this.quantity,
    this.expirationDate,
    required this.dateAdded,
  });

  static const String boxName = 'inventory_items';

  /// Creates and stores a new [InventoryItem] in Hive.
  static Future<void> create(InventoryItem item) async {
    final box = Hive.box<InventoryItem>(boxName);
    await box.put(item.id, item);
  }

  /// Retrieves an [InventoryItem] by its [id].
  static InventoryItem? getById(int id) {
    final box = Hive.box<InventoryItem>(boxName);
    return box.get(id);
  }

  /// Returns all stored [InventoryItem]s.
  static List<InventoryItem> all() {
    final box = Hive.box<InventoryItem>(boxName);
    return box.values.toList();
  }

  /// Computes total nutrition based on [quantity] and its [template]'s values.
  Map<String, double> totals() {
    return {
      'calories': template.caloriesPerUnit * quantity,
      'protein': template.proteinPerUnit * quantity,
      'carbs': template.carbsPerUnit * quantity,
      'fat': template.fatPerUnit * quantity,
    };
  }
}
