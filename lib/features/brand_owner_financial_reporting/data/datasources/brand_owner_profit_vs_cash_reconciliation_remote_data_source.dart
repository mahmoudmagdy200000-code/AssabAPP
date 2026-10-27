import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../models/export_profit_vs_cash_reconciliation_request.dart';
import '../models/profit_vs_cash_reconciliation_model.dart';
import 'brand_owner_profit_vs_cash_reconciliation_data_source.dart';

class BrandOwnerProfitVsCashReconciliationRemoteDataSourceImpl
    implements BrandOwnerProfitVsCashReconciliationDataSource {
  final Dio _dio;
  final String baseUrl;

  BrandOwnerProfitVsCashReconciliationRemoteDataSourceImpl(
    this._dio, {
    String? baseUrl,
  }) : baseUrl =
           (baseUrl == null || baseUrl.trim().isEmpty)
               ? ''
               : ApiEndpoint.normalizeBaseUrl(baseUrl);

  @override
  Future<ProfitVsCashReconciliationModel>
  getProfitVsCashReconciliation() async {
    final response = await _dio.get(
      '$baseUrl${ApiEndpoint.brandOwnerFinancialProfitVsCashReconciliation}',
    );
    return ProfitVsCashReconciliationModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  @override
  Future<String> exportProfitVsCashReconciliation({
    required ExportProfitVsCashReconciliationRequest request,
  }) async {
    final response = await _dio.post(
      '$baseUrl${ApiEndpoint.brandOwnerFinancialProfitVsCashReconciliationExport}',
      data: request.toJson(),
    );
    return (response.data as Map<String, dynamic>)['data']['file_url']
        as String;
  }

  @override
  Future<void> emailProfitVsCashReconciliation({
    required ExportProfitVsCashReconciliationRequest request,
  }) async {
    await _dio.post(
      '$baseUrl${ApiEndpoint.brandOwnerFinancialProfitVsCashReconciliationEmail}',
      data: request.toJson(),
    );
  }
}
