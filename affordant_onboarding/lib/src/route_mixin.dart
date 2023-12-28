import 'package:go_router/go_router.dart';
import 'package:flutter/widgets.dart';

import 'repository.dart';
import 'view_model.dart';

mixin OnboardingRouteMixin<SessionData, StepType extends Step<SessionData>>
    on GoRouteData {
  List<StepType> getOnboardingSteps(
    BuildContext context,
    GoRouterState state,
  );

  OnboardingRepository<SessionData> getOnboardingRepository(
    BuildContext context,
    GoRouterState state,
  );

  String redirection(
    BuildContext context,
    GoRouterState state,
  );

  @override
  String? redirect(BuildContext context, GoRouterState state) {
    final repository = getOnboardingRepository(context, state);

    final (_, status) = ComputeOnboardingState<SessionData, StepType>(
      onboardingRepository: repository,
      steps: getOnboardingSteps(context, state),
    ).computeForCurrent();

    if (status == OnboardingStatus.done) {
      return redirect(context, state);
    }
    return null;
  }
}
