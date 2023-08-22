import 'errors.dart';
import 'form.dart';

final class Required<T> extends Validator<T> {
  const Required({this.requiredError = "required"});

  final String requiredError;

  @override
  List<ValidatorError>? validate(dynamic value) {
    late final error = [const ValidatorError("required")];
    if (value == null) return error;
    if (value is String && value.isEmpty) return error;
    return null;
  }
}

final class HasValue<T> extends Validator<T> {
  const HasValue(
    this.ref, {
    this.errorKey = "equality",
  });

  final T ref;
  final String errorKey;

  @override
  Iterable<ValidatorError>? validate(dynamic value) {
    if (value == ref) return null;
    return [ValidatorError(errorKey)];
  }
}

final class EqualsToField<T> extends Validator<T> {
  EqualsToField(this.ref, {this.errorKey = "equal_to_field"})
      : super(dependsOn: [ref]);

  final Field<T> ref;
  final String errorKey;

  @override
  Iterable<ValidatorError>? validate(T value) {
    if (value == ref.value) return null;
    return [ValidatorError(errorKey)];
  }
}

final class OnlyIf<T> extends Validator<T> {
  const OnlyIf(
    this.test, {
    required this.run,
  });

  final bool Function(T value) test;
  final CompoundValidator<T> run;

  @override
  Iterable<ValidatorError>? validate(T value) {
    if (test(value) == false) return null;
    return run.validate(value);
  }
}

final class Check<T, E> extends Validator<T> {
  const Check(this.test);

  final Iterable<ValidatorError>? Function(T) test;

  @override
  Iterable<ValidatorError>? validate(T value) {
    return test(value);
  }
}

class CompoundValidator<T> extends Validator<T> {
  CompoundValidator(this.validators);

  final List<Validator<T>> validators;

  @override
  Iterable<ValidatorError>? validate(T value) {
    return validators
        .map((v) => v.validate(value))
        .whereType<Iterable<ValidatorError>>()
        .expand((errors) => errors);
  }
}
