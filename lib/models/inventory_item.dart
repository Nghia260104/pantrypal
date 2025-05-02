import 'package:hive_ce/hive.dart';
import 'ingredient_template.dart';
import 'hive_manager.dart';
part 'inventory_item.g.dart';

@HiveType(typeId: 4)
class InventoryItem extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final IngredientTemplate template;

  @HiveField(2)
  double quantity;

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
  /// If an item with the same [template] and [expirationDate] already exists, it updates the quantity.
  /// Otherwise, it creates a new inventory item.
  static Future<int> create(InventoryItem newItem) async {
    final box = Hive.box<InventoryItem>(boxName);

    // Get the next incremental ID
    final hiveManager = HiveManager();
    final id = await hiveManager.getNextId('lastInventoryItemId');

    // Assign the ID to the new item
    final newInventoryItem = InventoryItem(
      id: id,
      template: newItem.template,
      quantity: newItem.quantity,
      expirationDate: newItem.expirationDate,
      dateAdded: newItem.dateAdded,
    );

    // Check if an inventory item with the same template and expiration date already exists
    final matches = box.values.where(
      (item) =>
          item.template.id == newInventoryItem.template.id &&
          item.expirationDate == newInventoryItem.expirationDate,
    );

    if (matches.isNotEmpty) {
      final existingItem = matches.first;
      existingItem.quantity += newInventoryItem.quantity;
      await existingItem.save();
    } else {
      await box.put(newInventoryItem.id, newInventoryItem);
    }

    return id;
  }

  /// Retrieves an [InventoryItem] by its [id].
  static InventoryItem? getById(int id) {
    final box = Hive.box<InventoryItem>(boxName);
    return box.get(id);
  }

  /// Retrieves an inventory item by the ID of its ingredient template.
  static InventoryItem? getByTemplateId(int templateId) {
    final box = Hive.box<InventoryItem>(boxName);
    try {
      return box.values.firstWhere(
        (item) => item.template.id == templateId,
        // if nothing matches, orElse is called. We throw here
        // so it flows into the catch and returns null.
        orElse: () => throw StateError('no matching item'),
      );
    } on StateError {
      return null;
    }
  }

  /// Returns all stored [InventoryItem]s.
  static List<InventoryItem> all() {
    final box = Hive.box<InventoryItem>(boxName);
    return box.values.toList();
  }

  /// Deletes an [InventoryItem] by its [id].
  static Future<void> remove(int id) async {
    final box = Hive.box<InventoryItem>(boxName);
    await box.delete(id); // Remove the inventory item using its ID as the key
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
