import '../../../../core/utils/future_api_result.dart';
import '../entities/brand_owner_break_even_analysis_entity.dart';

abstract class BrandOwnerBreakEvenAnalysisRepository {
  FutureApiResult<BreakEvenAnalysisEntity> getBreakEvenAnalysis({
    int? year,
    int? month,
    required String branchId,
  });

  FutureApiResult<String> exportBreakEvenAnalysis({
    required int year,
    required int month,
    required String branchId,
    required String formatType,
  });
}
