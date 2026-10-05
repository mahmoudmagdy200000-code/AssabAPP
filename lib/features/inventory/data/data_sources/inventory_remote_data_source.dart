import 'package:assab/features/inventory/data/models/daily_inventory_items_response.dart';
import 'package:assab/features/inventory/data/models/daily_inventory_request.dart';
import 'package:assab/features/inventory/data/models/inventory_employee_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api_endpoints.dart';
import '../models/daily_inventory_list_response.dart';
import '../models/inventory_confirm_staff_task_request.dart';
import '../models/monthly_inventory_completed_products_response.dart';
import '../models/monthly_inventory_details_response.dart';
import '../models/monthly_inventory_list_response.dart';
import '../models/monthly_inventory_pending_products_response.dart';
import '../models/monthly_setup_info_response.dart';
import '../models/start_monthly_inventory_request.dart';
import '../models/start_monthly_inventory_response.dart';
import '../models/update_qty_monthly_inventory_request.dart';
import '../models/wasted_damage_items_response.dart';
import '../models/wasted_damage_list_response.dart';

part 'inventory_remote_data_source.g.dart';

@RestApi(baseUrl: ApiEndpoint.baseUrl)
abstract class InventoryRemoteDataSource {
  factory InventoryRemoteDataSource(Dio dio, {String baseUrl}) =
      _InventoryRemoteDataSource;

  @GET(ApiEndpoint.inventoryDailyQuickBranchItems)
  Future<DailyInventoryItemsResponse> getInventoryDailyQuickBranchItems();

  @GET(ApiEndpoint.inventoryEmployees)
  Future<InventoryEmployeeResponse> getInventoryEmployees();

  @POST('${ApiEndpoint.inventorycreateDaily}')
  Future<void> createDailyInventory({
    // @Path('id') required String id,
    @Body() required DailyInventoryRequest request,
  });

  @GET(ApiEndpoint.inventoryDailyQuickSessions)
  Future<DailyInventoryListResponse> getInventoryDailyRequests({
    @Query('status') String? status,
    @Query('page') required int page,
  });

  @GET(ApiEndpoint.inventoryWasteDamageProductsFromClosedOrders)
  Future<WastedDamageItemsResponse>
  getInventoryWasteDamageProductsFromClosedOrders();

  @POST(ApiEndpoint.inventoryWasteDamageReports)
  Future<void> createWasteDamageReport({@Body() required FormData request});

  @GET(ApiEndpoint.inventoryWasteDamageListReports)
  Future<WastedDamageListResponse> getWasteDamageListReports({
    @Query('status') String? status,
    @Query('page') required int page,
  });

  @GET(ApiEndpoint.inventoryMonthlySetupInfo)
  Future<MonthlySetupInfoResponse> getMonthlySetupInfo();

  @POST(ApiEndpoint.inventoryMonthly)
  Future<StartMonthlyInventoryResponse> startMonthlyInventory({
    @Body() required StartMonthlyInventoryRequest request,
  });

  @GET(ApiEndpoint.inventoryMonthly)
  Future<MonthlyInventoryListResponse> getMonthlyInventoryList({
    @Query('status') String? status,
    @Query('page') required int page,
  });

  @GET(ApiEndpoint.inventoryMonthlyProducts)
  Future<MonthlyInventoryPendingProductsResponse>
  getMonthlyInventoryPendingProducts({
    @Path('id') required String id,
    @Query('completed_only') required bool completedOnly,
  });

  @PUT(ApiEndpoint.inventoryMonthlyProductsUpdate)
  Future<void> updateMonthlyInventoryProduct({
    @Path('id') required String id,
    @Path('productId') required String productId,
    @Body() required UpdateQtyMonthlyInventoryRequest request,
  });

  @GET(ApiEndpoint.inventoryMonthlyProgress)
  Future<MonthlyInventoryCompletedProductsResponse>
  getMonthlyInventoryCompletedProducts({@Path('id') required String id});

  @GET(ApiEndpoint.inventoryMonthlyDetails)
  Future<MonthlyInventoryDetailsResponse> getMonthlyInventoryDetails({
    @Path('id') required String id,
  });

  @POST(ApiEndpoint.inventoryMonthlySubmit)
  Future<void> submitMonthlyInventory({@Path('id') required String id});

  @POST('inventory/waste-damage/reports/{id}/confirm')
  Future<void> confirmWasteDamageForStaff({
    @Path('id') required String id,
    @Body() required InventoryConfirmStaffTaskRequest request,
  });

  @POST('inventory/daily-quick/sessions/{id}/confirm')
  Future<void> confirmDailyForStaff({
    @Path('id') required String id,
    @Body() required InventoryConfirmStaffTaskRequest request,
  });
}
