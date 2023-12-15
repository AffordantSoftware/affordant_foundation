
# Summary

# Installation
add AffordantCoreLocalizations.delegate to your MaterialApp

# Result
Result object is used to represent the result of a fallible operation. It's takes its inspiration from the Rust language.
This implementation is subset of the rust standard library Result api, adapted for dart.

Result object are useful to define faillible operation and makes sur potential error are handled properly. While dart language already have exception,
this functional approach avoid issue with hidden uncaught exceptions.

The class is mainly designed to be used as return values for repositories's commands (TODO: add link to documentation).

This package also include an extension on `Future<Result>` which provides a similar API to the `Result` object, simply forwarding function call to the underlying `Result` object using `Future.then`. This makes working with async operation more straightforward.

## Usage
TODO

# Error
`Error` class is used to represent a error that should be handled. It also provides support for tracking human friendly error context for logging using `withContext` method.
`Error` can contain an arbitrary object and a stacktrace which are usually obtained from a `try-catch` close. If you don't provides a StackTrace to the Error, a new one will be instantiated using `StackTrace.current`.
If the object given to the error is an `Error` too, the error will looks for the inner stacktrace itself.
Calling `withContext` on an error will add a context to a list of context which can later be used for logging. If the inner error object is also an `Error`, the contexts will be aggregated. This is especially useful when wrapping generic error with context-specific error.

## Usage
TODO