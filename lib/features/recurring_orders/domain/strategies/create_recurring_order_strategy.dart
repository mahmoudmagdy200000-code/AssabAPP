import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/enums/recurring_order_activate_period_end_date_enum.dart';
import '../../../../core/enums/recurring_order_notifications_enum.dart';
import '../../../../core/enums/recurring_order_smart_settings_enum.dart';
import '../../../../core/enums/time_of_day_enum.dart';
import '../../../../core/strategies/purchase_source_strategy.dart';
import '../../../../core/utils/app_bottom_sheet.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../purchase/data/models/purchase_create_order_request.dart';
import '../../data/models/update_recurring_order_request.dart';
import '../../presentation/cubit/create_recurring_order/create_recurring_order_cubit.dart';
import '../../presentation/cubit/recurring_order_actions/recurring_order_actions_cubit.dart';
import '../../presentation/cubit/recurring_order_actions/recurring_order_actions_state.dart';
import '../../presentation/screens/recurring_order_setting_summary_screen.dart';
import 'repeat_frequency_strategy.dart';

abstract class CreateRecurringOrderStrategy {
  Widget buildSubmitButton(
    BuildContext context, {
    PurchaseCreateOrderRequest? createOrderRequest,
    PurchaseSourceStrategy? source,
    int? sourceIndex,
  }) {
    return const SizedBox.shrink();
  }
}

class CreateNewCreateRecurringOrderStrategy
    extends CreateRecurringOrderStrategy {
  @override
  Widget buildSubmitButton(
    BuildContext context, {
    PurchaseCreateOrderRequest? createOrderRequest,
    PurchaseSourceStrategy? source,
    int? sourceIndex,
  }) {
    return BlocSelector<ValidationCubit, ValidationState, bool>(
      selector: (state) => state.enableButton,
      builder: (context, state) {
        return AppButton(
          onClick: () {
            final validationCubit = context.read<ValidationCubit>();

            AppBottomSheet.customPageRoute(
              context,
              (context) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(value: validationCubit),
                  BlocProvider(
                    create: (context) => getIt<CreateRecurringOrderCubit>(),
                  ),
                ],
                child: RecurringOrderSettingSummaryScreen(
                  createOrderRequest: createOrderRequest!,
                  source: source!,
                  sourceIndex: sourceIndex!,
                ),
              ),
            );
          },
          text: context.tr.summary,
          borderRadius: BorderRadius.circular(18.r),
          padding: EdgeInsets.symmetric(vertical: 18.r),
          enabled: state,
        );
      },
    );
  }
}

class EditCreateRecurringOrderStrategy extends CreateRecurringOrderStrategy {
  final String orderId;

  EditCreateRecurringOrderStrategy({required this.orderId});

  @override
  Widget buildSubmitButton(
    BuildContext context, {
    PurchaseCreateOrderRequest? createOrderRequest,
    PurchaseSourceStrategy? source,
    int? sourceIndex,
  }) {
    return BlocConsumer<RecurringOrderActionsCubit, RecurringOrderActionsState>(
      listener: (context, recurringOrderActionsState) {
        if (recurringOrderActionsState is RecurringOrderActionsSuccess) {
          NavigationService.I.pop();
        } else if (recurringOrderActionsState is RecurringOrderActionsFailure) {
          AppDialog.showErrorDialog(
            context: context,
            failure: recurringOrderActionsState.failure,
          );
        }
      },
      builder: (context, recurringOrderActionsState) {
        return BlocSelector<ValidationCubit, ValidationState, bool>(
          selector: (state) => state.enableButton,
          builder: (context, state) {
            if (recurringOrderActionsState is RecurringOrderActionsLoading) {
              return const AppLoadingWidget();
            }

            return AppButton(
              onClick: () {
                final validationCubit = context.read<ValidationCubit>();

                final strategy = validationCubit
                    .getTypedValue<RepeatFrequencyStrategy>(
                      'repeatFrequencyType',
                    );

                final notifications = validationCubit
                    .getListValue<RecurringOrderNotificationsEnum>(
                      'notifications',
                    );

                final smartSettingsList = validationCubit
                    .getListValue<RecurringOrderSmartSettingsEnum>(
                      'smartSettings',
                    );

                final startDate = validationCubit.getTypedValue<String>(
                  'startDate',
                );

                final endDateType = validationCubit
                    .getTypedValue<RecurringOrderActivatePeriodEndDateEnum>(
                      'endDateType',
                    );

                final endDate = validationCubit.getTypedValue<String>(
                  'endDate',
                );

                final timeOfDay = validationCubit.getTypedValue<TimeOfDayEnum>(
                  'timeOfDay',
                );
                final hour = validationCubit.getTypedValue<String>('hour');
                final minute = validationCubit.getTypedValue<String>('minute');

                String? schedulingTime;
                String? meridiem;

                if (hour != null && minute != null && timeOfDay != null) {
                  final formattedHour = hour.padLeft(2, '0');
                  final formattedMinute = minute.padLeft(2, '0');

                  schedulingTime = '$formattedHour:$formattedMinute:00';
                  meridiem = timeOfDay.name;
                }

                final request = UpdateRecurringOrderRequest(
                  repeatFrequency: strategy?.getRepeatFrequencyValue,
                  repeatConfig: strategy?.buildRepeatConfig(validationCubit),
                  schedulingTime: schedulingTime,
                  meridiem: meridiem,
                  notificationOptions: notifications
                      ?.map((e) => e.value)
                      .toList(),
                  smartSettings: smartSettingsList
                      ?.map((e) => e.value)
                      .toList(),
                  startDate: startDate,
                  endDate: endDate,
                  endType: endDateType?.value,
                );

                context.read<RecurringOrderActionsCubit>().updateRecurringOrder(
                  id: orderId,
                  request: request,
                );
              },
              text: context.tr.update,
              borderRadius: BorderRadius.circular(18.r),
              padding: EdgeInsets.symmetric(vertical: 18.r),
              enabled: state,
            );
          },
        );
      },
    );
  }
}
