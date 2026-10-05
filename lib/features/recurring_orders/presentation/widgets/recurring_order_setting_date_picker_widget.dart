import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/enums/recurring_order_date_picker_enum.dart';

class RecurringOrderSettingDatePickerWidget extends StatefulWidget {
  const RecurringOrderSettingDatePickerWidget({super.key});

  @override
  State<RecurringOrderSettingDatePickerWidget> createState() =>
      _RecurringOrderSettingDatePickerWidgetState();
}

class _RecurringOrderSettingDatePickerWidgetState
    extends State<RecurringOrderSettingDatePickerWidget> {
  late final ValueNotifier<Set<RecurringOrderDatePickerEnum>> _selectedDates;

  @override
  void initState() {
    super.initState();

    _selectedDates = ValueNotifier<Set<RecurringOrderDatePickerEnum>>({});

    _loadSavedDates();
  }

  @override
  void dispose() {
    _selectedDates.dispose();
    super.dispose();
  }

  void _loadSavedDates() {
    final saved = context
        .read<ValidationCubit>()
        .getListValue<RecurringOrderDatePickerEnum>('repeatTypeMonthlyByDate');

    if (saved != null) {
      _selectedDates.value = saved.toSet();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Set<RecurringOrderDatePickerEnum>>(
      valueListenable: _selectedDates,
      builder: (context, selectedDates, _) {
        return Scaffold(
          body: AppPaddingWidget(
            top: 30.r,
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.tr.datePicker,
                        style: AppStyles.s20W600.copyWith(
                          color: context.customColor.text1,
                        ),
                      ),
                      8.verticalSpace,
                      Text(
                        context.tr.repeatMonthlyOnEvery,
                        style: AppStyles.s14W400.copyWith(
                          color: context.customColor.text3,
                        ),
                      ),
                      14.verticalSpace,
                      GridView.count(
                        crossAxisCount: 6,
                        shrinkWrap: true,
                        mainAxisSpacing: 8.r,
                        crossAxisSpacing: 8.r,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        children: [
                          ...List.generate(
                            RecurringOrderDatePickerEnum.values.length,
                            (index) {
                              final date =
                                  RecurringOrderDatePickerEnum.values[index];
                              final isSelected = selectedDates.contains(date);
                              return AppGestureDetectorButton(
                                onTap: () {
                                  final newSelected =
                                      Set<RecurringOrderDatePickerEnum>.from(
                                        selectedDates,
                                      );
                                  if (newSelected.contains(date)) {
                                    newSelected.remove(date);
                                  } else {
                                    newSelected.add(date);
                                  }
                                  _selectedDates.value = newSelected;
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.r),
                                    border: Border.all(
                                      color: isSelected
                                          ? context.theme.primaryColor
                                          : context.customColor.border,
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 9.r),
                                  child: Text(
                                    '${index + 1}',
                                    style: AppStyles.s14W600.copyWith(
                                      color: isSelected
                                          ? context.theme.primaryColor
                                          : context.customColor.text1,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                20.verticalSpace,
                AppButton(
                  onClick: () {
                    context.read<ValidationCubit>().validateFieldAndStoreList<
                      RecurringOrderDatePickerEnum
                    >(
                      fieldName: 'repeatTypeMonthlyByDate',
                      value: _selectedDates.value.toList(),
                      isValid: _selectedDates.value.isNotEmpty,
                    );

                    NavigationService.I.pop();
                  },
                  text: context.tr.confirmSelections,
                  enabled: selectedDates.isNotEmpty,
                  borderRadius: BorderRadius.circular(15.r),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
