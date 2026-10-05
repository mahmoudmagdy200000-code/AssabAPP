import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api_endpoints.dart';
import '../models/receive_goods_in_progress_orders_response.dart';
import '../models/receive_order_inspection_response.dart';

part 'receive_goods_remote_data_source.g.dart';

@RestApi(baseUrl: ApiEndpoint.baseUrl)
abstract class ReceiveGoodsRemoteDataSource {
  factory ReceiveGoodsRemoteDataSource(Dio dio, {String? baseUrl}) =
      _ReceiveGoodsRemoteDataSource;

  @GET(ApiEndpoint.purchaseReceivingOrdersInProgress)
  Future<ReceiveGoodsInProgressOrdersResponse> getReceivingOrdersInProgress({
    @Query('page') required int page,
  });

  @GET(ApiEndpoint.purchaseReceivingOrdersMissing)
  Future<ReceiveGoodsInProgressOrdersResponse> getReceivingOrdersMissing({
    @Query('page') required int page,
  });

  @GET(ApiEndpoint.purchaseReceivingOrdersCompleted)
  Future<ReceiveGoodsInProgressOrdersResponse> getReceivingOrdersCompleted({
    @Query('page') required int page,
  });

  @GET(ApiEndpoint.purchaseReceivingOrderInspection)
  Future<ReceiveOrderInspectionResponse> getReceivingOrderInspection({
    @Path('orderId') required String orderId,
  });

  @POST(ApiEndpoint.purchaseReceivingSupplierOrderStart)
  Future<void> startReceivingSupplierOrder({
    @Path('orderId') required String orderId,
    @Body() required FormData formData,
  });

  @POST(ApiEndpoint.purchaseReceivingBranchOrderStart)
  Future<void> startReceivingBranchOrder({
    @Path('orderId') required String orderId,
  });
}
