import 'package:assab/core/errors/api_failure.dart';
import 'package:assab/features/branch_manager_home/domain/entities/branch_manager_price_comparison_entity.dart';
import 'package:equatable/equatable.dart';

sealed class BranchManagerPriceComparisonState extends Equatable {
  const BranchManagerPriceComparisonState();

  @override
  List<Object?> get props => [];
}

final class BranchManagerPriceComparisonInit extends BranchManagerPriceComparisonState {
  const BranchManagerPriceComparisonInit();
}

final class BranchManagerPriceComparisonLoading extends BranchManagerPriceComparisonState {
  const BranchManagerPriceComparisonLoading();
}

final class BranchManagerPriceComparisonSuccess extends BranchManagerPriceComparisonState {
  final List<BranchManagerPriceComparisonEntity> comparisons;

  const BranchManagerPriceComparisonSuccess(this.comparisons);

  @override
  List<Object?> get props => [comparisons];
}

final class BranchManagerPriceComparisonFailure extends BranchManagerPriceComparisonState {
  final ApiFailure failure;

  const BranchManagerPriceComparisonFailure(this.failure);

  @override
  List<Object?> get props => [failure];
}
