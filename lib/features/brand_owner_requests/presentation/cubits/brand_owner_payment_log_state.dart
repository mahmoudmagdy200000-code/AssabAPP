import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../../../shared/models/meta_model/meta_model.dart';
import '../../data/models/brand_owner_requests_models.dart';

sealed class BrandOwnerPaymentLogState extends Equatable {
  const BrandOwnerPaymentLogState();

  @override
  List<Object> get props => [];
}

final class BrandOwnerPaymentLogInitial extends BrandOwnerPaymentLogState {
  const BrandOwnerPaymentLogInitial();
}

final class BrandOwnerPaymentLogLoading extends BrandOwnerPaymentLogState {
  const BrandOwnerPaymentLogLoading();
}

/// Normal success – full list available, no active fetch.
final class BrandOwnerPaymentLogSuccess extends BrandOwnerPaymentLogState {
  final List<BrandOwnerPaymentLogItemModel> items;
  final BrandOwnerPaymentLogSummaryModel summary;
  final MetaModel meta;
  final bool hasMore;

  const BrandOwnerPaymentLogSuccess({
    required this.items,
    required this.summary,
    required this.meta,
    required this.hasMore,
  });

  @override
  List<Object> get props => [items, summary, meta, hasMore];
}

/// Emitted while fetching the next page; carries the existing list
/// so the UI keeps rendering it while the spinner shows at the bottom.
final class BrandOwnerPaymentLogPaginating extends BrandOwnerPaymentLogState {
  final List<BrandOwnerPaymentLogItemModel> items;
  final BrandOwnerPaymentLogSummaryModel summary;
  final MetaModel meta;

  const BrandOwnerPaymentLogPaginating({
    required this.items,
    required this.summary,
    required this.meta,
  });

  @override
  List<Object> get props => [items, summary, meta];
}

final class BrandOwnerPaymentLogDetailsSuccess
    extends BrandOwnerPaymentLogState {
  final BrandOwnerPaymentLogDetailsModel details;

  const BrandOwnerPaymentLogDetailsSuccess(this.details);

  @override
  List<Object> get props => [details];
}

final class BrandOwnerPaymentLogBranchesSuccess
    extends BrandOwnerPaymentLogState {
  final List<BrandOwnerPaymentLogBranchItem> branches;

  const BrandOwnerPaymentLogBranchesSuccess(this.branches);

  @override
  List<Object> get props => [branches];
}

final class BrandOwnerPaymentLogFailure extends BrandOwnerPaymentLogState {
  final ApiFailure failure;

  const BrandOwnerPaymentLogFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
