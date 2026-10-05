import 'package:injectable/injectable.dart';

import '../../../../core/utils/api_result.dart';
import '../entities/sales_channel_level2_entity.dart';
import '../repositories/brand_owner_sales_channel_level2_repository.dart';

@LazySingleton()
class GetSalesChannelLevel2UseCase {
  final BrandOwnerSalesChannelLevel2Repository _repository;

  GetSalesChannelLevel2UseCase(this._repository);

  Future<ApiResult<SalesChannelLevel2Entity>> call({
    int? year,
    int? month,
    int? comparedYear,
    int? comparedMonth,
    String? branchId,
  }) {
    return _repository.getSalesChannelLevel2(
      year: year,
      month: month,
      comparedYear: comparedYear,
      comparedMonth: comparedMonth,
      branchId: branchId,
    );
  }
}
