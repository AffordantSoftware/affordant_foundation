import 'dart:collection';
import 'package:affordant_form/src/errors.dart';
import 'package:flutter/material.dart';

// Todo: Support for isSubmitButton enabled
// The controller should be a change notifier / own a value notifier
// It should also listen to field changes and update is own value accordingly
// The form may also integrate a custom error field + a custom validators
// The form should handle save function
abstract base class FormController with ChangeNotifier {
  FormController() {
    for (final field in fields) {
      field.addListener(_fieldListener);
    }
  }

  List<Field> get fields;

  List<Field> _erroredFields = [];

  UnmodifiableListView<Field> get erroredFields =>
      UnmodifiableListView(_erroredFields);

  bool get hasError => _erroredFields.isNotEmpty;

  bool get isSubmitButtonEnabled => isValid();

  bool get isPure => fields
      .map((value) => value.isPure)
      .reduce((allPure, pure) => allPure && pure);

  bool get isDirty => fields
      .map((value) => value.isDirty)
      .reduce((allDirty, dirty) => allDirty && dirty);

  bool validate() {
    bool valid = true;
    for (final f in fields) {
      valid = valid & f.validate();
    }
    return valid;
  }

  bool isValid() => fields
      .map((value) => value.isValid())
      .reduce((allValid, valid) => allValid && valid);

  void reset() {
    for (final f in fields) {
      f.reset();
    }
    validate();
  }

  Map<String, dynamic> snapshot() => {
        for (final f in fields) f.key: f.value,
      };

  @override
  void dispose() {
    for (final f in fields) {
      f.removeListener(_fieldListener);
      f.dispose();
    }
    super.dispose();
  }

  void _fieldListener() {
    final list = fields.where((f) => f.hasError).toList();
    if (list != _erroredFields) {
      _erroredFields = list;
      notifyListeners();
    }
  }
}

abstract class Validator<T> {
  const Validator({this.dependsOn});

  Iterable<ValidatorError>? validate(T value);

  final List<Field>? dependsOn;
}

class Field<T> with ChangeNotifier {
  Field(
    this.key, {
    required this.initialValue,
    T? value,
    this.validators,
  }) : _value = value ?? initialValue {
    _listenDependencies();
  }

  final String key;
  final T initialValue;
  final List<Validator<T>>? validators;

  T _value;
  FieldError? _error;

  T get value => _value;

  set value(T newValue) {
    if (_value != newValue) {
      _value = newValue;
      validate();
      notifyListeners();
    }
  }

  bool get isPure => initialValue == value;

  bool get isDirty => !isPure;

  FieldError? get error => _error;

  bool get hasError => _error != null;

  bool isValid() {
    if (isPure) return _computeFieldError() == null;
    return _error == null;
  }

  void reset() {
    value = initialValue;
  }

  bool validate() {
    final newError = _computeFieldError();
    if (newError != _error) {
      _error = newError;
      notifyListeners();
    }

    return newError == null;
  }

  Iterable<Field> _getDependencies() {
    return validators
            ?.where((v) => v.dependsOn != null)
            .expand((v) => v.dependsOn!) ??
        {};
  }

  void _listenDependencies() {
    for (final field in _getDependencies()) {
      assert(field != this, "Field registered itself as a dependency");
      field.addListener(validate);
    }
  }

  FieldError<Field<T>>? _computeFieldError() {
    final validatorsErrors =
        _computeValidatorsErrors()?.expand((errors) => errors);
    if (validatorsErrors != null) {
      return FieldError(this, validatorsErrors.toList());
    }
    return null;
  }

  Iterable<Iterable<ValidatorError>>? _computeValidatorsErrors() {
    final list = validators
        ?.map((v) => v.validate(value))
        .whereType<Iterable<ValidatorError>>();
    if (list?.isNotEmpty == true) return list;
    return null;
  }

  @override
  void dispose() {
    for (final field in _getDependencies()) {
      field.removeListener(validate);
    }
    super.dispose();
  }
}

class Form<T extends FormController> extends InheritedWidget {
  static T of<T extends FormController>(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<Form<T>>()!.controller;

  const Form({
    required this.controller,
    super.key,
    required super.child,
  });

  final T controller;

  @override
  bool updateShouldNotify(Form oldWidget) {
    return oldWidget.controller != controller;
  }
}

class FormField<T> extends StatelessWidget {
  const FormField({
    super.key,
    required this.field,
    required this.builder,
  });

  final Field<T> field;
  final Widget Function(BuildContext context, Field<T> field) builder;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: field,
      builder: (context, _) => builder(context, field),
    );
  }
}
