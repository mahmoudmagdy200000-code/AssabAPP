import 'package:injectable/injectable.dart';

import '../../../../core/utils/api_result.dart';
import '../repositories/brand_owner_sales_channel_level2_repository.dart';

@LazySingleton()
class ExportSalesChannelLevel2UseCase {
  final BrandOwnerSalesChannelLevel2Repository _repository;

  ExportSalesChannelLevel2UseCase(this._repository);

  Future<ApiResult<String>> call({
    required int year,
    required int month,
    required int comparedYear,
    required int comparedMonth,
    String? branchId,
    required String formatType,
  }) {
    return _repository.exportSalesChannelLevel2(
      year: year,
      month: month,
      comparedYear: comparedYear,
      comparedMonth: comparedMonth,
      branchId: branchId,
      formatType: formatType,
    );
  }
}
