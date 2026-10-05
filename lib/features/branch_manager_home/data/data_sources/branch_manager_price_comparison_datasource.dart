import 'package:assab/core/enums/time_keys.dart';
import 'package:assab/core/network/api_endpoints.dart';
import 'package:assab/features/branch_manager_home/domain/entities/branch_manager_price_comparison_entity.dart';
import 'package:assab/features/purchase/data/models/compare_price_response.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../models/branch_manager_export_price_comparison_response.dart';
import '../models/branch_manager_price_comparison_model.dart';

part 'branch_manager_price_comparison_datasource.g.dart';

@RestApi(baseUrl: ApiEndpoint.baseUrl)
abstract class BranchManagerPriceComparisonRemoteClient {
  factory BranchManagerPriceComparisonRemoteClient(Dio dio, {String baseUrl}) =
      _BranchManagerPriceComparisonRemoteClient;

  @GET(ApiEndpoint.branchManagerPriceComparisons)
  Future<BranchManagerPriceComparisonModel> getSavedPriceComparisons({
    @Query('timeKey') String? timeKey,
    @Query('itemId') String? itemId,
    @Query('supplierId') String? supplierId,
    @Query('page') int? page,
  });

  @GET(ApiEndpoint.branchManagerPriceComparisonDetails)
  Future<PurchaseComparePriceResponse> getPriceComparisonDetails({
    @Path('comparisonId') required String comparisonId,
  });

  @GET(ApiEndpoint.branchManagerPriceComparisonExport)
  Future<BranchManagerExportPriceComparisonResponse> exportPriceComparison({
    @Path('comparisonId') required String comparisonId,
    @Query('formatType') required String formatType,
  });

  @POST(ApiEndpoint.branchManagerPriceComparisonCreateOrder)
  Future<void> createOrderWithRecommendedSource({
    @Path('comparisonId') required String comparisonId,
  });
}
