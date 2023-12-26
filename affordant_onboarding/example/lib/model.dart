import 'package:affordant_onboarding/affordant_onboarding.dart';

import 'repository.dart';

// sealed class ExampleStep<T> extends Step<T> {}

// class Step1 extends ExampleStep<bool> {}

// class Step2 extends ExampleStep<bool> {}

class SessionData {
  final bool hasReadStep1;
  final bool hasReadStep2;

  SessionData({required this.hasReadStep1, required this.hasReadStep2});

  SessionData copyWith({
    bool? hasReadStep1,
    bool? hasReadStep2,
  }) =>
      SessionData(
        hasReadStep1: hasReadStep1 ?? this.hasReadStep1,
        hasReadStep2: hasReadStep2 ?? this.hasReadStep2,
      );
}

sealed class MyStep with Step<SessionData> {
  @override
  String get id => runtimeType.toString();

  @override
  bool canGoNext(SessionData? data) => true;
}

class Step1 extends MyStep {}

class Step2 extends MyStep {}

class MyOnboardingRepo extends OnboardingRepository<SessionData, MyStep> {
  MyOnboardingRepo({
    required super.storageDelegate,
  }) : super(
          initialSessionData: () => SessionData(
            hasReadStep1: false,
            hasReadStep2: false,
          ),
          steps: [
            Step1(),
            Step2(),
          ],
        );
}

final exampleModel = MyOnboardingRepo(
  storageDelegate: ExampleOnboardingStorage(),
);
