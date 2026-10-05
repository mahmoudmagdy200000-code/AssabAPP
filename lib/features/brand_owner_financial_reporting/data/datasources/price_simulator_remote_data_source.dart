import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../models/price_simulator_item_info_model.dart';
import '../models/price_simulator_item_model.dart';
import '../models/price_simulator_saved_scenario_model.dart';
import '../models/price_simulator_simulation_result_model.dart';
import 'price_simulator_data_source.dart';

class PriceSimulatorRemoteDataSourceImpl implements PriceSimulatorDataSource {
  final Dio _dio;
  final String baseUrl;

  PriceSimulatorRemoteDataSourceImpl(
    this._dio, {
    this.baseUrl = ApiEndpoint.baseUrl,
  });

  @override
  Future<List<PriceSimulatorItemModel>> getItems() async {
    final response = await _dio.get(
      '$baseUrl${ApiEndpoint.brandOwnerFinancialPriceSimulatorItems}',
    );
    final data = response.data;
    if (data is List) {
      return data
          .map(
            (e) => PriceSimulatorItemModel.fromJson(e as Map<String, dynamic>),
          )
          .toList();
    }
    if (data is Map<String, dynamic>) {
      final items = (data['data'] ?? data['items'] ?? []) as List<dynamic>;
      return items
          .map(
            (e) => PriceSimulatorItemModel.fromJson(e as Map<String, dynamic>),
          )
          .toList();
    }
    return [];
  }

  @override
  Future<PriceSimulatorItemInfoModel> getItemInfo({
    required String branchId,
    required String itemId,
  }) async {
    final response = await _dio.get(
      '$baseUrl${ApiEndpoint.brandOwnerFinancialPriceSimulatorItemInfo}',
      queryParameters: {'branch_id': branchId, 'item_id': itemId},
    );
    return PriceSimulatorItemInfoModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  @override
  Future<PriceSimulatorSimulationResultModel> submitSimulation({
    required String branchId,
    required String itemId,
    required double changePrice,
    required double expectedGrowthDecline,
  }) async {
    final response = await _dio.post(
      '$baseUrl${ApiEndpoint.brandOwnerFinancialPriceSimulatorSimulate}',
      data: {
        'branch_id': branchId,
        'item_id': itemId,
        'change_price': changePrice,
        'expected_growth_decline': expectedGrowthDecline,
      },
    );
    return PriceSimulatorSimulationResultModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  @override
  Future<List<PriceSimulatorSavedScenarioModel>> getSavedScenarios() async {
    final response = await _dio.get(
      '$baseUrl${ApiEndpoint.brandOwnerFinancialPriceSimulatorSavedScenarios}',
    );
    final data = response.data;
    final dataMap = data['data'];
    if (dataMap is List) {
      return dataMap
          .map(
            (e) => PriceSimulatorSavedScenarioModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList();
    }
    if (data is Map<String, dynamic>) {
      final items = (data['data'] ?? data['scenarios'] ?? []) as List<dynamic>;
      return items
          .map(
            (e) => PriceSimulatorSavedScenarioModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList();
    }
    return [];
  }

  @override
  Future<void> saveScenario({
    required String branchId,
    required String itemId,
    required double changePrice,
    required double expectedGrowthDecline,
  }) async {
    await _dio.post(
      '$baseUrl${ApiEndpoint.brandOwnerFinancialPriceSimulatorSimulate}',
      data: {
        'branch_id': branchId,
        'item_id': itemId,
        'change_price': changePrice,
        'expected_growth_decline': expectedGrowthDecline,
      },
    );
  }

  @override
  Future<String> exportScenario({
    required String scenarioId,
    required String formatType,
  }) async {
    final response = await _dio.post(
      '$baseUrl${ApiEndpoint.brandOwnerFinancialPriceSimulatorExport}',
      data: {'scenario_id': scenarioId, 'format_type': formatType},
    );
    return (response.data as Map<String, dynamic>)['data']['file_url']
        as String;
  }

  @override
  Future<void> emailScenario({
    required String scenarioId,
    required String email,
  }) async {
    await _dio.post(
      '$baseUrl${ApiEndpoint.brandOwnerFinancialPriceSimulatorEmail}',
      data: {'scenario_id': scenarioId, 'email': email},
    );
  }
}
