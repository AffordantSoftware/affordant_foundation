sealed class Result<T, E> {
  const Result();

  static Result<T, void> fromNullable<T>(T? value) {
    return switch (value) {
      Object() => Ok(value),
      null => Err(null),
    };
  }

  bool get isOk => switch (this) {
        Ok<T, E>() => true,
        Err<T, E>() => false,
      };

  bool get isErr => switch (this) {
        Ok<T, E>() => false,
        Err<T, E>() => true,
      };

  C fold<C>({
    required C Function(T) ok,
    required C Function(E) err,
  }) =>
      switch (this) {
        final Ok<T, E> res => ok(res.value),
        final Err<T, E> res => err(res.error),
      };

  Result<U, F> map<U, F>({
    required U Function(T value) ok,
    required F Function(E error) err,
  }) =>
      switch (this) {
        final Ok<T, E> res => Ok(ok(res.value)),
        final Err<T, E> res => Err(err(res.error)),
      };

  Result<U, E> mapOk<U>(U Function(T value) delegate) => map(
        ok: delegate,
        err: (err) => err,
      );

  Result<T, F> mapErr<F>(F Function(E error) delegate) => map(
        ok: (ok) => ok,
        err: delegate,
      );

  T getOrElse(T Function(E) orElse) => fold(
        ok: (ok) => ok,
        err: orElse,
      );

  T? getOrNull() => fold(
        ok: (ok) => ok,
        err: (_) => null,
      );

  // Result<T, E> when({
  //   required void Function(T) ok,
  //   required void Function(E) err,
  // }) {
  //   switch (this) {
  //     case final Ok<T, E> res:
  //       ok(res.value);
  //     case final Err<T, E> res:
  //       err(res.value);
  //   }
  //   return this;
  // }

  // Result<T, E> whenOk(void Function(T) sideEffect) => when(
  //       ok: sideEffect,
  //       err: (_) {},
  //     );

  // Result<T, E> whenErr(void Function(E) sideEffect) => when(
  //       ok: (ok) {},
  //       err: sideEffect,
  //     );
}

class Ok<T, E> extends Result<T, E> {
  const Ok(this.value);

  final T value;
}

class Err<T, E> extends Result<T, E> {
  const Err(this.error);

  final E error;
}

extension FutureResult<T, E> on Future<Result<T, E>> {
  Future<C> fold<C>({
    required C Function(T) ok,
    required C Function(E) err,
  }) =>
      then((r) => r.fold(ok: ok, err: err));

  Future<Result<U, F>> map<U, F>({
    required U Function(T value) ok,
    required F Function(E error) err,
  }) =>
      then((r) => r.map(ok: ok, err: err));

  Future<Result<U, E>> mapOk<U>(U Function(T value) delegate) =>
      then((r) => r.mapOk(delegate));

  Future<Result<T, F>> mapErr<F>(F Function(E error) delegate) =>
      then((r) => r.mapErr(delegate));

  Future<T> getOrElse(T Function(E) orElse) => then((r) => r.getOrElse(orElse));

  Future<T?> getOrNull() => then((r) => r.getOrNull());
}

Ok<void, E> ok<E>() => Ok(null);
