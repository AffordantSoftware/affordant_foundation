import 'dart:async';

import 'package:affordant_onboarding/affordant_onboarding.dart';
import 'package:example/model.dart';

class ExampleOnboardingStorage
    implements OnboardingStorageDelegate<SessionData> {
  @override
  Future<SessionData?> getSessionData() async {
    return null;
  }

  @override
  Future<List<String>?> getVisitedSteps() async {
    return null;
  }

  @override
  Future<void> setSessionData(data) async {}

  @override
  FutureOr<void> setVisitedSteps(List<String>? visitedSteps) {}
}
