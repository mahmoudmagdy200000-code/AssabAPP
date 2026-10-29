import 'package:assab/core/services/user_type_service.dart';
import 'package:assab/core/strategies/user_type_strategy.dart';
import 'package:assab/core/utils/currency_normalizer.dart';
import 'package:assab/features/shift_module_features/shift_management/data/data_source/shift_management_remote_data_source.dart';
import 'package:assab/features/shift_module_features/shift_management/data/mapper/shift/shift_mapper.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/handover_approve_body_request.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/shift_details/shift_details_model.dart';
import 'package:assab/features/shift_module_features/shift_management/data/repository/shift_management_repository_imp.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/shifts/approve_and_reject_handover/approve_and_reject_handover_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

/// GATE A (R-02): exact SAR decimals through the real data path:
/// backend JSON -> ShiftDetailsModel -> ShiftEntity -> expected amount ->
/// CASH-09 check in the cubit -> outgoing API body.
class _Ds extends Fake implements ShiftManagementRemoteDataSource {
  HandoverApproveAndRejectBodyRequest? approveBody;
  HandoverApproveAndRejectBodyRequest? acceptBody;

  @override
  Future<dynamic> approveHandover({
    required String shiftId,
    HandoverApproveAndRejectBodyRequest? handoverApproveAndRejectBodyRequest,
  }) async {
    approveBody = handoverApproveAndRejectBodyRequest;
    return {'success': true};
  }

  @override
  Future<dynamic> acceptCashierHandover({
    required String shiftId,
    HandoverApproveAndRejectBodyRequest? body,
  }) async {
    acceptBody = body;
    return {'success': true};
  }
}

/// Mirrors Backend ShiftDetailResource: handover_amount / cash_given / variance
/// are emitted as (float) JSON numbers.
Map<String, dynamic> _backendShiftJson({
  required Object? handoverAmount,
  Object? cashGiven,
  Object? variance = 0,
  Object? closingBalance = 999.0,
}) => {
  'id': 'shift-1',
  'shift_date': '2026-10-29',
  'status': 'completed',
  'cashier': {
    'id': 'c-1',
    'name': 'Cashier One',
    'email': null,
    'phone': null,
    'image': null,
    'status': null,
    'store_branch_name': null,
    'created_by_name': null,
    'store_branch_id': null,
    'number_of_shifts_per_day': null,
    'status_label': null,
    'created_at': null,
    'working_shifts': null,
  },
  'shift': {
    'id': 's-1',
    'name': 'Morning',
    'branch_id': 'b-1',
    'branch_name': 'Main',
    'is_active': true,
    'start_time': '08:00',
    'end_time': '16:00',
    'assigned_by': null,
  },
  'opening_balance': 0.0,
  'closing_balance': closingBalance,
  'expected_balance': 0.0,
  'variance': variance,
  'handover_amount': handoverAmount,
  'cash_given': cashGiven ?? handoverAmount,
};

void main() {
  setUpAll(() async => initializeDateFormatting('en'));
  const cases = <double>[100.50, 100.01, 0.50, 1250.99];

  group('GATE A: backend JSON -> ShiftEntity preserves exact SAR decimals', () {
    for (final amount in cases) {
      test('handover_amount $amount survives model + entity mapping', () {
        final model = ShiftDetailsModel.fromJson(
          _backendShiftJson(handoverAmount: amount),
        );
        final entity = model.toEntity();

        expect(entity.handoverAmount, equals(amount));
        expect(entity.cashGiven, equals(amount));
        expect(
          CurrencyNormalizer.formatSar(entity.handoverAmount!),
          equals(amount.toStringAsFixed(2)),
        );
      });
    }

    test('string-encoded decimals ("100.50") are also preserved', () {
      final entity = ShiftDetailsModel.fromJson(
        _backendShiftJson(handoverAmount: '100.50'),
      ).toEntity();
      expect(entity.handoverAmount, equals(100.50));
      expect(entity.cashGiven, equals(100.50));
    });

    test('variance halalas are preserved (not truncated to int)', () {
      final entity = ShiftDetailsModel.fromJson(
        _backendShiftJson(handoverAmount: 100.50, variance: -0.75),
      ).toEntity();
      expect(entity.variance, equals(-0.75));
    });

    test('closingBalance is never substituted for the handover amount', () {
      final entity = ShiftDetailsModel.fromJson(
        _backendShiftJson(
          handoverAmount: 100.50,
          closingBalance: 999.0,
        ),
      ).toEntity();
      expect(entity.handoverAmount, equals(100.50));
      expect(entity.handoverAmount, isNot(equals(entity.closingBalance)));
    });

    test('absent authoritative handover amount is NOT coerced to zero', () {
      final entity = ShiftDetailsModel.fromJson(
        _backendShiftJson(handoverAmount: null, cashGiven: null),
      ).toEntity();
      expect(entity.cashGiven, isNull);
      expect(entity.handoverAmount, isNull);
    });
  });

  group('GATE A: CASH-09 at halala precision through the production cubit', () {
    late _Ds ds;
    late ApproveAndRejectHandoverCubit cubit;

    setUp(() {
      ds = _Ds();
      cubit = ApproveAndRejectHandoverCubit(ShiftManagementRepositoryImp(ds));
      UserTypeService.selectedUserType = null;
    });

    for (final amount in cases) {
      final expected = amount.toStringAsFixed(2);

      test('exact count $expected accepted; body carries exactly $expected', () async {
        final entity = ShiftDetailsModel.fromJson(
          _backendShiftJson(handoverAmount: amount),
        ).toEntity();

        await cubit.confirmHandoverReceipt(
          shiftId: 'shift-1',
          confirmedAmount: expected,
          expectedAmount: entity.cashGiven,
          actorRole: UserType.branchManager,
        );

        expect(cubit.state, isA<HandoverActionSuccess>());
        expect(ds.approveBody?.confirmedAmount, equals(expected));
      });

      test('0.01 SAR difference from $expected is blocked (CASH-09)', () async {
        final entity = ShiftDetailsModel.fromJson(
          _backendShiftJson(handoverAmount: amount),
        ).toEntity();

        final off = ((amount * 100).round() + 1) / 100;
        await cubit.confirmHandoverReceipt(
          shiftId: 'shift-1',
          confirmedAmount: off.toStringAsFixed(2),
          expectedAmount: entity.cashGiven,
          actorRole: UserType.branchManager,
        );

        expect(cubit.state, isA<HandoverActionFailure>());
        expect(ds.approveBody, isNull);
        expect(ds.acceptBody, isNull);
      });

      test('truncated integer count of $expected is blocked', () async {
        if (amount == amount.truncateToDouble()) return;
        final entity = ShiftDetailsModel.fromJson(
          _backendShiftJson(handoverAmount: amount),
        ).toEntity();

        await cubit.confirmHandoverReceipt(
          shiftId: 'shift-1',
          confirmedAmount: amount.truncate().toString(),
          expectedAmount: entity.cashGiven,
          actorRole: UserType.cashier,
        );

        expect(cubit.state, isA<HandoverActionFailure>());
        expect(ds.acceptBody, isNull);
      });
    }

    test('missing authoritative expected amount fails closed (no assumed 0)', () async {
      await cubit.confirmHandoverReceipt(
        shiftId: 'shift-1',
        confirmedAmount: '0.00',
        expectedAmount: null,
        actorRole: UserType.branchManager,
      );

      expect(cubit.state, isA<HandoverActionFailure>());
      expect(ds.approveBody, isNull);
    });
  });
}
