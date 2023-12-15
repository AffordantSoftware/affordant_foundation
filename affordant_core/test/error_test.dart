import 'package:affordant_core/affordant_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Error test", () {
    test('simple error instanciation', () {
      final e = Error("error", null, "context");
      expect(e.error, equals("error"));
      expect(e.stackTrace, isNotNull);
      expect(e.contexts, equals(["context"]));
    });

    test('error instanciation with stacktrace', () {
      final s = StackTrace.current;
      final e = Error("error", s, "context");
      expect(e.error, equals("error"));
      expect(e.stackTrace, equals(s));
      expect(e.contexts, equals(["context"]));
    });

    test('error instanciation with nested error object', () {
      final s = StackTrace.current;
      final e1 = Error("e1", s, "e1");
      final e2 = Error(e1, null, "e2");
      expect(e2.error, equals(e1));
      expect(e2.stackTrace, equals(s));
      expect(e2.contexts, equals(["e1", "e2"]));
    });

    test('simple error withContext', () {
      final e1 = Error(null)
        ..withContext("1")
        ..withContext("2");

      expect(e1.contexts, equals(["1", "2"]));
    });

    test('error withContext complex function call', () {
      Error createError() {
        return Error(null, null, "1");
      }

      Error someCall() {
        return createError()
          ..withContext("2")
          ..withContext("3");
      }

      final e1 = someCall()..withContext("4");

      expect(e1.contexts, equals(["1", "2", "3", "4"]));
    });

    test('context of nested errors are aggregated', () {
      Error createError() {
        return Error(null, null, "1");
      }

      Error someCall() {
        final e = createError()..withContext("2");
        return Error(e)..withContext("3");
      }

      final e1 = someCall()..withContext("4");
      final e2 = Error(e1, null, "5")..withContext("6");

      expect(e2.contexts, equals(["1", "2", "3", "4", "5", "6"]));
    });

    test('deep stacktrace are found', () {
      final s = StackTrace.current;

      Error createError() {
        return Error(null, s, null);
      }

      Error someCall() {
        final e = createError();
        return Error(e);
      }

      final e1 = someCall();
      final e2 = Error(e1, null, "5");

      expect(e2.stackTrace, equals(s));
    });

    test('error inner object is unchanged', () {
      final e = Error("inner");
      final e1 = Error(e);
      final e2 = Error(e1);

      expect(e.error, equals("inner"));
      expect(e1.error, equals(e));
      expect(e2.error, equals(e1));
    });
  });
}
