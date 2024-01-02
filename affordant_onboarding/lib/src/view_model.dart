import 'dart:async';

import 'package:affordant_mvvm/affordant_mvvm.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'repository.dart';
import 'strategy.dart';

part 'view_model.freezed.dart';

mixin Step<SessionData> {
  String get id;

  bool canGoNext(SessionData? data);
}

enum OnboardingStatus {
  loading,
  inProgress,
  done,
}

@freezed
class OnboardingState<SessionData, StepType extends Step<SessionData>>
    with _$OnboardingState<SessionData, StepType> {
  const OnboardingState._();

  const factory OnboardingState({
    required SessionData? sessionData,
    required StepType? step,
    required OnboardingStatus status,
    required bool canGoNext,
    required int stepCount,
    required int? stepIndex,
  }) = _OnboardingState;
}

class OnboardingViewModel<SessionData, StepType extends Step<SessionData>>
    extends Cubit<OnboardingState<SessionData, StepType>>
    with StreamListenerCubit {
  OnboardingViewModel({
    required this.onboardingRepository,
    required this.steps,
    required this.onOnboardingCompleted,
    this.pageTransitionCurve = Curves.easeInOutCubic,
    this.pageTransitionDuration = const Duration(milliseconds: 460),
    this.replicationStrategy =
        const OnboardingDataReplicationStrategy.onStepChanged(),
  })  : pageController = PageController(),
        computeOnboardingState = ComputeOnboardingState(
          onboardingRepository: onboardingRepository,
          steps: steps,
        ),
        super(
          OnboardingState(
            sessionData: null,
            step: null,
            status: OnboardingStatus.loading,
            canGoNext: false,
            stepCount: steps.length,
            stepIndex: 0,
          ),
        ) {
    forEach(
      onboardingRepository.sessionData.stream,
      onData: (sessionData) {
        return state.copyWith(
          sessionData: sessionData,
          canGoNext: state.step?.canGoNext(sessionData) == true,
        );
      },
    );
    forEach(
      onboardingRepository.visitedSteps.stream,
      onData: (_) {
        final (step, status) = computeOnboardingState.computeForCurrent();

        if (status == OnboardingStatus.done) {
          onOnboardingCompleted.call();
        } else {
          _handleStepTransitionPageAnimation(step);
        }

        // Todo: test if this can raise an exception if the call back navigate to andother page
        // await Future.delayed(milliseconds: 300);

        return state.copyWith(
          step: step,
          status: status,
          stepIndex: step != null ? steps.indexOf(step) : null,
          canGoNext: step?.canGoNext(state.sessionData) == true,
        );
      },
    );
  }

  final VoidCallback onOnboardingCompleted;
  final ComputeOnboardingState<SessionData, StepType> computeOnboardingState;
  final Duration pageTransitionDuration;
  final Curve pageTransitionCurve;
  final OnboardingRepository<SessionData> onboardingRepository;
  final OnboardingDataReplicationStrategy replicationStrategy;
  final List<StepType> steps;

  PageController pageController;

  Future<void> setSessionData(SessionData? data) async {
    final policy = replicationStrategy.replicateOnDataChanged
        ? WritePolicy.optimistic
        : WritePolicy.cacheOnly;
    onboardingRepository.sessionData.set(data, policy: policy);
  }

  /// We remove previous screen from visited list so we can re-enter again
  Future<void> prev() async {
    if (state.status == OnboardingStatus.loading) return;

    final data = state.sessionData;
    final step = state.step;

    if (data != null && step != null) {
      final (newStep, newStatus) =
          computeOnboardingState.computeForPreviousStep();

      if (newStep != null) {
        final visited = {...?onboardingRepository.visitedSteps.value}
          ..remove(newStep.id);
        onboardingRepository.visitedSteps.set(visited.toList());
      }

      await _maybeReplicateSessionDataOnStepChanged(data, newStatus);
    }
  }

  Future<void> next() async {
    if (state.status != OnboardingStatus.inProgress) return;

    final step = state.step;
    final data = state.sessionData;
    if (data != null && step != null && step.canGoNext(data) == true) {
      final visited =
          {...?onboardingRepository.visitedSteps.value, step.id}.toList();

      final (_, newStatus) = computeOnboardingState.computeFor(
        onboardingRepository.sessionData.value,
        visited,
      );

      await _maybeReplicateSessionDataOnStepChanged(data, newStatus);

      onboardingRepository.visitedSteps.set(visited.toList());
    }
  }

  void dispose() {
    pageController.dispose();
  }

  void _handleStepTransitionPageAnimation(StepType? newStep) {
    if (newStep == null || state.step == newStep) return;

    final int index = steps.indexOf(newStep);

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

  FutureOr<void> _maybeReplicateSessionDataOnStepChanged(
    SessionData newData,
    OnboardingStatus newStatus,
  ) async {
    final WritePolicy policy;
    if (replicationStrategy.replicateOnStepChanged) {
      if (newStatus == OnboardingStatus.done &&
          replicationStrategy.waitForDataReplicatedBeforeDone) {
        policy = WritePolicy.networkFirst;
      } else {
        policy = WritePolicy.optimistic;
      }
    } else {
      policy = WritePolicy.cacheOnly;
    }
    onboardingRepository.sessionData.set(newData, policy: policy);
  }
}
