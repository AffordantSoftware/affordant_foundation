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
abstract class DisplayableException {
  const DisplayableException(
    this.stackTrace,
  );

  final StackTrace stackTrace;

  String localizedTitle(BuildContext context);
  String localizedMessage(BuildContext context);
}

extension _CoreLocalizations on BuildContext {
  AffordantCoreLocalizations get _coreL10n =>
      Localizations.of(this, AffordantCoreLocalizations);
}

final class UnspecifiedServerException extends DisplayableException {
  const UnspecifiedServerException(super.stackTrace);

  @override
  String localizedTitle(BuildContext context) =>
      context._coreL10n.error_server_unspecified_title;

  @override
  String localizedMessage(BuildContext context) =>
      context._coreL10n.error_server_unspecified_message;
}

final class NetworkUnavailableException extends DisplayableException {
  const NetworkUnavailableException(super.stackTrace);

  @override
  String localizedTitle(BuildContext context) =>
      context._coreL10n.error_network_unavailable_title;

  @override
  String localizedMessage(BuildContext context) =>
      context._coreL10n.error_network_unavailable_message;
}

final class ServerUnavailableException extends DisplayableException {
  const ServerUnavailableException(super.stackTrace);

  @override
  String localizedTitle(BuildContext context) =>
      context._coreL10n.error_server_unavailable_title;

  @override
  String localizedMessage(BuildContext context) =>
      context._coreL10n.error_server_unavailable_message;
}
