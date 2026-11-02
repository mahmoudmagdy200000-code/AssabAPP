import 'package:assab/features/cashier_my_shifts/presentation/formatter/cashier_shift_time_formatter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

void main() {
  setUpAll(() async => initializeDateFormatting('ar'));
  setUp(() => Intl.defaultLocale = 'ar');
  tearDown(() => Intl.defaultLocale = null);

  test('formats API clock strings under Arabic locale', () {
    expect(CashierShiftTimeFormatter.format('12:00'), '12:00 م');
    expect(CashierShiftTimeFormatter.format('00:00'), '12:00 ص');
    expect(CashierShiftTimeFormatter.format('23:59'), '11:59 م');
    expect(CashierShiftTimeFormatter.format('12:00:00'), '12:00 م');
  });

  test('invalid and missing clock strings do not crash a shift card', () {
    expect(CashierShiftTimeFormatter.format(''), '—');
    expect(CashierShiftTimeFormatter.format('not-a-time'), '—');
    expect(CashierShiftTimeFormatter.format('25:90'), '—');
  });
}
