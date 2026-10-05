import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/cubits/paging_cubit/paging_cubit.dart';
import '../../../../../../../core/cubits/paging_cubit/paging_state.dart';
import '../../../../../../../core/styles/app_styles.dart';
import '../../../../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../strategies/manager_shift_Management_screen_strategy/manager_shift_main_screen_options_selector.dart';
import '../../../strategies/manager_shift_Management_screen_strategy/manager_shift_main_screen_options_selector_impl.dart';

class ManagerShiftManagementTopSection extends StatelessWidget {
  const ManagerShiftManagementTopSection({super.key});

  void _updateSelectedStatus({
    required BuildContext context,
    required int index,
  }) {
    context.read<PagingCubit>().goToStep(index);
  }

  Color _selectedColor({
    required BuildContext context,
    required bool isSelected,
  }) {
    return isSelected ? context.theme.primaryColor : context.customColor.text3;
  }

  List<ManagerMainScreenOptions> get _managerShiftScreenOptions => [
    ManagerShiftsAllOption(),
    ManagerShiftsShiftDetailsOption(),
    ManagerShiftsHandOffsReceivedOption(),
    ManagerShiftsFinalHandOverOption(),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(13.r),
      child: Column(
        children: [
          Row(
            children: [
              6.horizontalSpace,
              Container(
                color: context.customColor.text2,
                width: 1.w,
                height: 10.h,
              ),
              6.horizontalSpace,

              Expanded(
                child: SizedBox(
                  height: 40.h,
                  child: ListView.builder(
                    itemCount: _managerShiftScreenOptions.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final option = _managerShiftScreenOptions[index];

                      return AppGestureDetectorButton(
                        onTap: () {
                          // context.read<ManagerShiftCubit>().getCurrentShift();
                          _updateSelectedStatus(context: context, index: index);
                        },
                        child: BlocBuilder<PagingCubit, PagingState>(
                          builder: (context, state) {
                            final isSelected = state.currentIndex == index;
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(
                                  color: _selectedColor(
                                    context: context,
                                    isSelected: isSelected,
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(1000.r),
                              ),
                              margin: EdgeInsetsDirectional.only(
                                end:
                                    index ==
                                        _managerShiftScreenOptions.length - 1
                                    ? 0
                                    : 10.r,
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.r,
                                vertical: 5.r,
                              ),
                              child: Center(
                                child: Text(
                                  option.name(context),
                                  style: AppStyles.s12W500.copyWith(
                                    color: _selectedColor(
                                      context: context,
                                      isSelected: isSelected,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          13.verticalSpace,
          const CustomDivider(),
          4.verticalSpace,
        ],
      ),
    );
  }
}
