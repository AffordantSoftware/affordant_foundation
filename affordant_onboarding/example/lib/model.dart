import 'package:affordant_onboarding/affordant_onboarding.dart';

import 'repository.dart';

// sealed class ExampleStep<T> extends Step<T> {}

// class Step1 extends ExampleStep<bool> {}

// class Step2 extends ExampleStep<bool> {}

class SessionData {
  bool hasReadStep1 = false;
  bool hasReadStep2 = false;
}

sealed class MyStep with Step<SessionData> {
  @override
  String get id => runtimeType.toString();

  @override
  bool validate(SessionData data) => true;
}

class Step1 extends MyStep {}

class Step2 extends MyStep {}

class MyOnboardingModel extends OnboardingModel<SessionData, MyStep> {
  MyOnboardingModel({
    required super.onboardingRepository,
  }) : super(
          initialSessionData: () => SessionData(),
          steps: [
            Step1(),
            Step2(),
          ],
        );
}

final exampleModel = MyOnboardingModel(
  onboardingRepository: ExampleOnboardingRepository(),
);
