import 'dart:io';

import 'package:assab/core/errors/repository_mixin.dart';
import 'package:assab/core/utils/future_api_result.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/models/cancel_reason/cancel_reason_response.dart';
import '../../../branch_manager_requests/data/models/reject_all_order_request.dart';
import '../data_source/supplier_remote_data_source.dart';
import '../models/supplier_alternative_product_request.dart';
import '../models/supplier_items_response.dart';
import '../models/supplier_mark_as_delivery_request.dart';
import '../models/supplier_need_time_request.dart';
import '../models/supplier_order_details_response.dart';
import '../models/supplier_order_modification_response.dart';
import '../models/supplier_orders_response.dart';
import '../models/supplier_partial_confirmItem_request.dart';
import '../models/supplier_preparing_request.dart';
import '../models/supplier_report_delay_request.dart';

@LazySingleton()
class SupplierRequestsRepository with RepositoryMixin {
  final SupplierRemoteDataSource _supplierRemoteDataSource;

  SupplierRequestsRepository(this._supplierRemoteDataSource);

  FutureApiResult<SupplierOrdersResponse> getSupplierOrders({
    required int page,
  }) => execute(() async {
    return _supplierRemoteDataSource.getSupplierOrders(page: page);
  });

  FutureApiResult<SupplierOrderDetailsResponse> getSupplierOrderDetails({
    required String id,
  }) => execute(() async {
    return _supplierRemoteDataSource.getSupplierOrderDetails(id: id);
  });

  FutureApiResult<void> supplierPartialConfirmItem({
    required String id,
    required SupplierPartialConfirmItemRequest body,
  }) => execute(() async {
    return _supplierRemoteDataSource.supplierPartialConfirmItem(
      id: id,
      body: body,
    );
  });

  FutureApiResult<void> supplierFullConfirmItem({
    required String orderId,
    required String itemId,
  }) => execute(() async {
    return _supplierRemoteDataSource.supplierFullConfirmItem(
      orderId: orderId,
      itemId: itemId,
    );
  });

  FutureApiResult<void> supplierCancelItem({
    required String orderId,
    required String itemId,
    required RejectAllOrderRequest body,
  }) => execute(() async {
    return _supplierRemoteDataSource.supplierCancelItem(
      orderId: orderId,
      itemId: itemId,
      body: body,
    );
  });

  FutureApiResult<void> supplierConfirmOrder({required String orderId}) =>
      execute(
        () async =>
            _supplierRemoteDataSource.supplierConfirmOrder(orderId: orderId),
      );

  FutureApiResult<void> supplierCancelOrder({
    required String orderId,
    required RejectAllOrderRequest body,
  }) => execute(() async {
    return _supplierRemoteDataSource.supplierCancelOrder(
      orderId: orderId,
      body: body,
    );
  });

  FutureApiResult<void> supplierNeedTimeItem({
    required String orderId,
    required String itemId,
    required SupplierNeedTimeRequest body,
  }) => execute(() async {
    return _supplierRemoteDataSource.supplierNeedTimeItem(
      orderId: orderId,
      itemId: itemId,
      body: body,
    );
  });

  FutureApiResult<void> supplierAlternativeProductItem({
    required String orderId,
    required String itemId,
    required SupplierAlternativeProductRequest body,
  }) => execute(() async {
    return _supplierRemoteDataSource.supplierAlternativeProductItem(
      orderId: orderId,
      itemId: itemId,
      body: body,
    );
  });

  FutureApiResult<SupplierItemsResponse> getSupplierItem({required int page}) =>
      execute(() async {
        return _supplierRemoteDataSource.getSupplierItem(page: page);
      });

  FutureApiResult<CancelReasonResponse> getSupplierCancellationReason({
    required String orderId,
    required String itemId,
  }) => execute(() async {
    return _supplierRemoteDataSource.getSupplierCancellationReason(
      orderId: orderId,
      itemId: itemId,
    );
  });

  FutureApiResult<SupplierOrderModificationResponse> getSupplierModification({
    required String orderId,
    required String itemId,
  }) => execute(() async {
    return _supplierRemoteDataSource.getSupplierModification(
      orderId: orderId,
      itemId: itemId,
    );
  });

  FutureApiResult<void> supplierStartPreparingOrder({
    required SupplierPreparingRequest body,
  }) => execute(() async {
    return _supplierRemoteDataSource.supplierStartPreparingOrder(
      body: body.toFormData(),
    );
  });

  FutureApiResult<void> supplierMarkOrderAsDelivery({
    required String orderId,
    required SupplierMarkAsDeliveryRequest body,
  }) => execute(() async {
    return _supplierRemoteDataSource.supplierMarkOrderAsDelivery(
      body: body.toFormData(),
      orderId: orderId,
    );
  });

  FutureApiResult<void> supplierRepostDelayOrder({
    required String orderId,
    required SupplierReportDelayRequest body,
  }) => execute(() async {
    return _supplierRemoteDataSource.supplierRepostDelayOrder(
      body: body.toFormData(),
      orderId: orderId,
    );
  });

  FutureApiResult<void> supplierMarkOrderDelivered({
    required String orderId,
    required File body,
  }) => execute(() async {
    final formData = FormData();

    formData.files.add(
      MapEntry(
        'delivery_photos[]',
        MultipartFile.fromFileSync(
          body.path,
          filename: body.path.split('/').last,
        ),
      ),
    );

    return _supplierRemoteDataSource.supplierMarkOrderDelivered(
      body: formData,
      orderId: orderId,
    );
  });
}
