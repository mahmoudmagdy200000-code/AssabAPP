import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/strategies/purchase_source_strategy.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/enums/recurring_order_activate_period_end_date_enum.dart';
import '../../../../core/enums/recurring_order_date_picker_enum.dart';
import '../../../../core/enums/recurring_order_notifications_enum.dart';
import '../../../../core/enums/recurring_order_repeat_days_enum.dart';
import '../../../../core/enums/recurring_order_setting_repeat_type_every_enum.dart';
import '../../../../core/enums/recurring_order_smart_settings_enum.dart';
import '../../../../core/enums/recurring_setting_repeat_type.dart';
import '../../../../core/enums/time_of_day_enum.dart';
import '../../../purchase/data/models/purchase_create_order_request.dart';
import '../../data/models/recurring_order_details_response.dart';
import '../../domain/strategies/create_recurring_order_strategy.dart';
import '../../domain/strategies/repeat_frequency_strategy.dart';
import '../widgets/recurring_order_activation_period_settings_widget.dart';
import '../widgets/recurring_order_setting_notifications_widget.dart';
import '../widgets/recurring_order_setting_repeat_frequency_widget.dart';
import '../widgets/recurring_order_setting_smart_settings_widget.dart';

class RecurringOrderSettingScreen extends StatelessWidget {
  final CreateRecurringOrderStrategy strategy;
  final PurchaseCreateOrderRequest? createOrderRequest;
  final PurchaseSourceStrategy? source;
  final int? sourceIndex;
  final RecurringOrderDetailsData? initialData;

  const RecurringOrderSettingScreen({
    super.key,
    required this.strategy,
    this.createOrderRequest,
    this.source,
    this.sourceIndex,
    this.initialData,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = ValidationCubit(
          requiredFields: {
            'repeatFrequencyType',
            'notifications',
            'smartSettings',
            'startDate',
            'endDateType',
          },
        );

        if (initialData != null) {
          _preFillValidation(cubit, initialData!);
        }

        return cubit;
      },
      child: _RecurringOrderSettingScreen(
        strategy: strategy,
        createOrderRequest: createOrderRequest,
        source: source,
        sourceIndex: sourceIndex,
      ),
    );
  }

  void _preFillValidation(
    ValidationCubit cubit,
    RecurringOrderDetailsData data,
  ) {
    final freq = data.frequencySettings;
    final inspection = data.details.inspectionSummary;
    final scheduling = data.details.schedulingSettings;

    // Repeat frequency type
    cubit.validateFieldAndStoreTypedValue<RepeatFrequencyStrategy>(
      fieldName: 'repeatFrequencyType',
      value: freq.frequency,
      isValid: true,
    );

    // Notifications
    cubit.validateFieldAndStoreList<RecurringOrderNotificationsEnum>(
      fieldName: 'notifications',
      value: scheduling.notifications,
      isValid: scheduling.notifications.isNotEmpty,
    );

    // Smart settings
    cubit.validateFieldAndStoreList<RecurringOrderSmartSettingsEnum>(
      fieldName: 'smartSettings',
      value: scheduling.smartSettings,
      isValid: scheduling.smartSettings.isNotEmpty,
    );

    // Start date
    cubit.validateFieldAndStoreTypedValue<String>(
      fieldName: 'startDate',
      value: inspection.startDate,
      isValid: true,
    );

    // End date type
    cubit.validateFieldAndStoreTypedValue<
      RecurringOrderActivatePeriodEndDateEnum
    >(fieldName: 'endDateType', value: freq.endType, isValid: true);

    // End date (if custom)
    if (freq.endType == RecurringOrderActivatePeriodEndDateEnum.custom &&
        inspection.endDate != null) {
      cubit.addDynamicFields({'endDate'});
      cubit.validateFieldAndStoreTypedValue<String>(
        fieldName: 'endDate',
        value: inspection.endDate!,
        isValid: true,
      );
    }

    // Scheduling time
    if (inspection.schedulingTime != '-' && inspection.meridiem != '-') {
      final parts = inspection.schedulingTime.split(':');
      if (parts.length >= 2) {
        cubit.validateFieldAndStoreTypedValue<String>(
          fieldName: 'hour',
          value: parts[0],
          isValid: true,
        );
        cubit.validateFieldAndStoreTypedValue<String>(
          fieldName: 'minute',
          value: parts[1],
          isValid: true,
        );
        cubit.validateFieldAndStoreTypedValue<TimeOfDayEnum>(
          fieldName: 'timeOfDay',
          value: TimeOfDayEnum.fromValue(inspection.meridiem),
          isValid: true,
        );
      }
    }

    // Frequency-specific settings
    if (freq.frequency is WeeklyRepeatFrequencyStrategy) {
      if (freq.repeatDays != null && freq.repeatDays!.isNotEmpty) {
        cubit.validateFieldAndStoreList<RecurringOrderRepeatDaysEnum>(
          fieldName: 'repeatDays',
          value: freq.repeatDays!,
          isValid: true,
        );
      }
    } else if (freq.frequency is MonthlyRepeatFrequencyStrategy) {
      if (freq.repeatType != null) {
        cubit.validateFieldAndStoreTypedValue<RecurringSettingRepeatType>(
          fieldName: 'repeatType',
          value: freq.repeatType!,
          isValid: true,
        );

        if (freq.repeatType == RecurringSettingRepeatType.byDate &&
            freq.dates != null) {
          cubit.validateFieldAndStoreList<RecurringOrderDatePickerEnum>(
            fieldName: 'repeatTypeMonthlyByDate',
            value: freq.dates!,
            isValid: freq.dates!.isNotEmpty,
          );
        } else if (freq.repeatType == RecurringSettingRepeatType.byPattern) {
          if (freq.every != null) {
            cubit.validateFieldAndStoreTypedValue<
              RecurringOrderSettingRepeatTypeEveryEnum
            >(
              fieldName: 'repeatTypeMonthlyByPatternEvery',
              value: freq.every!,
              isValid: true,
            );
          }
          if (freq.dayOfWeek != null) {
            cubit.validateFieldAndStoreTypedValue<RecurringOrderRepeatDaysEnum>(
              fieldName: 'repeatTypeMonthlyByPatternDays',
              value: freq.dayOfWeek!,
              isValid: true,
            );
          }
        }
      }
    } else if (freq.frequency is BasedOnInventoryLevelRepeatFrequencyStrategy) {
      if (freq.levelRatio != null) {
        cubit.validateFieldAndStoreTypedValue<String>(
          fieldName: 'levelRatioNum',
          value: freq.levelRatio!,
          isValid: true,
        );
      }
    }
  }
}

class _RecurringOrderSettingScreen extends StatelessWidget {
  final CreateRecurringOrderStrategy strategy;
  final PurchaseCreateOrderRequest? createOrderRequest;
  final PurchaseSourceStrategy? source;
  final int? sourceIndex;

  const _RecurringOrderSettingScreen({
    required this.strategy,
    this.createOrderRequest,
    this.source,
    this.sourceIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        top: 30.r,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr.setScheduleCycleAndNotificationsForThis,
                      style: AppStyles.s16W500.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                    12.verticalSpace,
                    const CustomDivider(),
                    12.verticalSpace,
                    const RecurringOrderSettingRepeatFrequencyWidget(),
                    12.verticalSpace,
                    BlocSelector<
                      ValidationCubit,
                      ValidationState,
                      RepeatFrequencyStrategy?
                    >(
                      selector: (state) =>
                          state.getTypedValue<RepeatFrequencyStrategy>(
                            'repeatFrequencyType',
                          ),
                      builder: (context, state) {
                        if (state == null) {
                          return const SizedBox.shrink();
                        }

                        return state.buildSpecialSection(context);
                      },
                    ),
                    const RecurringOrderSettingNotificationsWidget(),
                    12.verticalSpace,
                    const RecurringOrderSettingSmartSettingsWidget(),
                    12.verticalSpace,
                    const RecurringOrderActivationPeriodSettingsWidget(),
                  ],
                ),
              ),
            ),
            20.verticalSpace,
            Row(
              spacing: 12.w,
              children: [
                Expanded(
                  child: CustomTextButton(
                    text: context.tr.back,
                    onTap: () {
                      NavigationService.I.pop();
                    },
                    backgroundColor: Colors.transparent,
                    borderRadius: 18.r,
                    padding: EdgeInsets.symmetric(vertical: 18.h),
                    textColor: context.customColor.text1,
                  ),
                ),
                Expanded(
                  child: strategy.buildSubmitButton(
                    context,
                    createOrderRequest: createOrderRequest,
                    source: source,
                    sourceIndex: sourceIndex,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
