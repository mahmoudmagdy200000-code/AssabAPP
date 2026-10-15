import 'package:assab/features/shift_module_features/shift_management/data/model/shift/cash_shortage_allocation.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/end_shift_request.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/end_shift_request_with_variance.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/variance_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EndShiftRequest Contract Tests', () {
    final sampleVariance = Variance(
      responsibilityType: 'none',
      currentCashierAmount: 0.0,
      reason: '',
      otherCashiers: [],
      supportingFiles: [],
    );

    test('counted_cash differentiates null from legitimate zero 0.00', () async {
      // 1. null countedCash -> key not present
      final requestNull = EndShiftRequest(
        totalSales: 1000.0,
        cashCollected: 500.0,
        cardPayments: 500.0,
        aggregators: [],
        variance: sampleVariance,
        isThereVariance: false,
        countedCash: null,
      );
      final formDataNull = await requestNull.toFormData();
      final mapNull = Map.fromEntries(formDataNull.fields);
      expect(mapNull.containsKey('counted_cash'), isFalse);

      // 2. zero countedCash -> serializes as '0.00'
      final requestZero = EndShiftRequest(
        totalSales: 1000.0,
        cashCollected: 0.0,
        cardPayments: 1000.0,
        aggregators: [],
        variance: sampleVariance,
        isThereVariance: false,
        countedCash: 0.0,
      );
      final formDataZero = await requestZero.toFormData();
      final mapZero = Map.fromEntries(formDataZero.fields);
      expect(mapZero.containsKey('counted_cash'), isTrue);
      expect(mapZero['counted_cash'], equals('0.00'));

      // 3. positive countedCash -> formatted with 2 decimal places
      final requestVal = EndShiftRequest(
        totalSales: 1250.75,
        cashCollected: 650.5,
        cardPayments: 600.25,
        aggregators: [],
        variance: sampleVariance,
        isThereVariance: false,
        countedCash: 650.5,
      );
      final formDataVal = await requestVal.toFormData();
      final mapVal = Map.fromEntries(formDataVal.fields);
      expect(mapVal['counted_cash'], equals('650.50'));
    });

    test('shortage_allocations and reason are serialized properly', () async {
      final allocations = const [
        CashShortageAllocation(
          responsibleType: 'cashier',
          responsibleId: '101',
          amount: 30.50,
          name: 'Cashier Ahmed',
        ),
        CashShortageAllocation(
          responsibleType: 'branch_manager',
          responsibleId: '5',
          amount: 20.00,
          name: 'Manager Khaled',
        ),
      ];

      final request = EndShiftRequest(
        totalSales: 1000.0,
        cashCollected: 450.0,
        cardPayments: 500.0,
        aggregators: [],
        variance: sampleVariance,
        isThereVariance: false,
        countedCash: 450.0,
        shortageAllocations: allocations,
        allocationReason: 'Unaccounted register discrepancy at closing',
      );

      final formData = await request.toFormData();
      final map = Map.fromEntries(formData.fields);

      expect(map['counted_cash'], equals('450.00'));
      expect(map['shortage_allocations[0][responsible_type]'], equals('cashier'));
      expect(map['shortage_allocations[0][responsible_id]'], equals('101'));
      expect(map['shortage_allocations[0][amount]'], equals('30.50'));

      expect(map['shortage_allocations[1][responsible_type]'], equals('branch_manager'));
      expect(map['shortage_allocations[1][responsible_id]'], equals('5'));
      expect(map['shortage_allocations[1][amount]'], equals('20.00'));

      expect(map['allocation_reason'], equals('Unaccounted register discrepancy at closing'));
    });
  });

  group('EndShiftRequestWithHandOver Contract Tests', () {
    final sampleVariance = Variance(
      responsibilityType: 'none',
      currentCashierAmount: 0.0,
      reason: '',
      otherCashiers: [],
      supportingFiles: [],
    );

    test('isManager: true uses branch_manager_id without breaking next_cashier_id for false', () async {
      // 1. Handover to Manager -> uses branch_manager_id (fixes 422 to_branch_manager error)
      final requestManager = EndShiftRequestWithHandOver(
        totalSales: 800.0,
        cashCollected: 400.0,
        cardPayments: 400.0,
        posReceipt: null,
        nextCashierId: '42',
        handoverAmount: 400.0,
        handoverNotes: 'Manager handover note',
        aggregators: [],
        variance: sampleVariance,
        isThereVariance: false,
        isManager: true,
        countedCash: 400.0,
      );
      final formDataManager = await requestManager.toFormData();
      final mapManager = Map.fromEntries(formDataManager.fields);

      expect(mapManager['branch_manager_id'], equals('42'));
      expect(mapManager.containsKey('to_branch_manager'), isFalse);
      expect(mapManager.containsKey('next_cashier_id'), isFalse);
      expect(mapManager['handover_to_type'], equals('branch_manager'));
      expect(mapManager['counted_cash'], equals('400.00'));

      // 2. Handover to Cashier -> preserves next_cashier_id
      final requestCashier = EndShiftRequestWithHandOver(
        totalSales: 800.0,
        cashCollected: 400.0,
        cardPayments: 400.0,
        posReceipt: null,
        nextCashierId: '99',
        handoverAmount: 400.0,
        handoverNotes: 'Next cashier note',
        aggregators: [],
        variance: sampleVariance,
        isThereVariance: false,
        isManager: false,
        countedCash: 400.0,
      );
      final formDataCashier = await requestCashier.toFormData();
      final mapCashier = Map.fromEntries(formDataCashier.fields);

      expect(mapCashier['next_cashier_id'], equals('99'));
      expect(mapCashier.containsKey('branch_manager_id'), isFalse);
      expect(mapCashier.containsKey('to_branch_manager'), isFalse);
      expect(mapCashier['handover_to_type'], equals('cashier'));
    });

    test('EndShiftRequestWithHandOver serializes zero counted cash and shortage allocations', () async {
      final allocations = const [
        CashShortageAllocation(
          responsibleType: 'cashier',
          responsibleId: '12',
          amount: 50.00,
          name: 'Cashier Sara',
        ),
      ];

      final request = EndShiftRequestWithHandOver(
        totalSales: 500.0,
        cashCollected: 0.0,
        cardPayments: 500.0,
        posReceipt: null,
        nextCashierId: '10',
        handoverAmount: 0.0,
        handoverNotes: null,
        aggregators: [],
        variance: sampleVariance,
        isThereVariance: false,
        isManager: true,
        countedCash: 0.0,
        shortageAllocations: allocations,
        allocationReason: 'Draw shortage allocated to Sara',
      );

      final formData = await request.toFormData();
      final map = Map.fromEntries(formData.fields);

      expect(map['counted_cash'], equals('0.00'));
      expect(map['shortage_allocations[0][responsible_type]'], equals('cashier'));
      expect(map['shortage_allocations[0][responsible_id]'], equals('12'));
      expect(map['shortage_allocations[0][amount]'], equals('50.00'));
      expect(map['allocation_reason'], equals('Draw shortage allocated to Sara'));
    });
  });
}
