import 'dart:async';

import 'package:get_it/get_it.dart';

import 'reactive.dart';

export 'reactive.dart';

base class ReactiveRepository with ReactiveHost implements Disposable {
  @override
  FutureOr<void> onDispose() async {
    return await dispose();
  }
}
