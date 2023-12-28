import 'dart:async';
import 'package:affordant_onboarding/affordant_onboarding.dart';
import 'package:example/repository.dart';
import 'package:example/view_model.dart';
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

@TypedGoRoute<OnboardingRoute>(
  path: '/onboarding',
)
class OnboardingRoute extends GoRouteData with OnboardingRouteMixin {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return OnboardingView(
      createViewModel: (_) => MyOnboardingViewModel(
        onboardingRepository: exampleModel,
        onOnboardingCompleted: () => context.go('/'),
      ),
      loadingBuilder: (_) => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      stepBuilder: (BuildContext context, MyStep step) => switch (step) {
        Step1 s => Onboarding1Screen(step: s),
        Step2 s => Onboarding2Screen(step: s),
      },
    );
  }

  @override
  OnboardingRepository getOnboardingRepository(
          BuildContext context, GoRouterState state) =>
      exampleModel;

  @override
  List<MyStep> getOnboardingSteps(BuildContext context, GoRouterState state) =>
      onboardingSteps;

  @override
  String redirection(BuildContext context, GoRouterState state) => '/';
}
