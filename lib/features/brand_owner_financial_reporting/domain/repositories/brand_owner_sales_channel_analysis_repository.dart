import '../../../../core/utils/future_api_result.dart';
import '../entities/sales_channel_analysis_entity.dart';

abstract class BrandOwnerSalesChannelAnalysisRepository {
  FutureApiResult<SalesChannelAnalysisEntity> getSalesChannelAnalysis({
    int? year,
    int? month,
    int? comparedYear,
    int? comparedMonth,
    required String? branchId,
  });

  FutureApiResult<String> exportSalesChannelAnalysis({
    required int year,
    required int month,
    required int comparedYear,
    required int comparedMonth,
    required String branchId,
    required String formatType,
  });

  FutureApiResult<void> emailSalesChannelAnalysis({
    required int year,
    required int month,
    required int comparedYear,
    required int comparedMonth,
    required String branchId,
    required String email,
  });
}
