import 'package:affordant_onboarding/affordant_onboarding.dart';
import 'package:example/repository.dart';

sealed class MyStep with Step<SessionData> {
  @override
  String get id => runtimeType.toString();

  @override
  bool canGoNext(SessionData? data) => true;
}

class Step1 extends MyStep {}

class Step2 extends MyStep {}

final onboardingSteps = [
  Step1(),
  Step2(),
];

class MyOnboardingViewModel extends OnboardingViewModel<SessionData, MyStep> {
  MyOnboardingViewModel({
    required super.onboardingRepository,
    required super.onOnboardingCompleted,
  }) : super(steps: onboardingSteps);

  void setStep1Read() {
    setSessionData(
      state.sessionData?.copyWith(
        hasReadStep1: true,
      ),
    );
  }
}
