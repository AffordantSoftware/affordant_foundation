import 'package:affordant_onboarding/affordant_onboarding.dart';
import 'package:example/model.dart';

class ExampleOnboardingRepository implements OnboardingRepository<SessionData> {
  @override
  SessionData? getSessionData() {
    return null;
  }

  @override
  List<String>? getVisitedSteps() {
    return null;
  }

  @override
  void markStepVisited(String stepID, bool visited) {}

  @override
  void setSessionData(data) {}
}
