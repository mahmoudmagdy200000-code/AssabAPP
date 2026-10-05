import 'package:assab/core/errors/api_failure.dart';
import 'package:assab/features/purchase/data/models/compare_price_response.dart';
import 'package:equatable/equatable.dart';

sealed class BranchManagerPriceComparisonDetailsState extends Equatable {
  const BranchManagerPriceComparisonDetailsState();

  @override
  List<Object?> get props => [];
}

final class BranchManagerPriceComparisonDetailsInit extends BranchManagerPriceComparisonDetailsState {
  const BranchManagerPriceComparisonDetailsInit();
}

final class BranchManagerPriceComparisonDetailsLoading extends BranchManagerPriceComparisonDetailsState {
  const BranchManagerPriceComparisonDetailsLoading();
}

final class BranchManagerPriceComparisonDetailsSuccess extends BranchManagerPriceComparisonDetailsState {
  final PurchaseComparePriceResponse response;

  const BranchManagerPriceComparisonDetailsSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

final class BranchManagerPriceComparisonDetailsFailure extends BranchManagerPriceComparisonDetailsState {
  final ApiFailure failure;

  const BranchManagerPriceComparisonDetailsFailure(this.failure);

  @override
  List<Object?> get props => [failure];
}
