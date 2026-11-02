import 'package:assab/features/cashier_my_shifts/presentation/formatter/cashier_shift_time_formatter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('ar');
    await initializeDateFormatting('ar_EG');
  });
  setUp(() => Intl.defaultLocale = 'ar');
  tearDown(() => Intl.defaultLocale = null);

  test('formats API clock strings under Arabic locale', () {
    expect(CashierShiftTimeFormatter.format('12:00'), '12:00 م');
    expect(CashierShiftTimeFormatter.format('00:00'), '12:00 ص');
    expect(CashierShiftTimeFormatter.format('23:59'), '11:59 م');
    expect(CashierShiftTimeFormatter.format('12:00:00'), '12:00 م');
  });

  test('reproduces the legacy 12:00 crash under Egyptian Arabic', () {
    Intl.defaultLocale = 'ar_EG';
    expect(
      () => DateFormat('HH:mm').parse('12:00'),
      throwsA(isA<FormatException>().having(
        (error) => error.toString(),
        'message',
        contains('Trying to read HH from 12:00 at 0'),
      )),
    );
    expect(CashierShiftTimeFormatter.parseApiTime('12:00')?.hour, 12);
    expect(CashierShiftTimeFormatter.format('12:00'), isNot('—'));
    expect(CashierShiftTimeFormatter.format('12:00:00'), isNot('—'));
  });

  test('invalid and missing clock strings do not crash a shift card', () {
    expect(CashierShiftTimeFormatter.format(''), '—');
    expect(CashierShiftTimeFormatter.format('not-a-time'), '—');
    expect(CashierShiftTimeFormatter.format('25:90'), '—');
  });
}
