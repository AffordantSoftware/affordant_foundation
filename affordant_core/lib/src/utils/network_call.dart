import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';

import 'package:affordant_core/affordant_core.dart';

extension _CoreLocalizations on BuildContext {
  AffordantCoreLocalizations get _coreL10n =>
      Localizations.of(this, AffordantCoreLocalizations);
}

sealed class NetworkError extends Error with DisplayableError {
  NetworkError([super.error, super.stackTrace, super.context]);
}

final class UnspecifiedServerError extends NetworkError {
  UnspecifiedServerError([super.error, super.stackTrace, super.context]);

  @override
  String localizedTitle(BuildContext context) =>
      context._coreL10n.error_server_unspecified_title;

  @override
  String localizedMessage(BuildContext context) =>
      context._coreL10n.error_server_unspecified_message;
}

final class NetworkUnavailableError extends NetworkError {
  NetworkUnavailableError([super.error, super.stackTrace, super.context]);

  @override
  String localizedTitle(BuildContext context) =>
      context._coreL10n.error_network_unavailable_title;

  @override
  String localizedMessage(BuildContext context) =>
      context._coreL10n.error_network_unavailable_message;
}

final class ServerUnavailableError extends NetworkError {
  ServerUnavailableError([super.error, super.stackTrace, super.context]);

  @override
  String localizedTitle(BuildContext context) =>
      context._coreL10n.error_server_unavailable_title;

  @override
  String localizedMessage(BuildContext context) =>
      context._coreL10n.error_server_unavailable_message;
}

/// Execute a network call, catch any error and convert them to a [NetworkError] or return [Ok]
/// TODO: timeout
Future<Result<T, Error>> safeNetworkCall<T>(
  FutureOr<T> Function() run, {
  Error Function(dynamic, StackTrace) onApiError = Error.new,
}) async {
  try {
    return Ok(await run());
  } catch (e, s) {
    return Err(switch (e) {
      SocketException() => NetworkUnavailableError(e, s),
      _ => Error(e, s),
    });
  }
}
