import 'package:calories_counter/features/products/product.dart';
import 'package:calories_counter/stores.dart';

class ProductsStore extends MapStore<Product> {
  ProductsStore();

  @override
  Product fromJsonModel(json) => Product.fromJson(json);
}
