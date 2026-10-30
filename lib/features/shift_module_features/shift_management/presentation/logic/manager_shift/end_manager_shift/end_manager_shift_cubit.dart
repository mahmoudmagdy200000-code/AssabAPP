import 'dart:convert';
import 'package:assab/core/errors/api_failure.dart';
import '../../../../../../../core/errors/api_error_model.dart';
import '../final_daily_close/final_daily_close_cubit.dart';
import 'package:assab/core/network/idempotency_interceptor.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/manager_shift_management_models/end_shift_models/cashier_breakdown_request_model.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/manager_shift_management_models/end_shift_models/manager_end_shift_request_model.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/final_daily_close/cashier_breakdown_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/enums/manager_shift/end_shift_handover_timing.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../../core/helpers/safe_cubit.dart';
import '../../../../data/model/manager_shift_management_models/end_shift_models/update_manager_handover_request_model.dart';
import '../../../../data/repository/shift_management_repository_imp.dart';
import '../../../../domain/entity/manager_shift/end_shift_response_entites/manager_shift_end_data_entity.dart';

part 'end_manager_shift_state.dart';

@injectable
class EndAndUpdateManagerShiftCubit
    extends SafeCubit<EndAndUpdateManagerShiftState> {
  EndAndUpdateManagerShiftCubit(this._repo) : super(EndManagerShiftInitial());

  final ShiftManagementRepositoryImp _repo;

  HandoverTiming handoverTiming = HandoverTiming.today;
  String? _intentFingerprint;
  String? _intentKey;

  String _idempotencyKey(String action, Map<String, dynamic> payload) {
    final fingerprint = '$action:${jsonEncode(payload)}';
    if (_intentFingerprint != fingerprint) {
      _intentFingerprint = fingerprint;
      _intentKey = IdempotencyScopeManager.generateUuidV4();
    }
    return _intentKey!;
  }

  bool _validate(FinalDailyCloseLoadedOrUpdated workday) {
    if (workday.canSubmit) return true;
    emit(
      EndManagerShiftFailure(
        ValidationFailure(
          error: LocalErrorModel(
            message:
                'Load the selected workday and provide a reason and current revision for every correction.',
          ),
          icon: Icons.error_outline,
          statusCode: 422,
          stackTrace: StackTrace.current,
        ),
      ),
    );
    return false;
  }

  List<CashierBreakdownRequestModel> _rows(
    List<CashierBreakdownEntity> cashiers,
  ) => cashiers
      .map(
        (e) => CashierBreakdownRequestModel(
          cashierId: e.cashierId,
          cashierShiftId: e.cashierShiftId,
          cashCollected: e.cashCollected,
          cardPayments: e.cardPayments,
          deliveryAppPayments: e.deliveryAppPayments,
          sales: e.totalSales,
          aggregators:
              jsonEncode(e.aggregators) != jsonEncode(e.initialAggregators)
              ? e.aggregators
              : null,
          expectedRevision: e.isModified ? e.expectedRevision : null,
          reason: e.isModified ? e.reason?.trim() : null,
        ),
      )
      .toList();

  Future<void> endManagerShift({
    required FinalDailyCloseLoadedOrUpdated workday,
  }) async {
    if (state is EndManagerShiftButtonLoading || !_validate(workday)) return;
    emit(EndManagerShiftButtonLoading());
    final request = EndManagerShiftRequestModel(
      managerWorkdayId: workday.managerWorkdayId!,
      handoverTiming: handoverTiming,
      totalSales: workday.totals.totalSales,
      cashCollected: workday.totals.totalCashCollected,
      cardPayments: workday.totals.totalCardPayments,
      aggregatorPayments: workday.totals.totalDeliveryApps,
      cashierBreakdown: _rows(workday.cashiers),
    );
    final result = await _repo.endManagerShift(
      request: request,
      idempotencyKey: _idempotencyKey('end', request.toJson()),
    );
    handle(
      result,
      failure: (failure) => emit(EndManagerShiftFailure(failure)),
      success: (managerShift) =>
          emit(EndManagerShiftSuccess(managerShift: managerShift)),
    );
  }

  Future<void> updateManagerHandoverShift({
    required FinalDailyCloseLoadedOrUpdated workday,
  }) async {
    if (state is EndManagerShiftButtonLoading || !_validate(workday)) return;
    emit(EndManagerShiftButtonLoading());
    final request = UpdateManagerHandoverRequestModel(
      managerWorkdayId: workday.managerWorkdayId!,
      cashierBreakdown: _rows(workday.cashiers),
    );
    final result = await _repo.updateManagerHandoverShift(
      request: request,
      idempotencyKey: workday.cashiers.any((e) => e.isModified)
          ? _idempotencyKey('update', request.toJson())
          : null,
    );
    handle(
      result,
      failure: (failure) => emit(EndManagerShiftFailure(failure)),
      success: (managerShift) => emit(
        EndManagerShiftSuccess(
          managerShift: ManagerShiftEndDataEntity(
            finalHandover: managerShift.shift.finalHandover,
            dailyTotals: managerShift.dailyTotals,
          ),
        ),
      ),
    );
  }
}
