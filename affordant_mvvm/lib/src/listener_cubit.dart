// import 'dart:async';

// import 'package:flutter_bloc/flutter_bloc.dart';

// /// Provide [onEach] and [forEach] and [ForEachAsync] functions for a [Cubit], similar
// /// to [Bloc]'s [Emitter.forEach] and [Emitter.onEach]
// /// Usage:
// /// ```dart
// /// class MyViewModel extends ViewModel<State> with Observer {
// ///   ViewModel(Repository r) : super(State()) {
// ///      forEach(r.dataStream, (data) => State.fromData(data));
// ///   }
// /// }
// /// ```
// mixin StreamListenerCubit<T> on Cubit<T> {
//   final Set<StreamSubscription> _streamSubscriptions = {};

//   /// Call onData or onError for each event received from the stream
//   void onEach<DataType>(
//     Stream<DataType> s, {
//     required void Function(DataType) onData,
//     void Function(Object, StackTrace)? onError,
//     void Function()? onDone,
//     bool? cancelOnError,
//   }) {
//     final sub = s.listen(
//       onData,
//       onError: onError,
//       onDone: onDone,
//       cancelOnError: cancelOnError,
//     );
//     _streamSubscriptions.add(sub);
//   }

//   /// Emit a new state for each event received from the stream
//   void forEach<DataType>(
//     Stream<DataType> stream, {
//     required T Function(DataType) onData,
//     T Function(Object, StackTrace)? onError,
//   }) {
//     void handler(DataType d) {
//       emit(onData(d));
//     }

//     Function? errorHandler;
//     if (onError != null) {
//       errorHandler = (Object e, StackTrace s) {
//         emit(onError(e, s));
//       };
//     }

//     final sub = stream.listen(
//       handler,
//       onError: errorHandler,
//     );
//     _streamSubscriptions.add(sub);
//   }

//   /// Emit a new state for each event received from the stream
//   void forEachAsync<DataType>(
//     Stream<DataType> stream, {
//     required FutureOr<T> Function(DataType) onData,
//     T Function(Object, StackTrace)? onError,
//   }) {
//     void setState(T newState) {
//       emit(newState);
//     }

//     Function? errorHandler;
//     if (onError != null) {
//       errorHandler = (Object e, StackTrace s) {
//         emit(onError(e, s));
//       };
//     }

//     final sub = stream.asyncMap(onData).listen(
//           setState,
//           onError: errorHandler,
//         );
//     _streamSubscriptions.add(sub);
//   }

//   @override
//   Future<void> close() async {
//     Future.wait(_streamSubscriptions.map((s) => s.cancel()));
//     return super.close();
//   }
// }

// class ReassignableStreamSubscription<DataType> {
//   /// A stream subscription that can be re-assigned
//   /// This is useful when you need a to switch between multiple stream of
//   /// the same type.
//   /// This object should be used inside of a ViewModel with an Observer mixin.
//   /// The lifetime of the subscription is managed like any other subscription
//   /// the Observer ViewModel may have.
//   ///
//   /// Usage:
//   /// ```dart
//   /// class MyViewModel extends ViewModel<State> with Observer {
//   ///
//   ///   MyViewModel({required this.service}) : super(State()) {
//   ///     _sub = service.stream(
//   ///         this,
//   ///         0,
//   ///          onData: _handleEvent,
//   ///      );
//   ///   }
//   ///
//   ///   final Service service;
//   ///   late final MutableStreamObserver _sub;
//   ///
//   ///   void changeSource(int index) {
//   ///     _sub.setStream(service.stream(index))
//   ///   }
//   ///
//   ///   void _handleEvent(Data e) {
//   ///     // handle the event
//   ///   }
//   /// }
//   /// ```
//   ReassignableStreamSubscription(
//     this._listener,
//     Stream<DataType> stream, {
//     required this.onData,
//     this.onError,
//   }) {
//     _sub = stream.listen(
//       onData,
//       onError: onError,
//     );
//     _listener._streamSubscriptions.add(_sub);
//   }

//   final StreamListenerCubit _listener;

//   late StreamSubscription<DataType> _sub;
//   final void Function(DataType) onData;
//   final void Function(Object, StackTrace)? onError;

//   Future<void> setSource(Stream<DataType> stream) async {
//     _listener._streamSubscriptions.remove(_sub);
//     final oldSub = _sub;
//     await oldSub.cancel();
//     _sub = stream.listen(
//       onData,
//       onError: onError,
//     );
//   }
// }
