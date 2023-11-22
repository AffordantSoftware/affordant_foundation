import 'package:affordant_core/affordant_core.dart';

/// Execute a server call, catch any error and convert them to `UnspecifiedServerException`
T safeServerCall<T>(T Function() run) {
  try {
    return run();
  } catch (e, s) {
    throw UnspecifiedServerException(e, s);
  }
}
