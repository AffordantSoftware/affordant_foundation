import 'form.dart';
import 'package:flutter/material.dart';

final class Required<T> extends Validator<T, LocalizedError> {
  const Required({this.requiredError = "required"});

  final String requiredError;

  @override
  Iterable<LocalizedError>? validate(dynamic value) {
    late final error = [const LocalizedError("required")];
    if (value == null) return error;
    if (value is String && value.isEmpty) return error;
    return null;
  }
}

final class HasValue<T> extends Validator<T, LocalizedError> {
  const HasValue(
    this.ref, {
    this.errorKey = "equality",
  });

  final T ref;
  final String errorKey;

  @override
  Iterable<LocalizedError>? validate(dynamic value) {
    if (value == ref) return null;
    return [LocalizedError(errorKey)];
  }
}

final class EqualsToField<T> extends Validator<T, LocalizedError> {
  EqualsToField(this.ref, {this.errorKey = "equal_to_field"})
      : super(dependsOn: [ref]);

  final Field<T, dynamic> ref;
  final String errorKey;

  @override
  Iterable<LocalizedError>? validate(T value) {
    if (value == ref.value) return null;
    return [LocalizedError(errorKey)];
  }
}

final class OnlyIf<T> extends Validator<T, LocalizedError> {
  const OnlyIf(
    this.test, {
    required this.run,
  });

  final bool Function(T value) test;
  final CompoundValidator<T, LocalizedError> run;

  @override
  Iterable<LocalizedError>? validate(T value) {
    if (test(value) == false) return null;
    return run.validate(value);
  }
}

final class Check<T, E> extends Validator<T, E> {
  const Check(this.test);

  final Iterable<E>? Function(T) test;

  @override
  Iterable<E>? validate(T value) {
    return test(value);
  }
}

class CompoundValidator<T, E> extends Validator<T, E> {
  CompoundValidator(this.validators);

  final List<Validator<T, E>> validators;

  @override
  Iterable<E>? validate(T value) {
    return validators
        .map((v) => v.validate(value))
        .whereType<Iterable<E>>()
        .expand((errors) => errors);
  }
}
