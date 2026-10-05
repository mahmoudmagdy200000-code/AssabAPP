import 'package:assab/core/network/api_endpoints.dart';
import 'package:assab/shared/models/cancel_reason/cancel_reason_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../branch_manager_requests/data/models/reject_all_order_request.dart';
import '../models/supplier_alternative_product_request.dart';
import '../models/supplier_items_response.dart';
import '../models/supplier_need_time_request.dart';
import '../models/supplier_order_details_response.dart';
import '../models/supplier_order_modification_response.dart';
import '../models/supplier_orders_response.dart';
import '../models/supplier_partial_confirmItem_request.dart';

part 'supplier_remote_data_source.g.dart';

@RestApi(baseUrl: ApiEndpoint.baseUrl)
abstract class SupplierRemoteDataSource {
  factory SupplierRemoteDataSource(Dio dio, {String baseUrl}) =
      _SupplierRemoteDataSource;

  @GET(ApiEndpoint.supplierOrders)
  Future<SupplierOrdersResponse> getSupplierOrders({@Query('page') int? page});

  @GET('${ApiEndpoint.supplierOrders}/{id}')
  Future<SupplierOrderDetailsResponse> getSupplierOrderDetails({
    @Path('id') required String id,
  });

  @POST(ApiEndpoint.supplierPartialConfirmItem)
  Future<void> supplierPartialConfirmItem({
    @Path('id') required String id,
    @Body() required SupplierPartialConfirmItemRequest body,
  });

  @POST(ApiEndpoint.supplierFullConfirmItem)
  Future<void> supplierFullConfirmItem({
    @Path('orderId') required String orderId,
    @Path('itemId') required String itemId,
  });

  @POST(ApiEndpoint.supplierCancelItem)
  Future<void> supplierCancelItem({
    @Path('orderId') required String orderId,
    @Path('itemId') required String itemId,
    @Body() required RejectAllOrderRequest body,
  });

  @POST(ApiEndpoint.supplierConfirmOrder)
  Future<void> supplierConfirmOrder({@Path('id') required String orderId});

  @POST(ApiEndpoint.supplierCancelOrder)
  Future<void> supplierCancelOrder({
    @Path('id') required String orderId,
    @Body() required RejectAllOrderRequest body,
  });

  @POST(ApiEndpoint.supplierNeedTimeItem)
  Future<void> supplierNeedTimeItem({
    @Path('id') required String orderId,
    @Path('itemId') required String itemId,
    @Body() required SupplierNeedTimeRequest body,
  });

  @POST(ApiEndpoint.supplierAlternativeProductItem)
  Future<void> supplierAlternativeProductItem({
    @Path('id') required String orderId,
    @Path('itemId') required String itemId,
    @Body() required SupplierAlternativeProductRequest body,
  });

  @GET(ApiEndpoint.supplierItems)
  Future<SupplierItemsResponse> getSupplierItem({
    @Query('page') required int page,
  });

  @GET(ApiEndpoint.supplierCancellationReason)
  Future<CancelReasonResponse> getSupplierCancellationReason({
    @Path('id') required String orderId,
    @Path('itemId') required String itemId,
  });

  @GET(ApiEndpoint.supplierModification)
  Future<SupplierOrderModificationResponse> getSupplierModification({
    @Path('id') required String orderId,
    @Path('itemId') required String itemId,
  });

  @POST(ApiEndpoint.supplierStartPreparingOrder)
  Future<void> supplierStartPreparingOrder({@Body() required FormData body});

  @POST(ApiEndpoint.supplierMarkOrderAsDelivery)
  Future<void> supplierMarkOrderAsDelivery({
    @Path('order_id') required String orderId,
    @Body() required FormData body,
  });

  @POST(ApiEndpoint.supplierRepostDelayOrder)
  Future<void> supplierRepostDelayOrder({
    @Path('order_id') required String orderId,
    @Body() required FormData body,
  });

  @POST(ApiEndpoint.supplierMarkOrderAsDelivered)
  Future<void> supplierMarkOrderDelivered({
    @Path('order_id') required String orderId,
    @Body() required FormData body,
  });
}
