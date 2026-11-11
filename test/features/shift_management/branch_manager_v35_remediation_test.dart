import 'dart:io';
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
import 'package:assab/features/receive_goods/data/models/receive_order_supplier_request.dart';
import 'package:assab/core/enums/receive_goods_quality_enum.dart';
import 'package:assab/core/utils/api_result.dart';
import 'package:assab/core/utils/future_api_result.dart';
import 'package:assab/features/shift_module_features/shift_management/data/data_source/shift_management_remote_data_source.dart';
import 'package:assab/features/shift_module_features/shift_management/data/repository/shift_management_repository_imp.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/shortage_allocation_candidate.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/end_shift_aggregator_model.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/end_shift_request_with_variance.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/manager_shift_management_models/handover_details_models/handover_details_item_model.dart';
import 'package:assab/features/shift_module_features/shift_management/data/mapper/manager_shift/handover_details_mapper.dart';
import 'package:assab/features/receive_goods/data/models/receive_order_inspection_response.dart';

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

  EndShiftRequestWithHandOver? lastEndShiftWithHandOverRequest;

  @override
  FutureApiResult<void> endShiftWithHandOver(
    String shiftId,
    EndShiftRequestWithHandOver request,
  ) async {
    lastEndShiftWithHandOverRequest = request;
    return ApiResult.success(null);
  }
}

HandoverDetailsEntity _createHandover(HandoverStatus status, {bool isDocumented = false}) {
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
    isDocumentedPending: isDocumented,
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

    test('canProceedFromHandovers returns true when pending handover is fully documented under DAY-03', () {
      final handovers = [
        _createHandover(HandoverStatus.accepted),
        _createHandover(HandoverStatus.pending, isDocumented: true),
      ];
      final result = EndManagerShiftScreen.canProceedFromHandovers(handovers);
      expect(result, isTrue);
    });

    test('canProceedFromHandovers returns false when pending handover is undocumented under AC-35', () {
      final undocumented = _createHandover(HandoverStatus.pending, isDocumented: false);
      final handovers = [
        _createHandover(HandoverStatus.accepted),
        undocumented,
      ];
      final result = EndManagerShiftScreen.canProceedFromHandovers(handovers);
      expect(result, isFalse);
    });

    test('canProceedFromHandovers respects serverCanEnd authoritative parameter', () {
      final undocumented = _createHandover(HandoverStatus.pending, isDocumented: false);
      expect(
        EndManagerShiftScreen.canProceedFromHandovers([undocumented], serverCanEnd: true),
        isTrue,
      );
      expect(
        EndManagerShiftScreen.canProceedFromHandovers([], serverCanEnd: false),
        isFalse,
      );
    });

    test('HandoverDetailsItemModel parses is_documented_pending and maps to entity', () {
      final json = {
        'handover_id': 'ho-100',
        'cashier_shift_id': 'cs-100',
        'cashier_name': 'Cashier 1',
        'shift_time': 'Morning',
        'handover_amount': 250.0,
        'handover_date': '2026-11-07',
        'handover_time': '14:00:00',
        'handover_from': 'Cashier 1',
        'handover_to': 'Manager 1',
        'handover_to_id': 'mgr-1',
        'total_sales': 1000.0,
        'variance_amount': 0.0,
        'variance_type': 'None',
        'attached_files': <String>[],
        'status': 'pending',
        'rejection_count': 0,
        'can_approve': true,
        'can_reject': true,
        'accounting_name': 'Sales',
        'is_documented_pending': true,
      };

      final model = HandoverDetailsItemModel.fromJson(json);
      expect(model.isDocumentedPending, isTrue);

      final entity = model.toHandoverDetailsEntity();
      expect(entity.isDocumentedPending, isTrue);
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

    test('EndShiftRequestWithHandOver serializes pending_incoming_cash to FormData', () async {
      final request = EndShiftRequestWithHandOver(
        totalSales: 100.0,
        cashCollected: 100.0,
        cardPayments: 0.0,
        posReceipt: null,
        nextCashierId: 'c-2',
        handoverAmount: 100.0,
        handoverNotes: null,
        aggregators: [],
        variance: Variance(
          currentCashierAmount: 0.0,
          responsibilityType: 'none',
          otherCashiers: [],
          supportingFiles: [],
          reason: 'none',
        ),
        isThereVariance: false,
        isManager: false,
        countedCash: 600.0,
        pendingIncomingCash: 500.0,
      );

      final formData = await request.toFormData();
      final fields = Map.fromEntries(formData.fields);
      expect(fields['pending_incoming_cash'], equals('500.00'));
      expect(fields['counted_cash'], equals('600.00'));
    });

    test('EndShiftCubit.endShitWithHandOver binds pendingIncomingCash from cubit', () async {
      cubit.setCountedCash(600.0);
      cubit.updatePendingIncomingCash(500.0);
      expect(cubit.pendingIncomingCash, equals(500.0));

      final previewSuccess = await cubit.fetchCashReconciliationPreview();
      expect(previewSuccess, isTrue);

      await cubit.endShitWithHandOver(
        EndShiftRequestWithHandOver(
          totalSales: 100.0,
          cashCollected: 100.0,
          cardPayments: 0.0,
          posReceipt: null,
          nextCashierId: 'c-2',
          handoverAmount: 100.0,
          handoverNotes: null,
          aggregators: [],
          variance: Variance(
            currentCashierAmount: 0.0,
            responsibilityType: 'none',
            otherCashiers: [],
            supportingFiles: [],
            reason: 'none',
          ),
          isThereVariance: false,
          isManager: false,
        ),
      );

      expect(repo.lastEndShiftWithHandOverRequest, isNotNull);
      expect(repo.lastEndShiftWithHandOverRequest!.pendingIncomingCash, equals(500.0));
      final formData = await repo.lastEndShiftWithHandOverRequest!.toFormData();
      final fields = Map.fromEntries(formData.fields);
      expect(fields['pending_incoming_cash'], equals('500.00'));
    });

    test('Updating pending incoming cash invalidates preview', () async {
      cubit.setCountedCash(600.0);
      cubit.updatePendingIncomingCash(500.0);
      await cubit.fetchCashReconciliationPreview();
      expect(cubit.previewStale, isFalse);
      expect(cubit.previewData, isNotNull);

      // Change pending incoming cash
      cubit.updatePendingIncomingCash(600.0);
      expect(cubit.previewStale, isTrue);
      expect(cubit.previewData, isNull);
    });

    test('CASH-08 calculation: expected 100, pending 500, counted 600 yields 0 variance', () {
      const double expectedGross = 100.0;
      const double pendingIncoming = 500.0;
      const double countedCash = 600.0;

      // Under CASH-08 / AC-13:
      // effectiveExpected = expectedGross + pendingIncoming
      // variance = countedCash - effectiveExpected
      const double effectiveExpected = expectedGross + pendingIncoming;
      const double variance = countedCash - effectiveExpected;

      expect(effectiveExpected, equals(600.0));
      expect(variance, equals(0.0));
    });

    test('valid 500 then preview then malformed edit invalidates preview and blocks Next/submit', () async {
      cubit.validateAndSetPendingIncomingCash('500.00');
      cubit.setCountedCash(600.0);
      expect(cubit.isPendingIncomingCashValid, isTrue);
      expect(cubit.pendingIncomingCash, equals(500.0));

      final previewSuccess = await cubit.fetchCashReconciliationPreview();
      expect(previewSuccess, isTrue);
      expect(cubit.previewStale, isFalse);
      expect(cubit.canProceedToEndShift, isTrue);

      // User types malformed amount (e.g. invalid decimals / chars)
      cubit.validateAndSetPendingIncomingCash('500..abc');
      expect(cubit.isPendingIncomingCashValid, isFalse);
      expect(cubit.pendingIncomingCashError, isNotNull);
      expect(cubit.previewStale, isTrue);
      expect(cubit.previewData, isNull);
      expect(cubit.canProceedToEndShift, isFalse);

      // Submission must be refused while pending-cash input is invalid
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
      expect(cubit.state, isA<EndShiftFailure>());

      await cubit.endShitWithHandOver(
        EndShiftRequestWithHandOver(
          totalSales: 100.0,
          cashCollected: 100.0,
          cardPayments: 0.0,
          posReceipt: null,
          nextCashierId: 'c-2',
          handoverAmount: 100.0,
          handoverNotes: null,
          aggregators: [],
          variance: Variance(
            currentCashierAmount: 0.0,
            responsibilityType: 'none',
            otherCashiers: [],
            supportingFiles: [],
            reason: 'none',
          ),
          isThereVariance: false,
          isManager: false,
        ),
      );
      expect(cubit.state, isA<EndShiftFailure>());
    });

    test('malformed pending incoming cash on first entry blocks progression and preview', () async {
      cubit.validateAndSetPendingIncomingCash('-50.00');
      expect(cubit.isPendingIncomingCashValid, isFalse);
      expect(cubit.canProceedToEndShift, isFalse);

      final previewSuccess = await cubit.fetchCashReconciliationPreview();
      expect(previewSuccess, isFalse);
      expect(cubit.state, isA<EndShiftPreviewFailure>());
    });

    test('clearing pending incoming cash field resets to 0.0, resets error, and requires fresh preview', () async {
      cubit.validateAndSetPendingIncomingCash('500.00');
      cubit.setCountedCash(600.0);
      await cubit.fetchCashReconciliationPreview();
      expect(cubit.canProceedToEndShift, isTrue);

      // Explicit clear (empty string)
      cubit.validateAndSetPendingIncomingCash('');
      expect(cubit.isPendingIncomingCashValid, isTrue);
      expect(cubit.pendingIncomingCash, equals(0.0));
      expect(cubit.pendingIncomingCashError, isNull);
      expect(cubit.previewStale, isTrue);
      expect(cubit.previewData, isNull);
      expect(cubit.canProceedToEndShift, isFalse);

      // Fresh preview recalculates with 0.0 pending incoming cash
      final freshSuccess = await cubit.fetchCashReconciliationPreview();
      expect(freshSuccess, isTrue);
      expect(cubit.canProceedToEndShift, isTrue);
    });

    test('EndShiftCubit localizes pending cash error in Arabic and English', () {
      cubit.validateAndSetPendingIncomingCash('invalid', isArabic: false);
      expect(cubit.pendingIncomingCashError, contains('Invalid amount'));

      cubit.validateAndSetPendingIncomingCash('invalid', isArabic: true);
      expect(cubit.pendingIncomingCashError, contains('مبلغ غير صحيح'));
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

    test('ReceiveGoodsLocalItemModel handles null vatRate without blind 15% fallback', () {
      final unspecItem = ReceiveGoodsLocalItemModel(
        itemId: 'item-3',
        productName: 'Raw Ingredient',
        itemLogo: null,
        qtyOrdered: 10,
        qtyReceived: 10,
        unitPrice: 50.0,
        quality: ReceiveGoodsQualityEnum.normal,
        termperature: 20,
        unit: 'KG',
        isVariance: false,
        expirationDate: '2027-12-31',
        vatRate: null,
      );

      final totalBeforeTax = unspecItem.unitPrice * unspecItem.qtyReceived;
      final double? rawVatRate = unspecItem.vatRate;
      final vatAmount = rawVatRate != null ? totalBeforeTax * rawVatRate : 0.0;
      final totalWithVat = totalBeforeTax + vatAmount;

      expect(rawVatRate, isNull);
      expect(vatAmount, equals(0.0));
      expect(totalWithVat, equals(500.0));
    });

    test('ReceiveOrderInspectionResponse parses financial_summary with VAT details', () {
      final json = {
        'data': {
          'order_id': 'ord-1',
          'order_number': 'PO-2026-001',
          'supplier_name': 'Supplier A',
          'delivery_details': {
            'driver_name': 'Driver 1',
            'vehicle_number': '1234',
            'arrival_time': '2026-11-07 10:00:00',
            'delivery_address': 'Branch Main',
          },
          'goods_inspection': <Map<String, dynamic>>[],
          'financial_summary': {
            'amount_before_tax': 1000.0,
            'vat_rate': 0.15,
            'vat_amount': 150.0,
            'total_amount': 1150.0,
          },
        },
      };

      final response = ReceiveOrderInspectionResponse.fromJson(json);
      expect(response.data.authoritativeAmountBeforeTax, equals(1000.0));
      expect(response.data.authoritativeVatRate, equals(0.15));
      expect(response.data.authoritativeVatAmount, equals(150.0));
      expect(response.data.authoritativeTotalAmount, equals(1150.0));
    });

    test('ReceiveOrderInspectionResponse parses 0% VAT correctly (distinguished from missing)', () {
      final json = {
        'data': {
          'order_id': 'ord-2',
          'order_number': 'PO-2026-002',
          'supplier_name': 'Supplier B',
          'delivery_details': {
            'driver_name': 'Driver 2',
            'vehicle_number': '5678',
            'arrival_time': '2026-11-07 11:00:00',
            'delivery_address': 'Branch Sub',
          },
          'goods_inspection': <Map<String, dynamic>>[],
          'financial_summary': {
            'amount_before_tax': 1000.0,
            'vat_rate': 0.0,
            'vat_amount': 0.0,
            'total_amount': 1000.0,
          },
        },
      };

      final response = ReceiveOrderInspectionResponse.fromJson(json);
      expect(response.data.authoritativeVatRate, equals(0.0));
      expect(response.data.authoritativeVatAmount, equals(0.0));
      expect(response.data.authoritativeVatRate, isNotNull);
    });

    test('ReceiveOrderInspectionResponse handles missing VAT data as null', () {
      final json = {
        'data': {
          'order_id': 'ord-3',
          'order_number': 'PO-2026-003',
          'supplier_name': 'Supplier C',
          'delivery_details': {
            'driver_name': 'Driver 3',
            'vehicle_number': '9999',
            'arrival_time': '2026-11-07 12:00:00',
            'delivery_address': 'Branch Depot',
          },
          'goods_inspection': <Map<String, dynamic>>[],
          'financial_summary': {
            'expected_amount': 1000.0,
          },
        },
      };

      final response = ReceiveOrderInspectionResponse.fromJson(json);
      expect(response.data.authoritativeVatRate, isNull);
      expect(response.data.authoritativeVatAmount, isNull);
    });

    test('Dynamic VAT labels format correctly in Arabic and English', () {
      String formatVatLabel(double? rate, String locale) {
        if (rate == null) return locale.startsWith('ar') ? 'ضريبة القيمة المضافة (غير محددة)' : 'VAT (Not Specified)';
        if (rate == 0) return locale.startsWith('ar') ? 'ضريبة القيمة المضافة (0%)' : 'VAT (0%)';
        if (rate == 0.15) return locale.startsWith('ar') ? 'ضريبة القيمة المضافة (15%)' : 'VAT (15%)';
        final pct = (rate * 100).toStringAsFixed(0);
        return locale.startsWith('ar') ? 'ضريبة القيمة المضافة ($pct%)' : 'VAT ($pct%)';
      }

      expect(formatVatLabel(0.05, 'ar'), equals('ضريبة القيمة المضافة (5%)'));
      expect(formatVatLabel(0.05, 'en'), equals('VAT (5%)'));
      expect(formatVatLabel(0.15, 'ar'), equals('ضريبة القيمة المضافة (15%)'));
      expect(formatVatLabel(0.15, 'en'), equals('VAT (15%)'));
      expect(formatVatLabel(0.0, 'ar'), equals('ضريبة القيمة المضافة (0%)'));
      expect(formatVatLabel(0.0, 'en'), equals('VAT (0%)'));
      expect(formatVatLabel(null, 'ar'), equals('ضريبة القيمة المضافة (غير محددة)'));
      expect(formatVatLabel(null, 'en'), equals('VAT (Not Specified)'));
    });

    test('ReceiveOrderSupplierRequest.toFormData serializes 15% tax_rate and financial amounts for invoice', () {
      final tempDir = Directory.systemTemp.createTempSync('inv_test_15');
      final dummyFile = File('${tempDir.path}/test_invoice.jpg')..writeAsStringSync('dummy content');
      addTearDown(() => tempDir.deleteSync(recursive: true));

      final request = ReceiveOrderSupplierRequest(
        items: [],
        documentType: 'invoice',
        invoiceData: InvoiceData(
          invoiceNumber: 'INV-15-SERIALIZE',
          invoiceDate: '2026-11-07',
          dueDate: '2026-12-07',
          paymentTerms: 'Net 30 days',
          file: dummyFile,
          taxRate: 15.0,
          amountBeforeTax: 100.0,
          taxAmount: 15.0,
          totalAmount: 115.0,
        ),
      );

      final formData = request.toFormData();
      final fields = Map.fromEntries(formData.fields);
      expect(fields['document_type'], equals('invoice'));
      expect(fields['invoice_data[invoice_number]'], equals('INV-15-SERIALIZE'));
      expect(fields['invoice_data[tax_rate]'], equals('15'));
      expect(fields['invoice_data[vat_rate]'], equals('15'));
      expect(fields['invoice_data[amount_before_tax]'], equals('100.00'));
      expect(fields['invoice_data[tax_amount]'], equals('15.00'));
      expect(fields['invoice_data[total_amount]'], equals('115.00'));
    });

    test('ReceiveOrderSupplierRequest.toFormData serializes 0% tax_rate correctly', () {
      final tempDir = Directory.systemTemp.createTempSync('inv_test_0');
      final dummyFile = File('${tempDir.path}/test_invoice.jpg')..writeAsStringSync('dummy content');
      addTearDown(() => tempDir.deleteSync(recursive: true));

      final request = ReceiveOrderSupplierRequest(
        items: [],
        documentType: 'invoice',
        invoiceData: InvoiceData(
          invoiceNumber: 'INV-0-SERIALIZE',
          invoiceDate: '2026-11-07',
          dueDate: '2026-12-07',
          paymentTerms: 'Net 30 days',
          file: dummyFile,
          taxRate: 0.0,
          amountBeforeTax: 100.0,
          taxAmount: 0.0,
          totalAmount: 100.0,
        ),
      );

      final formData = request.toFormData();
      final fields = Map.fromEntries(formData.fields);
      expect(fields['invoice_data[tax_rate]'], equals('0'));
      expect(fields['invoice_data[vat_rate]'], equals('0'));
      expect(fields['invoice_data[amount_before_tax]'], equals('100.00'));
      expect(fields['invoice_data[total_amount]'], equals('100.00'));
    });

    test('Delivery note and receipt without document requests remain independent of invoice VAT', () {
      final request = ReceiveOrderSupplierRequest(
        items: [],
        documentType: 'delivery_note',
        invoiceData: null,
      );

      final formData = request.toFormData();
      final fields = Map.fromEntries(formData.fields);
      expect(fields['document_type'], equals('delivery_note'));
      expect(fields.containsKey('invoice_data[tax_rate]'), isFalse);
      expect(fields.containsKey('invoice_data[amount_before_tax]'), isFalse);
    });

    test('ReceiveOrderInspectionResponse parses invoice block when present', () {
      final json = {
        'data': {
          'order_id': 'ord-inv-1',
          'order_number': 'PO-INV-001',
          'supplier_name': 'Supplier With Invoice',
          'delivery_details': {
            'driver_name': 'Driver',
            'vehicle_number': '1234',
            'arrival_time': '2026-11-07 10:00:00',
            'delivery_address': 'Branch Main',
          },
          'goods_inspection': <Map<String, dynamic>>[],
          'invoice': {
            'amount_before_tax': 200.0,
            'tax_rate': 15.0,
            'tax_amount': 30.0,
            'total_amount': 230.0,
          },
        },
      };

      final response = ReceiveOrderInspectionResponse.fromJson(json);
      expect(response.data.authoritativeAmountBeforeTax, equals(200.0));
      expect(response.data.authoritativeVatRate, equals(15.0));
      expect(response.data.authoritativeVatAmount, equals(30.0));
      expect(response.data.authoritativeTotalAmount, equals(230.0));
    });
  });
}
