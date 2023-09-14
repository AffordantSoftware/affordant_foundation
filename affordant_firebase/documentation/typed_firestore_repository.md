# Typed firestore repository utils

While being powerfull, firestore API let's us access data as Map<String, dynamic>.
This package provides a set of utilities designed to facilitate the creation of typed firestore repository.

This is the first iteration of this package. it has been designed for a manual usage.
In the future, this package will rely on code generation instead. 

# Usage

## Create a repository

Create a repository class that will be the entry point to all firebase collection you want to access.

In the example bellow, we're providing access to a UserCollection.

```dart
class JournalRepository {
  UserCollection get users => UserCollection._(
        FirebaseFirestore.instance.collection('users'),
      );
}
```

## Typed collection reference

Created typed collection references by extending `CollectionRef` class.
The CollectionRef class has two type parameters: id and document reference type. The id is used to access a document in the collection, while the document reference type is the typed document reference returned when accessing the collection.

The convertID function takes an id and converts it to a Firestore DocID (String).

The convertDoc function takes a Firestore document reference and converts it to the desired typed document reference type (UserRef in this case).

```dart
final class UserCollection extends CollectionRef<String, UserRef> {
  UserCollection._(super.collection)
      : super(
          /// No need to convert since we're using string as doc id
          convertID: (String id) => id,
          convertDoc: (doc) => UserRef(doc),
        );
}
```

## Typed document reference

Typed document reference is used in combination with `FieldAccessor`, `MapAccessor` and `ArrayAccessor` to access document field in a type safe manner. 

```dart
final class JournalEntryRef extends DocRef{
  JournalEntryRef._(super.doc);

  late final DateTime = FieldAccessor<DateTime>(
      parent: this,
      key: "date",
      defaultValue: () => 0,
      fromJson: (v) => int.parse(v),
      toJson: (v) => v.toString());
}
```

You can then access the field using the followning syntax:
```dart
final date = await journalEntry.date.get();
journalEntry.date.set(DateTime.now());
```

### Retrieving the whole document as typed object
By default DocRef doesn't provides method to access the whole document as a typed object.
This capability can be added by adding the `ObjectAccessor<T>` mixin to you doc ref.

This mixin provides getter and setter of type T. You must implement `defaultValue`, `fromData` and `toData` methods first.
Your're never guarenteed that data will be present when you try to access it so you must provides default value.

```dart
final class JournalEntryRef extends DocRef with ObjectAccessor<JournalEntry> {
  JournalEntryRef._(super.doc);

  
  @override
  JournalEntry fromData(String id, Map<String, dynamic> data) {
    return JournalEntry.fromJson(data);
  }

  @override
  Map<String, dynamic> toData(JournalEntry value) => value.toJson();

  JournalEntryUserDataRef get userData => JournalEntryUserDataRef._(this);

  @override
  JournalEntry defaultValue(String id) {
    final date = DateTime.parse(id).toUtc();
    return JournalEntry.empty(date);
  }

  JournalEntryUserDataRef get userData => JournalEntryUserDataRef._(this);
}
```

We can now access and edit the document as a typed object:
```dart
JournalEntry entry = await jounralEntry.get();
jounralEntry.set(entry);
jounralEntry.delete();
```

## Field Accessors
Field accessor can be used inside DocRef or MapAccessor as a late final field.
They should provide a default value in case we're trying to access a field that's haven't been set yet.
```dart
class JournalEntryRef extends DocRef {
  late final DateTime = FieldAccessor<DateTime>(
      parent: this,
      key: "date",
      defaultValue: () => 0,
      fromJson: (v) => int.parse(v),
      toJson: (v) => v.toString());
}
```

Fields accessors support can be used in Map as well. 

```dart
class MapDataInsideADoc extends MapAccessor {
  late final String = FieldAccessor<String>(
      parent: this,
      key: "name",
      defaultValue: () => "Unknown",
      fromJson: (v) => v,
      toJson: (v) => v;
  );
}
```

## Map Accessors
Similare to DocRef, MapAccessor should be extended and use FieldAccessor or nested MapAccessor to provieds typed access to their field.
Map accesors takes a key as parameter and can be used inside DocRef or other MapAccessors.

```dart
class JournalEntryRef extends DocRef {
  final userData = JournalEntryUserData._(this);
}

final class JournalEntryUserData extends MapAccessor {
  JournalEntryUserDataRef._(super.parent) : super(key: 'userData');

  late final breakfast = FieldAccessor(...);
  late final lunch = FieldAccessor(...);
  late final snacks = FieldAccessor(...);
  late final dinner = FieldAccessor(...);
}
```

It can then be used as follow:
```dart
final breakFast = await journalEntry.userData.breakFast.get();
```

## Array accessor
Array accessor can be used inside MapAccessor or docRef.
They provide all basic feature such as get, set but also getIndex, removeIndex etc

```dart
final class JournalEntryUserData extends MapAccessor {
  JournalEntryUserDataRef._(super.parent) : super(key: 'userData');

  late final breakfast = ArrayAccessor<EatenFood>(this, 
    fromData: (int index, Map<String, dynamic> data) => EatenFood.fromJson(data),
    toJson: (EatenFood food) => food.toJson(),
  );
}
```

You can the access the array as follow:
```dart
List<EatenFood> foods = await jounralEntry.breakfast.get();
jounralEntry.breakfast.set([...]);
await jounralEntry.breakfast.add(food);
await jounralEntry.breakfast.setIndex(index, food);
EatenFood food = await jounralEntry.breakfast.getIndex(index);
```

## Sub collection

To create a sub collection, just create a new CollectionRef class and provides it as a getter of your parent doc.

```dart
final class UserRef extends DocRef {
  UserRef._(super.ref);

  JournalEntryCollection get journalEntries =>
      JournalEntryCollection._(ref.collection('journalEntries'));
}

final class JournalEntryCollection
    extends CollectionRef<DateTime, JournalEntryRef> {
  JournalEntryCollection._(
    super.collection,
  ) : super(
          convertID: (DateTime date) {
            final dateUtc = date.toUtc();
            return DateTime.utc(dateUtc.year, dateUtc.month, dateUtc.day)
                .toIso8601String();
          },
          convertDoc: JournalEntryRef._,
        );
}
```