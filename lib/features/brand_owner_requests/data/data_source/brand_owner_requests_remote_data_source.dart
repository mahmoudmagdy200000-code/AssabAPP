import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api_endpoints.dart';
import '../models/brand_owner_requests_models.dart';

part 'brand_owner_requests_remote_data_source.g.dart';

@RestApi(baseUrl: ApiEndpoint.baseUrl)
abstract class BrandOwnerRequestsRemoteDataSource {
  factory BrandOwnerRequestsRemoteDataSource(Dio dio, {String? baseUrl}) =
      _BrandOwnerRequestsRemoteDataSource;

  @POST(ApiEndpoint.brandOwnerPaymentForm)
  Future<void> submitOwnerPaymentForm({@Body() required FormData body});

  @GET(ApiEndpoint.brandOwnerPaymentLogs)
  Future<BrandOwnerPaymentLogResponse> getPaymentLogs({
    @Query('type') String? type,
    @Query('sortByDate') String? sortByDate,
    @Query('branchId') String? branchId,
    @Query('page') int? page,
  });

  @GET(ApiEndpoint.brandOwnerPaymentLogDetails)
  Future<BrandOwnerPaymentLogDetailsModel> getPaymentLogDetails({
    @Path('id') required String id,
  });

  @GET(ApiEndpoint.brandOwnerCashSalesTransfers)
  Future<BrandOwnerRequestsCustodySalesTransfersResponse>
  getCashSalesTransfers({@Query('page') int? page});

  @GET(ApiEndpoint.brandOwnerCashSalesTransferDetails)
  Future<BrandOwnerSalesTransferDetailsModel> getCashSalesTransferDetails({
    @Path('transferId') required String transferId,
  });

  @POST(ApiEndpoint.brandOwnerExpensesApprove)
  Future<void> approveBrandOwnerExpense({@Path('id') required String id});

  @POST(ApiEndpoint.brandOwnerExpensesReject)
  Future<void> rejectBrandOwnerExpense({
    @Path('id') required String id,
    @Body() required Map<String, dynamic> reason,
  });

  @POST(ApiEndpoint.brandOwnerCustodyRequestsApprove)
  Future<void> approveBrandOwnerCustodyRequest({
    @Path('id') required String id,
  });

  @POST(ApiEndpoint.brandOwnerCustodyRequestsReject)
  Future<void> rejectBrandOwnerCustodyRequest({
    @Path('id') required String id,
    @Body() required Map<String, dynamic> reason,
  });

  @POST(ApiEndpoint.brandOwnerCashSalesTransfersApprove)
  Future<void> approveBrandOwnerCashSalesTransfer({
    @Path('id') required String id,
  });

  @POST(ApiEndpoint.brandOwnerCashSalesTransfersReject)
  Future<void> rejectBrandOwnerCashSalesTransfer({
    @Path('id') required String id,
    @Body() required Map<String, dynamic> reason,
  });

  @GET(ApiEndpoint.brandOwnerBranches)
  Future<BrandOwnerPaymentLogBranchModel> getBranches();
}
