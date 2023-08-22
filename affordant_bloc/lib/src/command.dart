import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';

mixin DependencyInjection {
  GetIt get di => GetIt.I;
}

/// Command can depend on scope
/// Command should provides a nice api to catch error
/// Ideally we should provides a mixin to handle command failure
abstract base class Command<T> with DependencyInjection {
  const Command();

  FutureOr<T> run();
}

abstract class Query<T> extends Cubit<T> with DependencyInjection {
  Query(super.initialState);
}

mixin Observer<T> on Query<T> {
  final List<StreamSubscription> _streamSubscriptions = [];

  void watch<StreamType>(
    Stream<StreamType> s,
    void Function(StreamType)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    final sub = s.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
    _streamSubscriptions.add(sub);
  }

  @override
  Future<void> close() async {
    Future.wait(_streamSubscriptions.map((s) => s.cancel()));
    return super.close();
  }
}
