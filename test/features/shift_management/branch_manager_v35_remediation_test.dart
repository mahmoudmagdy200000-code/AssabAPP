import 'package:flutter_test/flutter_test.dart';
import 'package:assab/core/enums/shift_status/shift_handover_status.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/handover_details_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/screens/end_manager_shift_screen.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/shifts/end_shift/end_shift_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/shifts/reassign_shift/reassign_shift_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/reassign_shift/reassign_shift_params.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/shift_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/end_shift_request.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/variance_model.dart';
import 'package:assab/features/receive_goods/data/models/receive_goods_local_item_model.dart';
import 'package:assab/core/enums/receive_goods_quality_enum.dart';
import 'package:assab/core/utils/api_result.dart';
import 'package:assab/core/utils/future_api_result.dart';
import 'package:assab/features/shift_module_features/shift_management/data/data_source/shift_management_remote_data_source.dart';
import 'package:assab/features/shift_module_features/shift_management/data/repository/shift_management_repository_imp.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/shortage_allocation_candidate.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/end_shift_aggregator_model.dart';

class _FakeRemote implements ShiftManagementRemoteDataSource {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeShift extends Fake implements ShiftEntity {}

class _TestRepo extends ShiftManagementRepositoryImp {
  _TestRepo() : super(_FakeRemote());

  Map<String, dynamic>? lastPreviewBody;
  EndShiftRequest? lastEndShiftRequest;

  @override
  FutureApiResult<Map<String, dynamic>> previewCashReconciliation({
    required String shiftId,
    required double totalSales,
    required double countedCash,
    double? cardPayments,
    List<EndShiftAggregatorModel>? aggregators,
    double? pendingIncomingCash,
  }) async {
    lastPreviewBody = {
      'shiftId': shiftId,
      'totalSales': totalSales,
      'countedCash': countedCash,
      'cardPayments': cardPayments,
      'pendingIncomingCash': pendingIncomingCash,
    };
    return ApiResult.success({
      'data': {
        'cash_reconciliation': {
          'counted_cash': countedCash,
          'expected_cash': 100.0,
          'pending_incoming_cash': pendingIncomingCash ?? 0.0,
          'cash_variance': countedCash - (100.0 + (pendingIncomingCash ?? 0.0)),
          'cash_variance_type': 'balanced',
        },
        'shortage_to_allocate': 0.0,
        'allocation_required': false,
      },
    });
  }

  @override
  FutureApiResult<List<ShortageAllocationCandidate>> getShortageAllocationCandidates({
    required String shiftId,
  }) async {
    return ApiResult.success([]);
  }

  @override
  FutureApiResult<void> endShift({
    required String shiftId,
    required EndShiftRequest endShiftRequest,
  }) async {
    lastEndShiftRequest = endShiftRequest;
    return ApiResult.success(null);
  }
}

HandoverDetailsEntity _createHandover(HandoverStatus status) {
  return HandoverDetailsEntity(
    handoverId: 'ho-1',
    cashierShiftId: 'cs-1',
    cashierName: 'Ali Cashier',
    handoverAmount: 100.0,
    handoverDate: '2026-11-06',
    approvedAt: '2026-11-06',
    handoverTime: '12:00:00',
    handoverFrom: 'Ali',
    handoverTo: 'Manager',
    varianceAmount: 0.0,
    totalSales: 500.0,
    handoverNotes: null,
    handoverStatus: status,
  );
}

void main() {
  group('BM-01 & BM-02: Workday Closure Handover Validation (DAY-03 / CASH-15)', () {
    test('canProceedFromHandovers returns true when workday has zero handovers', () {
      final result = EndManagerShiftScreen.canProceedFromHandovers([]);
      expect(result, isTrue);
    });

    test('canProceedFromHandovers returns true when all handovers are accepted', () {
      final handovers = [
        _createHandover(HandoverStatus.accepted),
        _createHandover(HandoverStatus.accepted),
      ];
      final result = EndManagerShiftScreen.canProceedFromHandovers(handovers);
      expect(result, isTrue);
    });

    test('canProceedFromHandovers returns false when any handover is pending', () {
      final handovers = [
        _createHandover(HandoverStatus.accepted),
        _createHandover(HandoverStatus.pending),
      ];
      final result = EndManagerShiftScreen.canProceedFromHandovers(handovers);
      expect(result, isFalse);
    });

    test('canProceedFromHandovers returns false when any handover is rejected', () {
      final handovers = [
        _createHandover(HandoverStatus.accepted),
        _createHandover(HandoverStatus.rejected),
      ];
      final result = EndManagerShiftScreen.canProceedFromHandovers(handovers);
      expect(result, isFalse);
    });

    test('canProceedFromHandovers returns false when any handover is rejectedFinal', () {
      final handovers = [
        _createHandover(HandoverStatus.rejectedFinal),
      ];
      final result = EndManagerShiftScreen.canProceedFromHandovers(handovers);
      expect(result, isFalse);
    });

    test('handoverStatus serialization correctly supports rejected_final', () {
      expect(handoverStatusFromJson('rejected_final'), equals(HandoverStatus.rejectedFinal));
      expect(handoverStatusFromJson('rejectedFinal'), equals(HandoverStatus.rejectedFinal));
      expect(handoverStatusToJson(HandoverStatus.rejectedFinal), equals('rejected_final'));
    });
  });

  group('BM-05: Financial Amounts and VAT Decimal Calculation (SAL-02)', () {
    late _TestRepo repo;
    late EndShiftCubit endShiftCubit;
    late ReassignShiftCubit reassignShiftCubit;

    setUp(() {
      repo = _TestRepo();
      endShiftCubit = EndShiftCubit(repo, 'shift-1', null);
      reassignShiftCubit = ReassignShiftCubit(
        repo,
        ReassignShiftParams(
          shift: _FakeShift(),
          previousCashier: null,
          nextCashier: null,
        ),
      );
    });

    tearDown(() {
      endShiftCubit.close();
      reassignShiftCubit.close();
    });

    test('EndShiftCubit parses whole, decimal, and formatted sales without returning 0.00', () {
      // 115.00 SAR: net sales = 100.00, VAT = 15.00
      expect(endShiftCubit.calculateNetSales('115'), equals('100.00'));
      expect(endShiftCubit.calculateNetVal('115'), equals('15.00'));

      expect(endShiftCubit.calculateNetSales('115.00'), equals('100.00'));
      expect(endShiftCubit.calculateNetVal('115.00'), equals('15.00'));

      // 115.50 SAR: net sales = 100.43, VAT = 15.07
      expect(endShiftCubit.calculateNetSales('115.50'), equals('100.43'));
      expect(endShiftCubit.calculateNetVal('115.50'), equals('15.07'));

      // Formatted string with comma
      expect(endShiftCubit.calculateNetSales('1,150.00'), equals('1000.00'));
      expect(endShiftCubit.calculateNetVal('1,150.00'), equals('150.00'));
    });

    test('ReassignShiftCubit parses whole, decimal, and formatted sales without returning 0.00', () {
      expect(reassignShiftCubit.calculateNetSales('115.00'), equals('100.00'));
      expect(reassignShiftCubit.calculateNetVal('115.00'), equals('15.00'));
      expect(reassignShiftCubit.calculateNetSales('115.50'), equals('100.43'));
      expect(reassignShiftCubit.calculateNetVal('115.50'), equals('15.07'));
    });
  });

  group('BM-15: Pending Incoming Cash Handling (CASH-08)', () {
    late _TestRepo repo;
    late EndShiftCubit cubit;

    setUp(() {
      repo = _TestRepo();
      cubit = EndShiftCubit(repo, 'shift-1', null);
    });

    tearDown(() {
      cubit.close();
    });

    test('EndShiftRequest serializes pending_incoming_cash into form data when > 0', () async {
      final request = EndShiftRequest(
        totalSales: 100.0,
        cashCollected: 100.0,
        cardPayments: 0.0,
        countedCash: 600.0,
        pendingIncomingCash: 500.0,
        aggregators: [],
        variance: Variance(
          currentCashierAmount: 0.0,
          responsibilityType: 'none',
          otherCashiers: [],
          supportingFiles: [],
          reason: 'none',
        ),
        isThereVariance: false,
      );

      final formData = await request.toFormData();
      final fields = Map.fromEntries(formData.fields);
      expect(fields['pending_incoming_cash'], equals('500.00'));
      expect(fields['counted_cash'], equals('600.00'));
    });

    test('EndShiftRequest omits pending_incoming_cash when null or 0.0', () async {
      final request = EndShiftRequest(
        totalSales: 100.0,
        cashCollected: 100.0,
        cardPayments: 0.0,
        countedCash: 100.0,
        pendingIncomingCash: null,
        aggregators: [],
        variance: Variance(
          currentCashierAmount: 0.0,
          responsibilityType: 'none',
          otherCashiers: [],
          supportingFiles: [],
          reason: 'none',
        ),
        isThereVariance: false,
      );

      final formData = await request.toFormData();
      final fields = Map.fromEntries(formData.fields);
      expect(fields.containsKey('pending_incoming_cash'), isFalse);
    });

    test('EndShiftCubit passes pendingIncomingCash to preview and end shift calls', () async {
      cubit.setCountedCash(600.0);
      cubit.updatePendingIncomingCash(500.0);
      expect(cubit.pendingIncomingCash, equals(500.0));

      final success = await cubit.fetchCashReconciliationPreview();
      expect(success, isTrue);
      expect(repo.lastPreviewBody!['pendingIncomingCash'], equals(500.0));

      // End shift call propagates pending incoming cash
      await cubit.endShift(
        variance: Variance(
          currentCashierAmount: 0.0,
          responsibilityType: 'none',
          otherCashiers: [],
          supportingFiles: [],
          reason: 'none',
        ),
        isThereVariance: false,
      );

      expect(repo.lastEndShiftRequest, isNotNull);
      expect(repo.lastEndShiftRequest!.pendingIncomingCash, equals(500.0));
      final formData = await repo.lastEndShiftRequest!.toFormData();
      final fields = Map.fromEntries(formData.fields);
      expect(fields['pending_incoming_cash'], equals('500.00'));
    });
  });

  group('BM-16: Purchase Receiving VAT Handling (PUR-05)', () {
    test('ReceiveGoodsLocalItemModel supports custom vatRate (0% vs 15%)', () {
      final zeroVatItem = ReceiveGoodsLocalItemModel(
        itemId: 'item-1',
        productName: 'Fresh Produce',
        itemLogo: null,
        qtyOrdered: 10,
        qtyReceived: 10,
        unitPrice: 50.0,
        quality: ReceiveGoodsQualityEnum.normal,
        termperature: 4,
        unit: 'KG',
        isVariance: false,
        expirationDate: '2026-12-31',
        vatRate: 0.0,
      );

      final standardVatItem = ReceiveGoodsLocalItemModel(
        itemId: 'item-2',
        productName: 'Packaging Material',
        itemLogo: null,
        qtyOrdered: 10,
        qtyReceived: 10,
        unitPrice: 50.0,
        quality: ReceiveGoodsQualityEnum.normal,
        termperature: 20,
        unit: 'Box',
        isVariance: false,
        expirationDate: '2027-12-31',
        vatRate: 0.15,
      );

      // 0% VAT invoice calculation
      final totalBeforeTax0 = zeroVatItem.unitPrice * zeroVatItem.qtyReceived; // 500.0
      final vatAmount0 = totalBeforeTax0 * (zeroVatItem.vatRate ?? 0.15); // 0.0
      final totalWithVat0 = totalBeforeTax0 + vatAmount0; // 500.0
      expect(vatAmount0, equals(0.0));
      expect(totalWithVat0, equals(500.0));

      // 15% VAT invoice calculation
      final totalBeforeTax15 = standardVatItem.unitPrice * standardVatItem.qtyReceived; // 500.0
      final vatAmount15 = totalBeforeTax15 * (standardVatItem.vatRate ?? 0.15); // 75.0
      final totalWithVat15 = totalBeforeTax15 + vatAmount15; // 575.0
      expect(vatAmount15, equals(75.0));
      expect(totalWithVat15, equals(575.0));
    });
  });
}
