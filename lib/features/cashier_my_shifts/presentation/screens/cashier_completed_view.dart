import 'package:assab/features/cashier_my_shifts/domain/enums/my_shifts_status.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_failure_widget.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../domain/entities/cashier_my_shift_entity.dart';
import '../cubits/cashier_my_shifts_cubit.dart';
import '../cubits/cashier_my_shifts_state.dart';
import '../widgets/cashier_my_shifts_list_view.dart';

class CashierCompletedView extends StatelessWidget {
  const CashierCompletedView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CashierMyShiftsCubit, CashierMyShiftsState>(
      builder: (context, state) {
        final pendingState = state.completed;

        List<CashierShiftEntity> shifts = state.completed.items;

        if (pendingState.isLoading) {
          return const Center(child: AppLoadingWidget());
        } else if (pendingState.failure != null) {
          return Center(
            child: AppFailureWidget(
              failure: pendingState.failure!,
              onRetry: () {
                context.read<CashierMyShiftsCubit>().getCompletedShifts();
              },
            ),
          );
        } else if (pendingState.items.isNotEmpty) {
          shifts = pendingState.items;
        }

        return CashierMyShiftsListView(
          shifts: shifts,
          shiftsType: MyShiftStatusType.completed,
          onRefresh: () async {
            context.read<CashierMyShiftsCubit>().getCompletedShifts();
          },
        );
      },
    );
  }
}
