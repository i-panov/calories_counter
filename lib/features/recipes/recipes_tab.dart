import 'package:calories_counter/features/products/products_store.dart';
import 'package:calories_counter/features/recipes/recipes_store.dart';
import 'package:calories_counter/ui_helpers.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

class RecipesTab extends StatelessWidget {
  final RecipesStore recipesStore;
  final ProductsStore productsStore;

  const RecipesTab({
    super.key,
    required this.recipesStore,
    required this.productsStore
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () async {
          },
          style: TextButtonTheme.of(context).style?.copyWith(
            backgroundColor: WidgetStateProperty.all(Colors.blueAccent),
            foregroundColor: WidgetStateProperty.all(Colors.white),
          ),
          child: const Text('Добавить'),
        ),
        const SizedBox(height: 20),
        ValueListenableBuilder(
          valueListenable: recipesStore,
          builder: (context, recipesMap, _) {
            if (recipesMap.isEmpty) {
              return const Center(child: Text('Пока ничего не добавлено'));
            }

            final recipesList = recipesMap.entries.toIList();

            return SizedBox(
              width: screenSize.width,
              height: screenSize.height / 1.5,
              child: ListView.separated(
                itemBuilder: (context, index) {
                  final recipeId = recipesList[index].key;
                  final recipe = recipesList[index].value;

                  return Row(
                    children: [
                      Text(recipe.name),
                      const Spacer(),
                      Column(
                        children: [
                          TextButton(
                            onPressed: () async {
                            },
                            child: const Text('Редактировать'),
                          ),
                          TextButton(
                            onPressed: () async {
                              if (await confirm(context, 'Удалить рецепт?')) {
                                recipesStore.remove(recipeId);
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
                itemCount: recipesMap.length,
              ),
            );
          },
        ),
      ],
    );
  }
}
