import 'package:injectable/injectable.dart';

import '../../../../core/errors/repository_mixin.dart';
import '../../../../core/utils/future_api_result.dart';
import '../../domain/entities/brand_owner_operational_profitability_entity.dart';
import '../../domain/repositories/brand_owner_operational_profitability_repository.dart';
import '../datasources/brand_owner_operational_profitability_data_source.dart';
import '../models/export_operational_profitability_request.dart';

@LazySingleton(as: BrandOwnerOperationalProfitabilityRepository)
class BrandOwnerOperationalProfitabilityRepositoryImpl
    with RepositoryMixin
    implements BrandOwnerOperationalProfitabilityRepository {
  final BrandOwnerOperationalProfitabilityDataSource _dataSource;

  BrandOwnerOperationalProfitabilityRepositoryImpl(this._dataSource);

  @override
  FutureApiResult<OperationalProfitabilityEntity>
      getOperationalProfitability() {
    return execute(() async {
      return await _dataSource.getOperationalProfitability();
    });
  }

  @override
  FutureApiResult<String> exportOperationalProfitability({
    required String formatType,
  }) {
    return execute(() async {
      return await _dataSource.exportOperationalProfitability(
        request: ExportOperationalProfitabilityRequest(
          formatType: formatType,
        ),
      );
    });
  }

  @override
  FutureApiResult<void> emailOperationalProfitability({
    required String email,
  }) {
    return execute(() async {
      return await _dataSource.emailOperationalProfitability(
        request: ExportOperationalProfitabilityRequest(
          formatType: 'pdf',
          email: email,
        ),
      );
    });
  }
}
