import 'dart:async';
import 'dart:io';

import 'package:affordant_core/affordant_core.dart';

/// Execute a server call, catch any error and convert them to `UnspecifiedServerException`
Future<T> safeServerCall<T>(FutureOr<T> Function() run) async {
  try {
    return await run();
  } catch (e, s) {
    if (e is DisplayableException) {
      rethrow;
    } else {
      throw switch (e) {
        SocketException() => NetworkUnavailableException(e, s),
        _ => UnspecifiedServerException(e, s),
      };
    }
  }
}
