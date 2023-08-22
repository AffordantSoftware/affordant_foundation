import 'package:affordant_core/affordant_core.dart';
import 'package:flutter/material.dart';

import 'form.dart';

class ValidatorError {
  final String errorKey;
  final Map<String, dynamic>? parameters;

  const ValidatorError(
    this.errorKey, {
    this.parameters,
  });
}

class FieldError<T extends Field> with Displayable {
  FieldError(this.field, this.errors);

  final T field;
  final List<ValidatorError> errors;

  @override
  String display(BuildContext context) =>
      errors.firstOrNull?.errorKey ?? "error";
}
