// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'repository.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$OnboardingState<SessionData, StepType extends Step<SessionData>> {
  OnboardingStatus get status => throw _privateConstructorUsedError;
  SessionData? get data => throw _privateConstructorUsedError;
  StepType? get step => throw _privateConstructorUsedError;

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
  $Res call({OnboardingStatus status, SessionData? data, StepType? step});
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
    Object? status = null,
    Object? data = freezed,
    Object? step = null,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as OnboardingStatus,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as SessionData?,
      step: null == step
          ? _value.step
          : step // ignore: cast_nullable_to_non_nullable
              as StepType?,
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
  $Res call({OnboardingStatus status, SessionData? data, StepType? step});
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
    Object? status = null,
    Object? data = freezed,
    Object? step = null,
  }) {
    return _then(_$OnboardingStateImpl<SessionData, StepType>(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as OnboardingStatus,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as SessionData?,
      step: null == step
          ? _value.step
          : step // ignore: cast_nullable_to_non_nullable
              as StepType?,
    ));
  }
}

/// @nodoc

class _$OnboardingStateImpl<SessionData, StepType extends Step<SessionData>>
    extends _OnboardingState<SessionData, StepType> {
  const _$OnboardingStateImpl(
      {required this.status, required this.data, required this.step})
      : super._();

  @override
  final OnboardingStatus status;
  @override
  final SessionData? data;
  @override
  final StepType? step;

  @override
  String toString() {
    return 'OnboardingState<$SessionData, $StepType>(status: $status, data: $data, step: $step)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnboardingStateImpl<SessionData, StepType> &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other.data, data) &&
            const DeepCollectionEquality().equals(other.step, step));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      status,
      const DeepCollectionEquality().hash(data),
      const DeepCollectionEquality().hash(step));

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
          {required final OnboardingStatus status,
          required final SessionData? data,
          required final StepType? step}) =
      _$OnboardingStateImpl<SessionData, StepType>;
  const _OnboardingState._() : super._();

  @override
  OnboardingStatus get status;
  @override
  SessionData? get data;
  @override
  StepType? get step;
  @override
  @JsonKey(ignore: true)
  _$$OnboardingStateImplCopyWith<SessionData, StepType,
          _$OnboardingStateImpl<SessionData, StepType>>
      get copyWith => throw _privateConstructorUsedError;
}
