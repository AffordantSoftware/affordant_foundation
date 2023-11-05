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
  OnboardingModel<SessionData, StepType> get model;

  String get redirection;

  Widget buildStep(BuildContext context, StepType? step);

  OnboardingViewModelType createViewModel(BuildContext context);

  @override
  String? redirect(BuildContext context, GoRouterState state) {
    if (model.isDone) {
      return redirection;
    }
    return null;
  }

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BindAndConsume<OnboardingViewModelType, StepType?>(
      create: createViewModel,
      builder: buildStep,
    );
  }
}
