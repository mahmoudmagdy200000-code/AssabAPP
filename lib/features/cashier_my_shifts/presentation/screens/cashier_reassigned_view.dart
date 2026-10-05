import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_failure_widget.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../domain/entities/cashier_my_shift_entity.dart';
import '../../domain/enums/my_shifts_status.dart';
import '../cubits/cashier_my_shifts_cubit.dart';
import '../cubits/cashier_my_shifts_state.dart';
import '../widgets/cashier_my_shifts_list_view.dart';

class CashierReassignedView extends StatelessWidget {
  const CashierReassignedView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CashierMyShiftsCubit, CashierMyShiftsState>(
      builder: (context, state) {
        final pendingState = state.reassigned;

        List<CashierShiftEntity> shifts = state.reassigned.items;

        if (pendingState.isLoading) {
          return const Center(child: AppLoadingWidget());
        } else if (pendingState.failure != null) {
          return Center(
            child: AppFailureWidget(
              failure: pendingState.failure!,
              onRetry: () {
                context.read<CashierMyShiftsCubit>().getReassignedShifts();
              },
            ),
          );
        } else if (pendingState.items.isNotEmpty) {
          shifts = pendingState.items;
        }

        return CashierMyShiftsListView(
          shifts: shifts,
          shiftsType: MyShiftStatusType.reassigned,
          onRefresh: () async {
            context.read<CashierMyShiftsCubit>().getReassignedShifts();
          },
        );
      },
    );
  }
}
