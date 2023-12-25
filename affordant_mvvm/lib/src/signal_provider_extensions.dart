import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:signals/signals_flutter.dart';

extension WatchSignal on BuildContext {
  U watchSignal<T extends Object, U>(
    ReadonlySignal<U> Function(T viewModel) select,
  ) {
    return select(watch<T>()).watch(this);
  }
}
