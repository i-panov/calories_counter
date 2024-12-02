import 'package:calories_counter/features/products/product.dart';
import 'package:calories_counter/features/products/products_store.dart';
import 'package:flutter/material.dart';

Future<Product?> showProductForm({
  required BuildContext context,
  required ProductForm form,
}) async {
  return await showAdaptiveDialog<Product>(
    context: context,
    builder: (context) => form,
  );
}

class ProductForm extends StatefulWidget {
  final ProductsStore productsStore;
  final MapEntry<String, Product>? initValue;

  const ProductForm({
    super.key,
    required this.productsStore,
    this.initValue,
  });

  @override
  State createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final key = GlobalKey<FormState>();
  late var name = widget.initValue?.value.name ?? '';
  late var barcode = widget.initValue?.value.barcode ?? '';
  late var weight = widget.initValue?.value.weight ?? 0;
  late var calories = widget.initValue?.value.calories ?? 0;
  late var proteins = widget.initValue?.value.proteins ?? 0;
  late var fats = widget.initValue?.value.fats ?? 0;
  late var carbs = widget.initValue?.value.carbs ?? 0;

  late final floatFields = [
    (name: 'Калории', value: calories, setter: (double value) => calories = value),
    (name: 'Белки', value: proteins, setter: (double value) => proteins = value),
    (name: 'Жиры', value: fats, setter: (double value) => fats = value),
    (name: 'Углеводы', value: carbs, setter: (double value) => carbs = value),
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Form(
        key: key,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 50,
            horizontal: 16,
          ),
          child: Column(
            children: [
              TextFormField(
                initialValue: name,
                onChanged: (value) => name = value,
                decoration: const InputDecoration(
                  label: Text('Название'),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите название';
                  }

                  if (value.length > 100) {
                    return 'Слишком длинное название';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: barcode,
                      onChanged: (value) => barcode = value,
                      decoration: const InputDecoration(
                        label: Text('Штрих-код'),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value != null && value.length > 100) {
                          return 'Слишком длинный штрих-код';
                        }

                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () async {
                      /*final newBarcode = await showBarcodeScanner(context);

                        if (newBarcode != null) {
                          barcode = newBarcode;
                        }*/
                    },
                    icon: const Icon(Icons.camera_alt_outlined),
                    tooltip: 'Сканировать',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: weight.toString(),
                keyboardType: TextInputType.number,
                onChanged: (value) => weight = int.tryParse(value) ?? 0,
                decoration: const InputDecoration(
                  label: Text('Вес порции'),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return null;
                  }

                  final n = int.tryParse(value);

                  if (n == null) {
                    return 'Значение должно быть числом';
                  }

                  if (n < 0) {
                    return 'Значение должно быть положительным';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 20),
              for (final field in floatFields) ...[
                TextFormField(
                  initialValue: field.value.toString(),
                  keyboardType: const TextInputType.numberWithOptions(
                    signed: false,
                    decimal: true,
                  ),
                  onChanged: (value) => field.setter(double.tryParse(value) ?? 0),
                  decoration: InputDecoration(
                    label: Text(field.name),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Заполните поле';
                    }

                    final n = double.tryParse(value);

                    if (n == null) {
                      return 'Значение должно быть числом';
                    }

                    if (n < 0) {
                      return 'Значение должно быть положительным';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 20),
              ],
              Row(
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Отмена'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (key.currentState!.validate()) {
                        final product = Product(
                          name: name,
                          barcode: barcode,
                          weight: weight,
                          calories: calories,
                          proteins: proteins,
                          fats: fats,
                          carbs: carbs,
                        );

                        if (widget.initValue == null) {
                          widget.productsStore.add(product);
                        } else {
                          widget.productsStore.update(widget.initValue!.key, product);
                        }

                        Navigator.of(context).pop(product);
                      }
                    },
                    child: const Text('Сохранить'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
