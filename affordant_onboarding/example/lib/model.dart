import 'package:affordant_onboarding/affordant_onboarding.dart';

// sealed class ExampleStep<T> extends Step<T> {}

// class Step1 extends ExampleStep<bool> {}

// class Step2 extends ExampleStep<bool> {}

class SessionData {
  bool hasReadStep1 = false;
  bool hasReadStep2 = false;
}

sealed class ExampleStep with Step<SessionData> {
  @override
  String get id => runtimeType.toString();

  @override
  bool validate(SessionData data) => true;
}

class Step1 extends ExampleStep {
//   @override
//   bool validate(SessionData data) => data.hasReadStep1;
}

class Step2 extends ExampleStep {
  // @override
  // bool validate(SessionData data) => data.hasReadStep2;
}
