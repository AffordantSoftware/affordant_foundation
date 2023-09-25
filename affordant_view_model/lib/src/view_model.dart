import 'dart:async';

import 'package:bloc/bloc.dart';

/// A wrapper around Cubit from bloc package
abstract class ViewModel<T> extends Cubit<T> {
  ViewModel(super.initialState);
}

/// Provide [onEach] and [forEach] functions for a ViewModel, similar
/// to [Bloc]'s [Emitter.forEach] and [Emitter.onEach]
/// Usage:
/// ```dart
/// class MyViewModel extends ViewModel<State> with Observer {
///   ViewModel(Repository r) : super(State()) {
///      forEach(r.dataStream, (data) => State.fromData(data));
///   }
/// }
/// ```
mixin Observer<T> on ViewModel<T> {
  final Set<StreamSubscription> _streamSubscriptions = {};

  /// Call onData or onError for each event received from the stream
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

  /// Emit a new state for each event received from the stream
  void forEach<StreamType>(
    Stream<StreamType> stream, {
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

    final sub = stream.listen(
      handler,
      onError: errorHandler,
    );
    _streamSubscriptions.add(sub);
  }

  /// Emit a new state for each event received from the stream
  void forEachAsync<StreamType>(
    Stream<StreamType> stream, {
    required FutureOr<T> Function(StreamType) onData,
    T Function(Object, StackTrace)? onError,
  }) {
    Function? errorHandler;
    if (onError != null) {
      errorHandler = (Object e, StackTrace s) {
        emit(onError(e, s));
      };
    }

    final sub = stream.asyncMap(onData).listen(
          emit,
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

class MutableStreamSubscription<StreamType> {
  /// A stream subscription that can be re-assigned
  /// This is useful when you need a to switch between multiple stream of
  /// the same type.
  /// This object should be used inside of a ViewModel with an Observer mixin.
  /// The lifetime of the subscription is managed like any other subscription
  /// the Observer ViewModel may have.
  ///
  /// Usage:
  /// ```dart
  /// class MyViewModel extends ViewModel<State> with Observer {
  ///
  ///   MyViewModel({required this.service}) : super(State()) {
  ///     _sub = service.stream(
  ///         this,
  ///         0,
  ///          onData: _handleEvent,
  ///      );
  ///   }
  ///
  ///   final Service service;
  ///   late final MutableStreamObserver _sub;
  ///
  ///   void changeSource(int index) {
  ///     _sub.setStream(service.stream(index))
  ///   }
  ///
  ///   void _handleEvent(Data e) {
  ///     // handle the event
  ///   }
  /// }
  /// ```
  MutableStreamSubscription(
    this._observer,
    Stream<StreamType> stream, {
    required this.onData,
    this.onError,
  }) {
    _sub = stream.listen(
      onData,
      onError: onError,
    );
    _observer._streamSubscriptions.add(_sub);
  }

  final Observer _observer;

  late StreamSubscription<StreamType> _sub;
  final void Function(StreamType) onData;
  final void Function(Object, StackTrace)? onError;

  Future<void> setStream(Stream<StreamType> stream) async {
    _observer._streamSubscriptions.remove(_sub);
    final oldSub = _sub;
    await oldSub.cancel();
    _sub = stream.listen(
      onData,
      onError: onError,
    );
  }
}
