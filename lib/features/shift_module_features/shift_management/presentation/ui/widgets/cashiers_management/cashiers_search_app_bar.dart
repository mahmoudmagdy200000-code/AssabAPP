import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../../core/extensions/number_extensions.dart';
import '../../../../../../../core/services/navigation/navigation_service.dart';
import '../../../../../../../core/styles/app_styles.dart';
import '../../../../../../../core/utils/app_bottom_sheet.dart';
import '../../../../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../../../../../core/widgets/filter_button.dart';
import '../../../logic/cashier/cashier_filter/cashier_filter_cubit.dart';
import '../../../logic/cashier/cashier_management_cubit.dart';
import '../cashier_filter_bottom_sheet.dart';

class CashiersSearchAppBar extends StatelessWidget {
  const CashiersSearchAppBar({super.key});

  void _onClickFilter(BuildContext context) {
    final cubit = context.read<CashierFilterCubit>();

    AppBottomSheet.show(
      context,
      (context) => BlocProvider(
        create: (context) => CashierFilterCubit(),
        child: const CashierFilterBottomSheetWidget(),
      ),
    );
  }

  void _onClearFilter(BuildContext context) {
    context.read<CashierFilterCubit>().resetFilters();
    NavigationService.I.pop();

    context.read<CashierManagementCubit>().getCashiers(loadMore: false);
  }

  void _onShowResults(BuildContext context) {
    NavigationService.I.pop();

    context.read<CashierManagementCubit>().getCashiers(loadMore: false);
  }

  @override
  Widget build(BuildContext context) {
    final filterCubit = context.watch<CashierFilterCubit>();

    final String date = filterCubit.state.dateFilter?.name ?? '';

    final String status = filterCubit.state.statusFilter?.label ?? '';

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
                        '${filterCubit.hasActiveFilters ? 1 : 0}',
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
                            CashierManagementCubit,
                            CashierManagementState,
                            int
                          >(
                            selector: (state) {
                              if (state is CashierManagementSuccess) {
                                return state.cashiers.length;
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
