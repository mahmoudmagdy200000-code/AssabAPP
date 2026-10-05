import '../../../../core/utils/future_api_result.dart';
import '../entities/sales_channel_level2_entity.dart';

abstract class BrandOwnerSalesChannelLevel2Repository {
  FutureApiResult<SalesChannelLevel2Entity> getSalesChannelLevel2({
    int? year,
    int? month,
    int? comparedYear,
    int? comparedMonth,
    String? branchId,
  });

  FutureApiResult<String> exportSalesChannelLevel2({
    required int year,
    required int month,
    required int comparedYear,
    required int comparedMonth,
    String? branchId,
    required String formatType,
  });
}
