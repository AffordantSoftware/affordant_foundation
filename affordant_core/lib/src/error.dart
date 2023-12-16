import 'dart:async';

import 'package:flutter/widgets.dart';

import 'result.dart';

/// How to write a good error message:
/// Title: Say what happened
/// Message:
/// 1. Provides reassurance
/// 2. Say why its happened
/// 3. Help user fix issue
/// 4. Give a way out
///
/// Example:
/// Unable to save your changes
/// Your changes are saved locally, but we are unable to connect to your account because your device not connected to internet.
/// Please re-connect and try again. If the problem persist, contact [Customer Care](http://customercare.com)
base mixin DisplayableError on Error {
  String localizedTitle(BuildContext context);
  String localizedMessage(BuildContext context);
}

extension FutureResultErrorExtension<T, E extends Error>
    on Future<Result<T, E>> {
  /// If add context to Error if Result is Err
  Future<Result<T, E>> withContext(String context) => then(
        (r) => r.withContext(context),
      );
}

extension FutureOrResultErrorExtension<T, E extends Error>
    on FutureOr<Result<T, E>> {
  /// If add context to Error if Result is Err
  FutureOr<Result<T, E>> withContext(String context) => switch (this) {
        final Future f => f.then((r) => r.withContext(context)),
        _ => this.withContext(context),
      };
}

extension ResultErrExtension<T, E extends Error> on Result<T, E> {
  /// If add context to Error if Result is Err
  Result<T, E> withContext(String context) {
    if (this case Err(:final err)) {
      err.withContext(context);
    }
    return this;
  }
}

base class Error {
  Error(this.error, [StackTrace? stackTrace, String? context])
      : _stackTrace = error is Error ? null : stackTrace ?? StackTrace.current,
        _contexts = [if (context != null) context];

  /// Enrich error with context
  void withContext(String context) {
    _contexts.add(context);
  }

  final dynamic error;

  final StackTrace? _stackTrace;

  final List<String> _contexts;

  StackTrace? get stackTrace => error is Error ? error.stackTrace : _stackTrace;

  Iterable<String> get contexts => [
        if (error is Error) ...error.contexts,
        ..._contexts,
      ];
}

// final class UnknownError extends Error with DisplayableError {
//   UnknownError({super.error, super.stackTrace, super.context});

//   @override
//   String localizedMessage(BuildContext context) {
//     return "unknown";
//   }

//   @override
//   String localizedTitle(BuildContext context) {
//     return "unknown";
//   }
// }
