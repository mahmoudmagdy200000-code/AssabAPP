import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../models/brand_owner_branch_model.dart';
import '../models/export_profit_and_loss_request.dart';
import '../models/profit_and_loss_statement_model.dart';
import 'brand_owner_profit_and_loss_statement_data_source.dart';

class BrandOwnerProfitAndLossStatementRemoteDataSourceImpl
    implements BrandOwnerProfitAndLossStatementDataSource {
  final Dio _dio;
  final String baseUrl;

  BrandOwnerProfitAndLossStatementRemoteDataSourceImpl(
    this._dio, {
    String? baseUrl,
  }) : baseUrl =
           (baseUrl == null || baseUrl.trim().isEmpty)
               ? ''
               : ApiEndpoint.normalizeBaseUrl(baseUrl);

  @override
  Future<ProfitAndLossStatementModel> getProfitAndLossStatement({
    int? year,
    int? month,
    String? branchId,
  }) async {
    final queryParams = <String, dynamic>{};
    if (year != null) queryParams['year'] = year;
    if (month != null) queryParams['month'] = month;
    if (branchId != null) queryParams['branch_id'] = branchId;

    final response = await _dio.get(
      '$baseUrl${ApiEndpoint.brandOwnerFinancialProfitAndLoss}',
      queryParameters: queryParams,
    );
    return ProfitAndLossStatementModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  @override
  Future<String> exportProfitAndLossStatement({
    required ExportProfitAndLossRequest request,
  }) async {
    final response = await _dio.post(
      '$baseUrl${ApiEndpoint.brandOwnerFinancialProfitAndLossExport}',
      data: request.toJson(),
    );
    return (response.data as Map<String, dynamic>)['data']['file_url']
        as String;
  }

  @override
  Future<void> emailProfitAndLossStatement({
    required ExportProfitAndLossRequest request,
  }) async {
    await _dio.post(
      '$baseUrl${ApiEndpoint.brandOwnerFinancialProfitAndLossEmail}',
      data: request.toJson(),
    );
  }

  @override
  Future<List<BrandOwnerBranchModel>> getBranches() async {
    final response = await _dio.get(
      '$baseUrl${ApiEndpoint.brandOwnerBranches}',
    );
    final data = response.data as Map<String, dynamic>;
    final dataMap = data['data'] as Map<String, dynamic>?;
    final branches = (dataMap?['branches'] as List<dynamic>? ?? []);
    return branches
        .map((e) => BrandOwnerBranchModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
