import 'package:hive_ce/hive.dart';
import 'ingredient_template.dart';

part 'recipe_ingredient.g.dart';

@HiveType(typeId: 5)
class RecipeIngredient {
  @HiveField(0)
  final IngredientTemplate template;

  @HiveField(1)
  final double quantity;

  RecipeIngredient({required this.template, required this.quantity});
}
