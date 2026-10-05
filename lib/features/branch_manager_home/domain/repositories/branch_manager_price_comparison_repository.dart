import 'package:assab/core/enums/time_keys.dart';
import 'package:assab/core/utils/future_api_result.dart';
import 'package:assab/features/branch_manager_home/domain/entities/branch_manager_price_comparison_entity.dart';
import 'package:assab/features/purchase/data/models/compare_price_response.dart';

abstract class BranchManagerPriceComparisonRepository {
  FutureApiResult<List<BranchManagerPriceComparisonEntity>>
  getSavedPriceComparisons({
    TimeKeys? timeKey,
    String? itemId,
    String? supplierId,
  });

  FutureApiResult<PurchaseComparePriceResponse> getPriceComparisonDetails({
    required String comparisonId,
  });

  FutureApiResult<String> exportPriceComparison({
    required String comparisonId,
    required String formatType,
  });

  FutureApiResult<void> createOrderWithRecommendedSource({required String id});
}
