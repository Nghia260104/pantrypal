import 'package:hive_ce/hive.dart';
import 'recipe.dart';

part 'recipe_portion.g.dart';

@HiveType(typeId: 12)
class RecipePortion {
  @HiveField(0)
  final Recipe recipe;

  @HiveField(1)
  final double quantity; // Quantity of the recipe in this portion

  RecipePortion({required this.recipe, required this.quantity});
}
