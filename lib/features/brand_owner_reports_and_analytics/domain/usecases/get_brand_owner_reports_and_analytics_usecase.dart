import 'package:injectable/injectable.dart';

import '../../../../core/utils/api_result.dart';
import '../entities/brand_owner_reports_and_analytics_entity.dart';
import '../repositories/brand_owner_reports_and_analytics_repository.dart';

@LazySingleton()
class GetBrandOwnerReportsAndAnalyticsUseCase {
  final BrandOwnerReportsAndAnalyticsRepository _repository;

  GetBrandOwnerReportsAndAnalyticsUseCase(this._repository);

  Future<ApiResult<BrandOwnerReportsAndAnalyticsEntity>> call() {
    return _repository.getReportsAndAnalytics();
  }
}
