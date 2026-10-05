import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/brand_owner_expense_report_details_entity.dart';

sealed class BrandOwnerExpenseReportDetailsState extends Equatable {
  const BrandOwnerExpenseReportDetailsState();

  @override
  List<Object> get props => [];
}

final class BrandOwnerExpenseReportDetailsInitial
    extends BrandOwnerExpenseReportDetailsState {
  const BrandOwnerExpenseReportDetailsInitial();
}

final class BrandOwnerExpenseReportDetailsLoading
    extends BrandOwnerExpenseReportDetailsState {
  const BrandOwnerExpenseReportDetailsLoading();
}

final class BrandOwnerExpenseReportDetailsSuccess
    extends BrandOwnerExpenseReportDetailsState {
  final BrandOwnerExpenseReportDetailsEntity data;

  const BrandOwnerExpenseReportDetailsSuccess(this.data);

  @override
  List<Object> get props => [data];
}

final class BrandOwnerExpenseReportDetailsFailure
    extends BrandOwnerExpenseReportDetailsState {
  final ApiFailure failure;

  const BrandOwnerExpenseReportDetailsFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
