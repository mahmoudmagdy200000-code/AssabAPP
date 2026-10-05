import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/cubits/paging_cubit/paging_cubit.dart';
import '../../../../../../core/enums/shift_status/shift_status.dart';
import '../../../../../../core/styles/app_colors.dart';
import '../../../domain/entity/cashier_entity.dart';
import '../../logic/shifts/cashier_shifts_management_cubit.dart';
import '../filters/cashier_shifts_status_impl.dart';
import '../widgets/cashier_shifts_management_widgets/cashier_shift_management_top_section.dart';
import '../widgets/cashier_shifts_management_widgets/cashier_shifts_app_bar.dart';
import '../widgets/cashier_shifts_management_widgets/cashier_shifts_management_bottom_section.dart';

class CashierShiftsScreen extends StatelessWidget {
  const CashierShiftsScreen({super.key, required this.cashier});

  final CashierEntity cashier;

  void _updateSelectedStatus(BuildContext context, ShiftStatus shiftStatus) {
    final index = _shiftStatuses.indexWhere((s) => s.name == shiftStatus.name);
    context.read<PagingCubit>().goToStep(index);
  }

  List<ShiftStatus> get _shiftStatuses => [
    // CashierShiftsAllShiftsStatus(),
    CashierShiftsPendingStatus(),
    CashierShiftsInProgressStatus(),
    CashierShiftsCompletedStatus(),
  ];
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<
      CashierShiftsManagementCubit,
      CashierShiftsManagementState
    >(
      listener: (context, state) {
        // if (state is FetchShiftsAgain) {
        //   state.status!.get(context);
        // } else if (state is ShiftButtonFailure) {
        //   AppDialog.showErrorDialog(context: context, failure: state.failure);
        // }
      },
      builder: (context, state) {
        return AppScaffold(
          backgroundColor: AppColors.lightGray,
          child: AppPaddingWidget(
            top: 10.h,
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                CashierShiftsAppBar(
                  title: cashier.name,
                  subTitle: context.tr.cashierShifts,
                  cashier: cashier,
                  showInfoButton: true,
                ),

                Expanded(
                  child: Container(
                    width: double.maxFinite,

                    decoration: BoxDecoration(
                      color: context.theme.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.r),
                        topRight: Radius.circular(40.r),
                      ),
                    ),
                    child: Column(
                      children: [
                        CashierShiftsManagementTopSection(
                          cashierId: cashier.id,
                          onTabSelected: (status) {
                            final index = context
                                .read<PagingCubit>()
                                .state
                                .currentIndex;

                            context
                                .read<CashierShiftsManagementCubit>()
                                .getStatusByIndex(index);
                          },
                          shiftStatuses: _shiftStatuses,
                        ),

                        const CashierShiftsManagementBottomSection(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
