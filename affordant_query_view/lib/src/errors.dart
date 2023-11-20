import 'package:affordant_core/affordant_core.dart';
import 'package:flutter/widgets.dart';

final class QueryError extends DisplayableError {
  const QueryError(super.error, super.stackTrace);

  @override
  String display(BuildContext context) {
    /// Todo: localizations
    return error.toString();
  }
}
