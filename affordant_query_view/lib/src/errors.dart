import 'package:affordant_core/affordant_core.dart';
import 'package:affordant_query_view/src/l10n/affordant_query_view_localizations.dart';
import 'package:flutter/material.dart';

base class QueryError extends TraceableException with DisplayableException {
  const QueryError(super.error, super.stackTrace);

  @override
  String localizedTitle(BuildContext context) {
    return Localizations.of(context, AffordantQueryViewLocalizations)
        .error_query_unspecified_title;
  }

  @override
  String localizedMessage(BuildContext context) {
    return Localizations.of(context, AffordantQueryViewLocalizations)
        .error_query_unspecified_message;
  }
}
