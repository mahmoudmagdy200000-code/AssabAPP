import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../models/brand_owner_menu_engineering_model.dart';
import '../models/export_menu_engineering_request.dart';
import 'brand_owner_menu_engineering_data_source.dart';

class BrandOwnerMenuEngineeringRemoteDataSourceImpl
    implements BrandOwnerMenuEngineeringDataSource {
  final Dio _dio;
  final String baseUrl;

  BrandOwnerMenuEngineeringRemoteDataSourceImpl(
    this._dio, {
    String? baseUrl,
  }) : baseUrl =
           (baseUrl == null || baseUrl.trim().isEmpty)
               ? ''
               : ApiEndpoint.normalizeBaseUrl(baseUrl);

  @override
  Future<MenuEngineeringModel> getMenuEngineering({
    int? year,
    int? month,
    int? comparedYear,
    int? comparedMonth,
    String? branchId,
  }) async {
    final queryParams = <String, dynamic>{};
    if (year != null) queryParams['year'] = year;
    if (month != null) queryParams['month'] = month;
    if (comparedYear != null) queryParams['compared_year'] = comparedYear;
    if (comparedMonth != null) queryParams['compared_month'] = comparedMonth;
    if (branchId != null) queryParams['branch_id'] = branchId;

    final response = await _dio.get(
      '$baseUrl${ApiEndpoint.brandOwnerFinancialMenuEngineering}',
      queryParameters: queryParams,
    );
    return MenuEngineeringModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<String> exportMenuEngineering({
    required ExportMenuEngineeringRequest request,
  }) async {
    final response = await _dio.post(
      '$baseUrl${ApiEndpoint.brandOwnerFinancialMenuEngineeringExport}',
      data: request.toJson(),
    );
    return (response.data as Map<String, dynamic>)['data']['file_url']
        as String;
  }

  @override
  Future<void> emailMenuEngineering({
    required ExportMenuEngineeringRequest request,
  }) async {
    await _dio.post(
      '$baseUrl${ApiEndpoint.brandOwnerFinancialMenuEngineeringEmail}',
      data: request.toJson(),
    );
  }
}
