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

abstract class ViewModel<T> extends Cubit<T> with DependencyInjection {
  ViewModel(super.initialState);
}

mixin Observer<T> on ViewModel<T> {
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

mixin Observer2<T> on ViewModel<T> {
  final List<StreamSubscription> _streamSubscriptions = [];

  void onEach<StreamType>(
    Stream<StreamType> s, {
    required void Function(StreamType) onData,
    void Function(Object, StackTrace)? onError,
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

  void forEach<StreamType>(
    Stream<StreamType> s, {
    required T Function(StreamType) onData,
    T Function(Object, StackTrace)? onError,
  }) {
    void handler(StreamType d) {
      emit(onData(d));
    }

    Function? errorHandler;
    if (onError != null) {
      errorHandler = (Object e, StackTrace s) {
        emit(onError(e, s));
      };
    }

    final sub = s.listen(
      handler,
      onError: errorHandler,
    );
    _streamSubscriptions.add(sub);
  }

  @override
  Future<void> close() async {
    Future.wait(_streamSubscriptions.map((s) => s.cancel()));
    return super.close();
  }
}
