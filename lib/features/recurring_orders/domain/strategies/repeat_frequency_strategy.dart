import 'package:assab/core/cubits/choose_item/choose_item_cubit.dart';
import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/cubits/validation/validation_state.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/recurring_order_date_picker_enum.dart';
import '../../../../core/enums/recurring_order_repeat_days_enum.dart';
import '../../../../core/enums/recurring_order_setting_repeat_type_every_enum.dart';
import '../../../../core/enums/recurring_setting_repeat_type.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../../../core/widgets/saudi_riyal_svg_widget.dart';
import '../../data/models/create_recurring_order_request.dart';
import '../../data/models/recurring_order_details_response.dart';
import '../../presentation/widgets/recurring_order_setting_level_ratio_widget.dart';
import '../../presentation/widgets/recurring_order_setting_repeat_days_widget.dart';
import '../../presentation/widgets/recurring_order_setting_repeat_type_widget.dart';
import '../../presentation/widgets/recurring_order_setting_schedule_time_widget.dart';
import '../../presentation/widgets/repeat_mode_summary_widget.dart';

abstract class RepeatFrequencyStrategy {
  static RepeatFrequencyStrategy fromString(String value) {
    switch (value) {
      case 'weekly':
        return WeeklyRepeatFrequencyStrategy();
      case 'monthly':
        return MonthlyRepeatFrequencyStrategy();
      case 'based_on_inventory':
        return BasedOnInventoryLevelRepeatFrequencyStrategy();
      default:
        return WeeklyRepeatFrequencyStrategy();
    }
  }

  Widget buildSpecialSection(BuildContext context) {
    return const SizedBox.shrink();
  }

  String getDisplayValue(BuildContext context) {
    return '';
  }

  Widget buildScheduleSettingsForSummary(BuildContext context) {
    return const SizedBox.shrink();
  }

  Widget buildScheduleSettingsForSummaryBasedOnApi(
    BuildContext context,
    RecurringOrderDetailsFrequencySettings frequencySettings,
  ) {
    return const SizedBox.shrink();
  }

  Widget buildRepeatModeWidget(BuildContext context) {
    return const SizedBox.shrink();
  }

  String get getRepeatFrequencyValue;

  CreateRecurringOrderRequestRepeatConfig? buildRepeatConfig(
    ValidationCubit validationCubit,
  );
}

Text _buildColumnWidget({required BuildContext context, required String text}) {
  return Text(
    text,
    style: AppStyles.s13W500.copyWith(color: context.customColor.text1),
    textAlign: TextAlign.end,
  );
}

Widget _buildRowDetails({
  required BuildContext context,
  required String title,
  String? value,
  bool isCurrency = false,
  Widget? customValue,
  CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: crossAxisAlignment,
    children: [
      Expanded(
        child: Text(
          title,
          style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
        ),
      ),
      Expanded(
        child:
            customValue ??
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (isCurrency) const SaudiRiyalSvgWidget(),
                3.horizontalSpace,
                Flexible(
                  child: Text(
                    value ?? '',
                    style: AppStyles.s13W500.copyWith(
                      color: context.customColor.text1,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
      ),
    ],
  );
}

class WeeklyRepeatFrequencyStrategy extends RepeatFrequencyStrategy {
  @override
  Widget buildSpecialSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const RecurringOrderSettingRepeatDaysWidget(),
        12.verticalSpace,
        const RecurringOrderSettingScheduleTimeWidget(),
        12.verticalSpace,
      ],
    );
  }

  @override
  String getDisplayValue(BuildContext context) {
    return context.tr.weekly;
  }

  @override
  String get getRepeatFrequencyValue => 'weekly';

  @override
  CreateRecurringOrderRequestRepeatConfig? buildRepeatConfig(
    ValidationCubit validationCubit,
  ) {
    final repeatDays = validationCubit
        .getListValue<RecurringOrderRepeatDaysEnum>('repeatDays');

    return CreateRecurringOrderRequestRepeatConfig(
      repeatDays: repeatDays?.map((e) => e.value).toList(),
      repeatType: null,
      dates: null,
      occurrence: null,
      dayOfWeek: null,
      levelRatio: null,
      customThreshold: null,
    );
  }

  @override
  Widget buildScheduleSettingsForSummary(BuildContext context) {
    return BlocSelector<
      ValidationCubit,
      ValidationState,
      List<RecurringOrderRepeatDaysEnum>
    >(
      selector: (state) =>
          state.getListValue<RecurringOrderRepeatDaysEnum>('repeatDays') ?? [],
      builder: (context, state) {
        return _buildRowDetails(
          context: context,
          title: context.tr.requestDays,
          crossAxisAlignment: CrossAxisAlignment.start,
          customValue: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: state
                .map(
                  (e) => _buildColumnWidget(
                    context: context,
                    text: '${e.label(context)} -',
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }

  @override
  Widget buildScheduleSettingsForSummaryBasedOnApi(
    BuildContext context,
    RecurringOrderDetailsFrequencySettings frequencySettings,
  ) {
    return _buildRowDetails(
      context: context,
      title: context.tr.requestDays,
      crossAxisAlignment: CrossAxisAlignment.start,
      customValue: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: (frequencySettings.repeatDays ?? [])
            .map(
              (e) => _buildColumnWidget(
                context: context,
                text: '${e.label(context)} -',
              ),
            )
            .toList(),
      ),
    );
  }

  @override
  Widget buildRepeatModeWidget(BuildContext context) {
    return BlocSelector<
      ValidationCubit,
      ValidationState,
      List<RecurringOrderRepeatDaysEnum>
    >(
      selector: (state) =>
          state.getListValue<RecurringOrderRepeatDaysEnum>('repeatDays') ?? [],
      builder: (context, state) {
        return RepeatModeSummaryWidget(
          text: context.tr.thisOrderWillRepeatOnEvery(
            state.map((e) => e.label(context)).toList().join(', '),
          ),
        );
      },
    );
  }
}

class MonthlyRepeatFrequencyStrategy extends RepeatFrequencyStrategy {
  @override
  Widget buildSpecialSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BlocProvider(
          create: (context) {
            final cubit = PagingCubit(totalSteps: 2);
            final repeatType = context
                .read<ValidationCubit>()
                .getTypedValue<RecurringSettingRepeatType>('repeatType');
            if (repeatType == RecurringSettingRepeatType.byPattern) {
              cubit.goToStep(1);
            }
            return cubit;
          },
          child: const RecurringOrderSettingRepeatTypeWidget(),
        ),
        12.verticalSpace,
      ],
    );
  }

  @override
  String getDisplayValue(BuildContext context) {
    return context.tr.monthly;
  }

  @override
  String get getRepeatFrequencyValue => 'monthly';

  @override
  CreateRecurringOrderRequestRepeatConfig? buildRepeatConfig(
    ValidationCubit validationCubit,
  ) {
    final repeatType = validationCubit
        .getTypedValue<RecurringSettingRepeatType>('repeatType');

    if (repeatType == RecurringSettingRepeatType.byDate) {
      final dates = validationCubit.getListValue<RecurringOrderDatePickerEnum>(
        'repeatTypeMonthlyByDate',
      );

      return CreateRecurringOrderRequestRepeatConfig(
        repeatDays: null,
        repeatType: repeatType?.value,
        dates: dates?.map((e) => e.value).toList(),
        occurrence: null,
        dayOfWeek: null,
        levelRatio: null,
        customThreshold: null,
      );
    } else if (repeatType == RecurringSettingRepeatType.byPattern) {
      final every = validationCubit
          .getTypedValue<RecurringOrderSettingRepeatTypeEveryEnum>(
            'repeatTypeMonthlyByPatternEvery',
          );
      final day = validationCubit.getTypedValue<RecurringOrderRepeatDaysEnum>(
        'repeatTypeMonthlyByPatternDays',
      );

      return CreateRecurringOrderRequestRepeatConfig(
        repeatDays: null,
        repeatType: repeatType?.value,
        dates: null,
        occurrence: every?.value,
        dayOfWeek: day?.value,
        levelRatio: null,
        customThreshold: null,
      );
    }

    return null;
  }

  @override
  Widget buildScheduleSettingsForSummary(BuildContext context) {
    return Column(
      children: [
        BlocSelector<
          ValidationCubit,
          ValidationState,
          RecurringSettingRepeatType?
        >(
          selector: (state) =>
              state.getTypedValue<RecurringSettingRepeatType>('repeatType'),
          builder: (context, state) {
            return _buildRowDetails(
              context: context,
              title: context.tr.repeatType,
              crossAxisAlignment: CrossAxisAlignment.start,
              value: state?.label(context) ?? 'N/A',
            );
          },
        ),
        8.verticalSpace,
        const CustomDivider(),
        8.verticalSpace,
        BlocSelector<
          ValidationCubit,
          ValidationState,
          RecurringSettingRepeatType?
        >(
          selector: (state) =>
              state.getTypedValue<RecurringSettingRepeatType>('repeatType'),
          builder: (context, state) {
            if (state == RecurringSettingRepeatType.byDate) {
              return BlocSelector<
                ValidationCubit,
                ValidationState,
                List<RecurringOrderDatePickerEnum>
              >(
                selector: (state) =>
                    state.getListValue<RecurringOrderDatePickerEnum>(
                      'repeatTypeMonthlyByDate',
                    ) ??
                    [],
                builder: (context, state) {
                  return _buildRowDetails(
                    context: context,
                    title: context.tr.repeatDayOfEveryMonth,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    value: state.isNotEmpty
                        ? state.map((e) => e.label).join(', ')
                        : 'N/A',
                  );
                },
              );
            } else if (state == RecurringSettingRepeatType.byPattern) {
              return BlocSelector<
                ValidationCubit,
                ValidationState,
                Map<String, dynamic>?
              >(
                selector: (state) {
                  final every =
                      state
                          .getTypedValue<
                            RecurringOrderSettingRepeatTypeEveryEnum
                          >('repeatTypeMonthlyByPatternEvery')
                          ?.label ??
                      '-';

                  final day =
                      state
                          .getTypedValue<RecurringOrderRepeatDaysEnum>(
                            'repeatTypeMonthlyByPatternDays',
                          )
                          ?.label(context) ??
                      '';

                  return {'every': every, 'day': day};
                },
                builder: (context, state) {
                  return _buildRowDetails(
                    context: context,
                    title: context.tr.repeatDayOfEveryMonth,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    value:
                        '${state?['every']} ${state?['day'] ?? '-'}\n${context.tr.ofEveryMonth}',
                  );
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  @override
  Widget buildScheduleSettingsForSummaryBasedOnApi(
    BuildContext context,
    RecurringOrderDetailsFrequencySettings frequencySettings,
  ) {
    return Column(
      children: [
        _buildRowDetails(
          context: context,
          title: context.tr.repeatType,
          crossAxisAlignment: CrossAxisAlignment.start,
          value: frequencySettings.repeatType?.label(context) ?? 'N/A',
        ),
        8.verticalSpace,
        const CustomDivider(),
        8.verticalSpace,
        if (frequencySettings.repeatType ==
            RecurringSettingRepeatType.byDate) ...[
          _buildRowDetails(
            context: context,
            title: context.tr.repeatDayOfEveryMonth,
            crossAxisAlignment: CrossAxisAlignment.start,
            value:
                frequencySettings.dates?.map((e) => e.label).join(', ') ??
                'N/A',
          ),
        ] else if (frequencySettings.repeatType ==
            RecurringSettingRepeatType.byPattern) ...[
          _buildRowDetails(
            context: context,
            title: context.tr.repeatDayOfEveryMonth,
            crossAxisAlignment: CrossAxisAlignment.start,
            value:
                '${frequencySettings.dayOfWeek?.label(context) ?? '-'} ${frequencySettings.every?.label ?? '-'}\n${context.tr.ofEveryMonth}',
          ),
        ],
      ],
    );
  }

  @override
  Widget buildRepeatModeWidget(BuildContext context) {
    return BlocSelector<
      ValidationCubit,
      ValidationState,
      RecurringSettingRepeatType?
    >(
      selector: (state) =>
          state.getTypedValue<RecurringSettingRepeatType>('repeatType'),
      builder: (context, state) {
        if (state == RecurringSettingRepeatType.byDate) {
          return BlocSelector<
            ValidationCubit,
            ValidationState,
            List<RecurringOrderDatePickerEnum>
          >(
            selector: (state) =>
                state.getListValue<RecurringOrderDatePickerEnum>(
                  'repeatTypeMonthlyByDate',
                ) ??
                [],
            builder: (context, state) {
              return RepeatModeSummaryWidget(
                text: context.tr.thisOrderWillRepeatOnEveryOfEveryMonth(
                  state.map((e) => e.label).toList().join(', '),
                ),
              );
            },
          );
        } else if (state == RecurringSettingRepeatType.byPattern) {
          return BlocSelector<
            ValidationCubit,
            ValidationState,
            Map<String, dynamic>?
          >(
            selector: (state) {
              final every =
                  state
                      .getTypedValue<RecurringOrderSettingRepeatTypeEveryEnum>(
                        'repeatTypeMonthlyByPatternEvery',
                      )
                      ?.label ??
                  '-';

              final day =
                  state
                      .getTypedValue<RecurringOrderRepeatDaysEnum>(
                        'repeatTypeMonthlyByPatternDays',
                      )
                      ?.label(context) ??
                  '';

              return {'every': every, 'day': day};
            },
            builder: (context, state) {
              return RepeatModeSummaryWidget(
                text: context.tr.thisOrderWillRepeatOnEveryOfEveryMonth(
                  '${state?['every']} ${state?['day'] ?? 'N/A'}',
                ),
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class BasedOnInventoryLevelRepeatFrequencyStrategy
    extends RepeatFrequencyStrategy {
  @override
  Widget buildSpecialSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BlocProvider(
          create: (context) {
            final cubit = getIt<ChooseItemCubit>();
            final levelRatio = context
                .read<ValidationCubit>()
                .getTypedValue<String>('levelRatioNum');
            if (levelRatio != null) {
              switch (levelRatio) {
                case '10':
                  cubit.selectItem(0);
                case '20':
                  cubit.selectItem(1);
                case '40':
                  cubit.selectItem(2);
                default:
                  cubit.selectItem(3);
              }
            }
            return cubit;
          },
          child: const RecurringOrderSettingLevelRatioWidget(),
        ),
        12.verticalSpace,
      ],
    );
  }

  @override
  String getDisplayValue(BuildContext context) {
    return context.tr.basedOnInventoryLevel;
  }

  @override
  String get getRepeatFrequencyValue => 'based_on_inventory';

  @override
  CreateRecurringOrderRequestRepeatConfig? buildRepeatConfig(
    ValidationCubit validationCubit,
  ) {
    final levelRatio = validationCubit.getTypedValue<String>('levelRatioNum');

    return CreateRecurringOrderRequestRepeatConfig(
      repeatDays: null,
      repeatType: null,
      dates: null,
      occurrence: null,
      dayOfWeek: null,
      levelRatio: levelRatio,
      customThreshold: null,
    );
  }

  @override
  Widget buildScheduleSettingsForSummary(BuildContext context) {
    return BlocSelector<ValidationCubit, ValidationState, String?>(
      selector: (state) => state.getTypedValue<String>('levelRatioNum'),
      builder: (context, state) {
        return _buildRowDetails(
          context: context,
          title: context.tr.levelRatio,
          crossAxisAlignment: CrossAxisAlignment.start,
          value: '${state ?? 'N/A'}%',
        );
      },
    );
  }

  @override
  Widget buildScheduleSettingsForSummaryBasedOnApi(
    BuildContext context,
    RecurringOrderDetailsFrequencySettings frequencySettings,
  ) {
    return _buildRowDetails(
      context: context,
      title: context.tr.levelRatio,
      crossAxisAlignment: CrossAxisAlignment.start,
      value: '${frequencySettings.levelRatio ?? 'N/A'}%',
    );
  }

  @override
  Widget buildRepeatModeWidget(BuildContext context) {
    return BlocSelector<ValidationCubit, ValidationState, String?>(
      selector: (state) => state.getTypedValue<String>('levelRatioNum'),
      builder: (context, state) {
        return RepeatModeSummaryWidget(
          text: context.tr
              .whenSelectedItemAvailableQuantityDropsToPersOfUsualLevelsNewOrderCreatedAutomatically(
                state ?? 'N/A',
              ),
        );
      },
    );
  }
}
