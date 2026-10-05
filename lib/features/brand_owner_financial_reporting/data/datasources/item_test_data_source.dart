import '../models/item_test_result_model.dart';
import '../models/item_test_saved_test_model.dart';

abstract class ItemTestDataSource {
  Future<ItemTestResultModel> submitTest({
    required String branchId,
    required String branchName,
    required String itemName,
    required double expectedSellingPrice,
    required double productionCost,
    required int expectedSales,
    required double expectedGrowth,
  });

  Future<List<ItemTestSavedTestModel>> getSavedTests();

  Future<void> saveTest(ItemTestResultModel result);

  Future<String> exportTest({
    required String testId,
    required String formatType,
  });

  Future<void> emailTest({
    required String testId,
    required String email,
  });
}
