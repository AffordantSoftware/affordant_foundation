import 'dart:async';

import 'package:affordant_onboarding/affordant_onboarding.dart';
import 'package:example/model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'screens.dart';
part 'router.g.dart';

class ListenableStreamAdapter with ChangeNotifier {
  ListenableStreamAdapter(Stream stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription _subscription;

  @override
  Future<void> dispose() async {
    await _subscription.cancel();
    super.dispose();
  }
}

// final exampleModel = OnboardingModel<ExampleStep>(
//   config: [
//     Step1(),
//     Step2(),
//   ],
// );

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

final exampleModel = OnboardingModel<SessionData, ExampleStep>(
  createSession: () => SessionData(),
  onboardingRepository: ExampleOnboardingRepository(),
  config: [
    Step1(),
    Step2(),
  ],
);

final router = GoRouter(
  refreshListenable: ListenableStreamAdapter(exampleModel.stepStream),
  initialLocation: '/onboarding',
  routes: $appRoutes,
);

@TypedGoRoute<HomeRoute>(
  path: '/',
)
class HomeRoute extends GoRouteData {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const HomeScreen();
}

// @TypedGoRoute<OnboardingRoute>(
//   path: '/onboarding',
// )
// class OnboardingRoute extends GoRouteData
//     with OnboardingRouteMixin<ExampleStep> {
//   @override
//   final redirection = '/';

//   @override
//   OnboardingModel<ExampleStep> get model => exampleModel;

//   @override
//   Widget buildStep(BuildContext context, ExampleStep? step) => switch (step) {
//         Step1 s => Onboarding1Screen(step: s),
//         Step2 s => Onboarding2Screen(step: s),
//         _ => const SizedBox.shrink(),
//       };
// }

class MyOnboardingViewModel
    extends OnboardingViewModel<SessionData, ExampleStep> {
  MyOnboardingViewModel({
    required super.onboardingModel,
  });

  void setStep1Read() {
    onboardingModel.sessionData?.hasReadStep1 = true;
  }
}

@TypedGoRoute<OnboardingRoute>(
  path: '/onboarding',
)
class OnboardingRoute extends GoRouteData
    with OnboardingRouteMixin<SessionData, ExampleStep, MyOnboardingViewModel> {
  @override
  final redirection = '/';

  @override
  OnboardingModel<SessionData, ExampleStep> get model => exampleModel;

  @override
  MyOnboardingViewModel createViewModel(context) => MyOnboardingViewModel(
        onboardingModel: exampleModel,
      );

  @override
  Widget buildStep(BuildContext context, ExampleStep? step) => switch (step) {
        Step1 s => Onboarding1Screen(step: s),
        Step2 s => Onboarding2Screen(step: s),
        _ => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
      };
}
