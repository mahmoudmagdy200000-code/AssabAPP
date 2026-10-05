import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/cashier_shifts_management_widgets/shifts_filter_sheet_widgets/shifts_filter_bottom_sheet_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../../core/cubits/choose_item/choose_item_cubit.dart';
import '../../../../../../../../core/di/dependency_injection.dart';
import '../../../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../../../core/extensions/number_extensions.dart';
import '../../../../../../../../core/services/navigation/navigation_service.dart';
import '../../../../../../../../core/styles/app_styles.dart';
import '../../../../../../../../core/utils/app_bottom_sheet.dart';
import '../../../../../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../../../../../../core/widgets/filter_button.dart';

import '../../../../logic/shifts/cashier_shifts_management_cubit.dart';
import '../../../../logic/shifts/shift_filter/shift_filter_cubit.dart';

class CashierShiftsSearchAppBar extends StatelessWidget {
  const CashierShiftsSearchAppBar({super.key, required this.cashierId});

  final String cashierId;
  void _onClickFilter(BuildContext context) {
    AppBottomSheet.showModal(
      context,
      (context) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => getIt<ChooseItemCubit>()),

          BlocProvider(
            create: (context) =>
                getIt<CashierShiftsManagementCubit>(param1: cashierId),
          ),
          BlocProvider(create: (context) => ShiftFilterCubit()),
        ],
        child: const ShiftsFilterBottomSheetWidget(),
      ),
      isScrollControlled: true,
      useSafeArea: true,
    );
  }

  void _onClearFilter(BuildContext context) {
    context.read<ShiftFilterCubit>().resetFilters();
    NavigationService.I.pop();

    // context.read<CashierShiftsManagementCubit>().fetchShiftsWithFilters(
    //   loadMore: false,
    // );
  }

  @override
  Widget build(BuildContext context) {
    final filterCubit = context.watch<ShiftFilterCubit>();

    final String date = filterCubit.state.dateFilter?.name ?? '';

    final String status = filterCubit.state.status?.title ?? '';

    return Padding(
      padding: EdgeInsets.all(13.r),
      child: Column(
        children: [
          Row(
            children: [
              /// Filter Button + Badge
              Stack(
                children: [
                  FilterButton(onClick: () => _onClickFilter(context)),

                  Positioned(
                    right: 0,
                    bottom: -5.h,
                    child: Container(
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      padding: EdgeInsets.all(5.r),
                      child: Text(
                        '${filterCubit.hasFilters ? 1 : 0}',
                        style: AppStyles.s10W400.copyWith(
                          color: context.customColor.reversedTextColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              10.horizontalSpace,

              /// Filter Summary Text
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child:
                          BlocSelector<
                            CashierShiftsManagementCubit,
                            CashierShiftsManagementState,
                            int
                          >(
                            selector: (state) {
                              final tabState = state.filter;

                              if (tabState.items.isNotEmpty) {
                                return tabState.items.length;
                              }
                              return 0;
                            },
                            builder: (context, length) {
                              return Text(
                                '$status $date ($length)',
                                softWrap: true,
                                style: AppStyles.s14W400.copyWith(
                                  color: context.customColor.text3,
                                ),
                              );
                            },
                          ),
                    ),

                    5.horizontalSpace,

                    /// Clear Filter Button
                    AppGestureDetectorButton(
                      onTap: () => _onClearFilter(context),
                      child: Icon(
                        Icons.close,
                        color: context.customColor.text1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          20.verticalSpace,

          Divider(height: 1.h, color: context.customColor.border),
        ],
      ),
    );
  }
}
