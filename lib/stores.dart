import 'dart:convert';
import 'dart:io';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

abstract class BaseStore<T> extends ValueNotifier<T> {
  final T defaultValue;
  late final File _file;

  BaseStore({
    required this.defaultValue,
  }): super(defaultValue) {
    getApplicationDocumentsDirectory().then((dir) {
      _file = File('${dir.path}/$runtimeType.json');
      load();
    });
  }

  Future<void> load() async {
    if (await _file.exists()) {
      try {
        final json = jsonDecode(await _file.readAsString());
        value = fromJson(json);
        return;
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }

    value = defaultValue;
  }

  Future<void> flush() async {
    await _file.writeAsString(jsonEncode(toJson()), flush: true);
  }

  Object toJson();

  T fromJson(dynamic json);
}

abstract class BaseMapStore<Id, Model> extends BaseStore<IMap<Id, Model>> {
  BaseMapStore(): super(defaultValue: IMap<Id, Model>.empty());

  Future<void> update(Id id, Model model) async {
    value = value.add(id, model);
    await flush();
  }

  Future<void> remove(Id id) async {
    value = value.remove(id);
    await flush();
  }

  Id parseId(String id);

  Model fromJsonModel(json);

  @override
  IMap<Id, Model> fromJson(json) {
    return (json as Map? ?? {}).map((key, value) {
      final model = fromJsonModel(value);
      return MapEntry(parseId(key as String), model);
    }).lock;
  }

  @override
  Object toJson() {
    return value.unlock;
  }
}

abstract class MapStore<Model> extends BaseMapStore<String, Model> {
  final _uuid = const Uuid();

  MapStore();

  String generateId() => _uuid.v7();

  Future<void> add(Model model) async {
    value = value.add(generateId(), model);
    await flush();
  }

  @override
  String parseId(String id) => id;
}
