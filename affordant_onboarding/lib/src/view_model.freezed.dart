// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$OnboardingState<SessionData, StepType extends Step<SessionData>> {
  SessionData? get sessionData => throw _privateConstructorUsedError;
  StepType? get step => throw _privateConstructorUsedError;
  OnboardingStatus get status => throw _privateConstructorUsedError;
  bool get canGoNext => throw _privateConstructorUsedError;
  int get stepCount => throw _privateConstructorUsedError;
  int? get stepIndex => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $OnboardingStateCopyWith<SessionData, StepType,
          OnboardingState<SessionData, StepType>>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OnboardingStateCopyWith<SessionData,
    StepType extends Step<SessionData>, $Res> {
  factory $OnboardingStateCopyWith(OnboardingState<SessionData, StepType> value,
          $Res Function(OnboardingState<SessionData, StepType>) then) =
      _$OnboardingStateCopyWithImpl<SessionData, StepType, $Res,
          OnboardingState<SessionData, StepType>>;
  @useResult
  $Res call(
      {SessionData? sessionData,
      StepType? step,
      OnboardingStatus status,
      bool canGoNext,
      int stepCount,
      int? stepIndex});
}

/// @nodoc
class _$OnboardingStateCopyWithImpl<
        SessionData,
        StepType extends Step<SessionData>,
        $Res,
        $Val extends OnboardingState<SessionData, StepType>>
    implements $OnboardingStateCopyWith<SessionData, StepType, $Res> {
  _$OnboardingStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionData = freezed,
    Object? step = null,
    Object? status = freezed,
    Object? canGoNext = null,
    Object? stepCount = null,
    Object? stepIndex = freezed,
  }) {
    return _then(_value.copyWith(
      sessionData: freezed == sessionData
          ? _value.sessionData
          : sessionData // ignore: cast_nullable_to_non_nullable
              as SessionData?,
      step: null == step
          ? _value.step
          : step // ignore: cast_nullable_to_non_nullable
              as StepType?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as OnboardingStatus,
      canGoNext: null == canGoNext
          ? _value.canGoNext
          : canGoNext // ignore: cast_nullable_to_non_nullable
              as bool,
      stepCount: null == stepCount
          ? _value.stepCount
          : stepCount // ignore: cast_nullable_to_non_nullable
              as int,
      stepIndex: freezed == stepIndex
          ? _value.stepIndex
          : stepIndex // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OnboardingStateImplCopyWith<
    SessionData,
    StepType extends Step<SessionData>,
    $Res> implements $OnboardingStateCopyWith<SessionData, StepType, $Res> {
  factory _$$OnboardingStateImplCopyWith(
          _$OnboardingStateImpl<SessionData, StepType> value,
          $Res Function(_$OnboardingStateImpl<SessionData, StepType>) then) =
      __$$OnboardingStateImplCopyWithImpl<SessionData, StepType, $Res>;
  @override
  @useResult
  $Res call(
      {SessionData? sessionData,
      StepType? step,
      OnboardingStatus status,
      bool canGoNext,
      int stepCount,
      int? stepIndex});
}

/// @nodoc
class __$$OnboardingStateImplCopyWithImpl<SessionData,
        StepType extends Step<SessionData>, $Res>
    extends _$OnboardingStateCopyWithImpl<SessionData, StepType, $Res,
        _$OnboardingStateImpl<SessionData, StepType>>
    implements _$$OnboardingStateImplCopyWith<SessionData, StepType, $Res> {
  __$$OnboardingStateImplCopyWithImpl(
      _$OnboardingStateImpl<SessionData, StepType> _value,
      $Res Function(_$OnboardingStateImpl<SessionData, StepType>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionData = freezed,
    Object? step = null,
    Object? status = freezed,
    Object? canGoNext = null,
    Object? stepCount = null,
    Object? stepIndex = freezed,
  }) {
    return _then(_$OnboardingStateImpl<SessionData, StepType>(
      sessionData: freezed == sessionData
          ? _value.sessionData
          : sessionData // ignore: cast_nullable_to_non_nullable
              as SessionData?,
      step: null == step
          ? _value.step
          : step // ignore: cast_nullable_to_non_nullable
              as StepType?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as OnboardingStatus,
      canGoNext: null == canGoNext
          ? _value.canGoNext
          : canGoNext // ignore: cast_nullable_to_non_nullable
              as bool,
      stepCount: null == stepCount
          ? _value.stepCount
          : stepCount // ignore: cast_nullable_to_non_nullable
              as int,
      stepIndex: freezed == stepIndex
          ? _value.stepIndex
          : stepIndex // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$OnboardingStateImpl<SessionData, StepType extends Step<SessionData>>
    extends _OnboardingState<SessionData, StepType> {
  const _$OnboardingStateImpl(
      {required this.sessionData,
      required this.step,
      required this.status,
      required this.canGoNext,
      required this.stepCount,
      required this.stepIndex})
      : super._();

  @override
  final SessionData? sessionData;
  @override
  final StepType? step;
  @override
  final OnboardingStatus status;
  @override
  final bool canGoNext;
  @override
  final int stepCount;
  @override
  final int? stepIndex;

  @override
  String toString() {
    return 'OnboardingState<$SessionData, $StepType>(sessionData: $sessionData, step: $step, status: $status, canGoNext: $canGoNext, stepCount: $stepCount, stepIndex: $stepIndex)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnboardingStateImpl<SessionData, StepType> &&
            const DeepCollectionEquality()
                .equals(other.sessionData, sessionData) &&
            const DeepCollectionEquality().equals(other.step, step) &&
            const DeepCollectionEquality().equals(other.status, status) &&
            (identical(other.canGoNext, canGoNext) ||
                other.canGoNext == canGoNext) &&
            (identical(other.stepCount, stepCount) ||
                other.stepCount == stepCount) &&
            (identical(other.stepIndex, stepIndex) ||
                other.stepIndex == stepIndex));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(sessionData),
      const DeepCollectionEquality().hash(step),
      const DeepCollectionEquality().hash(status),
      canGoNext,
      stepCount,
      stepIndex);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OnboardingStateImplCopyWith<SessionData, StepType,
          _$OnboardingStateImpl<SessionData, StepType>>
      get copyWith => __$$OnboardingStateImplCopyWithImpl<SessionData, StepType,
          _$OnboardingStateImpl<SessionData, StepType>>(this, _$identity);
}

abstract class _OnboardingState<SessionData, StepType extends Step<SessionData>>
    extends OnboardingState<SessionData, StepType> {
  const factory _OnboardingState(
          {required final SessionData? sessionData,
          required final StepType? step,
          required final OnboardingStatus status,
          required final bool canGoNext,
          required final int stepCount,
          required final int? stepIndex}) =
      _$OnboardingStateImpl<SessionData, StepType>;
  const _OnboardingState._() : super._();

  @override
  SessionData? get sessionData;
  @override
  StepType? get step;
  @override
  OnboardingStatus get status;
  @override
  bool get canGoNext;
  @override
  int get stepCount;
  @override
  int? get stepIndex;
  @override
  @JsonKey(ignore: true)
  _$$OnboardingStateImplCopyWith<SessionData, StepType,
          _$OnboardingStateImpl<SessionData, StepType>>
      get copyWith => throw _privateConstructorUsedError;
}
