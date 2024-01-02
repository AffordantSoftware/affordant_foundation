import 'dart:async';

import 'package:get_it/get_it.dart';

import 'reactive.dart';

export 'reactive.dart';

/// A base class for repositories that use [Reactive] objects as underlying reactive api.
/// This class is mixed-in with [ReactiveHost] so you can access to [reactive] and [replicatedReactive],
/// and implement [Disposable] from [get_it] so it can be disposed automatically.
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
///
/// ...
///
/// GetIt.instance.register(MyRepo());
/// ```
///
/// See also:
/// * [ReactiveHost] The mixin that manage multiple [Reactive]s lifecycle
/// * [Reactive] The base class for reactive
/// * [ReplicatedReactive] A Reactive that replicated its data over network
base class ReactiveRepository with ReactiveHost implements Disposable {
  @override
  FutureOr<void> onDispose() async {
    return await dispose();
  }
}
