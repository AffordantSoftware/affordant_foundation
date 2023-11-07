import 'package:affordant_view_model/affordant_view_model.dart';
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
}

class OnboardingViewModel<SessionData, StepType extends Step<SessionData>>
    extends ViewModel<OnboardingState<SessionData, StepType>> with Observer {
  OnboardingViewModel({required this.onboardingModel})
      : super(OnboardingState(
          data: onboardingModel.sessionData,
          step: onboardingModel.currentStep,
        )) {
    forEach(
      onboardingModel.sessionDataStream,
      onData: (data) => state.copyWith(data: data),
    );
    forEach(onboardingModel.stepStream,
        onData: (step) => state.copyWith(step: step));
  }

  final OnboardingModel<SessionData, StepType> onboardingModel;

  void setData(SessionData data) {
    onboardingModel.sessionData = data;
  }

  void prev() {
    onboardingModel.previous();
  }

  void next() {
    onboardingModel.next();
  }
}

// @freezed
// class StepState<T> with _$StepState<T> {
//   const StepState._();

//   const factory StepState({
//     required bool canGoNext,
//     required T data,
//   }) = _StepState;
// }

// class OnboardingStepViewModel<SpecificStep extends Step<SessionData>,
//     ViewDataType> extends ViewModel<StepState<ViewDataType>> {
//   final OnboardingViewModel onboardingViewModel;
//   final SpecificStep step;

//   OnboardingStepViewModel(
//     super.initialState, {
//     required this.step,
//     required this.onboardingViewModel,
//   });

//   void setSessionData(SessionData data) {
//     onboardingViewModel.setData(data);
//     emit(state.copyWith(
//       canGoNext: step.validate(data),
//     ));
//   }
// }
