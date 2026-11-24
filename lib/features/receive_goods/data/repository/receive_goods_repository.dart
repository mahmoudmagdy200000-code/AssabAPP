import 'package:assab/core/errors/repository_mixin.dart';
import 'package:assab/core/utils/future_api_result.dart';
import 'package:injectable/injectable.dart';

import '../data_sources/receive_goods_remote_data_source.dart';
import '../models/receive_goods_in_progress_orders_response.dart';
import '../models/receive_order_inspection_response.dart';
import '../models/receive_order_supplier_request.dart';

@LazySingleton()
class ReceiveGoodsRepository with RepositoryMixin {
  final ReceiveGoodsRemoteDataSource _receiveGoodsRemoteDataSource;

  ReceiveGoodsRepository(this._receiveGoodsRemoteDataSource);

  FutureApiResult<ReceiveGoodsInProgressOrdersResponse>
  getReceivingOrdersInProgress({required int page}) => execute(() async {
    return _receiveGoodsRemoteDataSource.getReceivingOrdersInProgress(
      page: page,
    );
  });

  FutureApiResult<ReceiveGoodsInProgressOrdersResponse>
  getReceivingOrdersMissing({required int page}) => execute(() async {
    return _receiveGoodsRemoteDataSource.getReceivingOrdersMissing(page: page);
  });

  FutureApiResult<ReceiveGoodsInProgressOrdersResponse>
  getReceivingOrdersCompleted({required int page}) => execute(() async {
    return _receiveGoodsRemoteDataSource.getReceivingOrdersCompleted(
      page: page,
    );
  });

  FutureApiResult<ReceiveOrderInspectionResponse> getReceivingOrderInspection({
    required String orderId,
  }) => execute(() async {
    return _receiveGoodsRemoteDataSource.getReceivingOrderInspection(
      orderId: orderId,
    );
  });

  FutureApiResult<void> startReceivingSupplierOrder({
    required String orderId,
    required ReceiveOrderSupplierRequest request,
  }) => execute(() async {
    return _receiveGoodsRemoteDataSource.startReceivingSupplierOrder(
      orderId: orderId,
      formData: request.toFormData(),
    );
  });

  FutureApiResult<void> startReceivingBranchOrder({
    required String orderId,
    List<Map<String, dynamic>>? items,
    String? idempotencyKey,
  }) => execute(() async {
    final body = <String, dynamic>{
      if (items != null) 'items': items,
      if (idempotencyKey != null) 'idempotency_key': idempotencyKey,
    };
    return _receiveGoodsRemoteDataSource.startReceivingBranchOrder(
      orderId: orderId,
      body: body.isEmpty ? null : body,
    );
  });

  FutureApiResult<void> closeTransferVariance({
    required String orderId,
    required String resolution,
    String? reason,
    String? evidencePath,
    String? idempotencyKey,
  }) => execute(() async {
    final body = <String, dynamic>{
      'resolution': resolution,
      if (reason != null && reason.isNotEmpty) 'reason': reason,
      if (evidencePath != null && evidencePath.isNotEmpty)
        'evidence_path': evidencePath,
      if (idempotencyKey != null && idempotencyKey.isNotEmpty)
        'idempotency_key': idempotencyKey,
    };
    return _receiveGoodsRemoteDataSource.closeTransferVariance(
      orderId: orderId,
      body: body,
    );
  });
}
