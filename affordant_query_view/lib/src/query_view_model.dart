import 'dart:async';
import 'package:affordant_mvvm/affordant_mvvm.dart';
import 'package:affordant_query_view/src/errors.dart';
import 'package:affordant_core/affordant_core.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'query_view_model.mapper.dart';

/// Query view model's state
@MappableClass()
class QueryViewModelState<QueryParameters, DisplayParameters, QueryResult,
        DisplayData>
    with
        QueryViewModelStateMappable<QueryParameters, DisplayParameters,
            QueryResult, DisplayData> {
  QueryViewModelState({
    required this.queryParams,
    required this.displayParams,
    required this.data,
    this.queryResult,
    this.isLoading = false,
    this.hasExecutedQuery = false,
    this.error,
  });

  final QueryParameters queryParams;
  final QueryResult? queryResult;
  final DisplayParameters displayParams;
  final DisplayData data;
  final DisplayableError? error;
  final bool hasExecutedQuery;
  final bool isLoading;
}

/// A base class for creating view models that query data based on dynamic parameters
///
/// Sub classes should implements [query] and [queryResultToDisplayData] methods.
/// This View model use a pre-made state object of type [QueryViewModelState]
///
/// [QueryParameters] is the type of object passed to the [query].
/// [DisplayParameter] are local parameter that are passed to [queryResultToDisplayData].
/// Local parameters are parameter that doesn't invalidate the query result when changed.
/// [QueryResult] is the object type return by [query].
/// [DisplayData] is the objec type returned by [queryResultToDisplayData] and used by the view for display.
///
/// A query is a fetch operation on a data source of any type. It could be sync or async.
/// The query can have parameters, defined by [QueryParameters].
/// Each time the query parameter changes, the query is re-run by the view model.
/// Sub classes or views should use [setQueryParameters] to update query parameters.
///
/// Sometime the view doesn't display query result as is. This is often the case with sorting order for example.
/// To handle this kind of problem without re-running the query each time,
/// The QueryViewModel introduce [DisplayParameters] along with [queryResultToDisplayData] method.
/// All computation on result that doesn't need to re-run the query should be done inside this method.
/// The [QueryViewModel] will cache the query result and only execute [queryResultToDisplayData]
/// when the user changes display parameters.
abstract base class QueryViewModel<QueryParameters, DisplayParameters,
        QueryResult, DisplayData>
    extends Cubit<
        QueryViewModelState<QueryParameters, DisplayParameters, QueryResult,
            DisplayData>> {
  QueryViewModel({
    Debouncer? debouncer,
    required QueryParameters initialQueryParams,
    required DisplayParameters initialDisplayParams,
    required DisplayData initialData,
    QueryResult? initialQueryResult,
    bool runQuery = true,
  })  : debouncer = debouncer ??
            Debouncer.duration(
              const Duration(milliseconds: 330),
            ),
        super(
          QueryViewModelState(
            displayParams: initialDisplayParams,
            queryParams: initialQueryParams,
            queryResult: initialQueryResult,
            data: initialData,
            error: null,
            hasExecutedQuery: false,
            isLoading: false,
          ),
        ) {
    if (runQuery) {
      _execQueryWithDebouncer();
    }
  }

  final Debouncer debouncer;

  /// Fetch data from the source.
  /// This method will be executed each time query parameter changes.
  /// This method should perform any computation that doesn't depends on
  /// display parameter
  FutureOr<QueryResult> query(
    QueryParameters params,
  );

  /// Transform query result to a displayable data for the view
  /// This method will be run each time display parameter changes.
  /// This method should perform any computation that depends on
  /// display parameters.
  FutureOr<DisplayData> queryResultToDisplayData(
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
    _execQueryWithDebouncer(useCache: false, queryParams: params);
  }

  Future<void> setDisplayParams(DisplayParameters params) async {
    _execQueryWithDebouncer(useCache: true, displayParams: params);
  }

  void refresh() {
    _execQueryWithDebouncer(useCache: false);
  }

  void _execQueryWithDebouncer({
    bool useCache = false,
    QueryParameters? queryParams,
    DisplayParameters? displayParams,
  }) {
    if (isClosed) return;
    debouncer.debounce(() => _execQuery(
          useCache: useCache,
          queryParams: queryParams,
          displayParams: displayParams,
        ));
  }

  Future<void> _execQuery({
    bool useCache = false,
    QueryParameters? queryParams,
    DisplayParameters? displayParams,
  }) async {
    if (isClosed) return;
    emit(state.copyWith(
      queryParams: queryParams,
      displayParams: displayParams,
      hasExecutedQuery: true,
      isLoading: true,
    ));
    try {
      final queryRes =
          useCache ? state.queryResult : await query(state.queryParams);
      if (isClosed) return;
      final displayRes = queryRes != null
          ? await queryResultToDisplayData(queryRes, state.displayParams)
          : null;

      _safeEmit(state.copyWith(
        queryResult: queryRes,
        data: displayRes,
        error: null,
        isLoading: false,
      ));
    } catch (e) {
      _safeEmit(
        state.copyWith(
          isLoading: false,
          error: QueryError(),
        ),
      );
    }
  }

  void _safeEmit(
      QueryViewModelState<QueryParameters, DisplayParameters, QueryResult,
              DisplayData>
          state) {
    if (isClosed == false) {
      emit(state);
    }
  }
}
