import 'package:equatable/equatable.dart';

import '../../../../core/errors/api_failure.dart';
import '../../domain/entities/branch_manager_setting_and_aggregators_entity.dart';

sealed class BranchManagerSettingAndAggregatorsState extends Equatable {
  const BranchManagerSettingAndAggregatorsState();

  @override
  List<Object> get props => [];
}

final class BranchManagerSettingAndAggregatorsInitial
    extends BranchManagerSettingAndAggregatorsState {
  const BranchManagerSettingAndAggregatorsInitial();
}

final class BranchManagerSettingAndAggregatorsLoading
    extends BranchManagerSettingAndAggregatorsState {
  const BranchManagerSettingAndAggregatorsLoading();
}

final class BranchManagerSettingAndAggregatorsLoaded
    extends BranchManagerSettingAndAggregatorsState {
  final BranchManagerSettingAndAggregatorsEntity data;

  const BranchManagerSettingAndAggregatorsLoaded(this.data);

  @override
  List<Object> get props => [data];
}

final class BranchManagerSettingAndAggregatorsFailure
    extends BranchManagerSettingAndAggregatorsState {
  final ApiFailure failure;

  const BranchManagerSettingAndAggregatorsFailure(this.failure);

  @override
  List<Object> get props => [failure];
}