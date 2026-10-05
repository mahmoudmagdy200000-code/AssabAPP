import '../models/export_sales_channel_level2_request.dart';
import '../models/sales_channel_level2_model.dart';

abstract class BrandOwnerSalesChannelLevel2DataSource {
  Future<SalesChannelLevel2Model> getSalesChannelLevel2({
    int? year,
    int? month,
    int? comparedYear,
    int? comparedMonth,
    String? branchId,
  });

  Future<String> exportSalesChannelLevel2({
    required ExportSalesChannelLevel2Request request,
  });
}
