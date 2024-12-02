import 'package:calories_counter/features/activity/activity_store.dart';
import 'package:calories_counter/features/activity/activity_tab.dart';
import 'package:calories_counter/features/nutrition/nutrition_store.dart';
import 'package:calories_counter/features/nutrition/nutrition_tab.dart';
import 'package:calories_counter/features/products/products_store.dart';
import 'package:calories_counter/features/products/products_tab.dart';
import 'package:calories_counter/features/recipes/recipes_store.dart';
import 'package:calories_counter/features/recipes/recipes_tab.dart';
import 'package:flutter/material.dart';

// features: продукты, рецепты, активность, питание, вода

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nutrition Diary',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom()),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  final productsStore = ProductsStore();
  final recipesStore = RecipesStore();
  final nutritionStore = NutritionStore();
  final activityStore = ActivityStore();

  late final tabs = [
    (title: 'Питание', widget: const NutritionTab()),
    (title: 'Продукты', widget: ProductsTab(productsStore: productsStore)),
    (title: 'Рецепты', widget: RecipesTab(
      recipesStore: recipesStore,
      productsStore: productsStore,
    )),
    (title: 'Активность', widget: const ActivityTab()),
  ];

  late final tabCtrl = TabController(length: tabs.length, vsync: this);

  @override
  void dispose() {
    productsStore.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textButtonTheme = TextButtonTheme.of(context);

    final activeButtonStyle = textButtonTheme.style?.copyWith(
      backgroundColor: WidgetStateProperty.all(Colors.blueAccent),
      foregroundColor: WidgetStateProperty.all(Colors.white),
    );

    return ListenableBuilder(
      listenable: tabCtrl,
      builder: (context, _) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 50,
            ),
            child: tabs[tabCtrl.index].widget,
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blueAccent,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Wrap(
                spacing: 8,
                children: [
                  for (final (index, tab) in tabs.indexed)
                    TextButton(
                      onPressed: () => tabCtrl.animateTo(index),
                      style: index == tabCtrl.index ? activeButtonStyle : null,
                      child: Text(tab.title),
                    ),
                ],
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        );
      },
    );
  }
}
