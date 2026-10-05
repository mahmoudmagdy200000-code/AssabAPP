import 'package:assab/core/cubits/choose_item/choose_item_cubit.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/custom_dropdown.dart';
import 'package:assab/core/widgets/label_text_field.dart';
import 'package:assab/core/widgets/selection_circule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/choose_item/choose_item_state.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/enums/time_of_day_enum.dart';

class TimePickerBottomSheetWidget extends StatefulWidget {
  const TimePickerBottomSheetWidget({super.key});

  @override
  State<TimePickerBottomSheetWidget> createState() =>
      _TimePickerBottomSheetWidgetState();
}

class _TimePickerBottomSheetWidgetState
    extends State<TimePickerBottomSheetWidget> {
  late final ValidationCubit _validationCubit;

  @override
  void initState() {
    super.initState();

    _validationCubit = context.read<ValidationCubit>();

    _loadSavedValuesFromValidationCubit();

    if (!_validationCubit.fieldIsExists('submitTimePickerData')) {
      _validationCubit.addDynamicFields({'submitTimePickerData'});
    }
  }

  @override
  void dispose() {
    if (!_validationCubit.fieldIsValid('submitTimePickerData')) {
      _validationCubit.validateFieldAndStoreTypedValue<TimeOfDayEnum?>(
        fieldName: 'timeOfDay',
        value: null,
        isValid: false,
      );

      _validationCubit.validateFieldAndStoreTypedValue<String?>(
        fieldName: 'hour',
        value: null,
        isValid: false,
      );

      _validationCubit.validateFieldAndStoreTypedValue<String?>(
        fieldName: 'minute',
        value: null,
        isValid: false,
      );
    }
    super.dispose();
  }

  void _loadSavedValuesFromValidationCubit() {
    final timeOfDay = _validationCubit.getTypedValue<TimeOfDayEnum>(
      'timeOfDay',
    );

    if (_validationCubit.getTypedValue<String>('hour') != null &&
        _validationCubit.getTypedValue<String>('minute') != null &&
        timeOfDay != null) {
      context.read<ChooseItemCubit>().selectItem(
        timeOfDay == TimeOfDayEnum.am ? 0 : 1,
      );
    }
  }

  List<TimeOfDayEnum> get _timeofDay => [TimeOfDayEnum.am, TimeOfDayEnum.pm];

  List<String> _timeofDayDesc(BuildContext context) => [
    context.tr.morningBetween1200AM1159AM,
    context.tr.afternoonBetween1200PM1159PM,
  ];

  @override
  Widget build(BuildContext context) {
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
                    context.tr.timePicker,
                    style: AppStyles.s20W600.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                  8.verticalSpace,
                  Text(
                    context.tr.whatTimeShouldTheOrdersBeAutomaticallySent,
                    style: AppStyles.s14W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                  14.verticalSpace,
                  const CustomDivider(),
                  14.verticalSpace,
                  LabelTextField(
                    text: context.tr.timeOfDay,
                    style: AppStyles.s14W500.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                  8.verticalSpace,
                  Row(
                    spacing: 10.w,
                    children: List.generate(2, (index) {
                      return Expanded(
                        child:
                            BlocSelector<
                              ChooseItemCubit,
                              ChooseItemState,
                              bool
                            >(
                              selector: (state) => state.selectedIndex == index,
                              builder: (context, state) {
                                return AppGestureDetectorButton(
                                  onTap: () {
                                    context.read<ChooseItemCubit>().selectItem(
                                      index,
                                    );

                                    _validationCubit
                                        .validateFieldAndStoreTypedValue<
                                          TimeOfDayEnum
                                        >(
                                          fieldName: 'timeOfDay',
                                          value: _timeofDay[index],
                                          isValid: true,
                                        );
                                  },
                                  child: Container(
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                _timeofDay[index].label(
                                                  context,
                                                ),
                                                style: AppStyles.s14W500
                                                    .copyWith(
                                                      color: state
                                                          ? context
                                                                .theme
                                                                .primaryColor
                                                          : context
                                                                .customColor
                                                                .text1,
                                                    ),
                                              ),
                                              4.verticalSpace,
                                              Text(
                                                _timeofDayDesc(context)[index],
                                                style: AppStyles.s13W400
                                                    .copyWith(
                                                      color: context
                                                          .customColor
                                                          .text3,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        12.horizontalSpace,
                                        SelectionCircule(isSelected: state),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                      );
                    }),
                  ),
                  14.verticalSpace,
                  const CustomDivider(),
                  14.verticalSpace,
                  Row(
                    spacing: 14.w,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            LabelTextField(text: context.tr.hour),
                            CustomDropdown<String>(
                              items: List.generate(
                                12,
                                (index) => (index + 1).toString(),
                              ),
                              displayTextBuilder: (value) =>
                                  value ?? context.tr.choose,
                              backgroundColor: context.customColor.text2,
                              iconColor: context.customColor.text4,
                              iconSize: 18.r,
                              borderRadius: 18.r,
                              initialValue: _validationCubit
                                  .getTypedValue<String>('hour'),
                              itemBuilder: (context, item, isSelected) {
                                return Container(
                                  padding: EdgeInsets.all(16.r),
                                  child: Text(
                                    item,
                                    style: AppStyles.s12W500.copyWith(
                                      color: isSelected
                                          ? context.theme.primaryColor
                                          : context.customColor.text1,
                                    ),
                                  ),
                                );
                              },
                              onChanged: (value) {
                                _validationCubit
                                    .validateFieldAndStoreTypedValue<String>(
                                      fieldName: 'hour',
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
                            LabelTextField(text: context.tr.minute),
                            CustomDropdown<String>(
                              items: List.generate(60, (index) {
                                if (index < 10) {
                                  return '0$index';
                                } else {
                                  return index.toString();
                                }
                              }),
                              displayTextBuilder: (value) =>
                                  value ?? context.tr.choose,
                              backgroundColor: context.customColor.text2,
                              iconColor: context.customColor.text4,
                              initialValue: _validationCubit
                                  .getTypedValue<String>('minute'),
                              iconSize: 18.r,
                              borderRadius: 18.r,
                              itemBuilder: (context, item, isSelected) {
                                return Container(
                                  padding: EdgeInsets.all(16.r),
                                  child: Text(
                                    item,
                                    style: AppStyles.s12W500.copyWith(
                                      color: isSelected
                                          ? context.theme.primaryColor
                                          : context.customColor.text1,
                                    ),
                                  ),
                                );
                              },
                              onChanged: (value) {
                                _validationCubit
                                    .validateFieldAndStoreTypedValue<String>(
                                      fieldName: 'minute',
                                      value: value,
                                      isValid: true,
                                    );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            20.verticalSpace,
            BlocSelector<ValidationCubit, ValidationState, bool>(
              selector: (state) =>
                  state.getTypedValue('timeOfDay') != null &&
                  state.getTypedValue<String>('hour') != null &&
                  state.getTypedValue<String>('minute') != null,
              builder: (context, state) {
                final validationCubit = context.watch<ValidationCubit>();

                return AppButton(
                  onClick: () {
                    _validationCubit.validateFieldAndStoreTypedValue<bool>(
                      fieldName: 'submitTimePickerData',
                      value: state,
                      isValid: true,
                    );

                    NavigationService.I.pop();
                  },
                  text: state
                      ? '${context.tr.confirm} ${validationCubit.getTypedValue<String>('hour')}:${validationCubit.getTypedValue<String>('minute')} ${validationCubit.getTypedValue<TimeOfDayEnum>('timeOfDay')?.label(context)}'
                      : context.tr.confirmTime,
                  enabled: state,
                  borderRadius: BorderRadius.circular(15.r),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
