import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api_endpoints.dart';
import '../models/brand_owner_daily_inventory_details_response.dart';
import '../models/brand_owner_daily_inventory_requests_response.dart';
import '../models/brand_owner_wast_and_damage_details_response.dart';
import '../models/brand_owner_wast_and_damage_requests_response.dart';

part 'brand_owner_inventory_remote_data_source.g.dart';

@RestApi(baseUrl: ApiEndpoint.baseUrl)
abstract class BrandOwnerInventoryRemoteDataSource {
  factory BrandOwnerInventoryRemoteDataSource(Dio dio, {String baseUrl}) =
      _BrandOwnerInventoryRemoteDataSource;

  @GET(ApiEndpoint.brandManagerInventoryDailyRequests)
  Future<BrandOwnerDailyInventoryRequestsResponse> getDailyInventoryRequests({
    @Query('page') int? page,
  });

  @GET(ApiEndpoint.brandManagerInventoryWasteDamageRequests)
  Future<BrandOwnerWastAndDamageRequestsResponse> getWasteDamageRequests({
    @Query('page') int? page,
  });

  @GET(ApiEndpoint.brandManagerInventoryDailyRequestDetails)
  Future<BrandOwnerDailyInventoryDetailsResponse> getDailyInventoryDetails({
    @Path('requestId') required String requestId,
  });

  @GET(ApiEndpoint.brandManagerInventoryWasteDamageRequestDetails)
  Future<BrandOwnerWastAndDamageDetailsResponse> getWasteDamageDetails({
    @Path('requestId') required String requestId,
  });

  @POST(ApiEndpoint.brandManagerInventoryDailyRequestApprove)
  Future<void> approveDailyInventoryRequest({
    @Path('requestId') required String requestId,
  });

  @POST(ApiEndpoint.brandManagerInventoryDailyRequestReject)
  Future<void> rejectDailyInventoryRequest({
    @Path('requestId') required String requestId,
  });

  @POST(ApiEndpoint.brandManagerInventoryWasteDamageRequestApprove)
  Future<void> approveWasteDamageRequest({
    @Path('requestId') required String requestId,
  });

  @POST(ApiEndpoint.brandManagerInventoryWasteDamageRequestReject)
  Future<void> rejectWasteDamageRequest({
    @Path('requestId') required String requestId,
  });
}
