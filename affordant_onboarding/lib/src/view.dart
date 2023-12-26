import 'package:affordant_mvvm/affordant_mvvm.dart';
import 'package:affordant_onboarding/src/repository.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/widgets.dart';

import 'view_model.dart';

mixin OnboardingRouteMixin on GoRouteData {
  String get redirection;

  OnboardingRepository getModel(BuildContext context);

  @override
  String? redirect(BuildContext context, GoRouterState state) {
    final model = getModel(context);
    if (model.isDone.value) {
      return redirection;
    }
    return null;
  }
}

class OnboardingView<
    SessionData,
    StepType extends Step<SessionData>,
    OnboardingViewModelType extends OnboardingViewModel<SessionData,
        StepType>> extends StatelessWidget {
  const OnboardingView({
    super.key,
    required this.createViewModel,
    required this.loadingBuilder,
    required this.stepBuilder,
  });

  final WidgetBuilder loadingBuilder;
  final Widget Function(BuildContext context, StepType step) stepBuilder;
  final OnboardingViewModelType Function(BuildContext context) createViewModel;

  @override
  Widget build(BuildContext context) {
    return Provider<OnboardingViewModelType>(
      create: createViewModel,
      dispose: (context, value) => value.dispose(),
      child: _View<SessionData, StepType, OnboardingViewModelType>(
        loadingBuilder: loadingBuilder,
        stepBuilder: stepBuilder,
      ),
    );
  }
}

class _View<
    SessionData,
    StepType extends Step<SessionData>,
    OnboardingViewModelType extends OnboardingViewModel<SessionData,
        StepType>> extends StatelessWidget {
  const _View({
    required this.stepBuilder,
    required this.loadingBuilder,
  });

  final WidgetBuilder loadingBuilder;
  final Widget Function(BuildContext context, StepType step) stepBuilder;

  @override
  Widget build(BuildContext context) {
    final OnboardingState<SessionData, StepType>(:step, :status, :stepIndex) =
        context.watchSignal((OnboardingViewModelType vm) => (vm.state));

    if (status == OnboardingStatus.loading || step == null) {
      return loadingBuilder(context);
    }

    return PageView.builder(
      physics: const NeverScrollableScrollPhysics(),
      controller: context.read<OnboardingViewModelType>().pageController,
      itemBuilder: (context, index) => stepBuilder(
        context,
        step,
      ),
      itemCount: stepIndex,
    );
  }
}
