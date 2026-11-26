import 'package:assab/shared/models/order_track_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('OrderTrackResponse handles null driver/vehicle/file fields safely', () {
    final json = <String, dynamic>{
      'data': <String, dynamic>{
        'order_id': 'ord-1',
        'stages': <String, dynamic>{
          'preparing': null,
          'out_for_delivery': null,
          'delivered': <String, dynamic>{
            'status': 'delivered',
            'started_at': '2026-11-26 18:17:27',
            'delivery_photos': <dynamic>[],
          },
          'order_confirmation': <String, dynamic>{
            'status': 'confirmed',
            'receipt_details': <String, dynamic>{
              'date_time': '2026-11-26 18:17:27',
              'inspection_summary': <String, dynamic>{
                'number_of_items': 2,
                'quantity_variance': 0,
                'total_amount': 300,
                'driver_name': null,
                'contact_number': null,
                'vehicle_number': null,
                'arrival_time': '2026-11-26 17:40:44',
              },
              'goods_inspections': <dynamic>[],
              'document_type': 'invoice',
              'financial_summary': <String, dynamic>{
                'invoice_number': 'INV-S5-001',
                'invoice_date': '2026-11-26',
                'supplier_name': 'Al-Marai Subscribed Supplier',
                'amount_before_tax': 300,
                'vat': 45,
                'total_amount': 345,
              },
            },
          },
          'variance_logged': null,
        },
      },
    };

    final parsed = OrderTrackResponse.fromJson(json);
    final summary = parsed.data.stages.orderConfirmation!.receiptDetails.inspectionSummary;
    expect(summary.driverName, '');
    expect(summary.vehicleNumber, '');
    expect(summary.numberOfItems, 2);

    final prepJson = <String, dynamic>{
      'data': <String, dynamic>{
        'order_id': 'ord-2',
        'stages': <String, dynamic>{
          'preparing': <String, dynamic>{
            'status': 'preparing',
            'started_at': null,
            'items': <dynamic>[
              <String, dynamic>{
                'item_name': 'Tomato',
                'item_logo': null,
                'requested_quantity': 5.0,
                'item_unit': 'kg',
                'status': 'preparing',
                'quality_certificate': null,
              },
            ],
          },
        },
      },
    };
    final prepParsed = OrderTrackResponse.fromJson(prepJson);
    expect(prepParsed.data.stages.preparing?.startedAt, '');
    expect(prepParsed.data.stages.preparing?.items.first.requestedQuantity, 5);
  });
}
