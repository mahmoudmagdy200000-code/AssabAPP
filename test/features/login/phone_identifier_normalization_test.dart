import 'package:assab/core/utils/app_reg_exp.dart';
import 'package:assab/features/login/presentation/cubits/login_form/login_form_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:assab/generated/l10n.dart';
import 'package:flutter/widgets.dart';

void main() {
  setUpAll(() async {
    await S.load(const Locale('en'));
  });
  group('Step 1 — Saudi Phone Normalization Pure Function (AppRegExp.normalizeSaudiPhone)', () {
    const expectedCanonical = '+966512345678';

    test('normalizes 9-digit local phone starting with 5 (5XXXXXXXX)', () {
      expect(AppRegExp.normalizeSaudiPhone('512345678'), equals(expectedCanonical));
      expect(AppRegExp.phoneValidator('512345678'), isTrue);
    });

    test('normalizes 10-digit national phone starting with 05 (05XXXXXXXX)', () {
      expect(AppRegExp.normalizeSaudiPhone('0512345678'), equals(expectedCanonical));
      expect(AppRegExp.phoneValidator('0512345678'), isTrue);
    });

    test('normalizes 12-digit international format without plus (9665XXXXXXXX)', () {
      expect(AppRegExp.normalizeSaudiPhone('966512345678'), equals(expectedCanonical));
      expect(AppRegExp.phoneValidator('966512345678'), isTrue);
    });

    test('normalizes 14-digit international format with double zero (009665XXXXXXXX)', () {
      expect(AppRegExp.normalizeSaudiPhone('00966512345678'), equals(expectedCanonical));
      expect(AppRegExp.phoneValidator('00966512345678'), isTrue);
    });

    test('normalizes 13-char canonical E.164 with plus (+9665XXXXXXXX)', () {
      expect(AppRegExp.normalizeSaudiPhone('+966512345678'), equals(expectedCanonical));
      expect(AppRegExp.phoneValidator('+966512345678'), isTrue);
    });

    test('strips spaces and dashes from all accepted formats', () {
      expect(AppRegExp.normalizeSaudiPhone('051 234 5678'), equals(expectedCanonical));
      expect(AppRegExp.normalizeSaudiPhone('051-234-5678'), equals(expectedCanonical));
      expect(AppRegExp.normalizeSaudiPhone('+966 51 234 5678'), equals(expectedCanonical));
      expect(AppRegExp.normalizeSaudiPhone('+966-51-234-5678'), equals(expectedCanonical));
      expect(AppRegExp.normalizeSaudiPhone('966 51 234 5678'), equals(expectedCanonical));
      expect(AppRegExp.normalizeSaudiPhone('00966 51 234 5678'), equals(expectedCanonical));
      expect(AppRegExp.normalizeSaudiPhone('51 234-5678'), equals(expectedCanonical));
    });

    test('rejects invalid phone numbers and returns null', () {
      // Wrong prefix
      expect(AppRegExp.normalizeSaudiPhone('123456789'), isNull);
      expect(AppRegExp.normalizeSaudiPhone('0412345678'), isNull);
      expect(AppRegExp.normalizeSaudiPhone('+96551234567'), isNull); // Kuwait

      // Wrong length
      expect(AppRegExp.normalizeSaudiPhone('51234567'), isNull); // 8 digits
      expect(AppRegExp.normalizeSaudiPhone('5123456789'), isNull); // 10 digits without leading 0
      expect(AppRegExp.normalizeSaudiPhone('051234567'), isNull); // 9 digits with 0

      // Non-digits / letters
      expect(AppRegExp.normalizeSaudiPhone('51234abcd'), isNull);
      expect(AppRegExp.normalizeSaudiPhone('abc'), isNull);
      expect(AppRegExp.normalizeSaudiPhone(''), isNull);
      expect(AppRegExp.normalizeSaudiPhone('   '), isNull);

      // Malformed combination (leading 0 after country code)
      expect(AppRegExp.normalizeSaudiPhone('+9660512345678'), isNull);
      expect(AppRegExp.normalizeSaudiPhone('9660512345678'), isNull);
    });

    test('phoneValidator returns false for invalid inputs', () {
      expect(AppRegExp.phoneValidator('123456789'), isFalse);
      expect(AppRegExp.phoneValidator('0412345678'), isFalse);
      expect(AppRegExp.phoneValidator('+96551234567'), isFalse);
      expect(AppRegExp.phoneValidator(''), isFalse);
    });
  });

  group('Step 1 — LoginFormCubit & Round-Trip Prefill Validation', () {
    test('LoginFormCubit validates and accepts all valid Saudi phone formats', () {
      final cubit = LoginFormCubit();

      final validFormats = [
        '512345678',
        '0512345678',
        '966512345678',
        '00966512345678',
        '+966512345678',
        '051 234 5678',
        '+966-51-234-5678',
      ];

      for (final phone in validFormats) {
        cubit.updateIdentifier(phone);
        expect(cubit.state.isIdentifierValid, isTrue, reason: 'Failed for format: $phone');
        expect(cubit.state.identifierError, isNull);
      }

      cubit.close();
    });

    test('LoginFormCubit rejects invalid phone inputs', () {
      final cubit = LoginFormCubit();

      cubit.updateIdentifier('0412345678');
      expect(cubit.state.isIdentifierValid, isFalse);
      expect(cubit.state.identifierError, equals('Invalid email or phone'));

      cubit.updateIdentifier('51234567');
      expect(cubit.state.isIdentifierValid, isFalse);
      expect(cubit.state.identifierError, equals('Invalid email or phone'));

      cubit.close();
    });

    test('Round-trip through prefill: any saved format normalizes to canonical +9665XXXXXXXX', () {
      final storedRawVariants = [
        '512345678',
        '0512345678',
        '966512345678',
        '00966512345678',
        '+966512345678',
        ' 051-234-5678 ',
      ];

      for (final rawSaved in storedRawVariants) {
        // SharedLoginForm.initState prefill logic:
        final prefilled = AppRegExp.normalizeSaudiPhone(rawSaved) ?? rawSaved.trim();
        expect(prefilled, equals('+966512345678'));

        // Feed prefilled into LoginFormCubit
        final cubit = LoginFormCubit();
        cubit.initWithIdentifier(prefilled);
        expect(cubit.state.isIdentifierValid, isTrue);
        expect(cubit.state.identifier, equals('+966512345678'));
        cubit.close();
      }
    });

    test('Password is never trimmed by LoginFormCubit', () {
      final cubit = LoginFormCubit();
      const rawPasswordWithTrailingSpace = 'MySecurePass123! ';

      cubit.updatePassword(rawPasswordWithTrailingSpace);
      expect(cubit.state.password, equals(rawPasswordWithTrailingSpace));
      expect(cubit.state.password.length, equals(17));
      expect(cubit.state.isPasswordValid, isTrue);

      cubit.close();
    });
  });
}
