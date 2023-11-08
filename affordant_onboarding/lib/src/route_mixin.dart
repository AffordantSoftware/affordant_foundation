import 'package:affordant_view_model/affordant_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/widgets.dart';

import 'model.dart';
import 'view_model.dart';

mixin OnboardingRouteMixin<
    SessionData,
    StepType extends Step<SessionData>,
    OnboardingViewModelType extends OnboardingViewModel<SessionData,
        StepType>> on GoRouteData {
  Widget buildStep(
    BuildContext context,
    OnboardingState<SessionData, StepType> state,
  );

  OnboardingViewModelType createViewModel(BuildContext context);

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BindAndConsume<OnboardingViewModelType,
        OnboardingState<SessionData, StepType>>(
      create: createViewModel,
      builder: buildStep,
    );
  }
}
