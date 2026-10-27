import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../models/brand_owner_operational_profitability_model.dart';
import '../models/export_operational_profitability_request.dart';
import 'brand_owner_operational_profitability_data_source.dart';

class BrandOwnerOperationalProfitabilityRemoteDataSourceImpl
    implements BrandOwnerOperationalProfitabilityDataSource {
  final Dio _dio;
  final String baseUrl;

  BrandOwnerOperationalProfitabilityRemoteDataSourceImpl(
    this._dio, {
    String? baseUrl,
  }) : baseUrl =
           (baseUrl == null || baseUrl.trim().isEmpty)
               ? ''
               : ApiEndpoint.normalizeBaseUrl(baseUrl);

  @override
  Future<OperationalProfitabilityModel> getOperationalProfitability() async {
    final response = await _dio.get(
      '$baseUrl${ApiEndpoint.brandOwnerFinancialOperationalProfitability}',
    );
    return OperationalProfitabilityModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  @override
  Future<String> exportOperationalProfitability({
    required ExportOperationalProfitabilityRequest request,
  }) async {
    final response = await _dio.post(
      '$baseUrl${ApiEndpoint.brandOwnerFinancialOperationalProfitabilityExport}',
      data: request.toJson(),
    );
    return (response.data as Map<String, dynamic>)['data']['file_url']
        as String;
  }

  @override
  Future<void> emailOperationalProfitability({
    required ExportOperationalProfitabilityRequest request,
  }) async {
    await _dio.post(
      '$baseUrl${ApiEndpoint.brandOwnerFinancialOperationalProfitabilityEmail}',
      data: request.toJson(),
    );
  }
}
