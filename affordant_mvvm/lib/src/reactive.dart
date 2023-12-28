import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

class ReadOnlyReactive<T> {
  const ReadOnlyReactive(this._reactive);

  final Reactive<T> _reactive;

  Stream<T> get stream => _reactive.stream;
  T? get cache => _reactive.value;
}

abstract class Reactive<T> {
  factory Reactive([T? initialValue]) = _ReactiveSync;
  factory Reactive.replicated({
    T? initialValue,
    required AsyncFetch<T> fetch,
    required AsyncWrite<T> write,
  }) = ReplicatedReactive;

  Stream<T> get stream;

  T? get value;

  FutureOr<void> set(T newValue);

  FutureOr<void> dispose() {}

  ReadOnlyReactive<T> get readOnly;
}

class _ReactiveSync<T> implements Reactive<T> {
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
  late final ReadOnlyReactive<T> readOnly = ReadOnlyReactive(this);

  @override
  void set(T newValue) => _subject.add(newValue);

  @override
  Future<void> dispose() async {
    await _subject.close();
  }
}

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
  late final ReadOnlyReactive<T> readOnly = ReadOnlyReactive(this);

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

mixin ReactiveHost {
  final List<Reactive> _reactives = [];

  Reactive<T> reactive<T>([T? value]) {
    final reactive = Reactive(value);
    _reactives.add(reactive);
    return reactive;
  }

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
