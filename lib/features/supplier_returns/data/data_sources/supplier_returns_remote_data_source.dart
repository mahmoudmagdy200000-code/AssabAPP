import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api_endpoints.dart';
import '../models/supplier_return_goods_details_response.dart';
import '../models/supplier_returns_response.dart';

part 'supplier_returns_remote_data_source.g.dart';

@RestApi(baseUrl: ApiEndpoint.baseUrl)
abstract class SupplierReturnsRemoteDataSource {
  factory SupplierReturnsRemoteDataSource(Dio dio, {String? baseUrl}) =
      _SupplierReturnsRemoteDataSource;

  @GET(ApiEndpoint.supplierReturns)
  Future<SupplierReturnsResponse> getSupplierReturns({
    @Query('page') required int page,
  });

  @GET(ApiEndpoint.supplierReturnDetails)
  Future<SupplierReturnGoodsDetailsResponse> getSupplierReturnDetails({
    @Path('id') required String id,
  });

  @POST(ApiEndpoint.supplierReturnReject)
  Future<void> rejectSupplierReturn({
    @Path('id') required String id,
    @Body() required Map<String, dynamic> body,
  });

  @POST(ApiEndpoint.supplierReturnApprove)
  Future<void> approveSupplierReturn({@Path('id') required String id});
}
