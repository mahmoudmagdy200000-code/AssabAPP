import 'package:equatable/equatable.dart';

import '../../../../core/errors/api_failure.dart';
import '../../domain/entities/branch_manager_my_account_details_entity.dart';

sealed class BranchManagerMyAccountDetailsState extends Equatable {
  const BranchManagerMyAccountDetailsState();

  @override
  List<Object> get props => [];
}

final class BranchManagerMyAccountDetailsInitial
    extends BranchManagerMyAccountDetailsState {
  const BranchManagerMyAccountDetailsInitial();
}

final class BranchManagerMyAccountDetailsLoading
    extends BranchManagerMyAccountDetailsState {
  const BranchManagerMyAccountDetailsLoading();
}

final class BranchManagerMyAccountDetailsLoaded
    extends BranchManagerMyAccountDetailsState {
  final BranchManagerMyAccountDetailsEntity data;

  const BranchManagerMyAccountDetailsLoaded(this.data);

  @override
  List<Object> get props => [data];
}

final class BranchManagerMyAccountDetailsFailure
    extends BranchManagerMyAccountDetailsState {
  final ApiFailure failure;

  const BranchManagerMyAccountDetailsFailure(this.failure);

  @override
  List<Object> get props => [failure];
}