import 'package:assab/core/services/user_type_service.dart';
import 'package:assab/core/strategies/user_type_strategy.dart';
import 'package:assab/features/shift_module_features/shift_management/data/data_source/shift_management_remote_data_source.dart';
import 'package:assab/features/shift_module_features/shift_management/data/repository/shift_management_repository_imp.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/cashier/start_cashier_shift_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

class _MockShiftRemoteDataSource extends Fake implements ShiftManagementRemoteDataSource {
  String? lastCashierStartShiftId;
  String? lastManagerStartShiftId;

  @override
  Future<dynamic> startCashierShift({required String shiftId}) async {
    lastCashierStartShiftId = shiftId;
    return {'success': true};
  }

  @override
  Future<dynamic> startShiftByManager({required String shiftId}) async {
    lastManagerStartShiftId = shiftId;
    return {'success': true};
  }
}

void main() {
  group('FR-02: Role-Specific Start Shift Routing Tests', () {
    late _MockShiftRemoteDataSource mockDataSource;
    late ShiftManagementRepositoryImp repository;
    late StartCashierShiftCubit cubit;

    setUp(() {
      mockDataSource = _MockShiftRemoteDataSource();
      repository = ShiftManagementRepositoryImp(mockDataSource);
      cubit = StartCashierShiftCubit(repository);
      UserTypeService.selectedUserType = null;
    });

    test('Cashier starts own shift dispatches to cashierStartShift (/api/v1/cashier/shifts/{shift}/start)', () async {
      await cubit.startShift(shiftId: 'shift-101', actorRole: UserType.cashier);

      expect(mockDataSource.lastCashierStartShiftId, equals('shift-101'));
      expect(mockDataSource.lastManagerStartShiftId, isNull);
    });

    test('Branch Manager starts cashier shift dispatches to startShiftByManager (/api/v1/branch-manager/shifts/start-by-manager/{shiftId})', () async {
      await cubit.startShift(shiftId: 'shift-202', actorRole: UserType.branchManager);

      expect(mockDataSource.lastManagerStartShiftId, equals('shift-202'));
      expect(mockDataSource.lastCashierStartShiftId, isNull);
    });

    test('Falls back to UserTypeService authenticated role when actorRole is omitted', () async {
      UserTypeService.selectedUserType = UserType.branchManager;

      await cubit.startShift(shiftId: 'shift-303');

      expect(mockDataSource.lastManagerStartShiftId, equals('shift-303'));
      expect(mockDataSource.lastCashierStartShiftId, isNull);
    });

    test('Cashier default role does not escalate to manager endpoint', () async {
      UserTypeService.selectedUserType = UserType.cashier;

      await cubit.startShift(shiftId: 'shift-404');

      expect(mockDataSource.lastCashierStartShiftId, equals('shift-404'));
      expect(mockDataSource.lastManagerStartShiftId, isNull);
    });
  });
}