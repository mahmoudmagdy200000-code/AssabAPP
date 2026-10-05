import 'package:injectable/injectable.dart';

import '../../../../core/utils/api_result.dart';
import '../entities/item_test_result_entity.dart';
import '../repositories/item_test_repository.dart';

@LazySingleton()
class SubmitItemTestUseCase {
  final ItemTestRepository _repository;

  SubmitItemTestUseCase(this._repository);

  Future<ApiResult<ItemTestResultEntity>> call({
    required String branchId,
    required String branchName,
    required String itemName,
    required double expectedSellingPrice,
    required double productionCost,
    required int expectedSales,
    required double expectedGrowth,
  }) {
    return _repository.submitTest(
      branchId: branchId,
      branchName: branchName,
      itemName: itemName,
      expectedSellingPrice: expectedSellingPrice,
      productionCost: productionCost,
      expectedSales: expectedSales,
      expectedGrowth: expectedGrowth,
    );
  }
}
