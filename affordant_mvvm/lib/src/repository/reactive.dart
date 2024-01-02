import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

/// A read-only reactive piece of data
/// You can obtain a read-only reactive by using [readOnly] getter on any [Reactive]
///
/// Example usage:
/// ```dart
/// class MyRepo with ReactiveHost {
///     late final _data = reactive<int>(0);
///     get data => _data.readOnly;
/// }
/// ```
abstract interface class ReadOnlyReactive<T> {
  Stream<T> get stream;
  T? get value;
}

/// {@template reactive}
/// A reactive piece of data
///
/// {@template reactive_common}
/// [Reactive] MUST be disposed using [dispose] method.
/// To avoid managing [Reactive]'s lifecycle create them inside a [ReactiveHost]
/// with [reactive] or [replicatedReactive] methods.
///
/// - [Reactive.value] to access the last known value.
/// - Subscribes to [stream] to get updated when value changes. The stream will immediately emit current value to any new subscribers.
/// - [Reactive.set] is used to update current value and propagate the result to stream subscribers.
///
/// Example usage:
/// ```dart
/// class MyRepo with ReactiveHost {
///     late final _data = reactive<int>(0);
///     get data => _data.readOnly;
///
///     void setData(int data) {
///       _data.set(data);
///     }
/// }
///
/// final Stream<int> stream = myRepo.data.stream
/// final int value = myRepo.data.value
/// ```
/// {@endtemplate}
///
/// * [ReactiveHost], a mixin that manages Reactive's lifecycle automatically.
/// * [ReplicatedReactive], a reactive that replicate it's data over network
///
/// {@endtemplate}
abstract class Reactive<T> implements ReadOnlyReactive<T> {
  factory Reactive([T? initialValue]) = _ReactiveSync;
  factory Reactive.replicated({
    T? initialValue,
    required AsyncFetch<T> fetch,
    required AsyncWrite<T> write,
  }) = ReplicatedReactive;

  FutureOr<void> set(T newValue);

  FutureOr<void> dispose() {}

  ReadOnlyReactive<T> get readOnly;
}

class _ReactiveSync<T> implements Reactive<T>, ReadOnlyReactive<T> {
  _ReactiveSync([T? initialValue])
      : _subject = initialValue != null
            ? BehaviorSubject.seeded(initialValue)
            : BehaviorSubject();

  final BehaviorSubject<T> _subject;

  @override
  Stream<T> get stream => _subject.stream;

  @override
  T? get value => _subject.valueOrNull;

  @override
  late final ReadOnlyReactive<T> readOnly = this;

  @override
  void set(T newValue) => _subject.add(newValue);

  @override
  Future<void> dispose() async {
    await _subject.close();
  }
}

/// Controls how's [ReplicatedReactive]'s [set] method replicates data to network:
///
/// * [optimistic] replicated data but do not wait for any success confirmation
/// before writing to cache and propagating new value. If an error occur during replication, it will be accessible through [stream.onError]
///
/// * [networkFirst] replicated data and wait for success confirmation before writing to cache propagating new value. If an error occur during replication, it will be accessible through [stream.onError]
///
/// * [cacheOnly] do not replicated data and update cache immediately, propagating value to subscribers.
enum WritePolicy {
  // write value to the cache then update the network. fail if network call doesn't succeed and reset the last known value before failure.
  optimistic,

  // write value to the network then result value to the cache, if the network call doesn't succeed, don't save to the cache.
  networkFirst,

  // write value to the cache, don't update the network.
  cacheOnly,
}

typedef AsyncFetch<T> = FutureOr<T> Function();
typedef AsyncWrite<T> = FutureOr<void> Function(T value);

/// {@template replicated_reactive}
/// A reactive piece of data that replicated it's data on network
/// You can control how data is replicated by providing a [WritePolicy] to
/// the [set] method. The default WritingPolicy is [WritePolicy.optimistic].
///
/// {@macro reactive_content}
///
/// See also:
/// * [WritePolicy], the enum used to control how [set] replicates data.
/// * [ReactiveHost], a mixin that manages Reactive's lifecycle automatically.
/// * [Reactive], the base class for reactive value.
/// {@endtemplate}
class ReplicatedReactive<T> implements Reactive<T> {
  ReplicatedReactive({
    T? initialValue,
    required this.fetch,
    required this.write,
  }) : _subject = initialValue != null
            ? BehaviorSubject.seeded(initialValue)
            : BehaviorSubject();

  /// Fetch value from source
  final AsyncFetch<T> fetch;

  /// Update source with new value
  final AsyncWrite<T> write;

  final BehaviorSubject<T> _subject;

  @override
  T? get value => _subject.valueOrNull;

  @override
  Stream<T> get stream => _subject.stream;

  @override
  ReadOnlyReactive<T> get readOnly => this;

  @override
  FutureOr<void> set(
    T newValue, {
    WritePolicy policy = WritePolicy.optimistic,
  }) async {
    switch (policy) {
      case WritePolicy.optimistic:
        _subject.value = newValue;
        try {
          await write(newValue);
        } catch (e, s) {
          _subject.addError(e, s);
        }
      case WritePolicy.networkFirst:
        try {
          await write(newValue);
          _subject.value = newValue;
        } catch (e, s) {
          _subject.addError(e, s);
        }
      case WritePolicy.cacheOnly:
        _subject.value = newValue;
    }
  }

  @override
  Future<void> dispose() async {
    await _subject.close();
  }
}

/// A mixin to automatically manage multiple [Reactive]'s lifecycle
/// You still MUST call [dispose] method when host is no longer needed
/// Reactives are created using [reactive] and [replicatedReactive] methods
///
/// Example usage:
/// ```dart
/// class MyRepo with ReactiveHost {
///     late final _data = reactive<int>(0);
///
///     get data => _data.readOnly;
///
///     void setData(int data) {
///       _data.set(data);
///     }
///
///     late final _replicatedData = replicatedReactive<int>(
///       fetch: () async => /** fetch value */
///       write: (value) async => /** write value */
///     );
///
///     get replicatedData => _replicatedData.readOnly;
///
///      void setReplicatedData(int data) {
///       _replicatedData.set(data, WritePolicy.networkFirst);
///     }
/// }
/// ...
///
/// final Stream<int> stream = myRepo.data.stream
/// final int value = myRepo.data.value
/// ```
///
/// * [Reactive], the base class for reactives
/// * [ReplicatedReactive], a reactive that replicate it's data over network
///
mixin ReactiveHost {
  final List<Reactive> _reactives = [];

  /// {@macro reactive}
  Reactive<T> reactive<T>([T? value]) {
    final reactive = Reactive(value);
    _reactives.add(reactive);
    return reactive;
  }

  /// {@macro replicated_reactive}
  ReplicatedReactive<T> replicatedReactive<T>({
    T? initialValue,
    required AsyncFetch<T> fetch,
    required AsyncWrite<T> write,
  }) {
    final reactive = ReplicatedReactive<T>(
      initialValue: initialValue,
      fetch: fetch,
      write: write,
    );
    _reactives.add(reactive);
    return reactive;
  }

  @mustCallSuper
  Future<void> dispose() async {
    await Future.wait(
      _reactives.map((e) async => await e.dispose()),
    );
  }
}
