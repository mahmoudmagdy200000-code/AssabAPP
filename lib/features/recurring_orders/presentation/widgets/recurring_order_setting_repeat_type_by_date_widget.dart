import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/enums/recurring_order_date_picker_enum.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/container_custom_text_field.dart';
import 'recurring_order_setting_date_picker_widget.dart';

class RecurringOrderSettingRepeatTypeByDateWidget extends StatefulWidget {
  const RecurringOrderSettingRepeatTypeByDateWidget({super.key});

  @override
  State<RecurringOrderSettingRepeatTypeByDateWidget> createState() =>
      _RecurringOrderSettingRepeatTypeByDateWidgetState();
}

class _RecurringOrderSettingRepeatTypeByDateWidgetState
    extends State<RecurringOrderSettingRepeatTypeByDateWidget> {
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
    _validationCubit.addDynamicFields({'repeatTypeMonthlyByDate'});
  }

  void _removeDynamicFieldForScheduleTime() {
    _validationCubit.validateFieldAndStoreList(
      fieldName: 'repeatTypeMonthlyByDate',
      value: [],
      isValid: false,
    );

    _validationCubit.removeDynamicFields({'repeatTypeMonthlyByDate'});
  }

  @override
  Widget build(BuildContext context) {
    return AppGestureDetectorButton(
      onTap: () {
        final validationCubit = context.read<ValidationCubit>();

        AppBottomSheet.customPageRoute(
          context,
          (context) => BlocProvider.value(
            value: validationCubit,
            child: const RecurringOrderSettingDatePickerWidget(),
          ),
        );
      },
      child: ContainerCustomTextField(
        backgroundColor: context.customColor.reversedTextColor,
        label: context.tr.repeatMonthlyOnEvery,
        child: Row(
          children: [
            Expanded(
              child:
                  BlocSelector<
                    ValidationCubit,
                    ValidationState,
                    List<RecurringOrderDatePickerEnum>
                  >(
                    selector: (state) {
                      return state.getListValue<RecurringOrderDatePickerEnum>(
                            'repeatTypeMonthlyByDate',
                          ) ??
                          [];
                    },
                    builder: (context, state) {
                      return Text(
                        state.isEmpty
                            ? context.tr.datePicker
                            : state.map((e) => e.label).join(', '),
                        style: AppStyles.s14W400.copyWith(
                          color: state.isEmpty
                              ? context.customColor.text3
                              : context.customColor.text1,
                        ),
                      );
                    },
                  ),
            ),
            12.horizontalSpace,
            AppSvg(
              assetName: AppAssets.time04,
              width: 16.r,
              colorFilter: ColorFilter.mode(
                context.theme.primaryColor,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
