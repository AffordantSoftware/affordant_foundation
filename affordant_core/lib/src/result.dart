import 'dart:async';

import 'package:affordant_core/affordant_core.dart';
export 'package:rust_core/src/result/result.dart' hide okay, error;
export 'package:rust_core/src/result/result_extensions.dart';
export 'package:rust_core/src/result/future_result.dart';

extension ProtectedExecution<T> on Future<T> {
  FutureResult<T, Error> toResult() =>
      catchError((e) => Err(Error(e))).then((value) => Ok(value));
}

FutureOr<Result<T, Error>> safeExec<T>(FutureOr<T> Function() func) async {
  assert(T is! Result || T is! FutureResult, "Use safeExecResult instead");
  if (func is Future<T> Function()) {
    try {
      return (await func()).toOk();
    } catch (e, s) {
      return Err<T, Error>(Error(e, s));
    }
  } else {
    try {
      return Ok<T, Error>(func() as T);
    } catch (e, s) {
      return Err<T, Error>(Error(e, s));
    }
  }
}

// /// Executes the function in a protected context. [func] is called inside a try catch block. If the result is not
// /// catch, _then return value [func] returned inside an [Ok]. If [func] throws, _then the thrown value is returned
// /// inside an [Err].
// Result<S, Error> safeExec<S>(S Function() func) {
//   assert(S is Future, "Use executeProtectedAsync instead");
//   assert(S is! Result, "Use executeProtectedResult instead");
//   try {
//     return Ok(func());
//   } catch (e, s) {
//     return Err(Error(e, s));
//   }
// }

// /// Result unwrapping version of [executeProtected]. Where [func] returns an [Result], but can still throw.
// Result<S, Error> safeExecResult<S>(Result<S, Error> Function() func) {
//   assert(S is Future, "Use executeProtectedAsyncResult instead");
//   try {
//     return func();
//   } catch (e, s) {
//     return Err(Error(e, s));
//   }
// }

// /// Async version of [executeProtected]
// FutureResult<S, Error> safeExecAsync<S>(Future<S> Function() func) async {
//   assert(S is! Future, "Use executeProtected instead");
//   assert(S is! Result, "Use executeProtectedAsyncResult instead");
//   try {
//     return Ok(await func());
//   } catch (e, s) {
//     return Err(Error(e, s));
//   }
// }

// /// Async version of [executeProtectedResult]
// FutureResult<S, Error> safeExecAsyncResult<S>(
//     Future<Result<S, Error>> Function() func) async {
//   assert(S is! Future, "Use executeProtectedResult instead");
//   try {
//     return await func();
//   } catch (e, s) {
//     return Err(Error(e, s));
//   }
// }

/// {@macro futureResult}
typedef FutureResult<S, F extends Object> = Future<Result<S, F>>;

/// {@template futureResult}
/// [FutureResult] represents an asynchronous [Result]. And as such, inherits all of [Result]s methods.
/// {@endtemplate}
extension FutureOrResultExtension<S, F extends Object>
    on FutureOr<Result<S, F>> {
  FutureOr<R> _then<R>(FutureOr<R> Function(Result<S, F>) func) {
    if (this is Future<Result<S, F>>) {
      return (this as Future<Result<S, F>>).then((r) async => await func(r));
    } else {
      return func(this as Result<S, F>);
    }
  }

  FutureOr<S> unwrap() {
    return _then((result) => result.unwrap());
  }

  FutureOr<S> unwrapOr(S defaultValue) {
    return _then((result) => result.unwrapOr(defaultValue));
  }

  FutureOr<S> unwrapOrElse(FutureOr<S> Function(F) onError) {
    return mapOrElse(
      (err) {
        return onError(err);
      },
      (ok) {
        return ok;
      },
    );
  }

  FutureOr<S?> unwrapOrNull() {
    return _then((result) => result.unwrapOrNull());
  }

  FutureOr<F> unwrapErr() {
    return _then((result) => result.unwrapErr());
  }

  FutureOr<F> unwrapErrOr(F defaultValue) {
    return _then((result) => result.unwrapErrOr(defaultValue));
  }

  FutureOr<F> unwrapErrOrElse(FutureOr<F> Function(S ok) onOk) {
    return mapOrElse((error) {
      return error;
    }, (ok) {
      return onOk(ok);
    });
  }

  FutureOr<F?> unwrapErrOrNull() {
    return _then((result) => result.unwrapErrOrNull());
  }

  //************************************************************************//

  FutureOr<bool> isErr() {
    return _then((result) => result.isErr());
  }

  FutureOr<bool> isErrOr(bool Function(F) fn) {
    return _then((result) => result.isErrAnd(fn));
  }

  FutureOr<bool> isOk() {
    return _then((result) => result.isOk());
  }

  FutureOr<bool> isOkOr(bool Function(S) fn) {
    return _then((result) => result.isOkAnd(fn));
  }

  //************************************************************************//

  FutureOr<Iterable<S>> iter() {
    return _then((result) => result.iter());
  }

  //************************************************************************//

  FutureOr<Result<S2, F>> and<S2>(Result<S2, F> other) {
    return _then((result) => result.and(other));
  }

  FutureOr<Result<S, F2>> or<F2 extends Object>(Result<S, F2> other) {
    return _then((result) => result.or(other));
  }

  FutureOr<Result<S, F2>> orElse<F2 extends Object>(
      FutureOr<Result<S, F2>> Function(F) fn) {
    return mapOrElse(
      (error) {
        return fn(error);
      },
      (ok) {
        return Ok(ok);
      },
    );
  }

  //************************************************************************//

  FutureOr<W> match<W>(
      {required FutureOr<W> Function(S) ok,
      required FutureOr<W> Function(F) err}) {
    return _then<W>((result) => result.match(ok: ok, err: err));
  }

  FutureOr<Result<W, F>> map<W>(FutureOr<W> Function(S ok) fn) {
    return mapOrElse(
      (error) {
        return Err(error);
      },
      (ok) async {
        return Ok(await fn(ok));
      },
    );
  }

  FutureOr<W> mapOr<W>(W defaultValue, FutureOr<W> Function(S ok) fn) {
    return mapOrElse(
      (error) {
        return defaultValue;
      },
      (ok) {
        return fn(ok);
      },
    );
  }

  FutureOr<W> mapOrElse<W>(
      FutureOr<W> Function(F err) defaultFn, FutureOr<W> Function(S ok) fn) {
    return _then<W>((result) => result.mapOrElse(defaultFn, fn));
  }

  FutureOr<Result<S, W>> mapErr<W extends Object>(
      FutureOr<W> Function(F error) fn) {
    return mapOrElse(
      (error) async {
        return Err(await fn(error));
      },
      (ok) {
        return Ok(ok);
      },
    );
  }

  FutureOr<Result<W, F>> andThen<W>(FutureOr<Result<W, F>> Function(S ok) fn) {
    return mapOrElse(Err.new, fn);
  }

  FutureOr<Result<S, W>> andThenErr<W extends Object>(
      FutureOr<Result<S, W>> Function(F error) fn) {
    return mapOrElse(fn, Ok.new);
  }

  FutureOr<Result<S, F>> inspect(FutureOr<void> Function(S ok) fn) {
    return _then((result) => result.inspect(fn));
  }

  FutureOr<Result<S, F>> inspectErr(FutureOr<void> Function(F error) fn) {
    return _then((result) => result.inspectErr(fn));
  }

  //************************************************************************//

  FutureOr<Result<S, F>> copy() {
    return _then((result) => result.copy());
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

// extension FutureResult<T, E> on FutureOr<Result<T, E>> {
//   Future<C> fold<C>({
//     required C Function(T) ok,
//     required C Function(E) err,
//   }) =>
//       _then((r) => r.fold(ok: ok, err: err));

//   Future<Result<U, F>> map<U, F>({
//     required U Function(T value) ok,
//     required F Function(E error) err,
//   }) =>
//       _then((r) => r.map(ok: ok, err: err));

//   Future<Result<U, E>> mapOk<U>(U Function(T value) delegate) =>
//       _then((r) => r.mapOk(delegate));

//   Future<Result<T, F>> mapErr<F>(F Function(E error) delegate) =>
//       _then((r) => r.mapErr(delegate));

//   Future<T> unwrapOrElse(T Function(E) orElse) =>
//       _then((r) => r.getOrElse(orElse));

//   Future<T?> unwrapOrNull() => _then((r) => r.getOrNull());

//   Future<bool> get isOk => _then((r) => r.isOk);

//   Future<bool> get isErr => _then((r) => r.isErr);
// }

Ok<(), E> ok<E extends Object>() => Ok(());
