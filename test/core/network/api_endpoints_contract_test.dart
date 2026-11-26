import 'dart:convert';
import 'dart:typed_data';

import 'package:assab/core/network/api_endpoints.dart';
import 'package:assab/features/branch_manager_requests/data/data_source/requests_remote_data_source.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class _RecordingAdapter implements HttpClientAdapter {
  final List<String> requests = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add('${options.method} ${options.path}');
    return ResponseBody.fromString(
      jsonEncode({}),
      200,
      headers: {Headers.contentTypeHeader: [Headers.jsonContentType]},
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  test('T2.4 PUR-F12: ApiEndpoint constants match Backend Modules/Purchase/routes/api.php', () {
    expect(
      ApiEndpoint.purchaseApproveModification,
      'purchase/pending/{id}/items/{itemId}/modification/approve',
    );
    expect(
      ApiEndpoint.purchaseRejectModification,
      'purchase/pending/{id}/items/{itemId}/modification/reject',
    );
    expect(
      ApiEndpoint.purchaseApproveDelay,
      'purchase/pending/{id}/delay/approve',
    );
    expect(
      ApiEndpoint.purchaseRejectDelay,
      'purchase/pending/{id}/delay/reject',
    );
    expect(
      ApiEndpoint.purchaseConfirmHandover,
      'purchase/returns/{id}/confirm-handover',
    );
  });

  test('T2.4 PUR-F12: RequestsRemoteDataSource dispatches exact modification and delay paths', () async {
    final adapter = _RecordingAdapter();
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test/api/v1/'))
      ..httpClientAdapter = adapter;

    final ds = RequestsRemoteDataSource(dio);
    await ds.branchApproveModification(orderId: 'ord-1', itemId: 'itm-1');
    await ds.branchRejectModification(orderId: 'ord-1', itemId: 'itm-1', reason: {'reason': 'price'});
    await ds.approveDelay(id: 'ord-2');
    await ds.rejectDelay(id: 'ord-2', reason: {'reason': 'too late'});

    expect(adapter.requests, [
      'POST purchase/pending/ord-1/items/itm-1/modification/approve',
      'POST purchase/pending/ord-1/items/itm-1/modification/reject',
      'POST purchase/pending/ord-2/delay/approve',
      'POST purchase/pending/ord-2/delay/reject',
    ]);
  });
}
