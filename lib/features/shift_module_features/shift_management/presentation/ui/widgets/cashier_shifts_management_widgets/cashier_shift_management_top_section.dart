import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/filter_button.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/cashier_shifts_management_widgets/shifts_filter_sheet_widgets/shifts_filter_bottom_sheet_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/cubits/choose_item/choose_item_cubit.dart';
import '../../../../../../../core/cubits/paging_cubit/paging_cubit.dart';
import '../../../../../../../core/cubits/paging_cubit/paging_state.dart';
import '../../../../../../../core/di/dependency_injection.dart';
import '../../../../../../../core/enums/shift_status/shift_status.dart';
import '../../../../../../../core/styles/app_styles.dart';
import '../../../../../../../core/utils/app_bottom_sheet.dart';
import '../../../../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../logic/shifts/cashier_shifts_management_cubit.dart';
import '../../../logic/shifts/shift_filter/shift_filter_cubit.dart';

class CashierShiftsManagementTopSection extends StatelessWidget {
  const CashierShiftsManagementTopSection({
    super.key,
    required this.onTabSelected,
    required this.shiftStatuses,
    required this.cashierId,
  });

  final Function(ShiftStatus) onTabSelected;
  final List<ShiftStatus> shiftStatuses;
  final String cashierId;
  Color _selectedColor({
    required BuildContext context,
    required bool isSelected,
  }) {
    return isSelected ? context.theme.primaryColor : context.customColor.text3;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(13.r),
      child: Column(
        children: [
          Row(
            children: [
              6.horizontalSpace,

              FilterButton(
                onClick: () {
                  AppBottomSheet.showModal(
                    context,
                    (context) => MultiBlocProvider(
                      providers: [
                        BlocProvider(create: (_) => getIt<ChooseItemCubit>()),

                        BlocProvider(
                          create: (context) =>
                              getIt<CashierShiftsManagementCubit>(
                                param1: cashierId,
                              ),
                        ),
                        BlocProvider(create: (context) => ShiftFilterCubit()),
                      ],
                      child: const ShiftsFilterBottomSheetWidget(),
                    ),
                    isScrollControlled: true,
                    useSafeArea: true,
                  );
                },
              ),

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
                    itemCount: shiftStatuses.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final status = shiftStatuses[index];

                      return BlocBuilder<PagingCubit, PagingState>(
                        builder: (context, state) {
                          final isSelected = state.currentIndex == index;
                          return AppGestureDetectorButton(
                            onTap: () {
                              onTabSelected(status);
                              context.read<PagingCubit>().goToStep(index);
                            },
                            child: Container(
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
                                end: index == shiftStatuses.length - 1
                                    ? 0
                                    : 10.r,
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.r,
                                vertical: 5.r,
                              ),
                              child: Center(
                                child: Text(
                                  status.name,
                                  style: AppStyles.s12W500.copyWith(
                                    color: _selectedColor(
                                      context: context,
                                      isSelected: isSelected,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
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
