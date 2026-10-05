part of 'fixed_assets_get_zone_and_type_cubit.dart';

sealed class FixedAssetsGetZoneAndTypeState extends Equatable {
  const FixedAssetsGetZoneAndTypeState();

  @override
  List<Object> get props => [];
}

final class FixedAssetsGetZoneAndTypeInitial
    extends FixedAssetsGetZoneAndTypeState {}

final class FixedAssetsGetZoneAndTypeLoading
    extends FixedAssetsGetZoneAndTypeState {}

final class FixedAssetsGetZoneSuccess extends FixedAssetsGetZoneAndTypeState {
  final FixedAssetsZonesResponse zones;

  const FixedAssetsGetZoneSuccess(this.zones);

  @override
  List<Object> get props => [zones];
}

final class FixedAssetsGetTypesSuccess extends FixedAssetsGetZoneAndTypeState {
  final FixedAssetsTypesResponse types;

  const FixedAssetsGetTypesSuccess(this.types);

  @override
  List<Object> get props => [types];
}

final class FixedAssetsGetResponsibleEmployeesSuccess
    extends FixedAssetsGetZoneAndTypeState {
  final FixedAssetsResponsibleEmployeeResponse employees;

  const FixedAssetsGetResponsibleEmployeesSuccess(this.employees);

  @override
  List<Object> get props => [employees];
}

final class FixedAssetsGetBranchesSuccess
    extends FixedAssetsGetZoneAndTypeState {
  final FixedAssetsBranchesResponse branches;

  const FixedAssetsGetBranchesSuccess(this.branches);

  @override
  List<Object> get props => [branches];
}

final class FixedAssetsGetAssetsSuccess extends FixedAssetsGetZoneAndTypeState {
  final FixedAssetsAllAssetsResponse assets;

  const FixedAssetsGetAssetsSuccess(this.assets);

  @override
  List<Object> get props => [assets];
}

final class FixedAssetsGetZoneAndTypeFailure
    extends FixedAssetsGetZoneAndTypeState {
  final ApiFailure failure;

  const FixedAssetsGetZoneAndTypeFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
