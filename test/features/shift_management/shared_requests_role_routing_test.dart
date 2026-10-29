import 'package:assab/core/services/user_type_service.dart';
import 'package:assab/core/strategies/user_type_strategy.dart';
import 'package:assab/core/utils/currency_normalizer.dart';
import 'package:assab/features/branch_manager_requests/data/models/handovers_response.dart';
import 'package:assab/features/shift_module_features/shift_management/data/data_source/shift_management_remote_data_source.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/handover_approve_body_request.dart';
import 'package:assab/features/shift_module_features/shift_management/data/repository/shift_management_repository_imp.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/shifts/approve_and_reject_handover/approve_and_reject_handover_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/variance/variance_details_bottom_sheet_widget.dart';
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
  group('R-01: Shared Requests View Explicit Role Routing Tests', () {
    late _MockShiftRemoteDataSource mockDataSource;
    late ShiftManagementRepositoryImp repository;
    late ApproveAndRejectHandoverCubit cubit;

    setUp(() {
      mockDataSource = _MockShiftRemoteDataSource();
      repository = ShiftManagementRepositoryImp(mockDataSource);
      cubit = ApproveAndRejectHandoverCubit(repository);
      UserTypeService.selectedUserType = null;
    });

    test('Cashier actor routing routes confirmation to acceptCashierHandover, not approveHandover', () async {
      await cubit.confirmHandoverReceipt(
        shiftId: 'shift-100',
        confirmedAmount: '250.75',
        expectedAmount: 250.75,
        actorRole: UserType.cashier,
        comment: 'Received and verified drawer cash',
      );

      expect(mockDataSource.lastAcceptCashierShiftId, equals('shift-100'));
      expect(mockDataSource.lastAcceptCashierBody?.confirmedAmount, equals('250.75'));
      expect(mockDataSource.lastAcceptCashierBody?.comment, equals('Received and verified drawer cash'));
      // Must NOT route to branch manager endpoint
      expect(mockDataSource.lastApproveShiftId, isNull);
    });

    test('Branch Manager actor routing routes confirmation to approveHandover', () async {
      await cubit.confirmHandoverReceipt(
        shiftId: 'shift-200',
        confirmedAmount: '300.00',
        expectedAmount: 300.00,
        actorRole: UserType.branchManager,
        comment: 'Manager custody verification',
      );

      expect(mockDataSource.lastApproveShiftId, equals('shift-200'));
      expect(mockDataSource.lastApproveBody?.confirmedAmount, equals('300.00'));
      expect(mockDataSource.lastApproveBody?.managerComment, equals('Manager custody verification'));
      expect(mockDataSource.lastAcceptCashierShiftId, isNull);
    });

    test('Cashier rejection routes to rejectCashierHandover, not manager rejectHandover', () async {
      await cubit.rejectHandover(
        shiftId: 'shift-300',
        managerComment: 'Missing halalas counted in cash drawer',
        actorRole: UserType.cashier,
      );

      expect(mockDataSource.lastRejectCashierShiftId, equals('shift-300'));
      expect(mockDataSource.lastRejectCashierBody?.rejectionReason, equals('Missing halalas counted in cash drawer'));
      expect(mockDataSource.lastRejectShiftId, isNull);
    });

    test('Branch Manager rejection routes to manager rejectHandover', () async {
      await cubit.rejectHandover(
        shiftId: 'shift-400',
        managerComment: 'Manager rejected due to missing shift envelope',
        actorRole: UserType.branchManager,
      );

      expect(mockDataSource.lastRejectShiftId, equals('shift-400'));
      expect(mockDataSource.lastRejectBody?.rejectionReason, equals('Manager rejected due to missing shift envelope'));
      expect(mockDataSource.lastRejectCashierShiftId, isNull);
    });

    test('Unknown or absent role fails closed with 403 authorization failure', () async {
      await cubit.confirmHandoverReceipt(
        shiftId: 'shift-500',
        confirmedAmount: '100.00',
        expectedAmount: 100.00,
        actorRole: null, // absent role
      );

      expect(mockDataSource.lastApproveShiftId, isNull);
      expect(mockDataSource.lastAcceptCashierShiftId, isNull);
      expect(cubit.state, isA<HandoverActionFailure>());
      final failure = (cubit.state as HandoverActionFailure).failure;
      expect(failure.statusCode, equals(403));
    });
  });

  group('F-03: Handover Item can_be_accepted Gating Tests', () {
    test('HandoversResponseItem defaults canBeAccepted to false when field is missing or null', () {
      final json = {
        'id': 'shift-uuid-1', 'shift_date': '2026-10-29', 'shift_date_iso': '2026-10-29T10:00:00Z',
        'variance': '0.00',
        'cash_given': '150.00',
        'variance_amount': 0,
        'handover_amount': 150.00,
        'status': 'pending',
        'cash_from': 'Cashier 1',
        'cash_to': 'Cashier 2',
        // can_be_accepted is intentionally omitted
      };

      final item = HandoversResponseItem.fromJson(json);
      expect(item.canBeAccepted, isFalse, reason: 'Must fail closed when can_be_accepted is missing');
    });

    test('HandoversResponseItem correctly parses can_be_accepted when true', () {
      final json = {
        'id': 'shift-uuid-2', 'shift_date': '2026-10-29', 'shift_date_iso': '2026-10-29T10:00:00Z',
        'variance': '0.00',
        'cash_given': '200.00',
        'variance_amount': 0,
        'handover_amount': 200.00,
        'status': 'pending',
        'cash_from': 'Cashier 1',
        'cash_to': 'Cashier 2',
        'can_be_accepted': true,
      };

      final item = HandoversResponseItem.fromJson(json);
      expect(item.canBeAccepted, isTrue);
    });

    test('HandoversResponseItem correctly parses can_be_accepted when false', () {
      final json = {
        'id': 'shift-uuid-3', 'shift_date': '2026-10-29', 'shift_date_iso': '2026-10-29T10:00:00Z',
        'variance': '0.00',
        'cash_given': '200.00',
        'variance_amount': 0,
        'handover_amount': 200.00,
        'status': 'pending',
        'cash_from': 'Cashier 1',
        'cash_to': 'Cashier 2',
        'can_be_accepted': false,
      };

      final item = HandoversResponseItem.fromJson(json);
      expect(item.canBeAccepted, isFalse);
    });
  });

  group('R-02: Decimal SAR & Halalas Precision Preservation Tests', () {
    test('CurrencyNormalizer formats decimal SAR with exact two decimal places', () {
      expect(CurrencyNormalizer.formatSar(150.5), equals('150.50'));
      expect(CurrencyNormalizer.formatSar(0.75), equals('0.75'));
      expect(CurrencyNormalizer.formatSar(100), equals('100.00'));
      expect(CurrencyNormalizer.formatSar(234.56), equals('234.56'));
    });

    test('VarianceDetailsBottomSheetWidget stores num varianceAmount preserving halalas', () {
      const widget = VarianceDetailsBottomSheetWidget(
        shiftId: 'shift-1',
        handoverAmount: 150.25,
        varianceAmount: 12.50, // decimal halalas
      );

      expect(widget.varianceAmount, equals(12.50));
      expect(widget.varianceAmount, isA<num>());
      expect(CurrencyNormalizer.formatSar(widget.varianceAmount), equals('12.50'));
    });
  });
}