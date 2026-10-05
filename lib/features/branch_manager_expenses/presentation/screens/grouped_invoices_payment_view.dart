import 'package:assab/core/cubits/validation/validation_state.dart';
import 'package:assab/core/enums/payment_method.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/utils/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/cubits/paging_cubit/paging_cubit.dart';
import '../../../../core/cubits/paging_cubit/paging_state.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/utils/app_bottom_sheet.dart';
import '../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../../core/widgets/app_padding_widget.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/container_custom_text_field.dart';
import '../../../../core/widgets/custom_calendar.dart';
import '../../../../core/widgets/label_text_field.dart';
import '../widgets/expenses_payment_field.dart';

class GroupedInvoicesPaymentView extends StatelessWidget {
  final ValueChanged<int> whenPaymentTypeChange;

  const GroupedInvoicesPaymentView({
    super.key,
    required this.whenPaymentTypeChange,
  });

  void _onClickPaymentButton(BuildContext context, int index) {
    whenPaymentTypeChange(index);
    context.read<PagingCubit>().goToStep(index);
  }

  void _showCalendarBottomSheet(BuildContext context) {
    AppBottomSheet.show(
      context,
      (context) => AppPaddingWidget(
        top: 0,
        child: CustomCalendar(
          onDateSelected: (value) => _onDateSelected(context, value),
        ),
      ),
    );
  }

  void _onDateSelected(BuildContext context, DateTime selectedDate) {
    context.read<ValidationCubit>().validateFieldAndStoreValue(
      fieldName: 'dueDate',
      value: selectedDate.toIso8601String(),
      isValid: true,
    );
    NavigationService.I.pop();
  }

  void _validatePaymentMethod(
    BuildContext context,
    PaymentMethod paymentMethod,
  ) {
    context.read<ValidationCubit>().validateFieldAndStoreValue(
      fieldName: 'paymentMethod',
      value: paymentMethod.paymentMethodToString(),
      isValid: true,
    );

    NavigationService.I.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LabelTextField(text: context.tr.defaultPaymentMethod),
        Text(
          context.tr.defaultPaymentMethodDesc,
          style: AppStyles.s14W400.copyWith(color: context.customColor.text3),
        ),
        12.verticalSpace,
        Container(
          decoration: BoxDecoration(
            color: context.customColor.text2,
            borderRadius: BorderRadius.circular(1000.r),
          ),
          padding: EdgeInsets.all(6.r),
          child: BlocBuilder<PagingCubit, PagingState>(
            builder: (context, state) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(3, (index) {
                  final paymentMethods = <String>[
                    context.tr.full,
                    context.tr.partial,
                    context.tr.deferred,
                  ];

                  return _paymentMethodButton(
                    context: context,
                    text: paymentMethods[index],
                    isSelected: state.currentIndex == index,
                    onTap: () => _onClickPaymentButton(context, index),
                  );
                }),
              );
            },
          ),
        ),
        12.verticalSpace,
        BlocBuilder<PagingCubit, PagingState>(
          builder: (context, state) {
            return IndexedStack(
              index: state.currentIndex,
              children: [
                ExpensesPaymentField(
                  onPaymentMethodSelected: (value) =>
                      _validatePaymentMethod(context, value),
                  showConfirmButton: false,
                ),
                ExpensesPaymentField(
                  onPaymentMethodSelected: (value) =>
                      _validatePaymentMethod(context, value),
                  showConfirmButton: false,
                ),
                Column(
                  children: [
                    LabelTextField(text: context.tr.dueDateForCreditBalance),
                    5.verticalSpace,
                    AppGestureDetectorButton(
                      onTap: () => _showCalendarBottomSheet(context),
                      child: ContainerCustomTextField(
                        child: Row(
                          children: [
                            AppSvg(assetName: AppAssets.calendar, width: 16.w),
                            8.horizontalSpace,
                            Expanded(
                              child:
                                  BlocSelector<
                                    ValidationCubit,
                                    ValidationState,
                                    String?
                                  >(
                                    selector: (state) =>
                                        state.fieldsValue['dueDate'],
                                    builder: (context, state) {
                                      return Text(
                                        DateFormatter.formatDateMDY(
                                              DateTime.tryParse(state ?? ''),
                                            ) ??
                                            context
                                                .tr
                                                .whenIsTheInvoiceDueForPayment,
                                        style: AppStyles.s14W400.copyWith(
                                          color: context.customColor.text3,
                                        ),
                                      );
                                    },
                                  ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down_outlined,
                              size: 16.r,
                              color: context.customColor.text1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _paymentMethodButton({
    required BuildContext context,
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return AppGestureDetectorButton(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? context.customColor.reversedTextColor
              : Colors.transparent,
          borderRadius: BorderRadius.circular(1000.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 8.r),
        child: Text(
          text,
          style: AppStyles.s13W600.copyWith(
            color: isSelected
                ? context.customColor.text1
                : context.customColor.text3,
          ),
        ),
      ),
    );
  }
}
