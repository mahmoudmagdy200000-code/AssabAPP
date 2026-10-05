import '../models/export_sales_channel_analysis_request.dart';
import '../models/sales_channel_analysis_model.dart';

abstract class BrandOwnerSalesChannelAnalysisDataSource {
  Future<SalesChannelAnalysisModel> getSalesChannelAnalysis({
    int? year,
    int? month,
    int? comparedYear,
    int? comparedMonth,
    String? branchId,
  });

  Future<String> exportSalesChannelAnalysis({
    required ExportSalesChannelAnalysisRequest request,
  });

  Future<void> emailSalesChannelAnalysis({
    required ExportSalesChannelAnalysisRequest request,
  });
}
