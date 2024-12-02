import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String name;
  final String barcode;

  /// Вес порции
  final int weight;

  final double calories;

  /// БЖУ в граммах
  final double proteins, fats, carbs;

  const Product({
    required this.name,
    this.barcode = '',
    this.weight = 0,
    this.calories = 0,
    this.proteins = 0,
    this.fats = 0,
    this.carbs = 0,
  });

  factory Product.fromJson(Map json) => Product(
    name: json['name'],
    barcode: json['barcode'] as String? ?? '',
    weight: json['weight'] as int? ?? 0,
    calories: json['calories'],
    proteins: json['proteins'],
    fats: json['fats'],
    carbs: json['carbs'],
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'barcode': barcode,
    'weight': weight,
    'calories': calories,
    'proteins': proteins,
    'fats': fats,
    'carbs': carbs,
  };

  @override
  List<Object?> get props => [
    name,
    barcode,
    weight,
    calories,
    proteins,
    fats,
    carbs,
  ];
}
