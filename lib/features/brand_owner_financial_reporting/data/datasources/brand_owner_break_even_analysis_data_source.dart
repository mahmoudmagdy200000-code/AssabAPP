import '../models/brand_owner_break_even_analysis_model.dart';
import '../models/export_break_even_analysis_request.dart';

abstract class BrandOwnerBreakEvenAnalysisDataSource {
  Future<BreakEvenAnalysisModel> getBreakEvenAnalysis({
    int? year,
    int? month,
    String? branchId,
  });

  Future<String> exportBreakEvenAnalysis({
    required ExportBreakEvenAnalysisRequest request,
  });
}
