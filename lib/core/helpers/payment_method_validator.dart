import 'package:assab/core/cubits/validation/validation_cubit.dart';

abstract class PaymentMethodValidator {
  void addValidationsFields(ValidationCubit validationCubit);
  void removeValidationsFields(ValidationCubit validationCubit);
  String get paymentType;
}

class FullPaymentMethodValidator implements PaymentMethodValidator {
  @override
  void addValidationsFields(ValidationCubit validationCubit) {
    validationCubit.addDynamicFields({'singlePaymentMethod'});
  }

  @override
  void removeValidationsFields(ValidationCubit validationCubit) {
    validationCubit.removeDynamicFields({'singlePaymentMethod'});
  }

  @override
  String get paymentType => 'full';
}

class PartialPaymentMethodValidator implements PaymentMethodValidator {
  @override
  void addValidationsFields(ValidationCubit validationCubit) {
    validationCubit.addDynamicFields({
      'partialTotalInvoiceAmount',
      'partialPaidAmount',
      'singlePaymentMethod',
      'singleDueDate',
    });
  }

  @override
  void removeValidationsFields(ValidationCubit validationCubit) {
    validationCubit.removeDynamicFields({
      'partialTotalInvoiceAmount',
      'partialPaidAmount',
      'singlePaymentMethod',
      'singleDueDate',
    });
  }

  @override
  String get paymentType => 'partial';
}

class DeferredPaymentMethodValidator implements PaymentMethodValidator {
  @override
  void addValidationsFields(ValidationCubit validationCubit) {
    validationCubit.addDynamicFields({
      'deferredTotalInvoiceAmount',
      'singleDueDate',
    });
  }

  @override
  void removeValidationsFields(ValidationCubit validationCubit) {
    validationCubit.removeDynamicFields({
      'deferredTotalInvoiceAmount',
      'singleDueDate',
    });
  }

  @override
  String get paymentType => 'deferred';
}
