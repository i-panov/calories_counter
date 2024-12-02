import 'package:calories_counter/features/activity/day.dart';
import 'package:calories_counter/stores.dart';

/// Класс хранит активность (количество сожженных ккал) по дням
class ActivityStore extends BaseMapStore<Day, int> {
  @override
  Day parseId(String id) => Day.parse(id);

  @override
  int fromJsonModel(json) => json as int;
}
