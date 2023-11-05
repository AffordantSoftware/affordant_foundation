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
mixin _$OnboardingState<StepType extends Step<dynamic>> {
  StepType get step => throw _privateConstructorUsedError;
  bool get isDone => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $OnboardingStateCopyWith<StepType, OnboardingState<StepType>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OnboardingStateCopyWith<StepType extends Step<dynamic>, $Res> {
  factory $OnboardingStateCopyWith(OnboardingState<StepType> value,
          $Res Function(OnboardingState<StepType>) then) =
      _$OnboardingStateCopyWithImpl<StepType, $Res, OnboardingState<StepType>>;
  @useResult
  $Res call({StepType step, bool isDone});
}

/// @nodoc
class _$OnboardingStateCopyWithImpl<StepType extends Step<dynamic>, $Res,
        $Val extends OnboardingState<StepType>>
    implements $OnboardingStateCopyWith<StepType, $Res> {
  _$OnboardingStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? step = null,
    Object? isDone = null,
  }) {
    return _then(_value.copyWith(
      step: null == step
          ? _value.step
          : step // ignore: cast_nullable_to_non_nullable
              as StepType,
      isDone: null == isDone
          ? _value.isDone
          : isDone // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OnboardingStateImplCopyWith<StepType extends Step<dynamic>,
    $Res> implements $OnboardingStateCopyWith<StepType, $Res> {
  factory _$$OnboardingStateImplCopyWith(_$OnboardingStateImpl<StepType> value,
          $Res Function(_$OnboardingStateImpl<StepType>) then) =
      __$$OnboardingStateImplCopyWithImpl<StepType, $Res>;
  @override
  @useResult
  $Res call({StepType step, bool isDone});
}

/// @nodoc
class __$$OnboardingStateImplCopyWithImpl<StepType extends Step<dynamic>, $Res>
    extends _$OnboardingStateCopyWithImpl<StepType, $Res,
        _$OnboardingStateImpl<StepType>>
    implements _$$OnboardingStateImplCopyWith<StepType, $Res> {
  __$$OnboardingStateImplCopyWithImpl(_$OnboardingStateImpl<StepType> _value,
      $Res Function(_$OnboardingStateImpl<StepType>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? step = null,
    Object? isDone = null,
  }) {
    return _then(_$OnboardingStateImpl<StepType>(
      step: null == step
          ? _value.step
          : step // ignore: cast_nullable_to_non_nullable
              as StepType,
      isDone: null == isDone
          ? _value.isDone
          : isDone // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$OnboardingStateImpl<StepType extends Step<dynamic>>
    extends _OnboardingState<StepType> {
  const _$OnboardingStateImpl({required this.step, required this.isDone})
      : super._();

  @override
  final StepType step;
  @override
  final bool isDone;

  @override
  String toString() {
    return 'OnboardingState<$StepType>(step: $step, isDone: $isDone)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnboardingStateImpl<StepType> &&
            const DeepCollectionEquality().equals(other.step, step) &&
            (identical(other.isDone, isDone) || other.isDone == isDone));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(step), isDone);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OnboardingStateImplCopyWith<StepType, _$OnboardingStateImpl<StepType>>
      get copyWith => __$$OnboardingStateImplCopyWithImpl<StepType,
          _$OnboardingStateImpl<StepType>>(this, _$identity);
}

abstract class _OnboardingState<StepType extends Step<dynamic>>
    extends OnboardingState<StepType> {
  const factory _OnboardingState(
      {required final StepType step,
      required final bool isDone}) = _$OnboardingStateImpl<StepType>;
  const _OnboardingState._() : super._();

  @override
  StepType get step;
  @override
  bool get isDone;
  @override
  @JsonKey(ignore: true)
  _$$OnboardingStateImplCopyWith<StepType, _$OnboardingStateImpl<StepType>>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$StepState<T> {
  bool get canGoNext => throw _privateConstructorUsedError;
  T get data => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $StepStateCopyWith<T, StepState<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StepStateCopyWith<T, $Res> {
  factory $StepStateCopyWith(
          StepState<T> value, $Res Function(StepState<T>) then) =
      _$StepStateCopyWithImpl<T, $Res, StepState<T>>;
  @useResult
  $Res call({bool canGoNext, T data});
}

/// @nodoc
class _$StepStateCopyWithImpl<T, $Res, $Val extends StepState<T>>
    implements $StepStateCopyWith<T, $Res> {
  _$StepStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? canGoNext = null,
    Object? data = freezed,
  }) {
    return _then(_value.copyWith(
      canGoNext: null == canGoNext
          ? _value.canGoNext
          : canGoNext // ignore: cast_nullable_to_non_nullable
              as bool,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as T,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StepStateImplCopyWith<T, $Res>
    implements $StepStateCopyWith<T, $Res> {
  factory _$$StepStateImplCopyWith(
          _$StepStateImpl<T> value, $Res Function(_$StepStateImpl<T>) then) =
      __$$StepStateImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call({bool canGoNext, T data});
}

/// @nodoc
class __$$StepStateImplCopyWithImpl<T, $Res>
    extends _$StepStateCopyWithImpl<T, $Res, _$StepStateImpl<T>>
    implements _$$StepStateImplCopyWith<T, $Res> {
  __$$StepStateImplCopyWithImpl(
      _$StepStateImpl<T> _value, $Res Function(_$StepStateImpl<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? canGoNext = null,
    Object? data = freezed,
  }) {
    return _then(_$StepStateImpl<T>(
      canGoNext: null == canGoNext
          ? _value.canGoNext
          : canGoNext // ignore: cast_nullable_to_non_nullable
              as bool,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as T,
    ));
  }
}

/// @nodoc

class _$StepStateImpl<T> extends _StepState<T> {
  const _$StepStateImpl({required this.canGoNext, required this.data})
      : super._();

  @override
  final bool canGoNext;
  @override
  final T data;

  @override
  String toString() {
    return 'StepState<$T>(canGoNext: $canGoNext, data: $data)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StepStateImpl<T> &&
            (identical(other.canGoNext, canGoNext) ||
                other.canGoNext == canGoNext) &&
            const DeepCollectionEquality().equals(other.data, data));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, canGoNext, const DeepCollectionEquality().hash(data));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StepStateImplCopyWith<T, _$StepStateImpl<T>> get copyWith =>
      __$$StepStateImplCopyWithImpl<T, _$StepStateImpl<T>>(this, _$identity);
}

abstract class _StepState<T> extends StepState<T> {
  const factory _StepState(
      {required final bool canGoNext,
      required final T data}) = _$StepStateImpl<T>;
  const _StepState._() : super._();

  @override
  bool get canGoNext;
  @override
  T get data;
  @override
  @JsonKey(ignore: true)
  _$$StepStateImplCopyWith<T, _$StepStateImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
