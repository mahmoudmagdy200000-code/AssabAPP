import 'package:assab/core/utils/api_result.dart';
import 'package:assab/core/utils/future_api_result.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/add_cashier_models/update_cashier_request.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/cashier_model.dart';
import 'package:assab/features/shift_module_features/shift_management/data/repository/shift_management_repository_imp.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/cashier_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/working_shift_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/cashier/cashier_update_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

class _Repository implements ShiftManagementRepositoryImp {
  UpdateCashierRequest? request;
  String? cashierId;

  @override
  FutureApiResult updateCashier({
    required String cashierId,
    required UpdateCashierRequest request,
  }) async {
    this.request = request;
    this.cashierId = cashierId;
    return ApiResult.success(true);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

CashierEntity _cashier(List<String> ids) => CashierEntity(
  id: 'cashier-uuid',
  name: 'Cashier',
  email: 'cashier@example.invalid',
  phone: '',
  branch: BranchEntity(id: 'branch-uuid', name: 'Branch'),
  status: CashierStatus.active,
  shiftsCount: 0,
  workingShifts: [
    for (final id in ids)
      WorkingShiftEntity(
        id: id,
        name: id,
        startTime: '12:00',
        endTime: '20:00',
      ),
  ],
);

void main() {
  for (final scenario in <(String, List<String>, List<String>, List<String>?)>[
    ('removing one selection reaches the API', ['a', 'b'], ['a'], ['a']),
    (
      'adding a selection sends the whole new set',
      ['a'],
      ['a', 'b'],
      ['a', 'b'],
    ),
    (
      'reordered unchanged selection omits assignment mutation',
      ['a', 'b'],
      ['b', 'a'],
      null,
    ),
    ('metadata-only update omits assignment mutation', ['a'], ['a'], null),
    ('empty selection remains explicit for server validation', ['a'], [], []),
    ('unassigned cashier can receive a new selection', [], ['a'], ['a']),
  ]) {
    test(scenario.$1, () async {
      final repository = _Repository();
      final cubit = CashierUpdateCubit(repository);
      addTearDown(cubit.close);
      await cubit.updateCashier(
        openedFromChangeShiftButton: true,
        originalCashier: _cashier(scenario.$2),
        newCashier: _cashier(scenario.$3),
      );
      expect(repository.cashierId, 'cashier-uuid');
      expect(repository.request!.shiftIds, scenario.$4);
      expect(
        repository.request!.toForm().containsKey('shift_ids'),
        scenario.$4 != null,
      );
      expect(cubit.state, isA<CashierUpdateSuccess>());
    });
  }

  test('DTO distinguishes absent selection from explicit empty selection', () {
    expect(UpdateCashierRequest(name: 'Renamed').toForm(), {'name': 'Renamed'});
    expect(UpdateCashierRequest(shiftIds: []).toForm(), {'shift_ids': []});
  });
}
