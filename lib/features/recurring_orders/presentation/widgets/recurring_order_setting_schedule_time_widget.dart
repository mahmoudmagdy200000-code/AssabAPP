import 'package:assab/core/cubits/choose_item/choose_item_cubit.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/enums/time_of_day_enum.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/container_custom_text_field.dart';
import '../../../../core/widgets/label_text_field.dart';
import 'time_picker_bottom_sheet_widget.dart';

class RecurringOrderSettingScheduleTimeWidget extends StatefulWidget {
  const RecurringOrderSettingScheduleTimeWidget({super.key});

  @override
  State<RecurringOrderSettingScheduleTimeWidget> createState() =>
      _RecurringOrderSettingScheduleTimeWidgetState();
}

class _RecurringOrderSettingScheduleTimeWidgetState
    extends State<RecurringOrderSettingScheduleTimeWidget> {
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
    _validationCubit.addDynamicFields({'timeOfDay', 'hour', 'minute'});
  }

  void _removeDynamicFieldForScheduleTime() {
    _validationCubit.removeDynamicFields({'timeOfDay', 'hour', 'minute'});
  }

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
          LabelTextField(text: context.tr.scheduleTime),
          Text(
            context.tr.whatTimeShouldTheOrdersBeAutomaticallySent,
            style: AppStyles.s14W400.copyWith(color: context.customColor.text3),
          ),
          AppGestureDetectorButton(
            onTap: () {
              final validationCubit = context.read<ValidationCubit>();

              AppBottomSheet.customPageRoute(
                context,
                (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider.value(value: validationCubit),
                    BlocProvider(create: (context) => getIt<ChooseItemCubit>()),
                  ],
                  child: const TimePickerBottomSheetWidget(),
                ),
              );
            },
            child: ContainerCustomTextField(
              backgroundColor: context.customColor.reversedTextColor,
              child: Row(
                children: [
                  Expanded(
                    child: BlocSelector<ValidationCubit, ValidationState, String>(
                      selector: (state) {
                        return '${state.getTypedValue<String>('hour')}:${state.getTypedValue<String>('minute')} ${state.getTypedValue<TimeOfDayEnum>('timeOfDay')?.label(context)}';
                      },
                      builder: (context, state) {
                        return Text(
                          state.contains('null')
                              ? context.tr.timePicker
                              : state,
                          style: AppStyles.s14W400.copyWith(
                            color: !state.contains('null')
                                ? context.customColor.text1
                                : context.customColor.text3,
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
          ),
        ],
      ),
    );
  }
}
