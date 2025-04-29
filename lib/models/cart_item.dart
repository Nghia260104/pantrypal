import 'package:hive_ce/hive.dart';
import 'ingredient_template.dart';

part 'cart_item.g.dart';

@HiveType(typeId: 9)
class CartItem {
  @HiveField(0)
  final IngredientTemplate template;

  @HiveField(1)
  final double quantity;

  CartItem({required this.template, required this.quantity});
}
