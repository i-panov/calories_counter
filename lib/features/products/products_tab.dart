import 'package:calories_counter/features/products/product_form.dart';
import 'package:calories_counter/features/products/products_store.dart';
import 'package:calories_counter/ui_helpers.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

class ProductsTab extends StatelessWidget {
  final ProductsStore productsStore;

  const ProductsTab({
    super.key,
    required this.productsStore,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () async {
            await showProductForm(
              context: context,
              form: ProductForm(productsStore: productsStore),
            );
          },
          style: TextButtonTheme.of(context).style?.copyWith(
            backgroundColor: WidgetStateProperty.all(Colors.blueAccent),
            foregroundColor: WidgetStateProperty.all(Colors.white),
          ),
          child: const Text('Добавить'),
        ),
        const SizedBox(height: 20),
        ValueListenableBuilder(
          valueListenable: productsStore,
          builder: (context, productsMap, _) {
            if (productsMap.isEmpty) {
              return const Center(child: Text('Пока ничего не добавлено'));
            }

            final productsList = productsMap.entries.toIList();

            return SizedBox(
              width: screenSize.width,
              height: screenSize.height / 1.5,
              child: ListView.separated(
                itemBuilder: (context, index) {
                  final productId = productsList[index].key;
                  final product = productsList[index].value;

                  final props = [
                    (name: 'Калории', value: product.calories),
                    (name: 'Белки', value: product.proteins),
                    (name: 'Жиры', value: product.fats),
                    (name: 'Углеводы', value: product.carbs),
                  ];

                  return Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: Text(product.name),
                      ),
                      const Spacer(),
                      Column(
                        children: [
                          for (final prop in props)
                            Text('${prop.name}:'),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Column(
                        children: [
                          for (final prop in props)
                            Text(prop.value.toStringAsFixed(2)),
                        ],
                      ),
                      const Spacer(),
                      Column(
                        children: [
                          TextButton(
                            onPressed: () async {
                              await showProductForm(
                                context: context,
                                form: ProductForm(
                                  productsStore: productsStore,
                                  initValue: productsList[index],
                                ),
                              );
                            },
                            child: const Text('Редактировать'),
                          ),
                          TextButton(
                            onPressed: () async {
                              if (await confirm(context, 'Удалить продукт?')) {
                                productsStore.remove(productId);
                              }
                            },
                            child: const Text('Удалить'),
                          ),
                        ],
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount: productsList.length,
              ),
            );
          },
        ),
      ],
    );
  }
}
