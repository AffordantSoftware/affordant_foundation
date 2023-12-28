import 'package:affordant_mvvm/affordant_mvvm.dart';
import 'package:affordant_onboarding/affordant_onboarding.dart';
import 'package:flutter/widgets.dart';

class OnboardingView<StepType extends Step,
        OnboardingViewModelType extends OnboardingViewModel<dynamic, StepType>>
    extends StatelessWidget {
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
    return BlocProvider<OnboardingViewModelType>(
      create: createViewModel,
      child: _View<StepType, OnboardingViewModelType>(
        loadingBuilder: loadingBuilder,
        stepBuilder: stepBuilder,
      ),
    );
  }
}

class _View<StepType extends Step,
        OnboardingViewModelType extends OnboardingViewModel<dynamic, StepType>>
    extends StatelessWidget {
  const _View({
    required this.stepBuilder,
    required this.loadingBuilder,
  });

  final WidgetBuilder loadingBuilder;
  final Widget Function(BuildContext context, StepType step) stepBuilder;

  @override
  Widget build(BuildContext context) {
    final loading =
        context.select((OnboardingViewModelType vm) => vm.state.step == null);
    if (loading) return loadingBuilder(context);
    final steps = context.select((OnboardingViewModelType vm) => vm.steps);
    return PageView.builder(
      physics: const NeverScrollableScrollPhysics(),
      controller: context.read<OnboardingViewModelType>().pageController,
      itemBuilder: (context, index) => stepBuilder(
        context,
        steps[index],
      ),
      itemCount: steps.length,
    );
  }
}
