import 'package:assab/core/utils/api_result.dart';
import 'package:assab/features/cashier_my_shifts/data/repository/cashier_my_shifts_repo.dart';
import 'package:assab/features/cashier_my_shifts/data/model/shifts_models/pending/cashier_pending_shifts_response_model.dart';
import 'package:assab/features/cashier_my_shifts/presentation/cubits/cashier_my_shifts_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/data/repository/shift_management_repository_imp.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/shift_response_model.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/shifts/cashier_shifts_management_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

Map<String, dynamic> page(int page, {required bool manager}) => {
  'success': true,
  'message': 'OK',
  'data': [
    {
      'id': 'shift-$page',
      // Deliberately independent of device clock: these rows are selected by the server.
      manager ? 'shift_date' : 'date': page == 1 ? '2026-11-12' : '2026-11-13',
      'status': 'not_started', 'can_start': true,
      'start_time': '22:00', 'end_time': '06:00',
      if (manager)
        'cashier': {
          'id': 'cashier',
          'name': 'Cashier',
          'email': 'cashier@example.test',
          'phone': '',
          'store_branch_id': 'branch',
          'store_branch_name': 'Branch',
          'created_at': '2026-11-01',
        },
      if (manager)
        'shift': {
          'id': 'template',
          'name': 'Night',
          'branch_id': 'branch',
          'start_time': '22:00',
          'end_time': '06:00',
          'is_active': true,
        },
    },
  ],
  'meta': {'current_page': page, 'last_page': 2, 'total': 2},
};

class CashierRepo extends Fake implements CashierMyShiftsRepo {
  @override
  Future<ApiResult<CashierPendingShiftsResponseModel>>
  getCashierMyPendingShifts({int? page}) async => ApiResult.success(
    CashierPendingShiftsResponseModel.fromJson(_page(page ?? 1)),
  );
  Map<String, dynamic> _page(int index) => page(index, manager: false);
}

class ManagerRepo extends Fake implements ShiftManagementRepositoryImp {
  @override
  Future<ApiResult<ShiftResponseModel>> getPendingShifts(
    String cashierId,
    int index,
  ) async => ApiResult.success(
    ShiftResponseModel.fromJson(page(index, manager: true)),
  );
}

void main() {
  setUpAll(() async => initializeDateFormatting('en'));
  test('cashier retains server carry-over across pagination', () async {
    final cubit = CashierMyShiftsCubit(CashierRepo());
    addTearDown(cubit.close);
    await cubit.getPendingShifts();
    expect(cubit.state.pending.items.map((e) => e.id), ['shift-1']);
    await cubit.getPendingShifts(loadMore: true);
    expect(cubit.state.pending.items.map((e) => e.id), ['shift-1', 'shift-2']);
  });
  test('manager retains server carry-over across pagination', () async {
    final cubit = CashierShiftsManagementCubit(ManagerRepo(), 'cashier');
    addTearDown(cubit.close);
    await cubit.getPendingShifts();
    expect(cubit.state.pending.items.map((e) => e.id), ['shift-1']);
    await cubit.getPendingShifts(loadMore: true);
    expect(cubit.state.pending.items.map((e) => e.id), ['shift-1', 'shift-2']);
  });
}
