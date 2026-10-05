import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

import '../../../../core/network/api_endpoints.dart';
import '../model/shifts_models/completed/cashier_completed_shifts_response_model.dart';
import '../model/shifts_models/in_progress/cashier_in_progress_shifts_response_model.dart';
import '../model/shifts_models/pending/cashier_pending_shifts_response_model.dart';
import '../model/shifts_models/reassigned/cashier_reassigned_shifts_response_model.dart';

part 'cashier_my_shifts_data_source.g.dart';

@RestApi(baseUrl: ApiEndpoint.baseUrl)
abstract class CashierMyShiftsRemoteDataSource {
  factory CashierMyShiftsRemoteDataSource(Dio dio, {String? baseUrl}) =
      _CashierMyShiftsRemoteDataSource;

  @GET(ApiEndpoint.cashierMyPendingShifts)
  Future<CashierPendingShiftsResponseModel> getCashierMyPendingShifts({
    @Query('page') int? page,
  });

  @GET(ApiEndpoint.cashierMyCompletedShifts)
  Future<CashierCompletedShiftsResponseModel> getCashierMyCompletedShifts({
    @Query('page') int? page,
  });

  @GET(ApiEndpoint.cashierMyReassignedShifts)
  Future<CashierReassignedShiftsResponseModel> getCashierMyReassignedShifts({
    @Query('page') int? page,
  });

  @GET(ApiEndpoint.cashierMyInProgressShifts)
  Future<CashierInProgressShiftsResponseModel> getCashierMyInProgressShifts();

  @POST('${ApiEndpoint.cashierShifts}/{shift}/reassign/accept')
  Future acceptReassignedCashierShift({@Path('shift') required String shiftId});
}
