import 'package:flutter/material.dart';

import 'form.dart';

abstract class FieldError<T extends Field> {
  FieldError(this.field);

  final T field;
  final String errorKey;
  final Map<String, dynamic> parameters;
}

class LocalizedError {
  const LocalizedError(this.key);

  final String key;

  String display(BuildContext context) => key;
}
