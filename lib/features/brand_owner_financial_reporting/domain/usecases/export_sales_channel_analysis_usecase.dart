import 'package:injectable/injectable.dart';

import '../../../../core/utils/api_result.dart';
import '../repositories/brand_owner_sales_channel_analysis_repository.dart';

@LazySingleton()
class ExportSalesChannelAnalysisUseCase {
  final BrandOwnerSalesChannelAnalysisRepository _repository;

  ExportSalesChannelAnalysisUseCase(this._repository);

  Future<ApiResult<String>> call({
    required int year,
    required int month,
    required int comparedYear,
    required int comparedMonth,
    required String branchId,
    required String formatType,
  }) {
    return _repository.exportSalesChannelAnalysis(
      year: year,
      month: month,
      comparedYear: comparedYear,
      comparedMonth: comparedMonth,
      branchId: branchId,
      formatType: formatType,
    );
  }

  Future<ApiResult<void>> emailReport({
    required int year,
    required int month,
    required int comparedYear,
    required int comparedMonth,
    required String branchId,
    required String email,
  }) {
    return _repository.emailSalesChannelAnalysis(
      year: year,
      month: month,
      comparedYear: comparedYear,
      comparedMonth: comparedMonth,
      branchId: branchId,
      email: email,
    );
  }
}
