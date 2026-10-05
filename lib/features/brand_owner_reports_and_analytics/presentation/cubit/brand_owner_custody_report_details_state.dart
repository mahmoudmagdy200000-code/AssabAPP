import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/brand_owner_custody_report_details_entity.dart';

sealed class BrandOwnerCustodyReportDetailsState extends Equatable {
  const BrandOwnerCustodyReportDetailsState();

  @override
  List<Object> get props => [];
}

final class BrandOwnerCustodyReportDetailsInitial
    extends BrandOwnerCustodyReportDetailsState {
  const BrandOwnerCustodyReportDetailsInitial();
}

final class BrandOwnerCustodyReportDetailsLoading
    extends BrandOwnerCustodyReportDetailsState {
  const BrandOwnerCustodyReportDetailsLoading();
}

final class BrandOwnerCustodyReportDetailsSuccess
    extends BrandOwnerCustodyReportDetailsState {
  final BrandOwnerCustodyReportDetailsEntity data;

  const BrandOwnerCustodyReportDetailsSuccess(this.data);

  @override
  List<Object> get props => [data];
}

final class BrandOwnerCustodyReportDetailsFailure
    extends BrandOwnerCustodyReportDetailsState {
  final ApiFailure failure;

  const BrandOwnerCustodyReportDetailsFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
