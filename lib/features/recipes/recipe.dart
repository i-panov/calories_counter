import 'package:calories_counter/features/products/product.dart';
import 'package:calories_counter/features/products/products_store.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

class Recipe extends Equatable {
  final String name;

  /// productId -> weight
  final IMap<String, int> items;

  const Recipe({
    required this.name,
    this.items = const IMap.empty(),
  });

  factory Recipe.fromJson(Map json) {
    return Recipe(
      name: json['name'],
      items: (json['items'] as Map? ?? {})
        .map((key, value) => MapEntry(key as String, value as int))
        .toIMap(),
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'items': items.unlock,
  };

  /// Вычисляет общее КБЖУ рецепта из переданной таблицы продуктов
  Product toProduct(ProductsStore productsStore) {
    return items.entries.map((e) {
      final product = productsStore.value[e.key];

      if (product == null) {
        return null;
      }

      final weight = e.value;

      return Product(
        name: product.name,
        calories: product.calories * weight / 100,
        proteins: product.proteins * weight / 100,
        fats: product.fats * weight / 100,
        carbs: product.carbs * weight / 100,
      );
    }).whereType<Product>().fold(Product(name: name), (a, p) => Product(
      name: name,
      calories: a.calories + p.calories,
      proteins: a.proteins + p.proteins,
      fats: a.fats + p.fats,
      carbs: a.carbs + p.carbs,
    ));
  }

  @override
  List<Object?> get props => [name, items];
}
