import 'package:calories_counter/features/recipes/recipe.dart';
import 'package:calories_counter/stores.dart';

class RecipesStore extends MapStore<Recipe> {
  RecipesStore();

  @override
  Recipe fromJsonModel(json) => Recipe.fromJson(json);
}
