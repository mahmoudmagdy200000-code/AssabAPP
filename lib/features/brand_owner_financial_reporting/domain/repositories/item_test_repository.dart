import '../../../../core/utils/future_api_result.dart';
import '../entities/item_test_result_entity.dart';
import '../entities/item_test_saved_test_entity.dart';

abstract class ItemTestRepository {
  FutureApiResult<ItemTestResultEntity> submitTest({
    required String branchId,
    required String branchName,
    required String itemName,
    required double expectedSellingPrice,
    required double productionCost,
    required int expectedSales,
    required double expectedGrowth,
  });

  FutureApiResult<List<ItemTestSavedTestEntity>> getSavedTests();

  FutureApiResult<void> saveTest(ItemTestResultEntity result);

  FutureApiResult<String> exportTest({
    required String testId,
    required String formatType,
  });

  FutureApiResult<void> emailTest({
    required String testId,
    required String email,
  });
}
