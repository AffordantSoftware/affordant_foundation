import 'dart:math';

import 'package:affordant_mvvm/affordant_mvvm.dart';
import 'package:collection/collection.dart';

import 'view_model.dart';

abstract class OnboardingRepository<SessionData> with ReactiveHost {
  OnboardingRepository();

  ReplicatedReactive<SessionData?> get sessionData;
  ReplicatedReactive<List<String>?> get visitedSteps;
}

/// Compute the actual onboarding state
/// [step] and [status] shouldn't be accessed before [run] as been called
class ComputeOnboardingState<SessionData, StepType extends Step<SessionData>> {
  ComputeOnboardingState({
    required this.onboardingRepository,
    required this.steps,
  });

  final OnboardingRepository<SessionData> onboardingRepository;
  final List<StepType> steps;

  (StepType? step, OnboardingStatus status) computeFor(
    SessionData? sessionData,
    List<String>? visitedSteps,
  ) {
    if (visitedSteps != null && sessionData != null) {
      final step = _findCurrentStep(steps, sessionData, visitedSteps);
      final status =
          step != null ? OnboardingStatus.inProgress : OnboardingStatus.done;
      return (step, status);
    } else {
      return (null, OnboardingStatus.loading);
    }
  }

  (StepType? step, OnboardingStatus status) computeForCurrent() {
    return computeFor(
      onboardingRepository.sessionData.value,
      onboardingRepository.visitedSteps.value,
    );
  }

  (StepType?, OnboardingStatus) computeForPreviousStep() {
    var (step, status) = computeForCurrent();

    if (step != null) {
      final index = steps.indexOf(step);
      step = steps.elementAtOrNull(max(index - 1, 0));
      return (
        step,
        step != null ? OnboardingStatus.inProgress : OnboardingStatus.loading
      );
    } else if (status == OnboardingStatus.done) {
      return (steps.last, OnboardingStatus.inProgress);
    } else {
      return (step, status);
    }
  }

  bool _isVisited(
    List<String> visitedSteps,
    Step step,
  ) =>
      visitedSteps.contains(step.id);

  StepType? _findCurrentStep(
    List<StepType> steps,
    SessionData data,
    List<String> visitedSteps,
  ) =>
      steps.firstWhereOrNull(
        (step) =>
            _isVisited(visitedSteps, step) == false ||
            step.canGoNext(data) == false,
      );
}
