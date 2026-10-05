import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/models/fixed_assets_all_assets_response.dart';
import '../../../data/models/fixed_assets_branches_response.dart';
import '../../../data/models/fixed_assets_responsible_employee_response.dart';
import '../../../data/models/fixed_assets_types_response.dart';
import '../../../data/models/fixed_assets_zones_response.dart';
import '../../../data/repositories/fixed_assets_repository.dart';

part 'fixed_assets_get_zone_and_type_state.dart';

@injectable
class FixedAssetsGetZoneAndTypeCubit
    extends SafeCubit<FixedAssetsGetZoneAndTypeState> {
  final FixedAssetsRepository _repository;

  FixedAssetsGetZoneAndTypeCubit(this._repository)
    : super(FixedAssetsGetZoneAndTypeInitial());

  Future<void> getZones() async {
    emit(FixedAssetsGetZoneAndTypeLoading());

    final result = await _repository.getZonesAssets();

    handle(
      result,
      success: (data) => emit(FixedAssetsGetZoneSuccess(data)),
      failure: (failure) => emit(FixedAssetsGetZoneAndTypeFailure(failure)),
    );
  }

  Future<void> getTypes() async {
    emit(FixedAssetsGetZoneAndTypeLoading());

    final result = await _repository.getTypesAssets();

    handle(
      result,
      success: (data) => emit(FixedAssetsGetTypesSuccess(data)),
      failure: (failure) => emit(FixedAssetsGetZoneAndTypeFailure(failure)),
    );
  }

  Future<void> getResponsibleEmployees() async {
    emit(FixedAssetsGetZoneAndTypeLoading());

    final result = await _repository.getResponsibleEmployees();

    handle(
      result,
      success: (data) => emit(FixedAssetsGetResponsibleEmployeesSuccess(data)),
      failure: (failure) => emit(FixedAssetsGetZoneAndTypeFailure(failure)),
    );
  }

  Future<void> getBranches() async {
    emit(FixedAssetsGetZoneAndTypeLoading());

    final result = await _repository.getBranches();

    handle(
      result,
      success: (data) => emit(FixedAssetsGetBranchesSuccess(data)),
      failure: (failure) => emit(FixedAssetsGetZoneAndTypeFailure(failure)),
    );
  }

  Future<void> getAllAssets() async {
    emit(FixedAssetsGetZoneAndTypeLoading());

    final result = await _repository.getAllAssets();

    handle(
      result,
      success: (data) => emit(FixedAssetsGetAssetsSuccess(data)),
      failure: (failure) => emit(FixedAssetsGetZoneAndTypeFailure(failure)),
    );
  }
}
