import 'package:assab/core/errors/repository_mixin.dart';
import 'package:assab/core/utils/future_api_result.dart';
import 'package:injectable/injectable.dart';

import '../data_sources/recurring_order_remote_data_source.dart';
import '../models/create_recurring_order_request.dart';
import '../models/recurring_order_details_response.dart';
import '../models/recurring_orders_response.dart';
import '../models/update_recurring_order_request.dart';

@LazySingleton()
class RecurringOrderRepository with RepositoryMixin {
  final RecurringOrderRemoteDataSource _remoteDataSource;

  RecurringOrderRepository(this._remoteDataSource);

  FutureApiResult<void> createRecurringOrder(
    CreateRecurringOrderRequest request,
  ) => execute(() async {
    return _remoteDataSource.createRecurringOrder(requestBody: request);
  });

  FutureApiResult<RecurringOrdersResponse> getInProgressRecurringOrders() =>
      execute(() async => _remoteDataSource.getInProgressRecurringOrders());

  FutureApiResult<RecurringOrdersResponse> getNextSchedulingRecurringOrders() =>
      execute(() async => _remoteDataSource.getNextSchedulingRecurringOrders());

  FutureApiResult<RecurringOrdersResponse> getPausedRecurringOrders() =>
      execute(() async => _remoteDataSource.getPausedRecurringOrders());

  FutureApiResult<RecurringOrderDetailsResponse> getRecurringOrderDetails({
    required String id,
  }) => execute(() async => _remoteDataSource.getRecurringOrderDetails(id: id));

  FutureApiResult<void> deleteRecurringOrder({required String id}) =>
      execute(() async => _remoteDataSource.deleteRecurringOrder(id: id));

  FutureApiResult<void> pauseRecurringOrder({required String id}) =>
      execute(() async => _remoteDataSource.pauseRecurringOrder(id: id));

  FutureApiResult<void> resumeRecurringOrder({required String id}) =>
      execute(() async => _remoteDataSource.resumeRecurringOrder(id: id));

  FutureApiResult<void> updateRecurringOrder({
    required String id,
    required UpdateRecurringOrderRequest request,
  }) => execute(() async {
    return _remoteDataSource.updateRecurringOrder(id: id, requestBody: request);
  });
}
