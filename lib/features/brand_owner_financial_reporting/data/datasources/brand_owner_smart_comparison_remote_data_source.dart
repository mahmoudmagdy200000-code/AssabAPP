import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../domain/enums/brand_owner_smart_compare_type_enum.dart';
import '../models/export_smart_comparison_request.dart';
import '../models/smart_comparison_model.dart';
import 'brand_owner_smart_comparison_data_source.dart';

class BrandOwnerSmartComparisonRemoteDataSourceImpl
    implements BrandOwnerSmartComparisonDataSource {
  final Dio _dio;
  final String baseUrl;

  BrandOwnerSmartComparisonRemoteDataSourceImpl(
    this._dio, {
    this.baseUrl = ApiEndpoint.baseUrl,
  });

  @override
  Future<SmartComparisonModel> getSmartComparison({
    int? year,
    int? month,
    int? comparedYear,
    int? comparedMonth,
    required BrandOwnerSmartCompareTypeEnum type,
    String? branchId,
    String? comparedBranchId,
  }) async {
    final queryParams = <String, dynamic>{'type': type.value};
    if (year != null) queryParams['year'] = year;
    if (month != null) queryParams['month'] = month;
    if (comparedYear != null) queryParams['compared_year'] = comparedYear;
    if (comparedMonth != null) queryParams['compared_month'] = comparedMonth;
    if (branchId != null) queryParams['branch_id'] = branchId;
    if (comparedBranchId != null) {
      queryParams['compared_branch_id'] = comparedBranchId;
    }

    final response = await _dio.get(
      '$baseUrl${ApiEndpoint.brandOwnerFinancialSmartComparison}',
      queryParameters: queryParams,
    );
    return SmartComparisonModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<String> exportSmartComparison({
    required ExportSmartComparisonRequest request,
  }) async {
    final response = await _dio.post(
      '$baseUrl${ApiEndpoint.brandOwnerFinancialSmartComparisonExport}',
      data: request.toJson(),
    );
    return (response.data as Map<String, dynamic>)['data']['file_url']
        as String;
  }

  @override
  Future<void> emailSmartComparison({
    required ExportSmartComparisonRequest request,
  }) async {
    await _dio.post(
      '$baseUrl${ApiEndpoint.brandOwnerFinancialSmartComparisonEmail}',
      data: request.toJson(),
    );
  }
}
