import 'package:assab/features/recurring_orders/data/models/create_recurring_order_request.dart'
    show CreateRecurringOrderRequest;
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api_endpoints.dart';
import '../models/recurring_order_details_response.dart';
import '../models/recurring_orders_response.dart';
import '../models/update_recurring_order_request.dart';

part 'recurring_order_remote_data_source.g.dart';

@RestApi(baseUrl: ApiEndpoint.baseUrl)
abstract class RecurringOrderRemoteDataSource {
  factory RecurringOrderRemoteDataSource(Dio dio, {String? baseUrl}) =
      _RecurringOrderRemoteDataSource;

  @POST(ApiEndpoint.recurringOrders)
  Future<void> createRecurringOrder({
    @Body() required CreateRecurringOrderRequest requestBody,
  });

  @GET(ApiEndpoint.recurringOrdersInProgress)
  Future<RecurringOrdersResponse> getInProgressRecurringOrders();

  @GET(ApiEndpoint.recurringOrdersNextScheduling)
  Future<RecurringOrdersResponse> getNextSchedulingRecurringOrders();

  @GET(ApiEndpoint.recurringOrdersPaused)
  Future<RecurringOrdersResponse> getPausedRecurringOrders();

  @GET('${ApiEndpoint.recurringOrders}/{id}')
  Future<RecurringOrderDetailsResponse> getRecurringOrderDetails({
    @Path('id') required String id,
  });

  @DELETE('${ApiEndpoint.recurringOrders}/{id}')
  Future<void> deleteRecurringOrder({@Path('id') required String id});

  @POST('${ApiEndpoint.recurringOrders}/{id}/pause')
  Future<void> pauseRecurringOrder({@Path('id') required String id});

  @POST('${ApiEndpoint.recurringOrders}/{id}/resume')
  Future<void> resumeRecurringOrder({@Path('id') required String id});

  @PUT('${ApiEndpoint.recurringOrders}/{id}')
  Future<void> updateRecurringOrder({
    @Path('id') required String id,
    @Body() required UpdateRecurringOrderRequest requestBody,
  });
}
