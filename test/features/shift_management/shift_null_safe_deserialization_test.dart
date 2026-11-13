import 'package:assab/features/branch_manager_requests/data/models/handovers_response.dart';
import 'package:assab/features/branch_manager_requests/data/models/variances_response.dart';
import 'package:assab/features/cashier_home/data/models/cashier_branch_info_response.dart';
import 'package:assab/features/cashier_home/data/models/cashier_info_response.dart';
import 'package:assab/features/cashier_my_shifts/data/mapper/shift_status_mappers/cashier_pending_shift_mapper.dart';
import 'package:assab/features/cashier_my_shifts/data/mapper/shift_status_mappers/cashier_reassigned_shift_mapper.dart';
import 'package:assab/features/cashier_my_shifts/data/model/shifts_models/pending/cashier_pending_shift_model.dart';
import 'package:assab/features/cashier_my_shifts/data/model/shifts_models/reassigned/cashier_reassigned_shift_model.dart';
import 'package:assab/features/cashier_my_shifts/domain/enums/my_shifts_status.dart';
import 'package:assab/features/cashier_requests/data/models/reassigned_shift_item_model.dart';
import 'package:assab/features/shift_module_features/shift_management/data/mapper/shift/shift_mapper.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/manager_shift_management_models/cashier_handover_models/cashier_handover_details_model.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/manager_shift_management_models/handover_details_models/handover_details_item_model.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/available_cashiers_response_model.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/shift_details/shift_details_model.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/shift_response_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('en', null);
  });

  group('Shift & Cashier Null-Safe Deserialization Tests', () {
    test('ShiftResponseModel parses staging payload where assigned_by has null fields', () {
      final json = {
        'success': true,
        'message': 'Shifts retrieved successfully',
        'data': [
          {
            'id': 'shift-101',
            'shift_date': '2026-11-06',
            'status': 'not_started',
            'cashier': {
              'id': 'c-1',
              'name': 'يوسف الدوسري',
              'email': 'yousef.aldosari@daralhail.test',
              'phone': '+966500000102',
              'store_branch_name': 'فرع الملقا – الرياض',
              'store_branch_id': 'b-1',
              'created_at': '2026-11-05 20:00:00',
            },
            'shift': {
              'id': 's-1',
              'name': 'الوردية الرئيسية',
              'branch_id': 'b-1',
              'branch_name': 'فرع الملقا – الرياض',
              'is_active': true,
              'start_time': '08:00',
              'end_time': '23:59',
              // Exact staging payload causing screenshot crash:
              'assigned_by': {
                'id': null,
                'name': null,
                'user_type': null,
              },
            },
            'opening_balance': 0,
            'closing_balance': null,
            'expected_balance': 0,
            'total_sales': 0,
            'net_sales': 0,
            'vat_amount': 0,
            'cash_collected': 0,
            'card_payments': 0,
            'variance': 0,
            'next_cashier': null,
            'reassignment': null,
          }
        ],
        'meta': {
          'total': 1,
          'count': 1,
          'per_page': 15,
          'current_page': 1,
          'total_pages': 1,
        },
      };

      final response = ShiftResponseModel.fromJson(json);
      expect(response.data.length, 1);
      final shift = response.data.first;
      expect(shift.id, 'shift-101');
      expect(shift.shift.assignedBy, isNull);

      final entity = shift.toEntity();
      expect(entity.id, 'shift-101');
      expect(entity.shiftInfoDetails?.assignedBy, isNull);
    });

    test('ShiftDetailsModel parses payload with null/missing optional fields and maps cleanly', () {
      final json = {
        'id': 'shift-202',
        'shift_date': '2026-11-06',
        'status': 'in_progress',
        'cashier': {
          'id': 'c-1',
          'name': 'يوسف الدوسري',
        },
        'shift': {
          'id': 's-1',
          'name': 'الوردية الرئيسية',
          'branch_id': 'b-1',
          'start_time': '08:00',
          'end_time': '23:59',
          'assigned_by': {
            'id': null,
            'name': null,
            'user_type': null,
          },
        },
        'opening_balance': '100.50',
        'closing_balance': null,
        'expected_balance': '150.00',
        'variance': null,
        'total_sales': 50,
        'net_sales': 45,
        'vat_amount': 5,
        'cash_collected': 50,
        'card_payments': 0,
        'handover_to': {
          'id': 'c-2',
          'name': 'Next Cashier',
          'type': 'cashier',
          'email': null,
        },
        'handover_approved_or_rejected_by': {
          'id': 'bm-1',
          'name': 'ماجد القحطاني',
          'user_type': 'branch_manager',
          'action': 'approved',
          'reviewed_at': null,
        },
        'handover_details': {
          'handover_from': 'يوسف الدوسري',
          'handover_to': 'Next Cashier',
          'actioned_by': {
            'id': null,
            'name': null,
            'user_type': null,
          },
        },
        'sales_breakdown': [
          {
            'id': 'sb-1',
            'aggregator': null,
            'aggregator_name': 'HungerStation',
            'amount': 25,
          }
        ],
        'reassignment': {
          'reassigned_from': {
            'id': null,
            'name': null,
          },
          'reassigned_by': null,
          'reassigned_to': null,
        },
      };

      final model = ShiftDetailsModel.fromJson(json);
      expect(model.id, 'shift-202');
      expect(model.handoverTo?.email, '');
      expect(model.handoverApprovedOrRejectedBy?.reviewedAt, '');
      expect(model.handoverDetails?.actionedBy, isNull);
      expect(model.reassignment?.reassignedFrom, isNull);
      expect(model.aggregators?.first.aggregator, 'HungerStation');

      final entity = model.toEntity();
      expect(entity.id, 'shift-202');
      expect(entity.shiftInfoDetails?.assignedBy, isNull);
    });

    test('CashierPendingShiftModel parses staging payload with null assigned_by_user_type and next_cashier', () {
      final json = {
        'id': 'ps-1',
        'date': '2026-11-06',
        'status': 'reassigned', // lowercase status from staging
        'status_label': 'Pending',
        'start_time': '08:00',
        'end_time': '23:59',
        'opening_balance': 0,
        'cash_given': 0,
        'variance': 0,
        'cash_from': null,
        'handover_to': {
          'id': null,
          'name': null,
          'type': 'cashier',
        },
        'assigned_to': 'يوسف الدوسري',
        'next_cashier': null,
        'assigned_by': 'ماجد القحطاني',
        'assigned_by_user_type': null,
        'is_next_shift': true,
        'can_start': true,
        'actions': {
          'view_details': true,
          'reassign_shift': false,
        },
      };

      final model = CashierPendingShiftModel.fromJson(json);
      expect(model.id, 'ps-1');
      expect(model.status, MyShiftStatusType.reassigned);
      expect(model.handoverTo, isNull);
      expect(model.nextCashier, isNull);
      expect(model.assignedByUserType, '');

      final entity = model.toEntity();
      expect(entity.id, 'ps-1');
      expect(entity.status, MyShiftStatusType.reassigned);
      expect(entity.nextCashier, isNull);
      expect(entity.handoverTo, isNull);
    });

    test('CashierReassignedShiftModel parses null reassigned_from and map next_cashier', () {
      final json = {
        'id': 'rs-1',
        'shift_date': '2026-11-06',
        'shift_name': 'الوردية الرئيسية',
        'reassigned_at': '2026-11-06 10:00:00',
        'reassignment_reason': 'Emergency leave',
        'closing_balance': 0,
        'variance': 0,
        'cash_given': 0,
        'reassigned_to': {
          'id': 'c-2',
          'name': 'Cashier Two',
          'user_type': 'cashier',
        },
        'reassigned_from': null,
        'reassigned_by': null,
        'start_time': '08:00',
        'end_time': '23:59',
        'next_cashier': {
          'id': 'u1',
          'name': 'ماجد القحطاني',
        },
        'is_mid_reassign': false,
        'can_be_accepted': true,
        'original_cashier': 'يوسف الدوسري',
        'branch_name': 'فرع الملقا – الرياض',
        'branch_id': 'b-1',
        'status': 'reassigned',
      };

      final model = CashierReassignedShiftModel.fromJson(json);
      expect(model.id, 'rs-1');
      expect(model.reassignedFrom, isNull);
      expect(model.reassignedBy, isNull);
      expect(model.nextCashier, 'ماجد القحطاني');

      final entity = model.toEntity();
      expect(entity.id, 'rs-1');
      expect(entity.reassignedFrom, isNull);
      expect(entity.reassignedBy, isNull);
      expect(entity.nextCashier, 'ماجد القحطاني');
    });

    test('CashierInfoResponse and CashierBranchInfoResponse handle null fields on fresh tenant', () {
      final infoJson = {
        'data': {
          'id': 'c-1',
          'name': 'يوسف الدوسري',
          'email': 'yousef.aldosari@daralhail.test',
          'phone': '+966500000102',
          'image': null,
          'role': 'Cashier',
          'status': 'active',
          'status_label': 'نشط',
          'activity': 'online',
          'shift_details': {
            'id': 's-1',
            'store_branch': 'فرع الملقا – الرياض',
            'shift_name': 'الوردية الرئيسية',
            'start_time': '08:00',
            'end_time': '23:59',
            'shift_date': '2026-11-06',
            'status': 'not_started',
            'status_label': 'لم تبدأ',
            'workdays': null,
            'hands_over_to': null,
          },
        },
      };

      final info = CashierInfoResponse.fromJson(infoJson);
      expect(info.id, 'c-1');
      expect(info.shiftDetails?.workdays, '-');
      expect(info.shiftDetails?.handsOverTo.name, '-');

      final branchJson = {
        'data': {
          'id': 'b-1',
          'name': 'فرع الملقا – الرياض',
          'image': null,
          'location': null,
          'lat': null,
          'lng': null,
          'opening_hours': null,
          'closing_hours': null,
          'google_maps_url': null,
          'branch_manager': null,
        },
      };

      final branch = CashierBranchInfoResponse.fromJson(branchJson);
      expect(branch.id, 'b-1');
      expect(branch.name, 'فرع الملقا – الرياض');
      expect(branch.branchManager, isNull);
    });

    test('Handover and Variance models handle null fields gracefully', () {
      final handoverJson = {
        'id': 'h-1',
        'shift_date': '2026-11-06',
        'shift_date_iso': '2026-11-06T00:00:00Z',
        'status': 'pending',
        'cash_given': null,
        'variance': '0',
        'variance_amount': null,
        'cash_from': null,
        'acceptance_message': null,
      };
      final handover = HandoversResponseItem.fromJson(handoverJson);
      expect(handover.id, 'h-1');
      expect(handover.cashFrom, 'N/A');

      final varianceJson = {
        'id': 'v-1',
        'shift_date': '2026-11-06',
        'shift_date_iso': '2026-11-06T00:00:00Z',
        'status': 'pending',
        'responsibility_status': 'pending',
        'hand_over_from': null,
        'hand_over_to': null,
        'cash_handover_amount': null,
        'variance_amount': null,
        'variance_type': null,
        'reason_for_variance': null,
        'acceptance_message': null,
        'responsibility_reviewed_at': null,
      };
      final variance = VarianceItem.fromJson(varianceJson);
      expect(variance.id, 'v-1');
      expect(variance.handOverFrom, 'N/A');

      final reassignJson = {
        'id': 'req-1',
        'shift_date': '2026-11-06',
        'reassignment': {
          'reassigned_from': null,
          'reassigned_by': null,
          'cash_given': 0.0,
          'next_cashier': {'id': '1', 'name': 'Next'},
        },
        'shift': null,
        'variance': 0.0,
      };
      final reassignItem = ReassignedShiftItemModel.fromJson(reassignJson);
      expect(reassignItem.id, 'req-1');
      expect(reassignItem.nextCashier, 'Next');
    });

    test('AvailableCashier handles null email or id safely', () {
      final json = {
        'id': 123,
        'name': 'Test Cashier',
        'email': null,
        'image': null,
        'is_available': null,
        'reason_disabled': null,
      };
      final model = AvailableCashier.fromJson(json);
      expect(model.id, '123');
      expect(model.name, 'Test Cashier');
      expect(model.email, '');
      expect(model.isAvailable, isFalse);
    });

    test('HandoverDetailsItemModel and CashierHandover handle null fields safely', () {
      final itemJson = {
        'handover_id': 1,
        'cashier_shift_id': 2,
        'cashier_name': 'يوسف',
        'shift_time': '08:00 - 23:59',
        'handover_amount': 0,
        'handover_date': null,
        'handover_time': null,
        'handover_from': null,
        'handover_to': null,
        'handover_to_id': null,
        'total_sales': null,
        'variance_amount': null,
        'variance_type': null,
        'attached_files': null,
        'status': 'pending',
        'rejection_count': null,
        'can_approve': null,
        'can_reject': null,
        'accounting_name': null,
      };
      final item = HandoverDetailsItemModel.fromJson(itemJson);
      expect(item.handoverId, '1');
      expect(item.handoverTo, 'N/A');
      expect(item.accountingName, '');

      final cashierHandoverJson = {
        'handover_id': 10,
        'cashier_shift_id': 20,
        'cashier_name': 'يوسف',
        'cashier_id': 5,
        'shift_time': '08:00 - 23:59',
        'shift_id': 1,
        'handover_amount': 0,
        'total_sales': 0,
        'net_sales': 0,
        'vat_amount': 0,
        'cash_collected': 0,
        'card_payments': 0,
        'delivery_app_payments': 0,
        'variance_amount': 0,
        'variance_type': 'None',
        'attached_files': [],
        'status': 'pending',
        'rejection_count': 0,
        'handover_to_type': null,
        'handover_to': null,
        'handover_to_id': null,
        'handover_date': null,
        'handover_time': null,
      };
      final cashierHandover = CashierHandover.fromJson(cashierHandoverJson);
      expect(cashierHandover.handoverId, '10');
      expect(cashierHandover.handoverTo, 'N/A');
    });
  });
}
