import 'dart:async';

import 'package:affordant_onboarding/affordant_onboarding.dart';
import 'package:example/model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'screens.dart';
part 'router.g.dart';

final router = GoRouter(
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

class MyOnboardingViewModel extends OnboardingViewModel<SessionData, MyStep> {
  MyOnboardingViewModel({
    required super.onboardingModel,
    required super.navigationService,
    required super.redirection,
  });

  void setStep1Read() {
    onboardingModel.sessionData?.hasReadStep1 = true;
  }
}

@TypedGoRoute<OnboardingRoute>(
  path: '/onboarding',
)
class OnboardingRoute extends GoRouteData
    with OnboardingRouteMixin<SessionData, MyStep, MyOnboardingViewModel> {
  @override
  final String redirection = '/';

  @override
  OnboardingModel getModel(BuildContext context) => exampleModel;

  @override
  MyOnboardingViewModel createViewModel(context) => MyOnboardingViewModel(
        redirection: redirection,
        navigationService: router,
        onboardingModel: exampleModel,
      );

  @override
  Widget buildStep(BuildContext context, state) => switch (state.step) {
        Step1 s => Onboarding1Screen(step: s),
        Step2 s => Onboarding2Screen(step: s),
        _ => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
      };
}
