import 'dart:async';
import 'dart:math';
import 'package:affordant_mvvm/affordant_mvvm.dart';
import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'repository.freezed.dart';

mixin Step<SessionData> {
  String get id;
  bool canGoNext(SessionData? data);
}

enum OnboardingStatus {
  loading,
  inProgress,
  done,
}

typedef StatusUpdate<SessionData> = (Step<SessionData>?, OnboardingStatus);

abstract class OnboardingStorageDelegate<SessionData> {
  const OnboardingStorageDelegate();

  FutureOr<SessionData?> getSessionData();
  FutureOr<void> setSessionData(SessionData? sessionData);

  FutureOr<List<String>?> getVisitedSteps();
  FutureOr<void> setVisitedSteps(List<String>? visitedSteps);
}

@freezed
class OnboardingState<SessionData, StepType extends Step<SessionData>>
    with _$OnboardingState<SessionData, StepType> {
  const OnboardingState._();

  const factory OnboardingState({
    required OnboardingStatus status,
    required SessionData? data,
    required StepType? step,
  }) = _OnboardingState;

  bool get isDone => status == OnboardingStatus.done;
}

class OnboardingRepository<SessionData, StepType extends Step<SessionData>> {
  OnboardingRepository({
    required this.initialSessionData,
    required this.storageDelegate,
    required this.steps,
    this.onOnboardingCompleted,
  }) : assert(steps.isNotEmpty);

  final SessionData Function() initialSessionData;
  final void Function()? onOnboardingCompleted;

  final OnboardingStorageDelegate<SessionData> storageDelegate;

  final List<StepType> steps;

  final _state = BehaviorSubject<OnboardingState<SessionData, StepType>>.seeded(
      const OnboardingState(
    status: OnboardingStatus.loading,
    data: null,
    step: null,
  ));

  Stream<OnboardingState<SessionData, StepType>> get stateStream =>
      _state.stream;
  OnboardingState<SessionData, StepType> get state => _state.value;

  Set<String> _visitedSteps = {};

  Future<void> init() async {
    final data = await storageDelegate.getSessionData() ?? initialSessionData();
    _visitedSteps = (await storageDelegate.getVisitedSteps())?.toSet() ?? {};

    final (step, status) = _computeCurrentStepAndStatus(
      steps,
      _visitedSteps.toList(),
      data,
    );

    _state.add(OnboardingState(
      data: data,
      step: step,
      status: status,
    ));
  }

  Future<void> setSessionData(SessionData? data) async {
    _state.add(_state.value.copyWith(data: data));
    storageDelegate.setSessionData(data);
  }

  Future<void> nextStep() async {
    if (_state.value.status != OnboardingStatus.inProgress) return;

    final step = _state.value.step;
    final data = _state.value.data;
    if (data != null && step != null && step.canGoNext(data) == true) {
      _visitedSteps.add(step.id);
      storageDelegate.setVisitedSteps(_visitedSteps.toList());

      final (newStep, newStatus) =
          _computeCurrentStepAndStatus(steps, _visitedSteps.toList(), data);

      _state.add(_state.value.copyWith(
        step: newStep,
        status: newStatus,
      ));
    }
  }

  /// We remove previous screen from visisted list
  void previousStep() {
    if (_state.value.status == OnboardingStatus.loading) return;

    final data = _state.value.data;
    final step = _state.value.step;

    if (data != null && step != null) {
      final (newStep, newStatus) =
          _computePreviousStepAndStatus(steps, _visitedSteps.toList(), data);

      if (newStep != null) {
        _visitedSteps.remove(newStep.id);
        storageDelegate.setVisitedSteps(_visitedSteps.toList());
      }

      _state.add(_state.value.copyWith(
        step: newStep,
        status: newStatus,
      ));
    }
  }

  (StepType?, OnboardingStatus) _computeCurrentStepAndStatus(
    List<StepType> steps,
    List<String>? visitedSteps,
    SessionData? sessionData,
  ) {
    if (visitedSteps == null || sessionData == null) {
      return (null, OnboardingStatus.loading);
    }
    final step = _findCurrentStep<SessionData, StepType>(
        steps, sessionData, visitedSteps);
    return (
      step,
      step != null ? OnboardingStatus.inProgress : OnboardingStatus.done
    );
  }

  (StepType?, OnboardingStatus) _computePreviousStepAndStatus(
    List<StepType> steps,
    List<String>? visitedSteps,
    SessionData? sessionData,
  ) {
    if (visitedSteps == null || sessionData == null) {
      return (null, OnboardingStatus.loading);
    }
    var step = _findCurrentStep<SessionData, StepType>(
        steps, sessionData, visitedSteps);
    if (step != null) {
      final index = steps.indexOf(step);
      step = steps.elementAtOrNull(max(index - 1, 0));
    }

    return (
      step,
      step != null ? OnboardingStatus.inProgress : OnboardingStatus.done
    );
  }
}

bool _isVisited<SessionData>(
  List<String> visitedSteps,
  Step step,
) =>
    visitedSteps.contains(step.id);

StepType? _findCurrentStep<SessionData, StepType extends Step<SessionData>>(
  List<StepType> steps,
  SessionData data,
  List<String> visitedSteps,
) =>
    steps.firstWhereOrNull(
      (step) =>
          _isVisited(visitedSteps, step) == false ||
          step.canGoNext(data) == false,
    );
