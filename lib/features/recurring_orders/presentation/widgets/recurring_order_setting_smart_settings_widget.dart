import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/enums/recurring_order_smart_settings_enum.dart';
import '../../../../core/widgets/label_text_field.dart';
import 'recurring_order_setting_choose_item_widget.dart';

class RecurringOrderSettingSmartSettingsWidget extends StatefulWidget {
  const RecurringOrderSettingSmartSettingsWidget({super.key});

  @override
  State<RecurringOrderSettingSmartSettingsWidget> createState() =>
      _RecurringOrderSettingSmartSettingsWidgetState();
}

class _RecurringOrderSettingSmartSettingsWidgetState
    extends State<RecurringOrderSettingSmartSettingsWidget> {
  late final ValueNotifier<Set<RecurringOrderSmartSettingsEnum>>
  _selectedSmartSettings;

  @override
  void initState() {
    super.initState();

    final existing = context
        .read<ValidationCubit>()
        .getListValue<RecurringOrderSmartSettingsEnum>('smartSettings');
    _selectedSmartSettings =
        ValueNotifier<Set<RecurringOrderSmartSettingsEnum>>(
          existing != null ? existing.toSet() : {},
        );

    _selectedSmartSettings.addListener(() {
      context
          .read<ValidationCubit>()
          .validateFieldAndStoreList<RecurringOrderSmartSettingsEnum>(
            fieldName: 'smartSettings',
            value: _selectedSmartSettings.value.toList(),
            isValid: _selectedSmartSettings.value.isNotEmpty,
          );
    });
  }

  @override
  void dispose() {
    _selectedSmartSettings.dispose();
    super.dispose();
  }

  List<RecurringOrderSmartSettingsEnum> get _smartSettingsList => [
    RecurringOrderSmartSettingsEnum.autoAdjustQuantitiesBasedOnConsumption,
    RecurringOrderSmartSettingsEnum.freezeDuringHolidaysAndEvents,
    RecurringOrderSmartSettingsEnum.notifyWhenPricesChange,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.customColor.text2,
        borderRadius: BorderRadius.circular(15.r),
      ),
      padding: EdgeInsets.all(16.r),
      child: Column(
        spacing: 8.h,
        children: [
          LabelTextField(text: context.tr.smartSettings),
          ...List.generate(_smartSettingsList.length, (index) {
            return ValueListenableBuilder<Set<RecurringOrderSmartSettingsEnum>>(
              valueListenable: _selectedSmartSettings,
              builder: (context, selected, child) {
                return RecurringOrderSettingChooseItemWidget(
                  text: _smartSettingsList[index].label(context),
                  onTap: () {
                    final newSelected =
                        Set<RecurringOrderSmartSettingsEnum>.from(selected);

                    if (newSelected.contains(_smartSettingsList[index])) {
                      newSelected.remove(_smartSettingsList[index]);
                    } else {
                      newSelected.add(_smartSettingsList[index]);
                    }

                    _selectedSmartSettings.value = newSelected;
                  },
                  isSelected: selected.contains(_smartSettingsList[index]),
                );
              },
            );
          }),
        ],
      ),
    );
  }
}
