import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../models/export_sales_channel_analysis_request.dart';
import '../models/sales_channel_analysis_model.dart';
import 'brand_owner_sales_channel_analysis_data_source.dart';

class BrandOwnerSalesChannelAnalysisRemoteDataSourceImpl
    implements BrandOwnerSalesChannelAnalysisDataSource {
  final Dio _dio;
  final String baseUrl;

  BrandOwnerSalesChannelAnalysisRemoteDataSourceImpl(
    this._dio, {
    this.baseUrl = ApiEndpoint.baseUrl,
  });

  @override
  Future<SalesChannelAnalysisModel> getSalesChannelAnalysis({
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
      '$baseUrl${ApiEndpoint.brandOwnerFinancialSalesChannelAnalysis}',
      queryParameters: queryParams,
    );
    return SalesChannelAnalysisModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  @override
  Future<String> exportSalesChannelAnalysis({
    required ExportSalesChannelAnalysisRequest request,
  }) async {
    final response = await _dio.post(
      '$baseUrl${ApiEndpoint.brandOwnerFinancialSalesChannelAnalysisExport}',
      data: request.toJson(),
    );
    return (response.data as Map<String, dynamic>)['data']['file_url']
        as String;
  }

  @override
  Future<void> emailSalesChannelAnalysis({
    required ExportSalesChannelAnalysisRequest request,
  }) async {
    await _dio.post(
      '$baseUrl${ApiEndpoint.brandOwnerFinancialSalesChannelAnalysisEmail}',
      data: request.toJson(),
    );
  }
}
