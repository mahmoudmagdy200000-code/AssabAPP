import 'package:injectable/injectable.dart';

import '../../../../core/errors/repository_mixin.dart';
import '../../../../core/utils/future_api_result.dart';
import '../../domain/entities/sales_channel_level2_entity.dart';
import '../../domain/repositories/brand_owner_sales_channel_level2_repository.dart';
import '../datasources/brand_owner_sales_channel_level2_data_source.dart';
import '../models/export_sales_channel_level2_request.dart';

@LazySingleton(as: BrandOwnerSalesChannelLevel2Repository)
class BrandOwnerSalesChannelLevel2RepositoryImpl
    with RepositoryMixin
    implements BrandOwnerSalesChannelLevel2Repository {
  final BrandOwnerSalesChannelLevel2DataSource _dataSource;

  BrandOwnerSalesChannelLevel2RepositoryImpl(this._dataSource);

  @override
  FutureApiResult<SalesChannelLevel2Entity> getSalesChannelLevel2({
    int? year,
    int? month,
    int? comparedYear,
    int? comparedMonth,
    String? branchId,
  }) {
    return execute(() async {
      return await _dataSource.getSalesChannelLevel2(
        year: year,
        month: month,
        comparedYear: comparedYear,
        comparedMonth: comparedMonth,
        branchId: branchId,
      );
    });
  }

  @override
  FutureApiResult<String> exportSalesChannelLevel2({
    required int year,
    required int month,
    required int comparedYear,
    required int comparedMonth,
    String? branchId,
    required String formatType,
  }) {
    return execute(() async {
      return await _dataSource.exportSalesChannelLevel2(
        request: ExportSalesChannelLevel2Request(
          year: year,
          month: month,
          comparedYear: comparedYear,
          comparedMonth: comparedMonth,
          branchId: branchId,
          formatType: formatType,
        ),
      );
    });
  }
}
