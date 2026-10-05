import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/enums/recurring_order_activate_period_end_date_enum.dart'
    show RecurringOrderActivatePeriodEndDateEnum;
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/utils/date_formatter.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/custom_calendar.dart';
import 'package:assab/core/widgets/label_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/styles/app_styles.dart';

class RecurringOrderActivationPeriodSettingsWidget extends StatelessWidget {
  const RecurringOrderActivationPeriodSettingsWidget({super.key});

  void _openChooseStartDate(BuildContext context) {
    final validationCubit = context.read<ValidationCubit>();

    AppBottomSheet.pageRoute(context, (context) {
      return Expanded(
        child: AppPaddingWidget(
          top: 0,
          child: CustomCalendar(
            onDateSelected: (value) {
              validationCubit.validateFieldAndStoreTypedValue<String>(
                fieldName: 'startDate',
                value: value.toIso8601String(),
                isValid: true,
              );

              NavigationService.I.pop();
            },
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.customColor.text2,
        borderRadius: BorderRadius.circular(15.r),
      ),
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8.h,
        children: [
          Text(
            context.tr.activationPeriod,
            style: AppStyles.s14W500.copyWith(color: context.customColor.text1),
          ),
          LabelTextField(
            text: context.tr.startDate,
            style: AppStyles.s14W400.copyWith(color: context.customColor.text3),
          ),
          AppGestureDetectorButton(
            onTap: () => _openChooseStartDate(context),
            child: ContainerCustomTextField(
              backgroundColor: context.customColor.reversedTextColor,
              child: Row(
                children: [
                  Expanded(
                    child:
                        BlocSelector<ValidationCubit, ValidationState, String?>(
                          selector: (state) =>
                              state.getTypedValue<String>('startDate'),
                          builder: (context, state) {
                            return Text(
                              DateFormatter.formatDateMDY(
                                    DateTime.tryParse(state ?? ''),
                                  ) ??
                                  context.tr.choose,
                              style: AppStyles.s14W400.copyWith(
                                color: state != null
                                    ? context.customColor.text1
                                    : context.customColor.text3,
                              ),
                            );
                          },
                        ),
                  ),
                  12.horizontalSpace,
                  AppSvg(
                    assetName: AppAssets.calendar,
                    width: 16.r,
                    colorFilter: ColorFilter.mode(
                      context.theme.primaryColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
            ),
          ),
          LabelTextField(
            text: context.tr.endDate,
            style: AppStyles.s14W400.copyWith(color: context.customColor.text3),
          ),
          AppGestureDetectorButton(
            onTap: () {
              AppBottomSheet.showModal(
                context,
                (_) => _buildEndDateTypeSection(context: context),
              );
            },
            child: ContainerCustomTextField(
              backgroundColor: context.customColor.reversedTextColor,
              child: Row(
                children: [
                  Expanded(
                    child:
                        BlocSelector<
                          ValidationCubit,
                          ValidationState,
                          RecurringOrderActivatePeriodEndDateEnum?
                        >(
                          selector: (state) =>
                              state.getTypedValue<
                                RecurringOrderActivatePeriodEndDateEnum
                              >('endDateType'),
                          builder: (context, state) {
                            return Text(
                              state != null
                                  ? state ==
                                            RecurringOrderActivatePeriodEndDateEnum
                                                .open
                                        ? context.tr.openRepeatsUntilYouEndIt
                                        : (DateFormatter.formatDateMDY(
                                                DateTime.tryParse(
                                                  context
                                                          .read<
                                                            ValidationCubit
                                                          >()
                                                          .getTypedValue<
                                                            String
                                                          >('endDate') ??
                                                      ' ',
                                                ),
                                              ) ??
                                              'N/A')
                                  : context.tr.choose,
                              style: AppStyles.s14W400.copyWith(
                                color: state != null
                                    ? context.customColor.text1
                                    : context.customColor.text3,
                              ),
                            );
                          },
                        ),
                  ),
                  12.horizontalSpace,
                  AppSvg(
                    assetName: AppAssets.calendar,
                    width: 16.r,
                    colorFilter: ColorFilter.mode(
                      context.theme.primaryColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEndDateTypeSection({required BuildContext context}) {
    final validationCubit = context.read<ValidationCubit>();

    return AppPaddingWidget(
      top: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppGestureDetectorButton(
            onTap: () {
              validationCubit.removeDynamicFields({'endDate'});

              validationCubit.validateFieldAndStoreTypedValue<
                RecurringOrderActivatePeriodEndDateEnum
              >(
                fieldName: 'endDateType',
                value: RecurringOrderActivatePeriodEndDateEnum.open,
                isValid: true,
              );

              NavigationService.I.pop();
            },
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: context.customColor.border),
                borderRadius: BorderRadius.circular(15.r),
              ),
              padding: EdgeInsets.all(16.r),
              child: Text(
                context.tr.openRepeatsUntilYouEndIt,
                style: AppStyles.s14W400.copyWith(
                  color: context.customColor.text1,
                ),
              ),
            ),
          ),
          10.verticalSpace,
          AppGestureDetectorButton(
            onTap: () {
              validationCubit.addDynamicFields({'endDate'});

              NavigationService.I.pop();

              AppBottomSheet.pageRoute(
                context,
                (context) => Expanded(
                  child: AppPaddingWidget(
                    top: 0,
                    child: CustomCalendar(
                      onDateSelected: (value) {
                        validationCubit.validateFieldAndStoreTypedValue<
                          RecurringOrderActivatePeriodEndDateEnum
                        >(
                          fieldName: 'endDateType',
                          value: RecurringOrderActivatePeriodEndDateEnum.custom,
                          isValid: true,
                        );

                        validationCubit.validateFieldAndStoreTypedValue<String>(
                          fieldName: 'endDate',
                          value: value.toIso8601String(),
                          isValid: true,
                        );

                        NavigationService.I.pop();
                      },
                    ),
                  ),
                ),
              );
            },
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: context.customColor.border),
                borderRadius: BorderRadius.circular(15.r),
              ),
              padding: EdgeInsets.all(16.r),
              child: Text(
                context.tr.custom,
                style: AppStyles.s14W400.copyWith(
                  color: context.customColor.text1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
