import 'package:go_router/go_router.dart';
import 'package:flutter/widgets.dart';

import 'repository.dart';
import 'view_model.dart';

mixin OnboardingRouteMixin<SessionData, StepType extends Step<SessionData>>
    on GoRouteData {
  List<StepType> steps(
    BuildContext context,
    GoRouterState state,
  );

  OnboardingRepository<SessionData> onboardingRepository(
    BuildContext context,
    GoRouterState state,
  );

  String redirection(
    BuildContext context,
    GoRouterState state,
  );

  @override
  String? redirect(BuildContext context, GoRouterState state) {
    final repository = onboardingRepository(context, state);

    final (_, status) = ComputeOnboardingState<SessionData, StepType>(
      onboardingRepository: repository,
      steps: steps(context, state),
    ).computeForCurrent();

    if (status == OnboardingStatus.done) {
      return redirect(context, state);
    }
    return null;
  }
}
