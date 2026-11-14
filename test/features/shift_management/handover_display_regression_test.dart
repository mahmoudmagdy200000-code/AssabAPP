import 'package:assab/core/enums/shift_status/shift_handover_status.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/handover_details_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

HandoverDetailsEntity handover(String time) => HandoverDetailsEntity(
  handoverId: 'h', cashierShiftId: 's', cashierName: 'Cashier',
  handoverAmount: 35, handoverDate: '2026-11-14 00:00:00',
  handoverTime: time, approvedAt: '', handoverFrom: 'Cashier',
  handoverTo: 'Manager', varianceAmount: -5, totalSales: 115,
  handoverNotes: null, handoverStatus: HandoverStatus.pending,
);

void main() {
  test('handover time uses the time field even when date contains midnight', () async {
    await initializeDateFormatting('en');
    Intl.defaultLocale = 'en';
    expect(handover('18:16:00').formattedHandoverTime, '06:16 PM');
    expect(handover('not-a-time').formattedHandoverTime, '—');
  });
}
