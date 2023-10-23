import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart' as fs;
import 'package:collection/collection.dart';

abstract class MapAccessorBase {
  // Future<String> id();
  Stream<Map<String, dynamic>?> get stream;
  Future<Map<String, dynamic>?> getMap();
  Future<void> setMap(Map<String, dynamic> data);
}

base mixin ObjectAccessor<T> on DocRef {
  FutureOr<T> defaultValue(String id);

  T fromData(String id, Map<String, dynamic> data);
  Map<String, dynamic> toData(T value);

  Future<T> get() async {
    final doc = await ref.get();
    final data = doc.data();
    if (data == null) {
      return await defaultValue(doc.id);
    } else {
      return fromData(doc.id, data);
    }
  }

  Future<void> set(T value) {
    return setMap(toData(value));
  }

  @override
  Future<void> setMap(Map<String, dynamic> data) async {
    final snapshot = await ref.get();
    if (snapshot.exists == false) {
      //create the doc if it doesn't exist yet
      await ref.set(toData(await defaultValue(snapshot.id)));
    }
    return ref.set(
      data,
      fs.SetOptions(merge: true),
    );
  }

  Future<void> delete() {
    return ref.delete();
  }

  Stream<T> snapshots() {
    return ref.snapshots().asyncMap(
      (doc) async {
        if (doc.exists) {
          return fromData(
            doc.id,
            doc.data()!,
          );
        } else {
          return await defaultValue(doc.id);
        }
      },
    );
  }
}

abstract base class DocRef implements MapAccessorBase {
  final fs.DocumentReference<Map<String, dynamic>> ref;

  const DocRef(this.ref);

  @override
  Stream<Map<String, dynamic>?> get stream =>
      ref.snapshots().map((snapshot) => snapshot.data());

  @override
  Future<Map<String, dynamic>?> getMap() => ref.get().then((e) => e.data());

  @override
  Future<void> setMap(Map<String, dynamic> data) async {
    return ref.set(
      data,
      fs.SetOptions(merge: true),
    );
  }
}

abstract base class CollectionRef<ID, DocRefType extends DocRef> {
  CollectionRef(this.collection);

  final fs.CollectionReference<Map<String, dynamic>> collection;

  String convertID(ID id);

  DocRefType convertDoc(fs.DocumentReference<Map<String, dynamic>> doc);

  DocRefType doc(ID id) {
    final path = convertID(id);
    final doc = collection.doc(path);
    return convertDoc(doc);
  }

  Future<void> delete(String id) => collection.doc(id).delete();
}

abstract base class MapAccessor implements MapAccessorBase {
  final MapAccessorBase parent;
  final String key;

  MapAccessor(this.parent, {required this.key});

  @override
  Stream<Map<String, dynamic>?> get stream =>
      parent.stream.map((map) => map?[key]);

  @override
  Future<Map<String, dynamic>?> getMap() {
    return parent.getMap().then((data) {
      return data?[key];
    });
  }

  @override
  Future<void> setMap(Map<String, dynamic> data) {
    return parent.setMap({key: data});
  }
}

base class FieldAccessor<T> {
  final MapAccessorBase parent;
  final String key;
  final T Function() defaultValue;
  final T Function(dynamic) fromJson;
  final dynamic Function(T) toJson;

  FieldAccessor({
    required this.parent,
    required this.key,
    required this.defaultValue,
    required this.fromJson,
    required this.toJson,
  });

  Stream<T?> get stream => parent.stream.map((map) {
        try {
          return fromJson(map?[key]);
        } catch (e) {
          return defaultValue();
        }
      });

  Future<T> get() => parent.getMap().then((data) {
        try {
          return fromJson(data?[key]);
        } catch (e) {
          return defaultValue();
        }
      });

  Future<void> set(T value) => parent.setMap({key: toJson(value)});
}

base class ArrayAccessor<T> {
  final MapAccessorBase parent;
  final String key;

  final T Function(int index, dynamic data) fromData;
  final dynamic Function(T value) toData;

  ArrayAccessor(
    this.parent, {
    required this.key,
    required this.fromData,
    required this.toData,
  });

  Future<void> set(List<T> values) {
    final data = values.map(toData).toList();
    return parent.setMap({
      key: data,
    });
  }

  Future<List<T>> get() async {
    final list = await parent.getMap().then((map) => map?[key] as List?);
    return list?.mapIndexed(fromData).toList() ?? [];
  }

  Future<void> add(T value) async {
    final list = await get();
    return set([...list, value]);
  }

  Future<T?> getIndex(int index) async {
    return await get().then((list) => list[index]);
  }

  Future<void> setIndex(int index, T value) async {
    final list = await get();
    list[index] = value;
    return set(list);
  }

  Future<void> deleteIndex(int index) async {
    final list = await get();
    list.removeAt(index);
    set(list);
  }
}

final class DoubleAccessor extends FieldAccessor<double> {
  DoubleAccessor({
    required super.parent,
    required super.key,
    required super.defaultValue,
  }) : super(
          fromJson: (json) => json,
          toJson: (value) => value,
        );
}

final class IntAccessor extends FieldAccessor<int> {
  IntAccessor({
    required super.parent,
    required super.key,
    required super.defaultValue,
  }) : super(
          fromJson: (json) => json,
          toJson: (value) => value,
        );
}

final class StringAccessor extends FieldAccessor<String> {
  StringAccessor({
    required super.parent,
    required super.key,
    required super.defaultValue,
  }) : super(
          fromJson: (json) => json,
          toJson: (value) => value,
        );
}

final class BoolAccessor extends FieldAccessor<bool> {
  BoolAccessor({
    required super.parent,
    required super.key,
    required super.defaultValue,
  }) : super(
          fromJson: (json) => json,
          toJson: (value) => value,
        );
}

final class DateTimeAccessor extends FieldAccessor<DateTime> {
  DateTimeAccessor({
    required super.parent,
    required super.key,
    required super.defaultValue,
  }) : super(
          fromJson: (json) => DateTime.parse(json),
          toJson: (value) => value.toIso8601String(),
        );
}

final class EnumAccessor<T extends Enum> extends FieldAccessor<T> {
  EnumAccessor({
    required super.parent,
    required super.key,
    required super.defaultValue,
    required Map<String, T> nameMap,
  }) : super(
          fromJson: (json) => nameMap[json]!,
          toJson: (value) => value.name,
        );
}

// ignore: prefer_void_to_null
Null _getNull() => null;

final class NullableEnumAccessor<T extends Enum> extends FieldAccessor<T?> {
  NullableEnumAccessor({
    required super.parent,
    required super.key,
    required Map<String, T> nameMap,
    super.defaultValue = _getNull,
  }) : super(
          fromJson: (json) => nameMap[json]!,
          toJson: (value) => value?.name,
        );
}

final class NullableDoubleAccessor extends FieldAccessor<double?> {
  static double? _defaultValue() => null;

  NullableDoubleAccessor({
    required super.parent,
    required super.key,
    super.defaultValue = _defaultValue,
  }) : super(
          fromJson: (json) => json,
          toJson: (value) => value,
        );
}

final class NullableIntAccessor extends FieldAccessor<int?> {
  static int? _defaultValue() => null;

  NullableIntAccessor({
    required super.parent,
    required super.key,
    super.defaultValue = _defaultValue,
  }) : super(
          fromJson: (json) => json,
          toJson: (value) => value,
        );
}

final class NullableStringAccessor extends FieldAccessor<String?> {
  static String? _defaultValue() => null;

  NullableStringAccessor({
    required super.parent,
    required super.key,
    super.defaultValue = _defaultValue,
  }) : super(
          fromJson: (json) => json,
          toJson: (value) => value,
        );
}

final class NullableBoolAccessor extends FieldAccessor<bool?> {
  static bool? _defaultValue() => null;

  NullableBoolAccessor({
    required super.parent,
    required super.key,
    super.defaultValue = _defaultValue,
  }) : super(
          fromJson: (json) => json,
          toJson: (value) => value,
        );
}

final class NullableDateTimeAccessor extends FieldAccessor<DateTime?> {
  static DateTime? _defaultValue() => null;

  NullableDateTimeAccessor({
    required super.parent,
    required super.key,
    super.defaultValue = _defaultValue,
  }) : super(
          fromJson: (json) => DateTime.tryParse(json),
          toJson: (value) => value?.toIso8601String(),
        );
}
