import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/brand_owner_branch_entity.dart';

sealed class BrandOwnerBranchesForFilterState extends Equatable {
  const BrandOwnerBranchesForFilterState();

  @override
  List<Object> get props => [];
}

final class BrandOwnerBranchesForFilterInit
    extends BrandOwnerBranchesForFilterState {
  const BrandOwnerBranchesForFilterInit();
}

final class BrandOwnerBranchesForFilterLoading
    extends BrandOwnerBranchesForFilterState {
  const BrandOwnerBranchesForFilterLoading();
}

final class BrandOwnerBranchesForFilterSuccess
    extends BrandOwnerBranchesForFilterState {
  final List<BrandOwnerBranchEntity> branches;

  const BrandOwnerBranchesForFilterSuccess(this.branches);

  @override
  List<Object> get props => [branches];
}

final class BrandOwnerBranchesForFilterFailure
    extends BrandOwnerBranchesForFilterState {
  final ApiFailure failure;

  const BrandOwnerBranchesForFilterFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
