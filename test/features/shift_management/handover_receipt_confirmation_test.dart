import 'package:assab/core/services/user_type_service.dart';
import 'package:assab/core/strategies/user_type_strategy.dart';
import 'package:assab/features/shift_module_features/shift_management/data/data_source/shift_management_remote_data_source.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/handover_approve_body_request.dart';
import 'package:assab/features/shift_module_features/shift_management/data/repository/shift_management_repository_imp.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/shifts/approve_and_reject_handover/approve_and_reject_handover_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

class _MockShiftRemoteDataSource extends Fake implements ShiftManagementRemoteDataSource {
  String? lastApproveShiftId;
  HandoverApproveAndRejectBodyRequest? lastApproveBody;

  String? lastAcceptCashierShiftId;
  HandoverApproveAndRejectBodyRequest? lastAcceptCashierBody;

  String? lastRejectShiftId;
  HandoverApproveAndRejectBodyRequest? lastRejectBody;

  String? lastRejectCashierShiftId;
  HandoverApproveAndRejectBodyRequest? lastRejectCashierBody;

  @override
  Future<dynamic> approveHandover({
    required String shiftId,
    HandoverApproveAndRejectBodyRequest? handoverApproveAndRejectBodyRequest,
  }) async {
    lastApproveShiftId = shiftId;
    lastApproveBody = handoverApproveAndRejectBodyRequest;
    return {'success': true};
  }

  @override
  Future<dynamic> acceptCashierHandover({
    required String shiftId,
    HandoverApproveAndRejectBodyRequest? body,
  }) async {
    lastAcceptCashierShiftId = shiftId;
    lastAcceptCashierBody = body;
    return {'success': true};
  }

  @override
  Future<dynamic> rejectHandover({
    required String shiftId,
    HandoverApproveAndRejectBodyRequest? handoverApproveAndRejectBodyRequest,
  }) async {
    lastRejectShiftId = shiftId;
    lastRejectBody = handoverApproveAndRejectBodyRequest;
    return {'success': true};
  }

  @override
  Future<dynamic> rejectCashierHandover({
    required String shiftId,
    HandoverApproveAndRejectBodyRequest? body,
  }) async {
    lastRejectCashierShiftId = shiftId;
    lastRejectCashierBody = body;
    return {'success': true};
  }
}

void main() {
  group('FR-01: Handover Receipt Confirmation DTO & Contract Tests', () {
    test('HandoverApproveAndRejectBodyRequest correctly serializes confirmed_amount and omits nulls', () {
      const dto = HandoverApproveAndRejectBodyRequest(
        confirmedAmount: '150.00',
        managerComment: 'Verified in drawer',
      );

      final json = dto.toJson();

      expect(json['confirmed_amount'], equals('150.00'));
      expect(json['manager_comment'], equals('Verified in drawer'));
      expect(json.containsKey('rejection_reason'), isFalse);
      expect(json.containsKey('receiving_shift_id'), isFalse);
    });

    test('Cashier receipt DTO serializes receiving_shift_id and transfer_attempt_id', () {
      const dto = HandoverApproveAndRejectBodyRequest(
        confirmedAmount: '200.50',
        receivingShiftId: 'recv-shift-uuid',
        transferAttemptId: 'transfer-attempt-uuid',
        comment: 'Received complete',
      );

      final json = dto.toJson();

      expect(json['confirmed_amount'], equals('200.50'));
      expect(json['receiving_shift_id'], equals('recv-shift-uuid'));
      expect(json['transfer_attempt_id'], equals('transfer-attempt-uuid'));
      expect(json['comment'], equals('Received complete'));
    });
  });

  group('FR-01: Handover Receipt Confirmation Cubit Routing Tests', () {
    late _MockShiftRemoteDataSource mockDataSource;
    late ShiftManagementRepositoryImp repository;
    late ApproveAndRejectHandoverCubit cubit;

    setUp(() {
      mockDataSource = _MockShiftRemoteDataSource();
      repository = ShiftManagementRepositoryImp(mockDataSource);
      cubit = ApproveAndRejectHandoverCubit(repository);
      UserTypeService.selectedUserType = null;
    });

    test('Branch Manager receipt confirmation calls approveHandover with confirmed_amount', () async {
      await cubit.confirmHandoverReceipt(
        shiftId: 'shift-101',
        confirmedAmount: '175.00',
        expectedAmount: 175.00,
        actorRole: UserType.branchManager,
        comment: 'Safe audit matches',
      );

      expect(mockDataSource.lastApproveShiftId, equals('shift-101'));
      expect(mockDataSource.lastApproveBody?.confirmedAmount, equals('175.00'));
      expect(mockDataSource.lastApproveBody?.managerComment, equals('Safe audit matches'));
      expect(mockDataSource.lastAcceptCashierShiftId, isNull);
      expect(cubit.state, isA<HandoverActionSuccess>());
    });

    test('Cashier receipt confirmation calls acceptCashierHandover with confirmed_amount', () async {
      await cubit.confirmHandoverReceipt(
        shiftId: 'shift-202',
        confirmedAmount: '250.00',
        expectedAmount: 250.00,
        actorRole: UserType.cashier,
        comment: 'Drawer physically counted',
      );

      expect(mockDataSource.lastAcceptCashierShiftId, equals('shift-202'));
      expect(mockDataSource.lastAcceptCashierBody?.confirmedAmount, equals('250.00'));
      expect(mockDataSource.lastAcceptCashierBody?.comment, equals('Drawer physically counted'));
      expect(mockDataSource.lastApproveShiftId, isNull);
      expect(cubit.state, isA<HandoverActionSuccess>());
    });

    test('Cashier rejection calls rejectCashierHandover', () async {
      await cubit.rejectHandover(
        shiftId: 'shift-303',
        managerComment: 'Physical count was 20 SAR short',
        actorRole: UserType.cashier,
      );

      expect(mockDataSource.lastRejectCashierShiftId, equals('shift-303'));
      expect(mockDataSource.lastRejectCashierBody?.rejectionReason, equals('Physical count was 20 SAR short'));
      expect(mockDataSource.lastRejectShiftId, isNull);
      expect(cubit.state, isA<HandoverActionSuccess>());
    });

    test('Branch Manager rejection calls rejectHandover', () async {
      await cubit.rejectHandover(
        shiftId: 'shift-404',
        managerComment: 'Missing receipts attached',
        actorRole: UserType.branchManager,
      );

      expect(mockDataSource.lastRejectShiftId, equals('shift-404'));
      expect(mockDataSource.lastRejectBody?.rejectionReason, equals('Missing receipts attached'));
      expect(mockDataSource.lastRejectCashierShiftId, isNull);
      expect(cubit.state, isA<HandoverActionSuccess>());
    });

    test('CASH-09: Confirmation is strictly blocked when counted cash differs from expected handover amount', () async {
      await cubit.confirmHandoverReceipt(
        shiftId: 'shift-505',
        confirmedAmount: '120.00',
        expectedAmount: 150.00,
        actorRole: UserType.cashier,
        comment: 'Partial physical cash in drawer',
      );

      // Must not dispatch to API
      expect(mockDataSource.lastAcceptCashierShiftId, isNull);
      expect(mockDataSource.lastApproveShiftId, isNull);

      // Must fail closed with 422 error
      expect(cubit.state, isA<HandoverActionFailure>());
      final failureState = cubit.state as HandoverActionFailure;
      expect(failureState.failure.statusCode, equals(422));
      expect(failureState.failure.error.getErrorMessage, contains('CASH-09'));
    });

    test('Absent authenticated role in confirmHandoverReceipt fails closed with HTTP 403', () async {
      UserTypeService.selectedUserType = null;

      await cubit.confirmHandoverReceipt(
        shiftId: 'shift-606',
        confirmedAmount: '100.00',
        expectedAmount: 100.00,
      );

      expect(mockDataSource.lastAcceptCashierShiftId, isNull);
      expect(mockDataSource.lastApproveShiftId, isNull);
      expect(cubit.state, isA<HandoverActionFailure>());
      final failureState = cubit.state as HandoverActionFailure;
      expect(failureState.failure.statusCode, equals(403));
      expect(failureState.failure.error.getErrorMessage, contains('Unauthorized'));
    });

    test('Absent authenticated role in rejectHandover fails closed with HTTP 403', () async {
      UserTypeService.selectedUserType = null;

      await cubit.rejectHandover(
        shiftId: 'shift-707',
        managerComment: 'Unauthorized rejection attempt',
      );

      expect(mockDataSource.lastRejectCashierShiftId, isNull);
      expect(mockDataSource.lastRejectShiftId, isNull);
      expect(cubit.state, isA<HandoverActionFailure>());
      final failureState = cubit.state as HandoverActionFailure;
      expect(failureState.failure.statusCode, equals(403));
      expect(failureState.failure.error.getErrorMessage, contains('Unauthorized'));
    });
  });
}
