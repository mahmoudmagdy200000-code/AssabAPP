import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/utils/date_formatter.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/custom_calendar.dart';
import 'package:assab/features/branch_manager_expenses/presentation/widgets/expenses_payment_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/enums/payment_method.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/container_custom_text_field.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/saudi_riyal_svg_widget.dart';

class PaymentPartialType extends StatelessWidget {
  const PaymentPartialType({super.key});

  void _selectPaymentMethod(BuildContext context, PaymentMethod value) {
    context.read<ValidationCubit>().validateFieldAndStoreValue(
      fieldName: 'singlePaymentMethod',
      value: value.paymentMethodToString(),
      isValid: true,
    );
    NavigationService.I.pop();
  }

  void _datePicker(BuildContext context) {
    AppBottomSheet.show(
      context,
      (context) => AppPaddingWidget(
        top: 0,
        child: CustomCalendar(
          onDateSelected: (value) {
            context.read<ValidationCubit>().validateFieldAndStoreValue(
              fieldName: 'singleDueDate',
              value: value.toIso8601String(),
              isValid: true,
            );

            NavigationService.I.pop();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ContainerCustomTextField(
          label: context.tr.totalInvoiceAmount,
          child: Row(
            children: [
              const SaudiRiyalSvgWidget(),
              6.horizontalSpace,
              Expanded(
                child: CustomTextField(
                  hintText: context.tr.amount,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    context.read<ValidationCubit>().validateFieldAndStoreValue(
                      fieldName: 'partialTotalInvoiceAmount',
                      value: value,
                      isValid: value.isNotEmpty,
                    );
                  },
                ),
              ),
              6.horizontalSpace,
              Icon(
                Icons.error_outline,
                size: 16.r,
                color: context.customColor.text1,
              ),
            ],
          ),
        ),
        12.verticalSpace,
        BlocSelector<ValidationCubit, ValidationState, bool?>(
          selector: (state) => state.fieldsValidity['partialPaidAmount'],
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ContainerCustomTextField(
                  label: context.tr.amountPaidNow,
                  borderColor: state == false
                      ? context.customColor.error
                      : null,
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          hintText: context.tr.amountPaidViaCashOrCustody,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            final validationCubit = context
                                .read<ValidationCubit>();

                            final paidAmount = double.tryParse(value) ?? 0.0;
                            final totalInvoiceAmount =
                                double.tryParse(
                                  validationCubit
                                          .state
                                          .fieldsValue['partialTotalInvoiceAmount'] ??
                                      '0',
                                ) ??
                                0.0;

                            validationCubit.validateFieldAndStoreValue(
                              fieldName: 'partialPaidAmount',
                              value: value,
                              isValid:
                                  paidAmount > 0 &&
                                  paidAmount <= totalInvoiceAmount,
                            );
                          },
                        ),
                      ),
                      6.horizontalSpace,
                      const SaudiRiyalSvgWidget(),
                    ],
                  ),
                ),
                4.verticalSpace,
                if (state == false)
                  Text(
                    context
                        .tr
                        .enteredAmountExceedsTotalInvoiceAmountOrLessThanOne,
                    style: AppStyles.s11W400.copyWith(
                      color: context.customColor.error,
                    ),
                  ),
              ],
            );
          },
        ),
        12.verticalSpace,
        ExpensesPaymentField(
          showHeader: false,
          showConfirmButton: false,
          showSupplierCredit: false,
          onPaymentMethodSelected: (value) =>
              _selectPaymentMethod(context, value),
        ),
        12.verticalSpace,
        ContainerCustomTextField(
          label: context.tr.remainingBalanceAutoCalculated,
          child: Row(
            children: [
              const SaudiRiyalSvgWidget(),
              6.horizontalSpace,
              Expanded(
                child: BlocSelector<ValidationCubit, ValidationState, double?>(
                  selector: (state) {
                    final total = double.tryParse(
                      state.fieldsValue['partialTotalInvoiceAmount'] ?? '',
                    );

                    final paid = double.tryParse(
                      state.fieldsValue['partialPaidAmount'] ?? '',
                    );

                    if (total == null || paid == null) {
                      return null;
                    }

                    return total - paid;
                  },
                  builder: (context, state) {
                    return Text(
                      state?.toString() ?? context.tr.amount,
                      style: AppStyles.s13W400.copyWith(
                        color: context.customColor.text3,
                      ),
                    );
                  },
                ),
              ),
              6.horizontalSpace,
              Icon(
                Icons.error_outline,
                size: 16.r,
                color: context.customColor.text1,
              ),
            ],
          ),
        ),
        12.verticalSpace,
        AppGestureDetectorButton(
          onTap: () => _datePicker(context),
          child: ContainerCustomTextField(
            label: context.tr.dueDateForCreditBalance,
            child: Row(
              children: [
                const AppSvg(assetName: AppAssets.calendar),
                6.horizontalSpace,
                Expanded(
                  child:
                      BlocSelector<ValidationCubit, ValidationState, String?>(
                        selector: (state) => state.fieldsValue['singleDueDate'],
                        builder: (context, state) {
                          return Text(
                            DateFormatter.formatDateMDY(
                                  DateTime.tryParse(state ?? ''),
                                ) ??
                                context
                                    .tr
                                    .whenIsTheRemainingBalanceExpectedToBePaid,
                            style: AppStyles.s13W400.copyWith(
                              color: context.customColor.text3,
                            ),
                          );
                        },
                      ),
                ),
                6.horizontalSpace,
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 16.r,
                  color: context.customColor.text1,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
