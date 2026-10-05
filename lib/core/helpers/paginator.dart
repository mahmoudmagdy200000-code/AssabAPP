import 'package:flutter/material.dart';

import '../utils/api_result.dart';
import '../utils/future_api_result.dart';

/// Generic Paginator that works with ApiResult-based responses
class Paginator<T, R> {
  final FutureApiResult<R> Function(int page) fetchPage;
  final List<T> Function(R response) extractData;
  final MetaInfo Function(R response) extractMeta;

  int _currentPage = 1;
  int _lastPage = 1;
  bool _isLoading = false;

  final List<T> _items = [];

  Paginator({
    required this.fetchPage,
    required this.extractData,
    required this.extractMeta,
  });

  /// Current page number
  int get currentPage => _currentPage;

  /// Whether there are more pages to load
  bool get hasMore => _currentPage <= _lastPage;

  /// All fetched items so far
  List<T> get items => List.unmodifiable(_items);

  /// Whether a request is in progress
  bool get isLoading => _isLoading;

  /// Resets pagination and reloads from the first page
  Future<ApiResult<List<T>>> refresh() async {
    _currentPage = 1;
    _lastPage = 1;
    _items.clear();
    return await loadNextPage();
  }

  /// Loads the next page of data
  Future<ApiResult<List<T>>> loadNextPage() async {
    if (_isLoading || _currentPage > _lastPage) {
      return ApiResult.success(_items);
    }

    _isLoading = true;

    final result = await fetchPage(_currentPage);

    _isLoading = false;

    return result.when(
      failure: (failure) => ApiResult.failure(failure),
      success: (response) {
        final meta = extractMeta(response);
        final data = extractData(response);

        _lastPage = meta.lastPage;
        _currentPage++;
        _items.addAll(data);

        return ApiResult.success(_items);
      },
    );
  }

  /// Resets everything completely
  void reset() {
    _currentPage = 1;
    _lastPage = 1;
    _items.clear();
    _isLoading = false;
  }
}

/// Simple meta info class to make paginator generic and reusable
@immutable
class MetaInfo {
  final int currentPage;
  final int lastPage;
  final int total;

  const MetaInfo({
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });
}
