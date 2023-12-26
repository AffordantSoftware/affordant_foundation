import 'package:affordant_onboarding/affordant_onboarding.dart';

class ExampleOnboardingStorageDelegate implements StorageDelegate<SessionData> {
  const ExampleOnboardingStorageDelegate();

  @override
  SessionData? getSessionData() => null;

  @override
  void setSessionData(SessionData? sessionData) {}

  @override
  List<String>? getVisitedSteps() => null;

  @override
  void setVisitedSteps(List<String>? visitedSteps) {}
}

class SessionData {
  bool hasReadStep1 = false;
  bool hasReadStep2 = false;
}

sealed class MyStep with Step<SessionData> {
  @override
  String get id => runtimeType.toString();

  @override
  bool canGoNext(SessionData? data) => true;
}

class Step1 extends MyStep {}

class Step2 extends MyStep {}

class MyOnboardingRepository extends OnboardingRepository<SessionData, MyStep> {
  MyOnboardingRepository()
      : super(
          storageDelegate: const ExampleOnboardingStorageDelegate(),
          steps: [
            Step1(),
            Step2(),
          ],
        );
}

final exampleRepo = MyOnboardingRepository();
