import 'package:affordant_core/affordant_core.dart';
import 'package:flutter/material.dart';

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
mixin DisplayableException {
  String localizedTitle(BuildContext context);
  String localizedMessage(BuildContext context);
}

base class TraceableException<T> {
  const TraceableException(this.error, this.stackTrace);
  final T error;
  final StackTrace stackTrace;
}

extension _CoreLocalizations on BuildContext {
  AffordantCoreLocalizations get _coreL10n =>
      Localizations.of(this, AffordantCoreLocalizations);
}

final class UnspecifiedServerException extends TraceableException
    with DisplayableException {
  const UnspecifiedServerException(super.error, super.stackTrace);

  @override
  String localizedTitle(BuildContext context) =>
      context._coreL10n.error_server_unspecified_title;

  @override
  String localizedMessage(BuildContext context) =>
      context._coreL10n.error_server_unspecified_message;
}

final class NetworkUnavailableException extends TraceableException
    with DisplayableException {
  const NetworkUnavailableException(super.error, super.stackTrace);

  @override
  String localizedTitle(BuildContext context) =>
      context._coreL10n.error_network_unavailable_title;

  @override
  String localizedMessage(BuildContext context) =>
      context._coreL10n.error_network_unavailable_message;
}

final class ServerUnavailableException with DisplayableException {
  const ServerUnavailableException();

  @override
  String localizedTitle(BuildContext context) =>
      context._coreL10n.error_server_unavailable_title;

  @override
  String localizedMessage(BuildContext context) =>
      context._coreL10n.error_server_unavailable_message;
}
