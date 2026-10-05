import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/brand_owner_reports_and_analytics_entity.dart';

sealed class BrandOwnerReportsAndAnalyticsState extends Equatable {
  const BrandOwnerReportsAndAnalyticsState();

  @override
  List<Object> get props => [];
}

final class BrandOwnerReportsAndAnalyticsInitial
    extends BrandOwnerReportsAndAnalyticsState {
  const BrandOwnerReportsAndAnalyticsInitial();
}

final class BrandOwnerReportsAndAnalyticsLoading
    extends BrandOwnerReportsAndAnalyticsState {
  const BrandOwnerReportsAndAnalyticsLoading();
}

final class BrandOwnerReportsAndAnalyticsSuccess
    extends BrandOwnerReportsAndAnalyticsState {
  final BrandOwnerReportsAndAnalyticsEntity data;

  const BrandOwnerReportsAndAnalyticsSuccess(this.data);

  @override
  List<Object> get props => [data];
}

final class BrandOwnerReportsAndAnalyticsFailure
    extends BrandOwnerReportsAndAnalyticsState {
  final ApiFailure failure;

  const BrandOwnerReportsAndAnalyticsFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
