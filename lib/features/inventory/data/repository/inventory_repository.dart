import 'package:assab/core/errors/api_error_handler.dart';
import 'package:assab/core/errors/repository_mixin.dart';
import 'package:assab/core/services/realtime_service/realtime_service.dart';
import 'package:assab/core/utils/api_result.dart';
import 'package:assab/core/utils/future_api_result.dart';
import 'package:assab/features/inventory/data/data_sources/inventory_remote_data_source.dart';
import 'package:assab/features/inventory/data/models/daily_inventory_items_response.dart';
import 'package:assab/features/inventory/data/models/daily_inventory_request.dart';
import 'package:assab/features/inventory/data/models/inventory_employee_response.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/services/realtime_service/realtime_event.dart';
import '../../../../core/utils/stream_api_result.dart';
import '../models/create_wast_and_damage_request.dart';
import '../models/daily_inventory_list_response.dart';
import '../models/inventory_confirm_staff_task_request.dart';
import '../models/monthly_inventory_completed_products_response.dart';
import '../models/monthly_inventory_details_response.dart';
import '../models/monthly_inventory_list_response.dart';
import '../models/monthly_inventory_pending_product_payload.dart';
import '../models/monthly_inventory_pending_products_response.dart';
import '../models/monthly_setup_info_response.dart';
import '../models/start_monthly_inventory_request.dart';
import '../models/start_monthly_inventory_response.dart';
import '../models/update_qty_monthly_inventory_request.dart';
import '../models/wasted_damage_items_response.dart';
import '../models/wasted_damage_list_response.dart';

@LazySingleton()
class InventoryRepository with RepositoryMixin {
  final InventoryRemoteDataSource _inventoryRemoteDataSource;
  final RealtimeService _realtimeService;

  InventoryRepository(this._inventoryRemoteDataSource, this._realtimeService);

  FutureApiResult<DailyInventoryItemsResponse>
  getInventoryDailyQuickBranchItems() => execute(
    () async => _inventoryRemoteDataSource.getInventoryDailyQuickBranchItems(),
  );

  FutureApiResult<InventoryEmployeeResponse> getInventoryEmployees() =>
      execute(() async => _inventoryRemoteDataSource.getInventoryEmployees());

  FutureApiResult<void> createDailyInventory({
    required String id,
    required DailyInventoryRequest request,
  }) => execute(() async {
    return await _inventoryRemoteDataSource.createDailyInventory(
      // id: id,
      request: request,
    );
  });

  FutureApiResult<DailyInventoryListResponse> getInventoryDailyRequests({
    String? status,
    required int page,
  }) => execute(() async {
    return _inventoryRemoteDataSource.getInventoryDailyRequests(
      status: status,
      page: page,
    );
  });

  FutureApiResult<WastedDamageItemsResponse>
  getInventoryWasteDamageProductsFromClosedOrders() => execute(
    () async => _inventoryRemoteDataSource
        .getInventoryWasteDamageProductsFromClosedOrders(),
  );

  FutureApiResult<void> createWasteDamageReport({
    required CreateWastAndDamageRequest request,
  }) => execute(() async {
    return await _inventoryRemoteDataSource.createWasteDamageReport(
      request: request.toFormData(),
    );
  });

  FutureApiResult<WastedDamageListResponse> getWasteDamageListReports({
    String? status,
    required int page,
  }) => execute(() async {
    return _inventoryRemoteDataSource.getWasteDamageListReports(
      status: status,
      page: page,
    );
  });

  FutureApiResult<MonthlySetupInfoResponse> getMonthlySetupInfo() =>
      execute(() async => _inventoryRemoteDataSource.getMonthlySetupInfo());

  FutureApiResult<StartMonthlyInventoryResponse> startMonthlyInventory({
    required StartMonthlyInventoryRequest request,
  }) => execute(() async {
    return _inventoryRemoteDataSource.startMonthlyInventory(request: request);
  });

  FutureApiResult<MonthlyInventoryPendingProductsResponse>
  getMonthlyInventoryPendingProducts({
    required String inventoryId,
    required bool completedOnly,
  }) => execute(() async {
    return _inventoryRemoteDataSource.getMonthlyInventoryPendingProducts(
      id: inventoryId,
      completedOnly: completedOnly,
    );
  });

  StreamApiResult<T> _subscribe<T>({
    required String channel,
    required T Function(Map<String, dynamic> json) mapper,
  }) {
    return _realtimeService
        .subscribe<T>(channel: channel, mapper: mapper)
        .map<ApiResult<RealtimeEvent<T>>>(ApiResult.success)
        .handleError(
          (Object error, StackTrace stack) =>
              ApiResult<RealtimeEvent<T>>.failure(
                ApiErrorHandler.handle(error, stack),
              ),
        );
  }

  StreamApiResult<MonthlyInventoryPendingProductPayload>
  subscribeToMonthlyInventoryProducts({required String inventoryId}) {
    return _subscribe(
      channel: 'presence-inventory.monthly.$inventoryId',
      mapper: (json) => MonthlyInventoryPendingProductPayload.fromJson(json),
    );
  }

  FutureApiResult<void> unsubscribeFromMonthlyInventoryProducts({
    required String inventoryId,
  }) => execute(() async {
    return await _realtimeService.unsubscribe(
      'presence-inventory.monthly.$inventoryId',
    );
  });

  FutureApiResult<MonthlyInventoryListResponse> getMonthlyInventoryList({
    String? status,
    required int page,
  }) => execute(() async {
    return _inventoryRemoteDataSource.getMonthlyInventoryList(
      status: status,
      page: page,
    );
  });

  FutureApiResult<void> updateMonthlyInventoryProduct({
    required String inventoryId,
    required String productId,
    required UpdateQtyMonthlyInventoryRequest request,
  }) => execute(() async {
    return await _inventoryRemoteDataSource.updateMonthlyInventoryProduct(
      id: inventoryId,
      productId: productId,
      request: request,
    );
  });

  FutureApiResult<MonthlyInventoryCompletedProductsResponse>
  getMonthlyInventoryCompletedProducts({required String inventoryId}) =>
      execute(() async {
        return _inventoryRemoteDataSource.getMonthlyInventoryCompletedProducts(
          id: inventoryId,
        );
      });

  FutureApiResult<MonthlyInventoryDetailsResponse> getMonthlyInventoryDetails({
    required String inventoryId,
  }) => execute(() async {
    return _inventoryRemoteDataSource.getMonthlyInventoryDetails(
      id: inventoryId,
    );
  });

  FutureApiResult<void> submitMonthlyInventory({required String inventoryId}) =>
      execute(() async {
        return await _inventoryRemoteDataSource.submitMonthlyInventory(
          id: inventoryId,
        );
      });

  FutureApiResult<void> confirmWasteDamageForStaff({
    required String reportId,
    required InventoryConfirmStaffTaskRequest request,
  }) => execute(() async {
    return await _inventoryRemoteDataSource.confirmWasteDamageForStaff(
      id: reportId,
      request: request,
    );
  });

  FutureApiResult<void> confirmDailyForStaff({
    required String sessionId,
    required InventoryConfirmStaffTaskRequest request,
  }) => execute(() async {
    return await _inventoryRemoteDataSource.confirmDailyForStaff(
      id: sessionId,
      request: request,
    );
  });
}
