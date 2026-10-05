import 'package:assab/core/enums/time_keys.dart';
import 'package:assab/core/errors/repository_mixin.dart';
import 'package:assab/core/utils/future_api_result.dart';
import 'package:assab/features/branch_manager_home/domain/entities/branch_manager_price_comparison_entity.dart';
import 'package:assab/features/branch_manager_home/domain/repositories/branch_manager_price_comparison_repository.dart';
import 'package:assab/features/purchase/data/models/compare_price_response.dart';
import 'package:assab/features/branch_manager_home/data/data_sources/branch_manager_price_comparison_datasource.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: BranchManagerPriceComparisonRepository)
class BranchManagerPriceComparisonRepositoryImpl
    with RepositoryMixin
    implements BranchManagerPriceComparisonRepository {
  final BranchManagerPriceComparisonRemoteClient _dataSource;

  BranchManagerPriceComparisonRepositoryImpl(this._dataSource);
  @override
  FutureApiResult<List<BranchManagerPriceComparisonEntity>>
  getSavedPriceComparisons({
    TimeKeys? timeKey,
    String? itemId,
    String? supplierId,
    int? page,
  }) {
    return execute(() async {
      final response = await _dataSource.getSavedPriceComparisons(
        timeKey: timeKey?.key,
        itemId: itemId,
        supplierId: supplierId,
        page: page,
      );

      return response.comparisons.map((e) => e).toList();
    });
  }

  @override
  FutureApiResult<PurchaseComparePriceResponse> getPriceComparisonDetails({
    required String comparisonId,
  }) {
    return execute(() async {
      return await _dataSource.getPriceComparisonDetails(
        comparisonId: comparisonId,
      );
    });
  }

  @override
  FutureApiResult<String> exportPriceComparison({
    required String comparisonId,
    required String formatType,
  }) {
    return execute(() async {
      final response = await _dataSource.exportPriceComparison(
        comparisonId: comparisonId,
        formatType: formatType,
      );

      return response.url;
    });
  }

  @override
  FutureApiResult<void> createOrderWithRecommendedSource({required String id}) {
    return execute(() async {
      return await _dataSource.createOrderWithRecommendedSource(
        comparisonId: id,
      );
    });
  }
}
