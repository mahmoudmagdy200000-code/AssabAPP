import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/features/recurring_orders/presentation/widgets/recurring_order_setting_repeat_type_by_pattern_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/paging_cubit/paging_cubit.dart';
import '../../../../core/cubits/paging_cubit/paging_state.dart';
import '../../../../core/enums/recurring_setting_repeat_type.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../../core/widgets/container_custom_text_field.dart';
import '../../../../core/widgets/label_text_field.dart';
import 'recurring_order_setting_repeat_type_by_date_widget.dart';

class RecurringOrderSettingRepeatTypeWidget extends StatefulWidget {
  const RecurringOrderSettingRepeatTypeWidget({super.key});

  @override
  State<RecurringOrderSettingRepeatTypeWidget> createState() =>
      _RecurringOrderSettingRepeatTypeWidgetState();
}

class _RecurringOrderSettingRepeatTypeWidgetState
    extends State<RecurringOrderSettingRepeatTypeWidget> {
  late final ValidationCubit _validationCubit;

  @override
  void initState() {
    super.initState();

    _validationCubit = context.read<ValidationCubit>();

    _validationCubit.addDynamicFields({'repeatType'});

    if (!_validationCubit.typedFieldExists('repeatType')) {
      _validationCubit
          .validateFieldAndStoreTypedValue<RecurringSettingRepeatType>(
            fieldName: 'repeatType',
            value: RecurringSettingRepeatType.byDate,
            isValid: true,
          );
    }
  }

  @override
  void dispose() {
    _validationCubit.removeDynamicFields({'repeatType'});
    super.dispose();
  }

  List<RecurringSettingRepeatType> get _repeatTypeOptions => [
    RecurringSettingRepeatType.byDate,
    RecurringSettingRepeatType.byPattern,
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
          LabelTextField(text: context.tr.repeatType),
          Text(
            context.tr.pickTheDateToAutoSendThisOrderEveryMonth,
            style: AppStyles.s14W400.copyWith(color: context.customColor.text3),
          ),
          ContainerCustomTextField(
            backgroundColor: context.customColor.text3.withValues(alpha: 0.2),
            borderColor: Colors.transparent,
            borderRadius: BorderRadius.circular(1000.r),
            padding: EdgeInsets.all(6.r),
            child: Row(
              children: List.generate(_repeatTypeOptions.length, (index) {
                return BlocSelector<PagingCubit, PagingState, bool>(
                  selector: (state) => state.currentIndex == index,
                  builder: (context, state) {
                    return Expanded(
                      child: AppGestureDetectorButton(
                        onTap: () {
                          context.read<PagingCubit>().goToStep(index);

                          _validationCubit.validateFieldAndStoreTypedValue<
                            RecurringSettingRepeatType
                          >(
                            fieldName: 'repeatType',
                            value: _repeatTypeOptions[index],
                            isValid: true,
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: state
                                ? context.customColor.reversedTextColor
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(1000.r),
                          ),
                          padding: EdgeInsets.all(5.r),
                          child: Text(
                            _repeatTypeOptions[index].label(context),
                            style: AppStyles.s13W600.copyWith(
                              color: state
                                  ? context.customColor.text1
                                  : context.customColor.text3,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
          BlocSelector<PagingCubit, PagingState, int>(
            selector: (state) => state.currentIndex,
            builder: (context, state) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: state == 0
                    ? const RecurringOrderSettingRepeatTypeByDateWidget()
                    : const RecurringOrderSettingRepeatTypeByPatternWidget(),
              );
            },
          ),
        ],
      ),
    );
  }
}
