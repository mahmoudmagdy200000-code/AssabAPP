import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/recurring_order_repeat_days_enum.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/label_text_field.dart';
import 'recurring_order_setting_choose_item_widget.dart';

class RecurringOrderSettingRepeatDaysWidget extends StatefulWidget {
  const RecurringOrderSettingRepeatDaysWidget({super.key});

  @override
  State<RecurringOrderSettingRepeatDaysWidget> createState() =>
      _RecurringOrderSettingRepeatDaysWidgetState();
}

class _RecurringOrderSettingRepeatDaysWidgetState
    extends State<RecurringOrderSettingRepeatDaysWidget> {
  late final ValidationCubit _validationCubit;
  late final ValueNotifier<Set<RecurringOrderRepeatDaysEnum>> _selectedDays;

  @override
  void initState() {
    super.initState();

    _validationCubit = context.read<ValidationCubit>();

    final existing = _validationCubit
        .getListValue<RecurringOrderRepeatDaysEnum>('repeatDays');
    _selectedDays = ValueNotifier<Set<RecurringOrderRepeatDaysEnum>>(
      existing != null ? existing.toSet() : {},
    );

    _addDynamicFieldForRepeatDays();

    _selectedDays.addListener(() {
      _validationCubit.validateFieldAndStoreList<RecurringOrderRepeatDaysEnum>(
        fieldName: 'repeatDays',
        value: _selectedDays.value.toList(),
        isValid: _selectedDays.value.isNotEmpty,
      );
    });
  }

  @override
  void dispose() {
    _selectedDays.dispose();
    _validationCubit.removeDynamicFields({'repeatDays'});
    super.dispose();
  }

  void _addDynamicFieldForRepeatDays() {
    _validationCubit.addDynamicFields({'repeatDays'});
  }

  List<RecurringOrderRepeatDaysEnum> get _repeatDaysList => [
    RecurringOrderRepeatDaysEnum.sun,
    RecurringOrderRepeatDaysEnum.mon,
    RecurringOrderRepeatDaysEnum.tue,
    RecurringOrderRepeatDaysEnum.wed,
    RecurringOrderRepeatDaysEnum.thu,
    RecurringOrderRepeatDaysEnum.fri,
    RecurringOrderRepeatDaysEnum.sat,
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Set<RecurringOrderRepeatDaysEnum>>(
      valueListenable: _selectedDays,
      builder: (context, selectedDays, _) {
        return Container(
          decoration: BoxDecoration(
            color: context.customColor.text2,
            borderRadius: BorderRadius.circular(15.r),
          ),
          padding: EdgeInsets.all(16.r),
          child: Column(
            spacing: 8.h,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LabelTextField(text: context.tr.repeatDays),
              Text(
                context.tr.pickTheDaysToAutoSendThisOrderEveryWeek,
                style: AppStyles.s14W400.copyWith(
                  color: context.customColor.text3,
                ),
              ),
              GridView.count(
                crossAxisCount: 4,
                mainAxisSpacing: 8.h,
                crossAxisSpacing: 8.w,
                childAspectRatio: 1.5,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                children: _repeatDaysList
                    .map(
                      (day) => RecurringOrderSettingChooseItemWidget(
                        text: day.label(context),
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.r,
                          vertical: 9.r,
                        ),
                        textAlign: TextAlign.center,
                        isSelected: selectedDays.contains(day),
                        onTap: () {
                          final newSelected =
                              Set<RecurringOrderRepeatDaysEnum>.from(
                                selectedDays,
                              );

                          if (newSelected.contains(day)) {
                            newSelected.remove(day);
                          } else {
                            newSelected.add(day);
                          }

                          _selectedDays.value = newSelected;
                        },
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
