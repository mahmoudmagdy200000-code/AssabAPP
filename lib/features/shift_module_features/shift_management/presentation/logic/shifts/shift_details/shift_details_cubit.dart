import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/handover_status_details_entities/handover_status_details_entity.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../../core/errors/api_failure.dart';
import '../../../../../../../core/helpers/safe_cubit.dart';
import '../../../../data/repository/shift_management_repository_imp.dart';
import '../../../../domain/entity/shift/shift_entity.dart';

part 'shift_details_state.dart';

@injectable
class ShiftDetailsCubit extends SafeCubit<ShiftDetailsState> {
  final ShiftManagementRepositoryImp _repository;
  final String shiftId;
  final bool isCashier;

  late ShiftEntity shift;

  ShiftDetailsCubit(
    this._repository,
    @factoryParam this.shiftId,
    @factoryParam this.isCashier,
  ) : super(ShiftDetailsInitial());

  Future<void> getShiftDetails() async {
    emit(ShiftDetailsLoading());

    final result = await _repository.getShiftDetails(shiftId);

    handle(
      result,
      success: (shift) {
        this.shift = shift;
        emit(ShiftDetailsLoaded(shift));
      },
      failure: (failure) {
        emit(ShiftDetailsError(failure));
      },
    );
  }

  Future<void> getHandoverRejectionDetails() async {
    emit(HandoverDetailsLoading());

    final result = await _repository.getHandoverRejectionDetails(shiftId);

    handle(
      result,
      success: (handover) {
        emit(HandoverDetailsLoaded(handover));
      },
      failure: (failure) {
        emit(HandoverDetailsFailure(failure));
      },
    );
  }
}
