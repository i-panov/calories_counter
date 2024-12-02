import 'package:calories_counter/features/products/product.dart';
import 'package:calories_counter/features/products/products_store.dart';
import 'package:calories_counter/features/recipes/recipes_store.dart';
import 'package:equatable/equatable.dart';

/// Тип приема пиши
enum NutritionItemType { product, recipe, }

/// Прием пиши
class NutritionItem extends Equatable {
  final String id;
  final NutritionItemType type;
  final int weight;
  final DateTime time;

  const NutritionItem({
    required this.id,
    required this.type,
    required this.weight,
    required this.time,
  });

  factory NutritionItem.fromJson(Map json) {
    return NutritionItem(
      id: json['id'] as String,
      type: NutritionItemType.values.byName(json['type'] as String),
      weight: json['weight'] as int,
      time: DateTime.parse(json['time'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'weight': weight,
      'time': time.toIso8601String(),
    };
  }

  /// Вычисляет общее КБЖУ приема пиши из переданных таблиц продуктов и рецептов
  Product? toProduct({
    required ProductsStore productsStore,
    required RecipesStore recipesStore,
  }) {
    return switch (type) {
      NutritionItemType.product => productsStore.value[id],
      NutritionItemType.recipe => recipesStore.value[id]?.toProduct(productsStore),
    };
  }

  @override
  List<Object?> get props => [id, type, weight, time];
}
