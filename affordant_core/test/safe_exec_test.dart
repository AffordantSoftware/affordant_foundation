import 'package:affordant_core/affordant_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('safeExec', () {
    void syncThrow() {
      throw "syncThrow";
    }

    Future<void> asyncThrow() async {
      throw "syncThrow";
    }

    test("exception is caught for sync func", () async {
      final res = await safeExec(syncThrow);
      expect(res, isA<Err<void, Error>>());
    });

    test("exception is caught for async func", () async {
      final res = safeExec(asyncThrow);
      expect(res, isA<Future>());
      final res2 = await res;
      expect(res2, isA<Err<void, Error>>());
    });

    test("exception is caught for nested async func", () async {
      final res = safeExec(() async {
        await asyncThrow();
      });
      expect(res, isA<Future>());
      final res2 = await res;
      expect(res2, isA<Err<void, Error>>());
    });

    test("exception is caught for nested async func with forwarded future",
        () async {
      final res = safeExec(() async {
        return asyncThrow();
      });
      expect(res, isA<Future>());
      final res2 = await res;
      expect(res2, isA<Err<void, Error>>());
    });
  });
}
