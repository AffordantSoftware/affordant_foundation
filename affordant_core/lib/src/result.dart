import 'dart:async';

import 'package:rust_core/result.dart';
import 'package:affordant_core/src/error.dart';
export 'package:rust_core/src/result/result.dart' hide okay, error;
export 'package:rust_core/src/result/result_extensions.dart';
export 'package:rust_core/src/result/future_result.dart';

/// Executes the function in a protected context. [func] is called inside a try catch block. If the result is not
/// catch, then return value [func] returned inside an [Ok]. If [func] throws, then the thrown value is returned
/// inside an [Err].
Result<S, Error> safeExec<S>(S Function() func) {
  assert(S is! Result, "Use executeProtectedResult instead");
  try {
    return Ok(func());
  } catch (e, s) {
    return Err(Error(e, s));
  }
}

/// Result unwrapping version of [executeProtected]. Where [func] returns an [Result], but can still throw.
Result<S, Error> safeExecResult<S>(Result<S, Error> Function() func) {
  try {
    return func();
  } catch (e, s) {
    return Err(Error(e, s));
  }
}

/// Async version of [executeProtected]
FutureResult<S, Error> safeExecAsync<S>(Future<S> Function() func) async {
  assert(S is! Result, "Use executeProtectedAsyncResult instead");
  try {
    return Ok(await func());
  } catch (e, s) {
    return Err(Error(e, s));
  }
}

/// Async version of [executeProtectedResult]
FutureResult<S, Error> safeExecAsyncResult<S>(
    Future<Result<S, Error>> Function() func) async {
  try {
    return await func();
  } catch (e, s) {
    return Err(Error(e, s));
  }
}

// sealed class Result<T, E> {
//   const Result();

//   static Result<T, void> fromNullable<T>(T? value) {
//     return switch (value) {
//       Object() => Ok(value),
//       null => Err(null),
//     };
//   }

//   bool get isOk => switch (this) {
//         Ok<T, E>() => true,
//         Err<T, E>() => false,
//       };

//   bool get isErr => switch (this) {
//         Ok<T, E>() => false,
//         Err<T, E>() => true,
//       };

//   C fold<C>({
//     required C Function(T) ok,
//     required C Function(E) err,
//   }) =>
//       switch (this) {
//         final Ok<T, E> res => ok(res.value),
//         final Err<T, E> res => err(res.error),
//       };

//   Result<U, F> map<U, F>({
//     required U Function(T value) ok,
//     required F Function(E error) err,
//   }) =>
//       switch (this) {
//         final Ok<T, E> res => Ok(ok(res.value)),
//         final Err<T, E> res => Err(err(res.error)),
//       };

//   Result<U, E> mapOk<U>(U Function(T value) delegate) => map(
//         ok: delegate,
//         err: (err) => err,
//       );

//   Result<T, F> mapErr<F>(F Function(E error) delegate) => map(
//         ok: (ok) => ok,
//         err: delegate,
//       );

//   T getOrElse(T Function(E) orElse) => fold(
//         ok: (ok) => ok,
//         err: orElse,
//       );

//   T? getOrNull() => fold(
//         ok: (ok) => ok,
//         err: (_) => null,
//       );

//   // Result<T, E> when({
//   //   required void Function(T) ok,
//   //   required void Function(E) err,
//   // }) {
//   //   switch (this) {
//   //     case final Ok<T, E> res:
//   //       ok(res.value);
//   //     case final Err<T, E> res:
//   //       err(res.value);
//   //   }
//   //   return this;
//   // }

//   // Result<T, E> whenOk(void Function(T) sideEffect) => when(
//   //       ok: sideEffect,
//   //       err: (_) {},
//   //     );

//   // Result<T, E> whenErr(void Function(E) sideEffect) => when(
//   //       ok: (ok) {},
//   //       err: sideEffect,
//   //     );
// }

// class Ok<T, E> extends Result<T, E> {
//   const Ok(this.value);

//   final T value;
// }

// class Err<T, E> extends Result<T, E> {
//   const Err(this.error);

//   final E error;
// }

// extension FutureResult<T, E> on Future<Result<T, E>> {
//   Future<C> fold<C>({
//     required C Function(T) ok,
//     required C Function(E) err,
//   }) =>
//       then((r) => r.fold(ok: ok, err: err));

//   Future<Result<U, F>> map<U, F>({
//     required U Function(T value) ok,
//     required F Function(E error) err,
//   }) =>
//       then((r) => r.map(ok: ok, err: err));

//   Future<Result<U, E>> mapOk<U>(U Function(T value) delegate) =>
//       then((r) => r.mapOk(delegate));

//   Future<Result<T, F>> mapErr<F>(F Function(E error) delegate) =>
//       then((r) => r.mapErr(delegate));

//   Future<T> unwrapOrElse(T Function(E) orElse) =>
//       then((r) => r.getOrElse(orElse));

//   Future<T?> unwrapOrNull() => then((r) => r.getOrNull());

//   Future<bool> get isOk => then((r) => r.isOk);

//   Future<bool> get isErr => then((r) => r.isErr);
// }

Ok<(), E> ok<E extends Object>() => Ok(());
