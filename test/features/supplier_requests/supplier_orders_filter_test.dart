import 'dart:convert';
import 'dart:typed_data';

import 'package:assab/features/supplier_requests/data/data_source/supplier_remote_data_source.dart';
import 'package:assab/features/supplier_requests/data/repository/supplier_requests_repository.dart';
import 'package:assab/features/supplier_requests/presentation/cubit/supplier_get_requests/supplier_get_requests_cubit.dart';
import 'package:assab/features/supplier_requests/presentation/cubit/supplier_get_requests/supplier_get_requests_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class _FilterRecordingAdapter implements HttpClientAdapter {
  final List<Uri> uris = [];
  int totalToReturn = 2;
  int lastPageToReturn = 2;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    uris.add(options.uri);
    final page = int.tryParse(options.uri.queryParameters['page'] ?? '1') ?? 1;
    final payload = {
      'data': [
        {
          'id': 'po-$page',
          'order_number': 'PO-FLT-$page',
          'order_type': 'direct_supplier',
          'status': options.uri.queryParameters['status'] ?? 'pending',
          'branch': {
            'id': 'br-1',
            'name': 'Riyadh Main Branch',
            'image': null,
            'location': 'Riyadh',
            'lat': null,
            'lng': null,
            'opening_hours': null,
            'closing_hours': null,
          },
          'branch_manager': {
            'id': 'bm-1',
            'name': 'BM',
            'email': 'bm@test.local',
            'phone': '0500000000',
            'image': null,
          },
          'subtotal': 100,
          'tax_amount': 15,
          'total_amount': 115,
          'priority': 'normal',
          'preferred_delivery_date': null,
          'expected_delivery_at': null,
          'message': null,
          'special_instructions': null,
          'rejection_reason': null,
          'created_at': '2026-11-26T10:00:00Z',
          'confirmed_at': null,
          'rejected_at': null,
          'items': const [],
        },
      ],
      'meta': {
        'current_page': page,
        'last_page': lastPageToReturn,
        'total': totalToReturn,
      },
    };
    return ResponseBody.fromString(
      jsonEncode(payload),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  test(
    'SupplierGetRequestsCubit sends status & date filters, resets to page 1 on change, preserves filters on loadMore, and clears cleanly',
    () async {
      final adapter = _FilterRecordingAdapter();
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test/api/v1/'))
        ..httpClientAdapter = adapter;
      final repo = SupplierRequestsRepository(SupplierRemoteDataSource(dio));
      final cubit = SupplierGetRequestsCubit(repo);

      // Initial load: page=1, no filters
      await cubit.getRequests();
      expect(adapter.uris.last.queryParameters, {'page': '1'});
      expect(cubit.state, isA<SupplierGetRequestsSuccess>());
      expect((cubit.state as SupplierGetRequestsSuccess).total, 2);

      // Set status + date range -> resets to page 1
      await cubit.setStatusFilter('preparing');
      await cubit.setDateRange(dateFrom: '2026-11-01', dateTo: '2026-11-26');
      expect(adapter.uris.last.queryParameters, {
        'page': '1',
        'status': 'preparing',
        'date_from': '2026-11-01',
        'date_to': '2026-11-26',
      });
      expect(cubit.hasActiveFilters, isTrue);

      // Load page 2 -> preserves active filters
      await cubit.getRequests(loadMore: true);
      expect(adapter.uris.last.queryParameters, {
        'page': '2',
        'status': 'preparing',
        'date_from': '2026-11-01',
        'date_to': '2026-11-26',
      });
      expect((cubit.state as SupplierGetRequestsSuccess).requests, hasLength(2));

      // Clear filters -> resets to page 1 with no filter params
      await cubit.clearFilters();
      expect(adapter.uris.last.queryParameters, {'page': '1'});
      expect(cubit.hasActiveFilters, isFalse);

      await cubit.close();
    },
  );
}
