import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/cubits/validation/validation_state.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/container_custom_text_field.dart';
import '../../../../core/widgets/custom_calendar.dart';

class QuickCashExpensesDateField extends StatelessWidget {
  final String? date;

  const QuickCashExpensesDateField({super.key, this.date});

  void _onTap(BuildContext context) {
    final validationCubit = context.read<ValidationCubit>();

    AppBottomSheet.pageRoute(context, (context) {
      return AppPaddingWidget(
        child: Column(
          children: [
            SizedBox(
              height: 400.h,
              child: CustomCalendar(
                onDateSelected: (selectedDate) {
                  validationCubit.validateFieldAndStoreValue(
                    fieldName: 'date',
                    value: selectedDate.toIso8601String(),
                    isValid: true,
                  );

                  NavigationService.I.pop();
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppGestureDetectorButton(
      onTap: () => _onTap(context),
      child: ContainerCustomTextField(
        label: context.tr.expenseDate,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppSvg(assetName: AppAssets.calendar, width: 20.w),
            12.horizontalSpace,
            Expanded(
              child: BlocSelector<ValidationCubit, ValidationState, String?>(
                selector: (state) => state.fieldsValue['date'],
                builder: (context, selectedDate) {
                  final date =
                      DateFormatter.formatDateMDY(
                        DateTime.tryParse((selectedDate ?? this.date) ?? ''),
                      ) ??
                      '';

                  final value =
                      DateTime.tryParse(date.toString())?.toIso8601String() ??
                      '';

                  if (date.isNotEmpty && value.isNotEmpty) {
                    context.read<ValidationCubit>().validateFieldAndStoreValue(
                      fieldName: 'date',
                      value: value,
                      isValid: true,
                    );
                  }

                  return Text(
                    date.isNotEmpty ? date : context.tr.selectDate,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: AppStyles.s14W400.copyWith(
                      color: context.customColor.text1,
                    ),
                  );
                },
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: context.customColor.text1,
            ),
          ],
        ),
      ),
    );
  }
}
