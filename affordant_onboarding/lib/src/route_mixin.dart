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

  String get redirection;

  OnboardingModel getModel(BuildContext context);

  OnboardingViewModelType createViewModel(BuildContext context);

  @override
  String? redirect(BuildContext context, GoRouterState state) {
    final model = getModel(context);
    if (model.isDone) {
      return redirection;
    }
    return null;
  }

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BindAndConsume<OnboardingViewModelType,
        OnboardingState<SessionData, StepType>>(
      create: createViewModel,
      builder: buildStep,
    );
  }
}
