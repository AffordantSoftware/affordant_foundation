import 'package:cloud_firestore/cloud_firestore.dart' as fs;
import 'package:collection/collection.dart';

abstract class MapAccessorBase {
  // Future<String> id();
  Future<Map<String, dynamic>?> getMap();
  Future<void> setMap(Map<String, dynamic> data);
}

base mixin ObjectAccessor<T> on DocRef {
  T defaultValue(String id);

  T fromData(String id, Map<String, dynamic> data);
  Map<String, dynamic> toData(T value);

  Future<T> get() async {
    final doc = await ref.get();
    final data = doc.data();
    if (data == null) {
      return defaultValue(doc.id);
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
      await ref.set(toData(defaultValue(snapshot.id)));
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
    return ref.snapshots().map(
      (doc) {
        if (doc.exists) {
          return fromData(
            doc.id,
            doc.data()!,
          );
        } else {
          return defaultValue(doc.id);
        }
      },
    );
  }
}

abstract base class DocRef implements MapAccessorBase {
  final fs.DocumentReference<Map<String, dynamic>> ref;

  const DocRef(this.ref);

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
  CollectionRef(
    this.collection, {
    required this.convertID,
    required this.convertDoc,
  });

  final fs.CollectionReference<Map<String, dynamic>> collection;
  final String Function(ID) convertID;
  final DocRefType Function(fs.DocumentReference<Map<String, dynamic>> doc)
      convertDoc;

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
  final Map<String, dynamic> Function(T value) toData;

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
