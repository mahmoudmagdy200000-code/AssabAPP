import 'package:injectable/injectable.dart';

import '../../../../core/utils/api_result.dart';
import '../entities/sales_channel_analysis_entity.dart';
import '../repositories/brand_owner_sales_channel_analysis_repository.dart';

@LazySingleton()
class GetSalesChannelAnalysisUseCase {
  final BrandOwnerSalesChannelAnalysisRepository _repository;

  GetSalesChannelAnalysisUseCase(this._repository);

  Future<ApiResult<SalesChannelAnalysisEntity>> call({
    int? year,
    int? month,
    int? comparedYear,
    int? comparedMonth,
    required String? branchId,
  }) {
    return _repository.getSalesChannelAnalysis(
      year: year,
      month: month,
      comparedYear: comparedYear,
      comparedMonth: comparedMonth,
      branchId: branchId,
    );
  }
}
