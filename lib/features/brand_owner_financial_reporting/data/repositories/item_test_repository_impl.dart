import 'package:injectable/injectable.dart';

import '../../../../core/errors/repository_mixin.dart';
import '../../../../core/utils/future_api_result.dart';
import '../../domain/entities/item_test_result_entity.dart';
import '../../domain/entities/item_test_saved_test_entity.dart';
import '../../domain/repositories/item_test_repository.dart';
import '../datasources/item_test_data_source.dart';

@LazySingleton(as: ItemTestRepository)
class ItemTestRepositoryImpl
    with RepositoryMixin
    implements ItemTestRepository {
  final ItemTestDataSource _dataSource;

  ItemTestRepositoryImpl(this._dataSource);

  @override
  FutureApiResult<ItemTestResultEntity> submitTest({
    required String branchId,
    required String branchName,
    required String itemName,
    required double expectedSellingPrice,
    required double productionCost,
    required int expectedSales,
    required double expectedGrowth,
  }) {
    return execute(() async {
      return await _dataSource.submitTest(
        branchId: branchId,
        branchName: branchName,
        itemName: itemName,
        expectedSellingPrice: expectedSellingPrice,
        productionCost: productionCost,
        expectedSales: expectedSales,
        expectedGrowth: expectedGrowth,
      );
    });
  }

  @override
  FutureApiResult<List<ItemTestSavedTestEntity>> getSavedTests() {
    return execute(() async {
      return await _dataSource.getSavedTests();
    });
  }

  @override
  FutureApiResult<void> saveTest(ItemTestResultEntity result) {
    return execute(() async {
      return await _dataSource.saveTest(result as dynamic);
    });
  }

  @override
  FutureApiResult<String> exportTest({
    required String testId,
    required String formatType,
  }) {
    return execute(() async {
      return await _dataSource.exportTest(
        testId: testId,
        formatType: formatType,
      );
    });
  }

  @override
  FutureApiResult<void> emailTest({
    required String testId,
    required String email,
  }) {
    return execute(() async {
      return await _dataSource.emailTest(
        testId: testId,
        email: email,
      );
    });
  }
}
