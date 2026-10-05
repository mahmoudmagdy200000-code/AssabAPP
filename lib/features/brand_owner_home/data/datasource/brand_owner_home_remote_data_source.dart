import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api_endpoints.dart';
import '../models/brand_owner_branch_model.dart';
import '../models/brand_owner_home_data_model.dart';

part 'brand_owner_home_remote_data_source.g.dart';

@RestApi(baseUrl: ApiEndpoint.baseUrl)
abstract class BrandOwnerHomeRemoteDataSource {
  factory BrandOwnerHomeRemoteDataSource(Dio dio, {String? baseUrl}) =
      _BrandOwnerHomeRemoteDataSource;

  @GET(ApiEndpoint.brandOwnerBranchesDashboard)
  Future<BrandOwnerBranchModel> getBrandOwnerBranches();

  @GET(ApiEndpoint.brandOwnerHomeDashboard)
  Future<BrandOwnerHomeDataModel> getBrandOwnerHomeDashboard({
    @Query('branch_id') String? branchId,
    @Query('month') int? month,
    @Query('year') int? year,
    @Query('granularity') String? granularity,
  });

  @POST(ApiEndpoint.brandOwnerPaymentForm)
  Future<void> submitOwnerPaymentForm({@Body() required FormData body});

  @POST(ApiEndpoint.brandOwnerPurchaseReturnsApproveEscalation)
  Future<void> approveReturnEscalation({
    @Path('returnId') required String returnId,
  });

  @POST(ApiEndpoint.brandOwnerPurchaseReturnsRejectEscalation)
  Future<void> rejectReturnEscalation({
    @Path('returnId') required String returnId,
  });
}
