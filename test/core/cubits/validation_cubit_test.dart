import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('S5-DEF-010: ValidationCubit single-field enableButton', () {
    test('enables button immediately when the single required field becomes valid', () {
      final cubit = ValidationCubit(requiredFields: {'file_1'});
      expect(cubit.state.enableButton, isFalse);

      cubit.validateField('file_1', true);
      expect(cubit.state.enableButton, isTrue);

      cubit.validateField('file_1', false);
      expect(cubit.state.enableButton, isFalse);

      cubit.close();
    });

    test('enables button immediately with validateFieldAndStoreTypedValue', () {
      final cubit = ValidationCubit(requiredFields: {'driver_name'});
      cubit.validateFieldAndStoreTypedValue<String>(
        fieldName: 'driver_name',
        value: 'Ahmed',
        isValid: true,
      );
      expect(cubit.state.enableButton, isTrue);

      cubit.close();
    });
  });
}
