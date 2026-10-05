import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/utils/app_bottom_sheet.dart';
import '../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../../core/widgets/app_padding_widget.dart';
import '../../../../core/widgets/container_custom_text_field.dart';
import '../../../../core/widgets/custom_calendar.dart';

class CustodyHandoverToCashierHandoverDateSection extends StatelessWidget {
  const CustodyHandoverToCashierHandoverDateSection({super.key});

  void _onTapHandoverDate(BuildContext context) {
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
                    fieldName: 'handoverDate',
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
      onTap: () => _onTapHandoverDate(context),
      child: ContainerCustomTextField(
        label: context.tr.handoverDate,
        child: Row(
          children: [
            Expanded(
              child: BlocSelector<ValidationCubit, ValidationState, String?>(
                selector: (state) => state.fieldsValue['handoverDate'],
                builder: (context, state) {
                  return Text(
                    state ?? 'Today (June 12, 2025)',
                    style: AppStyles.s14W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  );
                },
              ),
            ),
            10.horizontalSpace,
            Icon(
              Icons.keyboard_arrow_down_outlined,
              size: 16.r,
              color: context.customColor.text1,
            ),
          ],
        ),
      ),
    );
  }
}
