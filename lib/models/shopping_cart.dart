import 'package:hive_ce/hive.dart';
import 'ingredient_template.dart';
import 'cart_item.dart';

part 'shopping_cart.g.dart';

@HiveType(typeId: 10)
class ShoppingCart extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final DateTime createdDate;

  @HiveField(2)
  final List<CartItem> items;

  ShoppingCart({
    required this.id,
    required this.createdDate,
    required this.items,
  });

  static const String boxName = 'shopping_carts';

  static Future<ShoppingCart> getCart({int id = 0}) async {
    final box = Hive.box<ShoppingCart>(boxName);
    var cart = box.get(id);
    if (cart == null) {
      cart = ShoppingCart(id: id, createdDate: DateTime.now(), items: []);
      await box.put(id, cart);
    }
    return cart;
  }

  Future<void> addItem(IngredientTemplate template, double quantity) async {
    final existing = items.firstWhere(
      (i) => i.template.id == template.id,
      orElse: () => CartItem(template: template, quantity: 0),
    );
    if (existing.quantity == 0) {
      items.add(CartItem(template: template, quantity: quantity));
    } else {
      final idx = items.indexOf(existing);
      items[idx] = CartItem(
        template: template,
        quantity: existing.quantity + quantity,
      );
    }
    await save();
  }

  Future<void> removeItem(int templateId) async {
    items.removeWhere((i) => i.template.id == templateId);
    await save();
  }

  Future<void> clear() async {
    items.clear();
    await save();
  }

  List<CartItem> getItems() => items;
}
