import 'package:calories_counter/features/nutrition/nutrition_item.dart';
import 'package:calories_counter/stores.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

class NutritionStore extends BaseStore<IList<NutritionItem>> {
  NutritionStore(): super(defaultValue: const IList.empty());

  @override
  IList<NutritionItem> fromJson(json) {
    return (json as List? ?? [])
        .map((e) => NutritionItem.fromJson(e))
        .toIList();
  }

  @override
  Object toJson() {
    return value.unlock;
  }
}
