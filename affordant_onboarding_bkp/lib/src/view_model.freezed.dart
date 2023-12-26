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
mixin _$OnboardingState<SessionDataType,
    StepType extends Step<SessionDataType>> {
  SessionDataType? get data => throw _privateConstructorUsedError;
  StepType? get step => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $OnboardingStateCopyWith<SessionDataType, StepType,
          OnboardingState<SessionDataType, StepType>>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OnboardingStateCopyWith<SessionDataType,
    StepType extends Step<SessionDataType>, $Res> {
  factory $OnboardingStateCopyWith(
          OnboardingState<SessionDataType, StepType> value,
          $Res Function(OnboardingState<SessionDataType, StepType>) then) =
      _$OnboardingStateCopyWithImpl<SessionDataType, StepType, $Res,
          OnboardingState<SessionDataType, StepType>>;
  @useResult
  $Res call({SessionDataType? data, StepType? step});
}

/// @nodoc
class _$OnboardingStateCopyWithImpl<
        SessionDataType,
        StepType extends Step<SessionDataType>,
        $Res,
        $Val extends OnboardingState<SessionDataType, StepType>>
    implements $OnboardingStateCopyWith<SessionDataType, StepType, $Res> {
  _$OnboardingStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
    Object? step = null,
  }) {
    return _then(_value.copyWith(
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as SessionDataType?,
      step: null == step
          ? _value.step
          : step // ignore: cast_nullable_to_non_nullable
              as StepType?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OnboardingStateImplCopyWith<
    SessionDataType,
    StepType extends Step<SessionDataType>,
    $Res> implements $OnboardingStateCopyWith<SessionDataType, StepType, $Res> {
  factory _$$OnboardingStateImplCopyWith(
          _$OnboardingStateImpl<SessionDataType, StepType> value,
          $Res Function(_$OnboardingStateImpl<SessionDataType, StepType>)
              then) =
      __$$OnboardingStateImplCopyWithImpl<SessionDataType, StepType, $Res>;
  @override
  @useResult
  $Res call({SessionDataType? data, StepType? step});
}

/// @nodoc
class __$$OnboardingStateImplCopyWithImpl<SessionDataType,
        StepType extends Step<SessionDataType>, $Res>
    extends _$OnboardingStateCopyWithImpl<SessionDataType, StepType, $Res,
        _$OnboardingStateImpl<SessionDataType, StepType>>
    implements _$$OnboardingStateImplCopyWith<SessionDataType, StepType, $Res> {
  __$$OnboardingStateImplCopyWithImpl(
      _$OnboardingStateImpl<SessionDataType, StepType> _value,
      $Res Function(_$OnboardingStateImpl<SessionDataType, StepType>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
    Object? step = null,
  }) {
    return _then(_$OnboardingStateImpl<SessionDataType, StepType>(
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as SessionDataType?,
      step: null == step
          ? _value.step
          : step // ignore: cast_nullable_to_non_nullable
              as StepType?,
    ));
  }
}

/// @nodoc

class _$OnboardingStateImpl<SessionDataType,
        StepType extends Step<SessionDataType>>
    extends _OnboardingState<SessionDataType, StepType> {
  const _$OnboardingStateImpl({required this.data, required this.step})
      : super._();

  @override
  final SessionDataType? data;
  @override
  final StepType? step;

  @override
  String toString() {
    return 'OnboardingState<$SessionDataType, $StepType>(data: $data, step: $step)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnboardingStateImpl<SessionDataType, StepType> &&
            const DeepCollectionEquality().equals(other.data, data) &&
            const DeepCollectionEquality().equals(other.step, step));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(data),
      const DeepCollectionEquality().hash(step));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OnboardingStateImplCopyWith<SessionDataType, StepType,
          _$OnboardingStateImpl<SessionDataType, StepType>>
      get copyWith => __$$OnboardingStateImplCopyWithImpl<
          SessionDataType,
          StepType,
          _$OnboardingStateImpl<SessionDataType, StepType>>(this, _$identity);
}

abstract class _OnboardingState<SessionDataType,
        StepType extends Step<SessionDataType>>
    extends OnboardingState<SessionDataType, StepType> {
  const factory _OnboardingState(
          {required final SessionDataType? data,
          required final StepType? step}) =
      _$OnboardingStateImpl<SessionDataType, StepType>;
  const _OnboardingState._() : super._();

  @override
  SessionDataType? get data;
  @override
  StepType? get step;
  @override
  @JsonKey(ignore: true)
  _$$OnboardingStateImplCopyWith<SessionDataType, StepType,
          _$OnboardingStateImpl<SessionDataType, StepType>>
      get copyWith => throw _privateConstructorUsedError;
}
