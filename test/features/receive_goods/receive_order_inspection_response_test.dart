import 'package:assab/features/receive_goods/data/models/receive_order_inspection_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ReceiveOrderInspectionResponse handles null delivery_details fields safely', () {
    final json = <String, dynamic>{
      'data': <String, dynamic>{
        'order_id': 'ord-1',
        'order_number': 'PO-S5-RECV-001',
        'supplier_name': 'Al-Marai Subscribed Supplier',
        'delivery_details': <String, dynamic>{
          'driver_name': null,
          'contact_number': null,
          'vehicle_number': null,
          'arrival_time': null,
          'delivery_address': null,
        },
        'goods_inspection': <dynamic>[
          <String, dynamic>{
            'item_id': 'itm-1',
            'product_name': 'طماطم بلدي',
            'item_logo': null,
            'qty_ordered': 10.0,
            'unit': 'kg',
            'price': 20,
          },
        ],
      },
    };

    final parsed = ReceiveOrderInspectionResponse.fromJson(json);
    expect(parsed.data.deliveryDetails.driverName, '');
    expect(parsed.data.deliveryDetails.vehicleNumber, '');
    expect(parsed.data.deliveryDetails.arrivalTime, '');
    expect(parsed.data.deliveryDetails.deliveryAddress, '');
    expect(parsed.data.goodsInspection.single.qtyOrdered, 10);
  });
}
