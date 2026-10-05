import 'package:assab/core/network/api_endpoints.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/cashier_branch_info_response.dart';
import '../models/cashier_info_response.dart';
import '../models/cashier_tasks_response.dart';

part 'cashier_home_remote_data_source.g.dart';

@RestApi(baseUrl: ApiEndpoint.baseUrl)
abstract class CashierHomeRemoteDataSource {
  factory CashierHomeRemoteDataSource(Dio dio, {String baseUrl}) =
      _CashierHomeRemoteDataSource;

  @GET(ApiEndpoint.inventoryTasks)
  Future<CashierTasksResponse> getInventoryTasks();

  @GET(ApiEndpoint.cashierBranchInfo)
  Future<CashierBranchInfoResponse> getBranchInfo();

  @GET(ApiEndpoint.cashierMyInfo)
  Future<CashierInfoResponse> getCashierInfo();
}
