import 'dart:async';

import 'package:collection/collection.dart';

mixin Step<SessionData> {
  /// A unique id representing this step
  String get id;

  /// Check if the session data match requierments for this step
  /// If no, the step will be displayed
  bool validate(SessionData data);
}

abstract interface class OnboardingRepository<SessionData> {
  FutureOr<void> setSessionData(SessionData? data);
  FutureOr<SessionData?> getSessionData();
  FutureOr<void> markStepVisited(String stepID, bool visited);
  FutureOr<List<String>?> getVisitedSteps();
}

class OnboardingModel<SessionData, StepType extends Step<SessionData>> {
  OnboardingModel({
    required this.createSession,
    required this.onboardingRepository,
    required this.config,
  }) : assert(config.isNotEmpty);

  FutureOr<SessionData> Function() createSession;

  final OnboardingRepository onboardingRepository;

  final List<StepType> config;

  final _stepStreamController = StreamController<StepType?>.broadcast();

  final _sessionDataStreamController =
      StreamController<SessionData?>.broadcast();

  SessionData? _sessionData;

  StepType? _currentStep;

  List<String> visitedSteps = [];

  set sessionData(SessionData? data) {
    _sessionData = data;
    _sessionDataStreamController.add(_sessionData);
    onboardingRepository.setSessionData(data);
  }

  SessionData? get sessionData => _sessionData;

  Future<void> init() async {
    sessionData =
        await onboardingRepository.getSessionData() ?? await createSession();
    visitedSteps = await onboardingRepository.getVisitedSteps() ?? [];

    /// Iterate over all step and found the first non-visited step
    _setCurrentStepAndNotify(
      config.firstWhereOrNull(
        (step) => visitedSteps.contains(step.id) == false,
      ),
    );
  }

  Stream<StepType?> get stepStream => _stepStreamController.stream;

  StepType? get currentStep => _currentStep;

  SpecificStep? step<SpecificStep extends StepType>() =>
      config.firstWhereOrNull((step) => step is SpecificStep) as SpecificStep;

  void _setCurrentStepAndNotify(StepType? value) {
    if (_currentStep != value) {
      _currentStep = value;
      _stepStreamController.add(_currentStep);
    }
  }

  /// Unset data in back-end only so we avoid skipping step if we start
  /// a new session
  void previous() {
    if (_currentStep != null) {
      final index = config.indexOf(_currentStep!);
      if (index > 0) {
        final previousStep = config[index - 1];
        visitedSteps.remove(_currentStep!.id);
        onboardingRepository.markStepVisited(_currentStep!.id, false);
        _setCurrentStepAndNotify(previousStep);
      }
    }
  }

  /// Check if data is validated by the step
  /// if yes, move to next step add step to visited steps list
  void next() {
    final step = currentStep;
    final data = sessionData;
    if (step != null && data != null && step.validate(data)) {
      visitedSteps.add(step.id);
      onboardingRepository.setSessionData(sessionData);
      onboardingRepository.markStepVisited(step.id, true);

      final index = config.indexOf(step);
      if (index < config.length - 1) {
        final nextStep = config[index + 1];
        _setCurrentStepAndNotify(nextStep);
      } else {
        _setCurrentStepAndNotify(null);
      }
    }
  }

  bool get isDone => visitedSteps.contains(config.last.id);
}
