import 'dart:async';

import 'package:affordant_view_model/affordant_view_model.dart';
import 'package:affordant_core/affordant_core.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'query_view.mapper.dart';

@MappableClass()
class QueryViewModelState<QueryParameters, DisplayParameters, QueryResult, Data>
    with
        QueryViewModelStateMappable<QueryParameters, DisplayParameters,
            QueryResult, Data> {
  QueryViewModelState({
    required this.queryParams,
    required this.displayParams,
    required this.queryResult,
    required this.data,
    required this.isLoading,
    required this.error,
  });

  final QueryParameters queryParams;
  final DisplayParameters displayParams;
  final QueryResult? queryResult;
  final Data? data;
  final DisplayableError? error;
  final bool isLoading;
}

/// A base class for creating view that query data based on dynamic parameters
///
/// A query view is based on a query: an async operation that return [QueryResult]
/// The query depends of query parameter. When query parameters changes, the query is re-run
/// The query view can also have display parameter. Those are parameter that only affect
/// how the data is displayed.
/// Child class should implement [query] and [computeData] that respectively returns
/// a takes a [QueryParameters] and [DisplayParameters] and returns a [QueryResult] and [Data].
/// The view is supposed to consumed the [Data]
abstract base class QueryViewModel<QueryParameters, DisplayParameters,
        QueryResult, Data>
    extends ViewModel<
        QueryViewModelState<QueryParameters, DisplayParameters, QueryResult,
            Data>> {
  QueryViewModel({
    required QueryParameters initialQueryParams,
    required DisplayParameters initialDisplayParams,
    required QueryResult? initialQueryResult,
    required Data? initialDisplayResult,
    bool runQuery = true,
  }) : super(
          QueryViewModelState(
            displayParams: initialDisplayParams,
            queryParams: initialQueryParams,
            queryResult: initialQueryResult,
            data: initialDisplayResult,
            error: null,
            isLoading: false,
          ),
        ) {
    if (runQuery) {
      _execQuery();
    }
  }

  FutureOr<QueryResult> query(
    QueryParameters params,
  );

  FutureOr<Data> computeData(
    QueryResult queryResult,
    DisplayParameters params,
  );

  void setParams(
      {QueryParameters? queryParams, DisplayParameters? displayParams}) {
    if (queryParams == null && displayParams != null) {
      setDisplayParams(displayParams);
    } else if (queryParams != null) {
      setQueryParams(queryParams);
    }
  }

  void setQueryParams(QueryParameters params) {
    _execQuery(useCache: false, queryParams: params);
  }

  Future<void> setDisplayParams(DisplayParameters params) async {
    _execQuery(useCache: true, displayParams: params);
  }

  void refresh() {
    _execQuery(useCache: false);
  }

  Future<void> _execQuery({
    bool useCache = false,
    QueryParameters? queryParams,
    DisplayParameters? displayParams,
  }) async {
    emit(state.copyWith(
      queryParams: queryParams,
      displayParams: displayParams,
      isLoading: true,
    ));
    try {
      final queryRes =
          useCache ? state.queryResult : await query(state.queryParams);
      final displayRes = queryRes != null
          ? await computeData(queryRes, state.displayParams)
          : null;

      emit(state.copyWith(
        queryResult: queryRes,
        displayResult: displayRes,
        error: null,
        isLoading: false,
      ));
    } catch (e, s) {
      emit(
        state.copyWith(
          error: DisplayableError(e, s),
          isLoading: false,
        ),
      );
    }
  }
}
