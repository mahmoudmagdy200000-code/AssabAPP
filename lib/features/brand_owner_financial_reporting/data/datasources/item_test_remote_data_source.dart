import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../models/item_test_result_model.dart';
import '../models/item_test_saved_test_model.dart';
import 'item_test_data_source.dart';

class ItemTestRemoteDataSourceImpl implements ItemTestDataSource {
  final Dio _dio;
  final String baseUrl;

  ItemTestRemoteDataSourceImpl(
    this._dio, {
    String? baseUrl,
  }) : baseUrl =
           (baseUrl == null || baseUrl.trim().isEmpty)
               ? ''
               : ApiEndpoint.normalizeBaseUrl(baseUrl);

  @override
  Future<ItemTestResultModel> submitTest({
    required String branchId,
    required String branchName,
    required String itemName,
    required double expectedSellingPrice,
    required double productionCost,
    required int expectedSales,
    required double expectedGrowth,
  }) async {
    final response = await _dio.post(
      '$baseUrl${ApiEndpoint.brandOwnerFinancialItemTestSubmit}',
      data: {
        'branch_id': branchId,
        'item_name': itemName,
        'expected_selling_price': expectedSellingPrice,
        'production_cost': productionCost,
        'expected_sales': expectedSales,
        'expected_growth': expectedGrowth,
      },
    );
    return ItemTestResultModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<List<ItemTestSavedTestModel>> getSavedTests() async {
    final response = await _dio.get(
      '$baseUrl${ApiEndpoint.brandOwnerFinancialItemTestSavedTests}',
    );

    final items = (response.data['data'] as List<dynamic>? ?? []);

    return items
        .map((e) => ItemTestSavedTestModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> saveTest(ItemTestResultModel result) async {
    await _dio.post(
      '$baseUrl${ApiEndpoint.brandOwnerFinancialItemTestSubmit}',
      data: result.toJson(),
    );
  }

  @override
  Future<String> exportTest({
    required String testId,
    required String formatType,
  }) async {
    final response = await _dio.post(
      '$baseUrl${ApiEndpoint.brandOwnerFinancialItemTestExport}',
      data: {'test_id': testId, 'format_type': formatType},
    );
    return (response.data as Map<String, dynamic>)['data']['file_url']
        as String;
  }

  @override
  Future<void> emailTest({
    required String testId,
    required String email,
  }) async {
    await _dio.post(
      '$baseUrl${ApiEndpoint.brandOwnerFinancialItemTestEmail}',
      data: {'test_id': testId, 'email': email},
    );
  }
}
