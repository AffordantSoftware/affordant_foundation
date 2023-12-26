import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:affordant_mvvm/affordant_mvvm.dart';

import 'repository.dart';

PageController
    _initPageController<SessionData, StepType extends Step<SessionData>>(
  OnboardingRepository repository,
) {
  final currentStep = repository.currentStep.value;
  return PageController(
    initialPage:
        currentStep != null ? repository.steps.indexOf(currentStep) : 0,
  );
}

class OnboardingState<SessionData, StepType extends Step<SessionData>> {
  final SessionData? sessionData;
  final StepType? step;
  final OnboardingStatus status;
  final bool canGoNext;
  final int stepCount;
  final int? stepIndex;

  const OnboardingState({
    required this.sessionData,
    required this.step,
    required this.status,
    required this.canGoNext,
    required this.stepCount,
    required this.stepIndex,
  });
}

class OnboardingViewModel<SessionData, StepType extends Step<SessionData>> {
  OnboardingViewModel({
    required this.onboardingRepository,
    this.pageTransitionCurve = Curves.easeInOutCubic,
    this.pageTransitionDuration = const Duration(milliseconds: 460),
    required this.redirection,
    required this.navigationService,
  }) : pageController = _initPageController(onboardingRepository) {
    _signalSubscriptionDisposer = effect(() {
      _handleStepChanged(
        onboardingRepository.currentStep.previousValue,
        onboardingRepository.currentStep.value,
      );
      _handleStatusChanged(
        onboardingRepository.status.value,
      );
    });
  }

  final OnboardingRepository<SessionData, StepType> onboardingRepository;
  final Duration pageTransitionDuration;
  final Curve pageTransitionCurve;
  final String redirection;
  final GoRouter navigationService;
  PageController pageController;

  late final Function() _signalSubscriptionDisposer;

  late final ReadonlySignal<OnboardingState<SessionData, StepType>> state =
      computed(() {
    final step = onboardingRepository.currentStep.value;
    final data = onboardingRepository.sessionData.value;

    return OnboardingState(
      sessionData: data,
      step: step,
      status: onboardingRepository.status.value,
      canGoNext: step?.canGoNext(data) == true,
      stepCount: onboardingRepository.steps.length,
      stepIndex: step != null ? onboardingRepository.steps.indexOf(step) : null,
    );
  });

  set sessionData(SessionData? data) {
    onboardingRepository.setSessionData(data);
  }

  SessionData? get sessionData => onboardingRepository.sessionData.value;

  void prev() {
    onboardingRepository.previousStep();
  }

  void next() {
    onboardingRepository.nextStep();
  }

  void dispose() {
    _signalSubscriptionDisposer();
  }

  void _handleStepChanged(StepType? previousStep, StepType? newStep) {
    if (newStep == null) return;

    final int index = onboardingRepository.steps.indexOf(newStep);

    if (previousStep == null) {
      _jumpToPage(index);
    } else {
      _animateToPage(index);
    }
  }

  void _jumpToPage(int index) {
    if (pageController.hasClients) {
      pageController.jumpToPage(index);
    } else {
      /// We can safely re-construct the controller since it doesn't have client
      pageController = PageController(initialPage: index);
    }
  }

  void _animateToPage(int index) {
    if (pageController.hasClients) {
      pageController.animateToPage(
        index,
        duration: pageTransitionDuration,
        curve: pageTransitionCurve,
      );
    } else {
      /// We can safely re-construct the controller since it doesn't have client
      pageController = PageController(initialPage: index);
    }
  }

  void _handleStatusChanged(OnboardingStatus? status) {
    if (status == OnboardingStatus.done) {
      navigationService.go(redirection);
    }
  }
}
