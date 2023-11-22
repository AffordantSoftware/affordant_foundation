import 'dart:io';

import 'package:affordant_core/affordant_core.dart';

/// Execute a server call, catch any error and convert them to `UnspecifiedServerException`
T safeServerCall<T>(T Function() run) {
  try {
    return run();
  } on SocketException catch (e, s) {
    throw NetworkUnavailableException(e, s);
  } catch (e, s) {
    throw UnspecifiedServerException(e, s);
  }
}
