import 'result.dart';
import 'error.dart';

typedef CommandResult<E extends Error> = Future<Result<void, E>>;
