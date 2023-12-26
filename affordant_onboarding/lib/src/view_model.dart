import 'package:affordant_mvvm/affordant_mvvm.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'repository.dart' as repo;

PageController
    _initPageController<SessionData, StepType extends repo.Step<SessionData>>(
  repo.OnboardingRepository repository,
) {
  final currentStep = repository.state.step;
  return PageController(
    initialPage:
        currentStep != null ? repository.steps.indexOf(currentStep) : 0,
  );
}

class OnboardingState<SessionData, StepType extends repo.Step<SessionData>> {
  final SessionData? sessionData;
  final StepType? step;
  final repo.OnboardingStatus status;
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

class OnboardingViewModel<SessionData, StepType extends repo.Step<SessionData>>
    extends Cubit<OnboardingState<SessionData, StepType>>
    with StreamListenerCubit {
  OnboardingViewModel({
    required this.onboardingRepository,
    this.pageTransitionCurve = Curves.easeInOutCubic,
    this.pageTransitionDuration = const Duration(milliseconds: 460),
    required this.redirection,
    required this.navigationService,
  })  : pageController = _initPageController(onboardingRepository),
        super(
          OnboardingState(
            sessionData: onboardingRepository.state.data,
            step: onboardingRepository.state.step,
            status: onboardingRepository.state.status,
            canGoNext: onboardingRepository.state.step
                    ?.canGoNext(onboardingRepository.state.data) ==
                true,
            stepCount: onboardingRepository.steps.length,
            stepIndex: onboardingRepository.state.step != null
                ? onboardingRepository.steps
                    .indexOf(onboardingRepository.state.step!)
                : null,
          ),
        ) {
    onEach(
      onboardingRepository.stateStream,
      onData: (newState) {
        final newStep = newState.step;
        final newData = newState.data;

        if (newState.isDone) {
          navigationService.go(redirection);
        } else {
          _handleStepChange(newStep);

          emit(OnboardingState(
            sessionData: newData,
            step: newStep,
            status: newState.status,
            canGoNext: newStep?.canGoNext(newData) == true,
            stepCount: onboardingRepository.steps.length,
            stepIndex: newStep != null
                ? onboardingRepository.steps.indexOf(newStep)
                : null,
          ));
        }
      },
    );
  }

  final repo.OnboardingRepository<SessionData, StepType> onboardingRepository;
  final Duration pageTransitionDuration;
  final Curve pageTransitionCurve;
  final String redirection;
  final GoRouter navigationService;
  PageController pageController;

  late final Function() _signalSubscriptionDisposer;
  set sessionData(SessionData? data) {
    onboardingRepository.setSessionData(data);
  }

  List<StepType> get steps => onboardingRepository.steps;

  void prev() {
    onboardingRepository.previousStep();
  }

  void next() {
    onboardingRepository.nextStep();
  }

  void dispose() {
    _signalSubscriptionDisposer();
  }

  void _handleStepChange(StepType? newStep) {
    if (newStep == null || state.step == newStep) return;

    final int index = onboardingRepository.steps.indexOf(newStep);

    if (state.step == null) {
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
}
