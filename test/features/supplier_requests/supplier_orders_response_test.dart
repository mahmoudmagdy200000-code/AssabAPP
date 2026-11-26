import 'package:assab/features/supplier_requests/data/models/supplier_orders_response.dart';
import 'package:assab/shared/models/branch_details_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('S5-DEF-009: SupplierOrdersResponse & BranchDetailsResponse null-safe parsing', () {
    test('BranchDetailsResponse handles null lat, lng, opening_hours, and closing_hours', () {
      final branch = BranchDetailsResponse.fromJson({
        'id': 'branch-1',
        'name': 'Main Branch',
        'image': null,
        'location': 'Riyadh',
        'lat': null,
        'lng': null,
        'opening_hours': null,
        'closing_hours': null,
      });

      expect(branch.id, 'branch-1');
      expect(branch.name, 'Main Branch');
      expect(branch.lat, 0.0);
      expect(branch.lng, 0.0);
      expect(branch.openingHours, isNull);
      expect(branch.closingHours, isNull);
    });

    test('SupplierOrdersResponse parses order when branch coordinates and totals are null', () {
      final response = SupplierOrdersResponse.fromJson({
        'data': [
          {
            'id': 'po-1',
            'order_number': 'PO-S5-SUP-ACC',
            'order_type': 'direct_supplier',
            'status': 'pending',
            'branch': {
              'id': 'branch-1',
              'name': 'Main Branch',
              'image': null,
              'location': 'Riyadh',
              'lat': null,
              'lng': null,
              'opening_hours': null,
              'closing_hours': null,
            },
            'branch_manager': {
              'id': 'bm-1',
              'name': 'Branch Manager',
              'email': 'bm@stage5.local',
              'phone': '0500000000',
              'image': null,
            },
            'subtotal': null,
            'tax_amount': null,
            'total_amount': null,
            'priority': 'normal',
            'preferred_delivery_date': null,
            'expected_delivery_at': null,
            'message': null,
            'special_instructions': null,
            'rejection_reason': null,
            'created_at': '2026-11-26T10:00:00Z',
            'confirmed_at': null,
            'rejected_at': null,
            'items': [
              {
                'id': 'item-1',
                'item_id': 'prod-1',
                'item_name': 'Tomato',
                'quantity_ordered': 5,
                'quantity_confirmed': null,
                'item_unit': 'kg',
                'unit_price': null,
                'total_price': null,
                'status': 'pending',
              },
            ],
          },
        ],
        'meta': {
          'current_page': 1,
          'last_page': 1,
          'total': 1,
        },
      });

      expect(response.data, hasLength(1));
      final order = response.data.first;
      expect(order.orderNumber, 'PO-S5-SUP-ACC');
      expect(order.branch.lat, 0.0);
      expect(order.branch.lng, 0.0);
      expect(order.subtotal, 0);
      expect(order.taxAmount, 0);
      expect(order.totalAmount, 0);
      expect(order.items.first.unitPrice, 0);
      expect(order.items.first.totalPrice, 0);
    });
  });
}
