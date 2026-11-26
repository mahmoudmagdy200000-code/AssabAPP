import 'package:assab/features/returns_management/data/models/return_goods_details_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ReturnGoodsDetailsData parses optional handed_over_at safely', () {
    final baseJson = <String, dynamic>{
      'id': 'ret-1',
      'return_number': 'RO-1',
      'return_date': '2026-11-26',
      'status': 'approved',
      'status_label': 'Approved',
      'status_color': '#22C55E',
      'required_action': 'cash_refund',
      'required_action_label': 'Cash Refund',
      'total_return_amount': 20,
      'is_escalated': false,
      'submitted_at': '2026-11-26 18:00:00',
      'approved_at': '2026-11-26 18:10:00',
      'created_at': '2026-11-26 18:00:00',
      'is_draft': false,
      'is_pending': true,
      'is_completed': false,
      'purchase_order': {
        'id': 'po-1',
        'order_number': 'PO-1',
        'status': 'closed',
        'status_label': 'Closed',
      },
      'supplier': {
        'id': 'sup-1',
        'name': 'Supplier 1',
        'status': 'active',
        'status_label': 'Active',
        'contact_methods': <dynamic>[],
      },
      'items': <dynamic>[],
      'timelines': <dynamic>[],
    };

    final withoutHandover = ReturnGoodsDetailsResponse.fromJson({
      'data': baseJson,
    });
    expect(withoutHandover.data.handedOverAt, isNull);

    final withHandover = ReturnGoodsDetailsResponse.fromJson({
      'data': {
        ...baseJson,
        'handed_over_at': '2026-11-26 18:20:00',
      },
    });
    expect(withHandover.data.handedOverAt, isNotNull);
  });
}
