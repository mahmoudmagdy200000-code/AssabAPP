import 'package:assab/core/network/api_endpoints.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/branch_custody_transactions_response.dart';
import '../models/custody_branch_balance_response.dart';
import '../models/custody_create_request_transfer_request_model.dart';
import '../models/custody_get_past_requests_response.dart';
import '../models/custody_handover_to_cashier_request.dart';
import '../models/custody_personal_balance_only_response.dart';
import '../models/custody_personal_balance_response.dart';
import '../models/custody_recipients_response.dart';
import '../models/custody_request_details_response.dart';
import '../models/custody_requests_response.dart';
import '../models/custody_trend_balance_state_response.dart';
import '../models/export_as_pdf_response.dart';
import '../models/personal_custody_transactions_response.dart';

part 'custody_remote_data_source.g.dart';

@RestApi(baseUrl: ApiEndpoint.baseUrl)
abstract class CustodyRemoteDataSource {
  factory CustodyRemoteDataSource(Dio dio, {String baseUrl}) =
      _CustodyRemoteDataSource;

  @POST(ApiEndpoint.custodyRequestCashIn)
  Future<void> requestCashIn(@Body() FormData body);

  @POST(ApiEndpoint.custodyRequestCashIn)
  Future<void> reusePastRequestCashIn(@Body() FormData body);

  @POST(ApiEndpoint.custodyRequestTransfer)
  Future<void> requestTransfer(
    @Body() CustodyCreateRequestTransferRequestModel body,
  );

  @GET(ApiEndpoint.custodyRequests)
  Future<CustodyRequestsResponse> getRequests({
    @Query('status') required String? status,
    @Query('timePeriod') required String? timePeriod,
  });

  @GET(ApiEndpoint.custodyRequestsHistory)
  Future<CustodyGetPastRequestsResponse> getPastRequests();

  @GET(ApiEndpoint.custodyPersonalBalanceOnly)
  Future<CustodyPersonalBalanceOnlyResponse> getPersonalBalanceOnly();

  @GET(ApiEndpoint.custodyPersonalBalance)
  Future<CustodyPersonalBalanceResponse> getPersonalBalance({
    @Query('month') required String? month,
    @Query('year') required String? year,
  });

  @GET(ApiEndpoint.custodyPersonalBalanceTransactions)
  Future<PersonalCustodyTransactionsResponse> getPersonalBalanceTransactions({
    @Query('month') required String? month,
    @Query('year') required String? year,
  });

  @POST(ApiEndpoint.custodyPersonalBalanceTransactionsExportPdf)
  Future<ExportAsPdfResponse> getPersonalBalanceTransactionsExportPdf({
    @Query('timePeriod') required String? timePeriod,
    @Query('type') required String? type,
  });

  @GET(ApiEndpoint.custodyBranchTransactions)
  Future<BranchCustodyTransactionsResponse> getBranchTransactions({
    @Query('status') required String? status,
    @Query('timePeriod') required String? timePeriod,
  });

  @GET(ApiEndpoint.custodyBranchBalance)
  Future<CustodyBranchBalanceResponse> getBranchBalance();

  @POST(ApiEndpoint.custodyHandoverToCashier)
  Future<void> handoverToCashier({
    @Body() required CustodyHandoverToCashierRequest body,
  });

  @GET(ApiEndpoint.custodyGetRecipients)
  Future<CustodyRecipientsResponse> getRecipients();

  @GET(ApiEndpoint.custodyGetBalanceTrendState)
  Future<CustodyTrendBalanceStateResponse> getTrendBalanceState({
    @Query('month') required String? month,
    @Query('year') required String? year,
    @Query('custodyType') required String? custodyType,
    @Query('granularity') required String? granularity,
  });

  @GET(ApiEndpoint.custodyRequestDetails)
  Future<CustodyRequestDetailsResponse> getRequestDetails({
    @Path('id') required String id,
  });
}
