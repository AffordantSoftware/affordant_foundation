import 'dart:async';
import 'package:affordant_mvvm/affordant_mvvm.dart';
import 'package:collection/collection.dart';

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

abstract class StorageDelegate<SessionData> {
  const StorageDelegate();

  FutureOr<SessionData?> getSessionData();
  FutureOr<void> setSessionData(SessionData? sessionData);

  FutureOr<List<String>?> getVisitedSteps();
  FutureOr<void> setVisitedSteps(List<String>? visitedSteps);
}

class OnboardingRepository<SessionData, StepType extends Step<SessionData>> {
  OnboardingRepository({
    required this.storageDelegate,
    required this.steps,
    this.onOnboardingCompleted,
  }) : assert(steps.isNotEmpty);

  final void Function()? onOnboardingCompleted;

  final StorageDelegate<SessionData> storageDelegate;

  final List<StepType> steps;

  final Signal<OnboardingStatus> _status = signal(OnboardingStatus.loading);
  final Signal<SessionData?> _sessionData = signal(null);
  final Signal<StepType?> _currentStep = signal(null);

  ReadonlySignal<OnboardingStatus> get status => _status;
  ReadonlySignal<SessionData?> get sessionData => _sessionData;
  ReadonlySignal<StepType?> get currentStep => _currentStep;

  List<String>? _visitedSteps;

  Future<void> init() async {
    final data = await storageDelegate.getSessionData();
    _visitedSteps = await storageDelegate.getVisitedSteps() ?? [];

    final (step, status) = _computeStepAndStatus(
      steps,
      _visitedSteps,
      data,
    );

    batch(() {
      _sessionData.value = data;
      _currentStep.value = step;
      _status.value = status;
    });
  }

  Future<void> setSessionData(SessionData? data) async {
    await storageDelegate.setSessionData(data);
    _sessionData.value = data;
  }

  Future<void> nextStep() async {
    if (status.value != OnboardingStatus.inProgress) return;

    final step = currentStep.value;
    final data = sessionData.value;
    if (data != null && step != null && step.canGoNext(data) == true) {
      _visitedSteps?.add(step.id);
      storageDelegate.setVisitedSteps(_visitedSteps);

      final (newStep, newStatus) =
          _computeStepAndStatus(steps, _visitedSteps, data);

      batch(() {
        _currentStep.value = newStep;
        _status.value = newStatus;
      });
    }
  }

  late final ReadonlySignal<bool> isDone =
      computed(() => status.value == OnboardingStatus.done);

  /// We remove previous screen from visisted list
  void previousStep() {
    if (status.value == OnboardingStatus.loading) return;

    final data = sessionData.value;
    final step = currentStep.value;

    if (data != null && step != null) {
      storageDelegate.setVisitedSteps(_visitedSteps);
      _visitedSteps?.remove(step.id);

      final (newStep, newStatus) =
          _computeStepAndStatus(steps, _visitedSteps, data);

      batch(() {
        _currentStep.value = newStep;
        _status.value = newStatus;
      });
    }
  }

  (StepType?, OnboardingStatus) _computeStepAndStatus(
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
