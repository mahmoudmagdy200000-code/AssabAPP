import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api_endpoints.dart';
import '../models/return_goods_details_response.dart';
import '../models/return_goods_response.dart';

part 'return_management_remote_data_source.g.dart';

@RestApi(baseUrl: ApiEndpoint.baseUrl)
abstract class ReturnManagementRemoteDataSource {
  factory ReturnManagementRemoteDataSource(Dio dio, {String baseUrl}) =
      _ReturnManagementRemoteDataSource;

  @POST(ApiEndpoint.purchaseCreateReturns)
  Future<void> createReturnRequest({@Body() required FormData body});

  @POST(ApiEndpoint.purchaseAcceptReturnRejection)
  Future<void> acceptReturnRejection({@Path('id') required String id});

  @POST(ApiEndpoint.purchaseEscalateReturn)
  Future<void> escalateReturn({
    @Path('id') required String id,
    @Body() required Map<String, dynamic> body,
  });

  @GET(ApiEndpoint.purchaseInProgressReturns)
  Future<ReturnGoodsResponse> getInpogressReturns();

  @GET(ApiEndpoint.purchaseCompletedReturns)
  Future<ReturnGoodsResponse> getCompletedReturns();

  @GET(ApiEndpoint.purchaseReturnDetails)
  Future<ReturnGoodsDetailsResponse> getReturnDetials({
    @Path('id') required String id,
  });
}
