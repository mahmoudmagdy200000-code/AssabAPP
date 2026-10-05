import 'package:injectable/injectable.dart';

import '../../../../core/utils/api_result.dart';
import '../entities/brand_owner_break_even_analysis_entity.dart';
import '../repositories/brand_owner_break_even_analysis_repository.dart';

@LazySingleton()
class GetBreakEvenAnalysisUseCase {
  final BrandOwnerBreakEvenAnalysisRepository _repository;

  GetBreakEvenAnalysisUseCase(this._repository);

  Future<ApiResult<BreakEvenAnalysisEntity>> call({
    int? year,
    int? month,
    required String branchId,
  }) {
    return _repository.getBreakEvenAnalysis(
      year: year,
      month: month,
      branchId: branchId,
    );
  }
}
