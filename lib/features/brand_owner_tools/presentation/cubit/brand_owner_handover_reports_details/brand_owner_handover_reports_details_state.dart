import 'package:assab/core/errors/api_failure.dart';

import '../../../data/models/brand_owner_fixed_assets_handover_report_details_response.dart';

sealed class BrandOwnerHandoverReportsDetailsState {
  const BrandOwnerHandoverReportsDetailsState();
}

final class BrandOwnerHandoverReportsDetailsInitial
    extends BrandOwnerHandoverReportsDetailsState {
  const BrandOwnerHandoverReportsDetailsInitial();
}

final class BrandOwnerHandoverReportsDetailsLoading
    extends BrandOwnerHandoverReportsDetailsState {
  const BrandOwnerHandoverReportsDetailsLoading();
}

final class BrandOwnerHandoverReportsDetailsSuccess
    extends BrandOwnerHandoverReportsDetailsState {
  final BrandOwnerFixedAssetsHandoverReportDetailsResponse details;

  const BrandOwnerHandoverReportsDetailsSuccess(this.details);
}

final class BrandOwnerHandoverReportsDetailsFailure
    extends BrandOwnerHandoverReportsDetailsState {
  final ApiFailure failure;

  const BrandOwnerHandoverReportsDetailsFailure(this.failure);
}

final class BrandOwnerHandoverReportsDetailsActionLoading
    extends BrandOwnerHandoverReportsDetailsState {
  final BrandOwnerFixedAssetsHandoverReportDetailsResponse details;
  final bool isSalaryDeduction;

  const BrandOwnerHandoverReportsDetailsActionLoading(
    this.details,
    this.isSalaryDeduction,
  );
}

final class BrandOwnerHandoverReportsDetailsActionSuccess
    extends BrandOwnerHandoverReportsDetailsState {
  final BrandOwnerFixedAssetsHandoverReportDetailsResponse details;
  final bool isSalaryDeduction;

  const BrandOwnerHandoverReportsDetailsActionSuccess(
    this.details,
    this.isSalaryDeduction,
  );
}

final class BrandOwnerHandoverReportsDetailsActionFailure
    extends BrandOwnerHandoverReportsDetailsState {
  final BrandOwnerFixedAssetsHandoverReportDetailsResponse details;
  final ApiFailure failure;
  final bool isSalaryDeduction;

  const BrandOwnerHandoverReportsDetailsActionFailure(
    this.details,
    this.failure,
    this.isSalaryDeduction,
  );
}
