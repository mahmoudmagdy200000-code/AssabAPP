import 'package:assab/features/shift_module_features/shift_management/data/model/branch_response_model.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/handover_status_details/handover_status_details_response_model.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/manager_shift_management_models/cashier_handover_models/cashier_handover_details_model.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/manager_shift_management_models/final_daily_close/final_daily_close_model.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/aggregators_response_model.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/hand_over_request.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/shift_details/variance/variance_details_response_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../../core/network/api_endpoints.dart';
import '../model/available_recipients_response_model.dart';
import '../model/add_cashier_models/check_email_response_model.dart';
import '../model/cashier_details_response_model.dart';
import '../model/cashiers_response_model.dart';
import '../model/get_all_cashiers_and_managers_response_model.dart';
import '../model/manager_shift_management_models/current_shift_response_model.dart';
import '../model/manager_shift_management_models/end_shift_models/end_shift_response_models/end_shift_response_model.dart';
import '../model/manager_shift_management_models/end_shift_models/end_shift_response_models/manager_shift_update_data_model.dart';
import '../model/manager_shift_management_models/end_shift_models/manager_end_shift_request_model.dart';
import '../model/manager_shift_management_models/end_shift_models/update_manager_handover_request_model.dart';
import '../model/shift/available_cashiers_response_model.dart';
import '../model/shift/available_shifts_model.dart';
import '../model/shift/handover_approve_body_request.dart';
import '../model/shift/reassign_shift/reassign_shift_request_model.dart';
import '../model/shift/shift_details/shift_details_response_model.dart';
import '../model/shift/shift_response_model.dart';

part 'shift_management_remote_data_source.g.dart';

@RestApi(baseUrl: ApiEndpoint.baseUrl)
abstract class ShiftManagementRemoteDataSource {
  factory ShiftManagementRemoteDataSource(Dio dio, {String? baseUrl}) =
      _ShiftManagementRemoteDataSource;

  @GET(ApiEndpoint.branchManagerCashiers)
  Future<CashiersResponseModel> getCashiers({
    @Queries() Map<String, dynamic>? queryParams,
    @Query('page') int? page,
    @Query('status') String? status,
    @Query('search') String? search,
    @Query('date_filter') String? dateOption,
  });

  @GET('${ApiEndpoint.branchManagerCashiers}/all')
  Future<GetAllCashiersAndManagersResponse> getAllCashiersAndManagers({
    @Query('page') int? page,
  });

  @POST(ApiEndpoint.branchManagerCashiers)
  Future<void> addCashier({@Body() required Map<String, dynamic> body});

  @GET(ApiEndpoint.Aggregators)
  Future<AggregatorsResponseModel> getAggregators({@Query('page') int? page});

  @GET(ApiEndpoint.branchManagerAllCashierShifts)
  Future<ShiftResponseModel> getAllCashierShifts({
    @Query('cashier_id') required String cashierId,
    @Query('page') int? page,
    @Query('status') String? status,
    @Query('date_filter') String? dateOption,
    @Query('manager_id') String? managerId,
  });

  @GET(ApiEndpoint.branchManagerShifts)
  Future<AvailableShiftResponseModel> getAvailableShifts({
    @Query('page') int? page,
  });

  @GET(ApiEndpoint.branchManagerBranches)
  Future<BranchesResponseModel> getBranches({@Query('page') int? page});

  @GET(ApiEndpoint.branchManagerCashiersAvailableForShifts)
  Future<AvailableCashiersResponse> getAvailableCashiersForShift({
    @Query('shift_id') required String shiftId,
    @Query('shift_date') required String shiftDate,
    @Query('page') int? page,
  });

  @POST('${ApiEndpoint.branchManagerShifts}/{shiftId}/reassign')
  Future<void> reassignShift(
    @Path('shiftId') String shiftId,
    @Body() ReassignShiftRequestModel request,
  );

  @POST('${ApiEndpoint.branchManagerShifts}/{shift}/reassign-with-handover')
  Future<void> reassignShiftWithHandOver({
    @Path('shift') required String shiftId,
    @Body() required FormData data,
  });

  @GET(ApiEndpoint.branchManagerPendingShifts)
  Future<ShiftResponseModel> getPendingShifts({
    @Query('cashier_id') required String cashierId,
    @Query('page') int? page,
  });

  @GET(ApiEndpoint.branchManagerInProgressShifts)
  Future<ShiftResponseModel> getInProgressShifts({
    @Query('cashier_id') required String cashierId,
    @Query('page') int? page,
  });

  @GET(ApiEndpoint.branchManagerCompletedShifts)
  Future<ShiftResponseModel> getCompletedShifts({
    @Query('cashier_id') required String cashierId,
    @Query('page') int? page,
  });

  @GET('${ApiEndpoint.branchManagerAllCashierShifts}/{shift}')
  Future<ShiftDetailsResponseModel> getShiftDetails({
    @Path('shift') required String shiftId,
  });

  @GET('${ApiEndpoint.branchManagerShifts}/{shift}/handover/status')
  Future<HandoverStatusDetailsResponseModel> getHandoverRejectionDetails({
    @Path('shift') required String shiftId,
  });

  @POST('${ApiEndpoint.branchManagerShifts}/{shift}/end')
  Future<void> endShift({
    @Path('shift') required String shiftId,
    @Body() required FormData formData,
    // @Path('shift') required int shiftId,
    // @Part(name: 'pos_receipt') required File posReceipt,
    // @Part(name: 'total_sales') required double totalSales,
    // @Part(name: 'cash_collected') double? cashCollected,
    // @Part(name: 'card_payments')  double? cardPayments,
    // @PartMap() Map<String, dynamic>? fields,
  });

  @POST('${ApiEndpoint.branchManagerShifts}/{shift}/end-with-handover')
  Future<void> endShiftWithHandOver({
    @Path('shift') required String shiftId,
    @Body() required FormData data,
  });

  @POST('${ApiEndpoint.branchManagerShifts}/{shift}/cash-reconciliation/preview')
  Future<dynamic> previewCashReconciliation({
    @Path('shift') required String shiftId,
    @Body() required Map<String, dynamic> body,
  });

  @GET('${ApiEndpoint.branchWorkDayMgmt}/current')
  Future<CurrentShiftResponse> getCurrentShift();

  @POST('${ApiEndpoint.branchWorkDayMgmt}/start')
  Future startManagerShift();

  @POST('${ApiEndpoint.branchWorkDayMgmt}/end')
  Future<ShiftEndResponseModel> endManagerShift({
    @Body() required EndManagerShiftRequestModel endManagerShiftRequestModel,
    @Header('Idempotency-Key') String? idempotencyKey,
  });

  @PUT('${ApiEndpoint.branchWorkDayMgmt}/daily-close')
  Future<ManagerShiftUpdateResponseModel> updateManagerHandoverShift({
    @Body()
    required UpdateManagerHandoverRequestModel updateManagerShiftRequestModel,
    @Header('Idempotency-Key') String? idempotencyKey,
  });

  @POST(ApiEndpoint.cashierStartHandover)
  Future<dynamic> handOver({
    @Path('shift') required String shiftId,
    @Body() required HandOverRequest handOverRequest,
  });

  @POST(ApiEndpoint.cashierStartShift)
  Future startCashierShift({@Path('shiftId') required String shiftId});

  @POST(ApiEndpoint.branchManagerStartShift)
  Future startShiftByManager({@Path('shiftId') required String shiftId});

  @POST('${ApiEndpoint.cashierShifts}/{shift}/handover/accept')
  Future acceptCashierHandover({
    @Path('shift') required String shiftId,
    @Body() HandoverApproveAndRejectBodyRequest? body,
  });

  @POST('${ApiEndpoint.cashierShifts}/{shift}/handover/reject')
  Future rejectCashierHandover({
    @Path('shift') required String shiftId,
    @Body() HandoverApproveAndRejectBodyRequest? body,
  });

  @GET(ApiEndpoint.cashierAvailableRecipients)
  Future<AvailableRecipientsResponseModel> getAvailableRecipients({
    @Path('shift') required String shiftId,
  });

  @GET('${ApiEndpoint.branchManagerShifts}/{shift}/variance')
  Future<VarianceResponseModel> getVarianceDetails({
    @Path('shift') required String shiftId,
  });

  @GET('${ApiEndpoint.branchWorkDayMgmt}/daily-close')
  Future<FinalDailyCloseResponse> getDailyClose();

  @POST('${ApiEndpoint.branchManagerShifts}/{shift}/handover/approve')
  Future approveHandover({
    @Path('shift') required String shiftId,
    @Body()
    HandoverApproveAndRejectBodyRequest? handoverApproveAndRejectBodyRequest,
  });

  @POST('${ApiEndpoint.branchManagerShifts}/{shift}/handover/reject')
  Future rejectHandover({
    @Path('shift') required String shiftId,
    @Body()
    HandoverApproveAndRejectBodyRequest? handoverApproveAndRejectBodyRequest,
  });

  @POST(
    '${ApiEndpoint.branchManagerShifts}/{shift}/handover/rejection-decision',
  )
  Future requestHandoverCorrection({
    @Path('shift') required String shiftId,
    @Body()
    HandoverApproveAndRejectBodyRequest? handoverApproveAndRejectBodyRequest,
  });

  @GET('${ApiEndpoint.branchWorkDayMgmt}/handoffs/cashier/{handoverId}')
  Future<CashierHandoverDetailsModel> getHandoverDetails({
    @Path('handoverId') required String handoverId,
  });

  @GET('${ApiEndpoint.branchManagerCashiers}/check-email')
  Future<CheckEmailResponseModel> checkCashierEmail({
    @Query('email') required String email,
  });

  @PUT('${ApiEndpoint.branchManagerCashiers}/{cashier}')
  Future<void> updateCashier({
    @Path('cashier') required String cashierId,
    @Body() required Map<String, dynamic> body,
  });

  @GET('${ApiEndpoint.branchManagerCashiers}/{cashier}')
  Future<CashierResponseModel> getCashierDetails({
    @Path('cashier') required String cashierId,
  });
}
