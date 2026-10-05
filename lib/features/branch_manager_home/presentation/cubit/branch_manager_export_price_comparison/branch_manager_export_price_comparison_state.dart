import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

sealed class BranchManagerExportPriceComparisonState extends Equatable {
  const BranchManagerExportPriceComparisonState();

  @override
  List<Object?> get props => [];
}

final class BranchManagerExportPriceComparisonInit extends BranchManagerExportPriceComparisonState {
  const BranchManagerExportPriceComparisonInit();
}

final class BranchManagerExportPriceComparisonLoading extends BranchManagerExportPriceComparisonState {
  const BranchManagerExportPriceComparisonLoading();
}

final class BranchManagerExportPriceComparisonSuccess extends BranchManagerExportPriceComparisonState {
  final String fileUrl;

  const BranchManagerExportPriceComparisonSuccess(this.fileUrl);

  @override
  List<Object?> get props => [fileUrl];
}

final class BranchManagerExportPriceComparisonFailure extends BranchManagerExportPriceComparisonState {
  final ApiFailure failure;

  const BranchManagerExportPriceComparisonFailure(this.failure);

  @override
  List<Object?> get props => [failure];
}
