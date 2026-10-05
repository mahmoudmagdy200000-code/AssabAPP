import 'package:assab/core/cubits/choose_item/choose_item_cubit.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/choose_item/choose_item_state.dart';
import '../../../../core/enums/recurring_order_setting_level_ratio_enum.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../../core/widgets/container_custom_text_field.dart';
import '../../../../core/widgets/label_text_field.dart';
import '../../../../core/widgets/selection_circule.dart';

class RecurringOrderSettingLevelRatioWidget extends StatefulWidget {
  const RecurringOrderSettingLevelRatioWidget({super.key});

  @override
  State<RecurringOrderSettingLevelRatioWidget> createState() =>
      _RecurringOrderSettingLevelRatioWidgetState();
}

class _RecurringOrderSettingLevelRatioWidgetState
    extends State<RecurringOrderSettingLevelRatioWidget> {
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
    _validationCubit.addDynamicFields({'levelRatioNum'});
  }

  void _removeDynamicFieldForScheduleTime() {
    _validationCubit.removeDynamicFields({'levelRatioNum'});
  }

  List<RecurringOrderSettingLevelRatioEnum> get _levelValues => [
    RecurringOrderSettingLevelRatioEnum.l10Percent,
    RecurringOrderSettingLevelRatioEnum.l20Percent,
    RecurringOrderSettingLevelRatioEnum.l40Percent,
    RecurringOrderSettingLevelRatioEnum.custom,
  ];

  List<String> _levelDesc(BuildContext context) => [
    context.tr.emergency,
    context.tr.low,
    context.tr.moderate,
    context.tr.setValue,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LabelTextField(text: context.tr.levelRatio),
          Text(
            context.tr.triggerOrderWhenSelectedItemAvailableQuantityDropsTo,
            style: AppStyles.s14W400.copyWith(color: context.customColor.text3),
          ),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            mainAxisSpacing: 8.r,
            crossAxisSpacing: 8.r,
            childAspectRatio: 2,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            children: List.generate(4, (index) {
              return AppGestureDetectorButton(
                onTap: () {
                  context.read<ChooseItemCubit>().selectItem(index);

                  final isLastIndex = index == _levelValues.length - 1;

                  if (isLastIndex) {
                    _validationCubit.validateFieldAndStoreTypedValue<String?>(
                      fieldName: 'levelRatioNum',
                      value: null,
                      isValid: false,
                    );

                    return;
                  }

                  _validationCubit.validateFieldAndStoreTypedValue<String>(
                    fieldName: 'levelRatioNum',
                    value: _levelValues[index].value,
                    isValid: true,
                  );
                },
                child: BlocSelector<ChooseItemCubit, ChooseItemState, bool>(
                  selector: (state) {
                    return state.selectedIndex == index;
                  },
                  builder: (context, state) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.r),
                        border: Border.all(
                          color: state
                              ? context.theme.primaryColor
                              : context.customColor.border,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.r,
                        vertical: 12.r,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _levelValues[index].label(context),
                                  style: AppStyles.s14W500.copyWith(
                                    color: state
                                        ? context.theme.primaryColor
                                        : context.customColor.text1,
                                  ),
                                ),
                                4.verticalSpace,
                                Text(
                                  _levelDesc(context)[index],
                                  style: AppStyles.s13W400.copyWith(
                                    color: context.customColor.text3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          12.horizontalSpace,
                          SelectionCircule(isSelected: state),
                        ],
                      ),
                    );
                  },
                ),
              );
            }),
          ),
          BlocSelector<ChooseItemCubit, ChooseItemState, bool>(
            selector: (state) {
              final isLastIndex =
                  state.selectedIndex == _levelValues.length - 1;

              return isLastIndex;
            },
            builder: (context, state) {
              if (!state) {
                return const SizedBox.shrink();
              }

              return const RecurringOrderSettingLevelRatioCustomRatioWidget();
            },
          ),
          BlocSelector<ChooseItemCubit, ChooseItemState, bool>(
            selector: (state) {
              return state.selectedIndex != null;
            },
            builder: (context, state) {
              if (!state) {
                return const SizedBox.shrink();
              }

              return Container(
                decoration: BoxDecoration(
                  color: context.customColor.text3.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(color: context.customColor.border),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 12.r),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.error_outline_outlined,
                      color: context.theme.primaryColor,
                    ),
                    12.horizontalSpace,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.tr.triggerCondition,
                            style: AppStyles.s14W600.copyWith(
                              color: context.customColor.text1,
                            ),
                          ),
                          4.verticalSpace,
                          Text(
                            context
                                .tr
                                .aNewOrderWillBeAutoCreatedButNoFurtherOrdersWillBeTriggeredUntilRestockIsConfirmed,
                            style: AppStyles.s14W400.copyWith(
                              color: context.customColor.text3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class RecurringOrderSettingLevelRatioCustomRatioWidget extends StatefulWidget {
  const RecurringOrderSettingLevelRatioCustomRatioWidget({super.key});

  @override
  State<RecurringOrderSettingLevelRatioCustomRatioWidget> createState() =>
      _RecurringOrderSettingLevelRatioCustomRatioWidgetState();
}

class _RecurringOrderSettingLevelRatioCustomRatioWidgetState
    extends State<RecurringOrderSettingLevelRatioCustomRatioWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomDivider(color: context.customColor.border),
        8.verticalSpace,
        ContainerCustomTextField(
          backgroundColor: context.customColor.reversedTextColor,
          child: Row(
            children: [
              Expanded(
                child: CustomTextField(
                  hintText: '0',
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    context
                        .read<ValidationCubit>()
                        .validateFieldAndStoreTypedValue<String>(
                          fieldName: 'levelRatioNum',
                          value: value,
                          isValid:
                              value.isNotEmpty &&
                              double.tryParse(value) != null &&
                              double.parse(value) > 0 &&
                              double.parse(value) <= 100,
                        );
                  },
                ),
              ),
              12.horizontalSpace,
              Text(
                context.tr.ratioLevel,
                style: AppStyles.s14W400.copyWith(
                  color: context.customColor.text3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
