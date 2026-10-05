import 'package:assab/features/branch_manager_requests/data/models/orders_response.dart';
import 'package:assab/shared/models/cancel_reason/cancel_reason_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../shared/models/order_track_response.dart';
import '../../../cashier_requests/data/models/reassigned_shift_response.dart';
import '../models/approve_all_order_request.dart';
import '../models/branch_order_modification_response.dart';
import '../models/direct_supplier_order_details_response.dart';
import '../models/handovers_response.dart';
import '../models/officer_order_details_response.dart';
import '../models/order_details_response.dart';
import '../models/partial_approve_order_request.dart';
import '../models/reject_all_order_request.dart';
import '../models/responsibility_details_response_model.dart';
import '../models/responsibility_reject_body_request.dart';
import '../models/variances_response.dart';

part 'requests_remote_data_source.g.dart';

@RestApi(baseUrl: ApiEndpoint.baseUrl)
abstract class RequestsRemoteDataSource {
  factory RequestsRemoteDataSource(Dio dio, {String? baseUrl}) =
      _RequestsRemoteDataSource;

  @GET(ApiEndpoint.branchManagerOrders)
  Future<OrdersResponse> getOrders({@Query('page') required int page});

  @GET(ApiEndpoint.branchManagerRequestsHandovers)
  Future<HandoversResponse> getHandovers({@Query('page') required int page});

  @GET(ApiEndpoint.branchManagerRequestsVariances)
  Future<VariancesResponse> getVariances({@Query('page') required int page});

  @GET('${ApiEndpoint.purchaseHistory}/{id}')
  Future<OrderDetailsResponse> getBranchOrdersDetails({
    @Path('id') required String id,
  });

  @GET('${ApiEndpoint.purchaseHistory}/{id}')
  Future<DirectSupplierOrderDetailsResponse> getDirectSupplierOrdersDetails({
    @Path('id') required String id,
  });

  @GET('${ApiEndpoint.purchaseHistory}/{id}')
  Future<OfficerOrderDetailsResponse> getOfficerOrdersDetails({
    @Path('id') required String id,
  });

  @POST(
    '${ApiEndpoint.purchasePending}{id}/${ApiEndpoint.purchaseApproveRequest}',
  )
  Future<void> approveOrder({
    @Path('id') required String id,
    @Body() required ApproveAllOrderRequest body,
  });

  @POST(
    '${ApiEndpoint.purchasePending}{id}/${ApiEndpoint.purchasePartialApproveRequest}',
  )
  Future<void> partialApproveOrder({
    @Path('id') required String id,
    @Body() required PartialApproveOrderRequest body,
  });

  @POST(
    '${ApiEndpoint.purchasePending}{id}/${ApiEndpoint.purchaseRejectRequest}',
  )
  Future<void> rejectOrder({
    @Path('id') required String id,
    @Body() required RejectAllOrderRequest body,
  });

  @POST(ApiEndpoint.purchaseCancelItem)
  Future<void> cancelItem({
    @Path('order_id') required String orderId,
    @Path('item_id') required String itemId,
    @Body() required RejectAllOrderRequest body,
  });

  @GET(ApiEndpoint.purchaseModification)
  Future<BranchOrderModificationResponse> getModification({
    @Path('id') required String orderId,
    @Path('itemId') required String itemId,
  });

  @GET(ApiEndpoint.purchaseCancellationReason)
  Future<CancelReasonResponse> getCancellationReason({
    @Path('id') required String orderId,
    @Path('itemId') required String itemId,
  });

  @POST(ApiEndpoint.purchaseApproveModification)
  Future<void> branchApproveModification({
    @Path('order_id') required String orderId,
    @Path('item_id') required String itemId,
  });

  @POST(ApiEndpoint.purchaseRejectModification)
  Future<void> branchRejectModification({
    @Path('id') required String orderId,
    @Path('itemId') required String itemId,
    @Body() required Map<String, dynamic> reason,
  });

  @POST(ApiEndpoint.purchaseCancelOrder)
  Future<void> cancelOrder({
    @Path('id') required String orderId,
    @Body() required RejectAllOrderRequest body,
  });

  @GET(ApiEndpoint.purchaseOrderTracking)
  Future<OrderTrackResponse> getTrackOrder({
    @Path('orderId') required String orderId,
  });

  @POST(ApiEndpoint.purchaseApproveDelay)
  Future<void> approveDelay({@Path('id') required String id});

  @POST(ApiEndpoint.purchaseRejectDelay)
  Future<void> rejectDelay({
    @Path('id') required String id,
    @Body() required Map<String, dynamic> reason,
  });

  @POST('${ApiEndpoint.branchManagerShifts}/{shift}/responsibility/approve')
  Future approveResponsibility({@Path('shift') required String shiftId});

  @POST('${ApiEndpoint.branchManagerShifts}/{shift}/responsibility/reject')
  Future rejectResponsibility({
    @Path('shift') required String shiftId,
    @Body() ResponsibilityRejectBodyRequest? responsibilityRejectBodyRequest,
  });

  @POST('${ApiEndpoint.cashierShifts}/{shift}/reassign/accept')
  Future acceptReassignedShift({@Path('shift') required String shiftId});

  @GET('${ApiEndpoint.branchManagerShifts}/{shift}/responsibility/details')
  Future<ResponsibilityDetailsResponseModel> getResponsibilityDetails(
    @Path('shift') String shiftId,
  );

  @GET(ApiEndpoint.cashierRequestsReassignedShifts)
  Future<ReassignedShiftsResponse> getReassignedShifts({
    @Query('page') required int page,
  });
}
