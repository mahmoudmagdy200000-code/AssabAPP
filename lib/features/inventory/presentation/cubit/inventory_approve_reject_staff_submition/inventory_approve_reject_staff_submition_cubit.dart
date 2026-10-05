import 'package:assab/core/errors/api_failure.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/models/inventory_confirm_staff_task_request.dart';
import '../../../data/repository/inventory_repository.dart';

part 'inventory_approve_reject_staff_submition_state.dart';

@injectable
class InventoryApproveRejectStaffSubmitionCubit
    extends SafeCubit<InventoryApproveRejectStaffSubmitionState> {
  final InventoryRepository _inventoryRepository;

  InventoryApproveRejectStaffSubmitionCubit(this._inventoryRepository)
    : super(const InventoryApproveRejectStaffSubmitionInitial());

  Future<void> confirmDailyForStaff({
    required String sessionId,
    required InventoryConfirmStaffTaskRequest request,
  }) async {
    emit(const InventoryApproveRejectStaffSubmitionLoading());

    final result = await _inventoryRepository.confirmDailyForStaff(
      sessionId: sessionId,
      request: request,
    );

    handle(
      result,
      success: (_) => emit(const InventoryApproveRejectStaffSubmitionSuccess()),
      failure: (failure) =>
          emit(InventoryApproveRejectStaffSubmitionFailure(failure)),
    );
  }

  Future<void> confirmWasteDamageForStaff({
    required String reportId,
    required InventoryConfirmStaffTaskRequest request,
  }) async {
    emit(const InventoryApproveRejectStaffSubmitionLoading());

    final result = await _inventoryRepository.confirmWasteDamageForStaff(
      reportId: reportId,
      request: request,
    );

    handle(
      result,
      success: (_) => emit(const InventoryApproveRejectStaffSubmitionSuccess()),
      failure: (failure) =>
          emit(InventoryApproveRejectStaffSubmitionFailure(failure)),
    );
  }
}
