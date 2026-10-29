import 'package:assab/core/utils/currency_normalizer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CurrencyNormalizer', () {
    test('sanitizes ASCII and Arabic-Indic and Persian digits', () {
      expect(CurrencyNormalizer.sanitizeNumericString('150.50'), '150.50');
      expect(CurrencyNormalizer.sanitizeNumericString('١٥٠٫٥٠'), '150.50');
      expect(CurrencyNormalizer.sanitizeNumericString('۱۵۰.۵۰'), '150.50');
      expect(CurrencyNormalizer.sanitizeNumericString(' 1,500.25 '), '1500.25');
      expect(CurrencyNormalizer.sanitizeNumericString('١٬٥٠٠٫٢٥'), '1500.25');
    });

    test('parseSarAmount correctly parses valid non-negative amounts', () {
      expect(CurrencyNormalizer.parseSarAmount('150'), 150.0);
      expect(CurrencyNormalizer.parseSarAmount('150.50'), 150.50);
      expect(CurrencyNormalizer.parseSarAmount('١٥٠٫٧٥'), 150.75);
      expect(CurrencyNormalizer.parseSarAmount('0'), 0.0);
      expect(CurrencyNormalizer.parseSarAmount('0.00'), 0.0);
    });

    test('parseSarAmount rejects invalid or negative amounts', () {
      expect(CurrencyNormalizer.parseSarAmount(null), isNull);
      expect(CurrencyNormalizer.parseSarAmount(''), isNull);
      expect(CurrencyNormalizer.parseSarAmount('   '), isNull);
      expect(CurrencyNormalizer.parseSarAmount('-50'), isNull);
      expect(CurrencyNormalizer.parseSarAmount('-٥٠'), isNull);
      expect(CurrencyNormalizer.parseSarAmount('abc'), isNull);
      expect(CurrencyNormalizer.parseSarAmount('12.34.56'), isNull);
    });

    test('normalizeSarInput formats valid numbers to 2 decimal places', () {
      expect(CurrencyNormalizer.normalizeSarInput('150'), '150.00');
      expect(CurrencyNormalizer.normalizeSarInput('150.5'), '150.50');
      expect(CurrencyNormalizer.normalizeSarInput('١٥٠٫٥'), '150.50');
      expect(CurrencyNormalizer.normalizeSarInput('1,234.56'), '1234.56');
      expect(CurrencyNormalizer.normalizeSarInput('-10'), isNull);
      expect(CurrencyNormalizer.normalizeSarInput('xyz'), isNull);
    });

    test('formatSar formats num to 2 decimal places', () {
      expect(CurrencyNormalizer.formatSar(150), '150.00');
      expect(CurrencyNormalizer.formatSar(150.5), '150.50');
      expect(CurrencyNormalizer.formatSar(0), '0.00');
    });

    test('areAmountsEqual handles halala tolerance', () {
      expect(CurrencyNormalizer.areAmountsEqual(100.0, 100.0), isTrue);
      expect(CurrencyNormalizer.areAmountsEqual(100.0, 100.0005), isTrue);
      expect(CurrencyNormalizer.areAmountsEqual(100.0, 100.001), isTrue);
      expect(CurrencyNormalizer.areAmountsEqual(100.0, 100.01), isFalse);
      expect(CurrencyNormalizer.areAmountsEqual(100.0, 99.99), isFalse);
    });
  });
}
