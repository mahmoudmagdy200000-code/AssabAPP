import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../models/export_sales_channel_level2_request.dart';
import '../models/sales_channel_level2_model.dart';
import 'brand_owner_sales_channel_level2_data_source.dart';

class BrandOwnerSalesChannelLevel2RemoteDataSourceImpl
    implements BrandOwnerSalesChannelLevel2DataSource {
  final Dio _dio;
  final String baseUrl;

  BrandOwnerSalesChannelLevel2RemoteDataSourceImpl(
    this._dio, {
    String? baseUrl,
  }) : baseUrl =
           (baseUrl == null || baseUrl.trim().isEmpty)
               ? ''
               : ApiEndpoint.normalizeBaseUrl(baseUrl);

  @override
  Future<SalesChannelLevel2Model> getSalesChannelLevel2({
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
      '$baseUrl${ApiEndpoint.brandOwnerFinancialSalesChannelLevel2}',
      queryParameters: queryParams,
    );
    return SalesChannelLevel2Model.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  @override
  Future<String> exportSalesChannelLevel2({
    required ExportSalesChannelLevel2Request request,
  }) async {
    final response = await _dio.post(
      '$baseUrl${ApiEndpoint.brandOwnerFinancialSalesChannelLevel2Export}',
      data: request.toJson(),
    );
    return (response.data as Map<String, dynamic>)['data']['file_url']
        as String;
  }
}
