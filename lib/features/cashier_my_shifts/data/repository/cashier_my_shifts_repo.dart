import 'package:injectable/injectable.dart';

import '../../../../core/errors/repository_mixin.dart';
import '../../../../core/utils/future_api_result.dart';
import '../data_source/cashier_my_shifts_data_source.dart';
import '../model/shifts_models/completed/cashier_completed_shifts_response_model.dart';
import '../model/shifts_models/in_progress/cashier_in_progress_shifts_response_model.dart';
import '../model/shifts_models/pending/cashier_pending_shifts_response_model.dart';
import '../model/shifts_models/reassigned/cashier_reassigned_shifts_response_model.dart';

@LazySingleton()
class CashierMyShiftsRepo with RepositoryMixin {
  final CashierMyShiftsRemoteDataSource _remoteDataSource;

  CashierMyShiftsRepo(this._remoteDataSource);

  // Pending
  FutureApiResult<CashierPendingShiftsResponseModel> getCashierMyPendingShifts({
    int? page,
  }) => execute(() async {
    return _remoteDataSource.getCashierMyPendingShifts(page: page);
  });

  // Completed
  FutureApiResult<CashierCompletedShiftsResponseModel>
  getCashierMyCompletedShifts({int? page}) => execute(() async {
    return _remoteDataSource.getCashierMyCompletedShifts(page: page);
  });

  // Reassigned
  FutureApiResult<CashierReassignedShiftsResponseModel>
  getCashierMyReassignedShifts({int? page}) => execute(() async {
    return _remoteDataSource.getCashierMyReassignedShifts(page: page);
  });

  // InProgress
  FutureApiResult<CashierInProgressShiftsResponseModel>
  getCashierMyInProgressShifts({int? page}) =>
      execute(() async => _remoteDataSource.getCashierMyInProgressShifts());

  FutureApiResult acceptReassignedCashierShift(String shiftId) =>
      execute(() async {
        await _remoteDataSource.acceptReassignedCashierShift(shiftId: shiftId);
        return true;
      });
}
