import 'package:injectable/injectable.dart';

import '../../../../core/utils/api_result.dart';
import '../repositories/brand_owner_break_even_analysis_repository.dart';

@LazySingleton()
class ExportBreakEvenAnalysisUseCase {
  final BrandOwnerBreakEvenAnalysisRepository _repository;

  ExportBreakEvenAnalysisUseCase(this._repository);

  Future<ApiResult<String>> call({
    required int year,
    required int month,
    required String branchId,
    required String formatType,
  }) {
    return _repository.exportBreakEvenAnalysis(
      year: year,
      month: month,
      branchId: branchId,
      formatType: formatType,
    );
  }
}
