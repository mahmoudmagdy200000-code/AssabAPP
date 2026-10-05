import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/enums/recurring_order_repeat_days_enum.dart';
import '../../../../core/enums/recurring_order_setting_repeat_type_every_enum.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/custom_dropdown.dart';
import '../../../../core/widgets/label_text_field.dart';

class RecurringOrderSettingRepeatTypeByPatternWidget extends StatefulWidget {
  const RecurringOrderSettingRepeatTypeByPatternWidget({super.key});

  @override
  State<RecurringOrderSettingRepeatTypeByPatternWidget> createState() =>
      _RecurringOrderSettingRepeatTypeByPatternWidgetState();
}

class _RecurringOrderSettingRepeatTypeByPatternWidgetState
    extends State<RecurringOrderSettingRepeatTypeByPatternWidget> {
  late final ValidationCubit _validationCubit;

  @override
  void initState() {
    super.initState();

    _validationCubit = context.read<ValidationCubit>();

    _addDynamicFieldForScheduleTime();
  }

  @override
  void dispose() {
    _removeDynamicFieldForScheduleTime();
    super.dispose();
  }

  void _addDynamicFieldForScheduleTime() {
    _validationCubit.addDynamicFields({
      'repeatTypeMonthlyByPatternEvery',
      'repeatTypeMonthlyByPatternDays',
    });
  }

  void _removeDynamicFieldForScheduleTime() {
    _validationCubit.removeDynamicFields({
      'repeatTypeMonthlyByPatternEvery',
      'repeatTypeMonthlyByPatternDays',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 14.w,
      children: [
        Expanded(
          child: Column(
            children: [
              LabelTextField(text: context.tr.every),
              CustomDropdown<RecurringOrderSettingRepeatTypeEveryEnum>(
                items: RecurringOrderSettingRepeatTypeEveryEnum.values,
                initialValue: _validationCubit
                    .getTypedValue<RecurringOrderSettingRepeatTypeEveryEnum>(
                      'repeatTypeMonthlyByPatternEvery',
                    ),
                displayTextBuilder: (value) =>
                    value?.label ?? context.tr.choose,
                backgroundColor: context.customColor.reversedTextColor,
                iconColor: context.customColor.text4,
                iconSize: 18.r,
                borderRadius: 18.r,
                itemBuilder: (context, item, isSelected) {
                  return Container(
                    padding: EdgeInsets.all(16.r),
                    child: Text(
                      item.label,
                      style: AppStyles.s12W500.copyWith(
                        color: isSelected
                            ? context.theme.primaryColor
                            : context.customColor.text1,
                      ),
                    ),
                  );
                },
                onChanged: (value) {
                  _validationCubit.validateFieldAndStoreTypedValue<
                    RecurringOrderSettingRepeatTypeEveryEnum
                  >(
                    fieldName: 'repeatTypeMonthlyByPatternEvery',
                    value: value,
                    isValid: true,
                  );
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              LabelTextField(text: context.tr.dayOfTheWeek),
              CustomDropdown<RecurringOrderRepeatDaysEnum>(
                items: RecurringOrderRepeatDaysEnum.values,
                initialValue: _validationCubit
                    .getTypedValue<RecurringOrderRepeatDaysEnum>(
                      'repeatTypeMonthlyByPatternDays',
                    ),
                displayTextBuilder: (value) =>
                    value?.label(context) ?? context.tr.choose,
                backgroundColor: context.customColor.reversedTextColor,
                iconColor: context.customColor.text4,
                iconSize: 18.r,
                borderRadius: 18.r,
                itemBuilder: (context, item, isSelected) {
                  return Container(
                    padding: EdgeInsets.all(16.r),
                    child: Text(
                      item.label(context),
                      style: AppStyles.s12W500.copyWith(
                        color: isSelected
                            ? context.theme.primaryColor
                            : context.customColor.text1,
                      ),
                    ),
                  );
                },
                onChanged: (value) {
                  _validationCubit.validateFieldAndStoreTypedValue<
                    RecurringOrderRepeatDaysEnum
                  >(
                    fieldName: 'repeatTypeMonthlyByPatternDays',
                    value: value,
                    isValid: true,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
