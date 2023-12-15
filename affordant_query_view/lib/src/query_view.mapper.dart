// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element

part of 'query_view.dart';

class QueryViewModelStateMapper extends ClassMapperBase<QueryViewModelState> {
  QueryViewModelStateMapper._();

  static QueryViewModelStateMapper? _instance;
  static QueryViewModelStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = QueryViewModelStateMapper._());
    }
    return _instance!;
  }

  static T _guard<T>(T Function(MapperContainer) fn) {
    ensureInitialized();
    return fn(MapperContainer.globals);
  }

  @override
  final String id = 'QueryViewModelState';
  @override
  Function get typeFactory =>
      <QueryParameters, DisplayParameters, QueryResult, Data>(f) => f<
          QueryViewModelState<QueryParameters, DisplayParameters, QueryResult,
              Data>>();

  static dynamic _$queryParams(QueryViewModelState v) => v.queryParams;
  static dynamic
      _arg$queryParams<QueryParameters, DisplayParameters, QueryResult, Data>(
              f) =>
          f<QueryParameters>();
  static const Field<QueryViewModelState, dynamic> _f$queryParams =
      Field('queryParams', _$queryParams, arg: _arg$queryParams);
  static dynamic _$displayParams(QueryViewModelState v) => v.displayParams;
  static dynamic
      _arg$displayParams<QueryParameters, DisplayParameters, QueryResult, Data>(
              f) =>
          f<DisplayParameters>();
  static const Field<QueryViewModelState, dynamic> _f$displayParams =
      Field('displayParams', _$displayParams, arg: _arg$displayParams);
  static dynamic _$queryResult(QueryViewModelState v) => v.queryResult;
  static dynamic
      _arg$queryResult<QueryParameters, DisplayParameters, QueryResult, Data>(
              f) =>
          f<QueryResult>();
  static const Field<QueryViewModelState, dynamic> _f$queryResult =
      Field('queryResult', _$queryResult, arg: _arg$queryResult);
  static dynamic _$data(QueryViewModelState v) => v.data;
  static dynamic
      _arg$data<QueryParameters, DisplayParameters, QueryResult, Data>(f) =>
          f<Data>();
  static const Field<QueryViewModelState, dynamic> _f$data =
      Field('data', _$data, arg: _arg$data);
  static bool _$isLoading(QueryViewModelState v) => v.isLoading;
  static const Field<QueryViewModelState, bool> _f$isLoading =
      Field('isLoading', _$isLoading);
  static bool _$hasExecutedQuery(QueryViewModelState v) => v.hasExecutedQuery;
  static const Field<QueryViewModelState, bool> _f$hasExecutedQuery =
      Field('hasExecutedQuery', _$hasExecutedQuery);
  static DisplayableError? _$error(QueryViewModelState v) => v.error;
  static const Field<QueryViewModelState, DisplayableError> _f$error =
      Field('error', _$error);

  @override
  final Map<Symbol, Field<QueryViewModelState, dynamic>> fields = const {
    #queryParams: _f$queryParams,
    #displayParams: _f$displayParams,
    #queryResult: _f$queryResult,
    #data: _f$data,
    #isLoading: _f$isLoading,
    #hasExecutedQuery: _f$hasExecutedQuery,
    #error: _f$error,
  };

  static QueryViewModelState<QueryParameters, DisplayParameters, QueryResult,
          Data>
      _instantiate<QueryParameters, DisplayParameters, QueryResult, Data>(
          DecodingData data) {
    return QueryViewModelState(
        queryParams: data.dec(_f$queryParams),
        displayParams: data.dec(_f$displayParams),
        queryResult: data.dec(_f$queryResult),
        data: data.dec(_f$data),
        isLoading: data.dec(_f$isLoading),
        hasExecutedQuery: data.dec(_f$hasExecutedQuery),
        error: data.dec(_f$error));
  }

  @override
  final Function instantiate = _instantiate;

  static QueryViewModelState<QueryParameters, DisplayParameters, QueryResult,
          Data>
      fromMap<QueryParameters, DisplayParameters, QueryResult, Data>(
          Map<String, dynamic> map) {
    return _guard((c) => c.fromMap<
        QueryViewModelState<QueryParameters, DisplayParameters, QueryResult,
            Data>>(map));
  }

  static QueryViewModelState<QueryParameters, DisplayParameters, QueryResult,
          Data>
      fromJson<QueryParameters, DisplayParameters, QueryResult, Data>(
          String json) {
    return _guard((c) => c.fromJson<
        QueryViewModelState<QueryParameters, DisplayParameters, QueryResult,
            Data>>(json));
  }
}

mixin QueryViewModelStateMappable<QueryParameters, DisplayParameters,
    QueryResult, Data> {
  String toJson() {
    return QueryViewModelStateMapper._guard((c) => c.toJson(this
        as QueryViewModelState<QueryParameters, DisplayParameters, QueryResult,
            Data>));
  }

  Map<String, dynamic> toMap() {
    return QueryViewModelStateMapper._guard((c) => c.toMap(this
        as QueryViewModelState<QueryParameters, DisplayParameters, QueryResult,
            Data>));
  }

  QueryViewModelStateCopyWith<
          QueryViewModelState<QueryParameters, DisplayParameters, QueryResult,
              Data>,
          QueryViewModelState<QueryParameters, DisplayParameters, QueryResult,
              Data>,
          QueryViewModelState<QueryParameters, DisplayParameters, QueryResult,
              Data>,
          QueryParameters,
          DisplayParameters,
          QueryResult,
          Data>
      get copyWith => _QueryViewModelStateCopyWithImpl(
          this as QueryViewModelState<QueryParameters, DisplayParameters,
              QueryResult, Data>,
          $identity,
          $identity);
  @override
  String toString() {
    return QueryViewModelStateMapper._guard((c) => c.asString(this));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            QueryViewModelStateMapper._guard((c) => c.isEqual(this, other)));
  }

  @override
  int get hashCode {
    return QueryViewModelStateMapper._guard((c) => c.hash(this));
  }
}

extension QueryViewModelStateValueCopy<$R, $Out, QueryParameters,
        DisplayParameters, QueryResult, Data>
    on ObjectCopyWith<
        $R,
        QueryViewModelState<QueryParameters, DisplayParameters, QueryResult,
            Data>,
        $Out> {
  QueryViewModelStateCopyWith<
          $R,
          QueryViewModelState<QueryParameters, DisplayParameters, QueryResult,
              Data>,
          $Out,
          QueryParameters,
          DisplayParameters,
          QueryResult,
          Data>
      get $asQueryViewModelState =>
          $base.as((v, t, t2) => _QueryViewModelStateCopyWithImpl(v, t, t2));
}

abstract class QueryViewModelStateCopyWith<
    $R,
    $In extends QueryViewModelState<QueryParameters, DisplayParameters,
        QueryResult, Data>,
    $Out,
    QueryParameters,
    DisplayParameters,
    QueryResult,
    Data> implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {QueryParameters? queryParams,
      DisplayParameters? displayParams,
      QueryResult? queryResult,
      Data? data,
      bool? isLoading,
      bool? hasExecutedQuery,
      DisplayableError? error});
  QueryViewModelStateCopyWith<
      $R2,
      $In,
      $Out2,
      QueryParameters,
      DisplayParameters,
      QueryResult,
      Data> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _QueryViewModelStateCopyWithImpl<$R, $Out, QueryParameters,
        DisplayParameters, QueryResult, Data>
    extends ClassCopyWithBase<
        $R,
        QueryViewModelState<QueryParameters, DisplayParameters, QueryResult,
            Data>,
        $Out>
    implements
        QueryViewModelStateCopyWith<
            $R,
            QueryViewModelState<QueryParameters, DisplayParameters, QueryResult,
                Data>,
            $Out,
            QueryParameters,
            DisplayParameters,
            QueryResult,
            Data> {
  _QueryViewModelStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<QueryViewModelState> $mapper =
      QueryViewModelStateMapper.ensureInitialized();
  @override
  $R call(
          {QueryParameters? queryParams,
          DisplayParameters? displayParams,
          Object? queryResult = $none,
          Object? data = $none,
          bool? isLoading,
          bool? hasExecutedQuery,
          Object? error = $none}) =>
      $apply(FieldCopyWithData({
        if (queryParams != null) #queryParams: queryParams,
        if (displayParams != null) #displayParams: displayParams,
        if (queryResult != $none) #queryResult: queryResult,
        if (data != $none) #data: data,
        if (isLoading != null) #isLoading: isLoading,
        if (hasExecutedQuery != null) #hasExecutedQuery: hasExecutedQuery,
        if (error != $none) #error: error
      }));
  @override
  QueryViewModelState<QueryParameters, DisplayParameters, QueryResult, Data>
      $make(CopyWithData data) => QueryViewModelState(
          queryParams: data.get(#queryParams, or: $value.queryParams),
          displayParams: data.get(#displayParams, or: $value.displayParams),
          queryResult: data.get(#queryResult, or: $value.queryResult),
          data: data.get(#data, or: $value.data),
          isLoading: data.get(#isLoading, or: $value.isLoading),
          hasExecutedQuery:
              data.get(#hasExecutedQuery, or: $value.hasExecutedQuery),
          error: data.get(#error, or: $value.error));

  @override
  QueryViewModelStateCopyWith<
      $R2,
      QueryViewModelState<QueryParameters, DisplayParameters, QueryResult,
          Data>,
      $Out2,
      QueryParameters,
      DisplayParameters,
      QueryResult,
      Data> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _QueryViewModelStateCopyWithImpl($value, $cast, t);
}
