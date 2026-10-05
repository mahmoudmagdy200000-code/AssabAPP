import 'package:assab/core/errors/repository_mixin.dart';
import 'package:assab/core/utils/future_api_result.dart';
import 'package:assab/features/branch_manager_requests/domain/mappers/responsibility_mapper.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/models/cancel_reason/cancel_reason_response.dart';
import '../../../../shared/models/order_track_response.dart';
import '../../../cashier_requests/data/models/reassigned_shift_response.dart';
import '../../domain/entities/orders_entity.dart';
import '../../domain/entities/responsibility_entity.dart';
import '../data_source/requests_remote_data_source.dart';
import '../models/approve_all_order_request.dart';
import '../models/branch_order_modification_response.dart';
import '../models/direct_supplier_order_details_response.dart';
import '../models/handovers_response.dart';
import '../models/officer_order_details_response.dart';
import '../models/order_details_response.dart';
import '../models/partial_approve_order_request.dart';
import '../models/reject_all_order_request.dart';
import '../models/responsibility_reject_body_request.dart';
import '../models/variances_response.dart';

@LazySingleton()
class RequestsRepository with RepositoryMixin {
  final RequestsRemoteDataSource remoteDataSource;

  RequestsRepository({required this.remoteDataSource});

  FutureApiResult<OrdersEntity> getOrders({required int page}) async {
    return execute(() async {
      final response = await remoteDataSource.getOrders(page: page);
      final orders = response.data.orders;
      final requests = response.data.requests;

      final mergedOrdersAndRequests = [...orders, ...requests];

      mergedOrdersAndRequests.sort((a, b) {
        final aDate = DateTime.parse(a.createdAt);
        final bDate = DateTime.parse(b.createdAt);
        return bDate.compareTo(aDate);
      });

      return OrdersEntity(meta: response.meta, orders: mergedOrdersAndRequests);
    });
  }

  FutureApiResult<HandoversResponse> getHandovers({required int page}) async {
    return execute(() async {
      final response = await remoteDataSource.getHandovers(page: page);
      return response;
    });
  }

  FutureApiResult<VariancesResponse> getVariances({required int page}) async {
    return execute(() async {
      final response = await remoteDataSource.getVariances(page: page);
      return response;
    });
  }

  FutureApiResult<OrderDetailsResponse> getBranchOrdersDetails({
    required String id,
  }) async {
    return execute(() async {
      final response = await remoteDataSource.getBranchOrdersDetails(id: id);

      return response;
    });
  }

  FutureApiResult<DirectSupplierOrderDetailsResponse>
  getDirectSupplierOrdersDetails({required String id}) async {
    return execute(() async {
      final response = await remoteDataSource.getDirectSupplierOrdersDetails(
        id: id,
      );
      return response;
    });
  }

  FutureApiResult<OfficerOrderDetailsResponse> getOfficerOrdersDetails({
    required String id,
  }) async {
    return execute(() async {
      final response = await remoteDataSource.getOfficerOrdersDetails(id: id);
      return response;
    });
  }

  FutureApiResult<void> approveOrder({
    required String id,
    required ApproveAllOrderRequest body,
  }) async {
    return execute(() async {
      final response = await remoteDataSource.approveOrder(id: id, body: body);

      return response;
    });
  }

  FutureApiResult<void> partialApproveOrder({
    required String id,
    required PartialApproveOrderRequest body,
  }) async {
    return execute(() async {
      final response = await remoteDataSource.partialApproveOrder(
        id: id,
        body: body,
      );

      return response;
    });
  }

  FutureApiResult<void> rejectOrder({
    required String id,
    required RejectAllOrderRequest body,
  }) async {
    return execute(() async {
      final response = await remoteDataSource.rejectOrder(id: id, body: body);

      return response;
    });
  }

  FutureApiResult<void> cancelItem({
    required String orderId,
    required String itemId,
    required RejectAllOrderRequest body,
  }) async {
    return execute(() async {
      final response = await remoteDataSource.cancelItem(
        orderId: orderId,
        itemId: itemId,
        body: body,
      );

      return response;
    });
  }

  FutureApiResult<BranchOrderModificationResponse> getModification({
    required String orderId,
    required String itemId,
  }) async {
    return execute(() async {
      final response = await remoteDataSource.getModification(
        orderId: orderId,
        itemId: itemId,
      );

      return response;
    });
  }

  FutureApiResult<CancelReasonResponse> getCancellationReason({
    required String orderId,
    required String itemId,
  }) async {
    return execute(() async {
      final response = await remoteDataSource.getCancellationReason(
        orderId: orderId,
        itemId: itemId,
      );

      return response;
    });
  }

  FutureApiResult<void> approveModification({
    required String orderId,
    required String itemId,
  }) async {
    return execute(() async {
      final response = await remoteDataSource.branchApproveModification(
        orderId: orderId,
        itemId: itemId,
      );

      return response;
    });
  }

  FutureApiResult<void> rejectModification({
    required String orderId,
    required String itemId,
    required String reason,
  }) async {
    return execute(() async {
      final response = await remoteDataSource.branchRejectModification(
        orderId: orderId,
        itemId: itemId,
        reason: {'reason': reason},
      );

      return response;
    });
  }

  FutureApiResult<void> cancelOrder({
    required String orderId,
    required RejectAllOrderRequest body,
  }) async {
    return execute(() async {
      final response = await remoteDataSource.cancelOrder(
        orderId: orderId,
        body: body,
      );

      return response;
    });
  }

  FutureApiResult<OrderTrackResponse> getTrackOrder({
    required String orderId,
  }) async {
    return execute(() async {
      final response = await remoteDataSource.getTrackOrder(orderId: orderId);
      return response;
    });
  }

  FutureApiResult<void> approveDelay({required String id}) async {
    return execute(() async {
      final response = await remoteDataSource.approveDelay(id: id);
      return response;
    });
  }

  FutureApiResult<void> rejectDelay({
    required String id,
    required String reason,
  }) async {
    return execute(() async {
      final response = await remoteDataSource.rejectDelay(
        id: id,
        reason: {'reason': reason},
      );
      return response;
    });
  }

  FutureApiResult approveResponsibility({required String shiftId}) async {
    return execute(() async {
      await remoteDataSource.approveResponsibility(shiftId: shiftId);
      return true;
    });
  }

  FutureApiResult rejectResponsibility({
    required String shiftId,
    required String managerComment,
  }) async {
    return execute(() async {
      await remoteDataSource.rejectResponsibility(
        shiftId: shiftId,
        responsibilityRejectBodyRequest: ResponsibilityRejectBodyRequest(
          reason: managerComment,
        ),
      );
      return true;
    });
  }

  FutureApiResult acceptReassignedShift({required String shiftId}) async {
    return execute(() async {
      await remoteDataSource.acceptReassignedShift(shiftId: shiftId);
      return true;
    });
  }

  FutureApiResult<ResponsibilityDetailsEntity> getResponsibilityDetails(
    String shiftId,
  ) async {
    return execute(() async {
      final response = await remoteDataSource.getResponsibilityDetails(shiftId);

      return response.data.toEntity();
    });
  }

  FutureApiResult<ReassignedShiftsResponse> getReassignedShifts({
    required int page,
  }) async {
    return execute(() async {
      final response = await remoteDataSource.getReassignedShifts(page: page);

      return response;
    });
  }
}
