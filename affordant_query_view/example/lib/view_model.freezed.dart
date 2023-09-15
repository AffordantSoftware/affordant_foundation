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
mixin _$SearchResult {
  DateTime get start => throw _privateConstructorUsedError;
  List<SearchEvent> get events => throw _privateConstructorUsedError;
  int get queryNumber => throw _privateConstructorUsedError;
  List<String> get results => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SearchResultCopyWith<SearchResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchResultCopyWith<$Res> {
  factory $SearchResultCopyWith(
          SearchResult value, $Res Function(SearchResult) then) =
      _$SearchResultCopyWithImpl<$Res, SearchResult>;
  @useResult
  $Res call(
      {DateTime start,
      List<SearchEvent> events,
      int queryNumber,
      List<String> results});
}

/// @nodoc
class _$SearchResultCopyWithImpl<$Res, $Val extends SearchResult>
    implements $SearchResultCopyWith<$Res> {
  _$SearchResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? start = null,
    Object? events = null,
    Object? queryNumber = null,
    Object? results = null,
  }) {
    return _then(_value.copyWith(
      start: null == start
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as DateTime,
      events: null == events
          ? _value.events
          : events // ignore: cast_nullable_to_non_nullable
              as List<SearchEvent>,
      queryNumber: null == queryNumber
          ? _value.queryNumber
          : queryNumber // ignore: cast_nullable_to_non_nullable
              as int,
      results: null == results
          ? _value.results
          : results // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_SearchResultCopyWith<$Res>
    implements $SearchResultCopyWith<$Res> {
  factory _$$_SearchResultCopyWith(
          _$_SearchResult value, $Res Function(_$_SearchResult) then) =
      __$$_SearchResultCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime start,
      List<SearchEvent> events,
      int queryNumber,
      List<String> results});
}

/// @nodoc
class __$$_SearchResultCopyWithImpl<$Res>
    extends _$SearchResultCopyWithImpl<$Res, _$_SearchResult>
    implements _$$_SearchResultCopyWith<$Res> {
  __$$_SearchResultCopyWithImpl(
      _$_SearchResult _value, $Res Function(_$_SearchResult) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? start = null,
    Object? events = null,
    Object? queryNumber = null,
    Object? results = null,
  }) {
    return _then(_$_SearchResult(
      start: null == start
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as DateTime,
      events: null == events
          ? _value._events
          : events // ignore: cast_nullable_to_non_nullable
              as List<SearchEvent>,
      queryNumber: null == queryNumber
          ? _value.queryNumber
          : queryNumber // ignore: cast_nullable_to_non_nullable
              as int,
      results: null == results
          ? _value._results
          : results // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class _$_SearchResult extends _SearchResult {
  const _$_SearchResult(
      {required this.start,
      required final List<SearchEvent> events,
      required this.queryNumber,
      required final List<String> results})
      : _events = events,
        _results = results,
        super._();

  @override
  final DateTime start;
  final List<SearchEvent> _events;
  @override
  List<SearchEvent> get events {
    if (_events is EqualUnmodifiableListView) return _events;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_events);
  }

  @override
  final int queryNumber;
  final List<String> _results;
  @override
  List<String> get results {
    if (_results is EqualUnmodifiableListView) return _results;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_results);
  }

  @override
  String toString() {
    return 'SearchResult(start: $start, events: $events, queryNumber: $queryNumber, results: $results)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SearchResult &&
            (identical(other.start, start) || other.start == start) &&
            const DeepCollectionEquality().equals(other._events, _events) &&
            (identical(other.queryNumber, queryNumber) ||
                other.queryNumber == queryNumber) &&
            const DeepCollectionEquality().equals(other._results, _results));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      start,
      const DeepCollectionEquality().hash(_events),
      queryNumber,
      const DeepCollectionEquality().hash(_results));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SearchResultCopyWith<_$_SearchResult> get copyWith =>
      __$$_SearchResultCopyWithImpl<_$_SearchResult>(this, _$identity);
}

abstract class _SearchResult extends SearchResult {
  const factory _SearchResult(
      {required final DateTime start,
      required final List<SearchEvent> events,
      required final int queryNumber,
      required final List<String> results}) = _$_SearchResult;
  const _SearchResult._() : super._();

  @override
  DateTime get start;
  @override
  List<SearchEvent> get events;
  @override
  int get queryNumber;
  @override
  List<String> get results;
  @override
  @JsonKey(ignore: true)
  _$$_SearchResultCopyWith<_$_SearchResult> get copyWith =>
      throw _privateConstructorUsedError;
}
