import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/brand_owner_branch_model.dart';

sealed class BrandOwnerBranchesState extends Equatable {
  const BrandOwnerBranchesState();

  @override
  List<Object?> get props => [];
}

final class BrandOwnerBranchesInit extends BrandOwnerBranchesState {
  const BrandOwnerBranchesInit();
}

final class BrandOwnerBranchesLoading extends BrandOwnerBranchesState {
  const BrandOwnerBranchesLoading();
}

final class BrandOwnerBranchesSuccess extends BrandOwnerBranchesState {
  final List<BrandOwnerBranchItemDashboard> branches;

  const BrandOwnerBranchesSuccess(this.branches);

  @override
  List<Object?> get props => [branches];
}

final class BrandOwnerBranchesFailure extends BrandOwnerBranchesState {
  final ApiFailure failure;

  const BrandOwnerBranchesFailure(this.failure);

  @override
  List<Object?> get props => [failure];
}
