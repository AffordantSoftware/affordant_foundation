import 'package:affordant_navigation/affordant_navigation.dart';
import 'package:affordant_view_model/affordant_view_model.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'model.dart';
part 'view_model.freezed.dart';

@freezed
class OnboardingState<SessionDataType, StepType extends Step<SessionDataType>>
    with _$OnboardingState<SessionDataType, StepType> {
  const OnboardingState._();

  const factory OnboardingState({
    required SessionDataType? data,
    required StepType? step,
  }) = _OnboardingState;

  bool get isCurrentStepValid {
    final s = step;
    final d = data;
    if (d == null || s == null) return false;
    return s.validate(d);
  }
}

class OnboardingViewModel<SessionData, StepType extends Step<SessionData>>
    extends ViewModel<OnboardingState<SessionData, StepType>> with Observer {
  OnboardingViewModel({
    this.pageTransitionCurve = Curves.easeInOutCubic,
    this.pageTransitionDuration = const Duration(milliseconds: 460),
    required this.redirection,
    required this.navigationService,
    required this.onboardingModel,
  })  : steps = onboardingModel.steps,
        pageController = PageController(
          initialPage: onboardingModel.currentStep != null
              ? onboardingModel.steps.indexOf(onboardingModel.currentStep!)
              : 0,
        ),
        super(OnboardingState(
          data: onboardingModel.sessionData,
          step: onboardingModel.currentStep,
        )) {
    forEach(
      onboardingModel.sessionDataStream,
      onData: (data) => state.copyWith(data: data),
    );
    onEach(
      onboardingModel.stepStream,
      onData: _handleStepChanged,
    );
    onEach(onboardingModel.statusStream, onData: _handleStatusChanged);
  }

  final Duration pageTransitionDuration;
  final Curve pageTransitionCurve;
  final String redirection;
  final NavigationService navigationService;
  final OnboardingModel<SessionData, StepType> onboardingModel;
  final List<StepType> steps;
  PageController pageController;

  void _handleStepChanged(StepType? newStep) {
    final jumpToPage = newStep != null && state.step == null;
    emit(state.copyWith(step: newStep));
    if (jumpToPage) _initializePageController();
  }

  void _initializePageController() {
    final index = steps.indexOf(state.step!);
    if (pageController.hasClients) {
      pageController.jumpToPage(
        steps.indexOf(state.step!),
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

  void setData(SessionData data) {
    onboardingModel.sessionData = data;
  }

  void prev() {
    pageController.previousPage(
      duration: pageTransitionDuration,
      curve: pageTransitionCurve,
    );
    onboardingModel.previous();
  }

  void next() {
    pageController.nextPage(
      duration: pageTransitionDuration,
      curve: pageTransitionCurve,
    );
    onboardingModel.next();
  }
}
