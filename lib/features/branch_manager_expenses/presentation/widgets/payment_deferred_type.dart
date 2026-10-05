import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/cubits/validation/validation_state.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/utils/date_formatter.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/custom_calendar.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/container_custom_text_field.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/saudi_riyal_svg_widget.dart';

class PaymentDeferredType extends StatelessWidget {
  const PaymentDeferredType({super.key});

  void _datePicker(BuildContext context) {
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
      fieldName: 'singleDueDate',
      value: selectedDate.toIso8601String(),
      isValid: true,
    );
    NavigationService.I.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              color: context.theme.primaryColor,
              width: 4.r,
              height: 33.r,
            ),
            15.horizontalSpace,
            Expanded(
              child: Text(
                context.tr.deferredPaymentDesc,
                style: AppStyles.s13W400.copyWith(
                  color: context.customColor.text3,
                ),
              ),
            ),
          ],
        ),
        12.verticalSpace,
        const CustomDivider(),
        12.verticalSpace,
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
                      fieldName: 'deferredTotalInvoiceAmount',
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
