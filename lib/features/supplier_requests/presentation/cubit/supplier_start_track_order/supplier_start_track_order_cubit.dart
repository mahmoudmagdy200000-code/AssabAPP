import 'dart:io';

import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/models/supplier_mark_as_delivery_request.dart';
import '../../../data/models/supplier_preparing_request.dart';
import '../../../data/models/supplier_report_delay_request.dart';
import '../../../data/repository/supplier_requests_repository.dart';
import 'supplier_start_track_order_state.dart';

@injectable
class SupplierStartTrackOrderCubit
    extends SafeCubit<SupplierStartTrackOrderState> {
  final SupplierRequestsRepository _supplierRequestsRepository;

  SupplierStartTrackOrderCubit(this._supplierRequestsRepository)
    : super(const SupplierStartTrackOrderInit());

  void supplierStartPreparingOrder({
    required SupplierPreparingRequest body,
  }) async {
    emit(const SupplierStartTrackOrderLoading());
    final result = await _supplierRequestsRepository
        .supplierStartPreparingOrder(body: body);

    handle(
      result,
      success: (_) {
        emit(const SupplierStartTrackOrderSuccess());
      },
      failure: (failure) {
        emit(SupplierStartTrackOrderFailure(failure));
      },
    );
  }

  void supplierMarkOrderAsDelivery({
    required String orderId,
    required SupplierMarkAsDeliveryRequest body,
  }) async {
    emit(const SupplierStartTrackOrderLoading());
    final result = await _supplierRequestsRepository
        .supplierMarkOrderAsDelivery(body: body, orderId: orderId);

    handle(
      result,
      success: (_) {
        emit(const SupplierStartTrackOrderSuccess());
      },
      failure: (failure) {
        emit(SupplierStartTrackOrderFailure(failure));
      },
    );
  }

  void supplierRepostDelayOrder({
    required String orderId,
    required SupplierReportDelayRequest body,
  }) async {
    emit(const SupplierStartTrackOrderLoading());
    final result = await _supplierRequestsRepository.supplierRepostDelayOrder(
      body: body,
      orderId: orderId,
    );

    handle(
      result,
      success: (_) {
        emit(const SupplierStartTrackOrderSuccess());
      },
      failure: (failure) {
        emit(SupplierStartTrackOrderFailure(failure));
      },
    );
  }

  void supplierMarkOrderDelivered({
    required String orderId,
    required File body,
  }) async {
    emit(const SupplierStartTrackOrderLoading());
    final result = await _supplierRequestsRepository.supplierMarkOrderDelivered(
      body: body,
      orderId: orderId,
    );

    handle(
      result,
      success: (_) {
        emit(const SupplierStartTrackOrderSuccess());
      },
      failure: (failure) {
        emit(SupplierStartTrackOrderFailure(failure));
      },
    );
  }
}
