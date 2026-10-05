import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../models/brand_owner_break_even_analysis_model.dart';
import '../models/export_break_even_analysis_request.dart';
import 'brand_owner_break_even_analysis_data_source.dart';

class BrandOwnerBreakEvenAnalysisRemoteDataSourceImpl
    implements BrandOwnerBreakEvenAnalysisDataSource {
  final Dio _dio;
  final String baseUrl;

  BrandOwnerBreakEvenAnalysisRemoteDataSourceImpl(
    this._dio, {
    this.baseUrl = ApiEndpoint.baseUrl,
  });

  @override
  Future<BreakEvenAnalysisModel> getBreakEvenAnalysis({
    int? year,
    int? month,
    String? branchId,
  }) async {
    final queryParams = <String, dynamic>{};
    if (year != null) queryParams['year'] = year;
    if (month != null) queryParams['month'] = month;
    if (branchId != null) queryParams['branch_id'] = branchId;

    final response = await _dio.get(
      '$baseUrl${ApiEndpoint.brandOwnerFinancialBreakEvenAnalysis}',
      queryParameters: queryParams,
    );

    return BreakEvenAnalysisModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  @override
  Future<String> exportBreakEvenAnalysis({
    required ExportBreakEvenAnalysisRequest request,
  }) async {
    final response = await _dio.post(
      '$baseUrl${ApiEndpoint.brandOwnerFinancialBreakEvenAnalysisExport}',
      data: request.toJson(),
    );
    return (response.data as Map<String, dynamic>)['data']['file_url']
        as String;
  }
}
