import 'package:affordant_onboarding/affordant_onboarding.dart';
import 'package:example/model.dart';

class ExampleOnboardingRepository implements OnboardingRepository<SessionData> {
  @override
  Future<SessionData?> getSessionData() async {
    return null;
  }

  @override
  Future<List<String>?> getVisitedSteps() async {
    return null;
  }

  @override
  Future<void> markStepVisited(String stepID, bool visited) async {}

  @override
  Future<void> setSessionData(data) async {}
}
