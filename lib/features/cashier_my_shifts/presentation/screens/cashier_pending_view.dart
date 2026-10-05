import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/features/cashier_my_shifts/domain/entities/cashier_my_shift_entity.dart';
import 'package:assab/features/cashier_my_shifts/presentation/cubits/cashier_my_shifts_cubit.dart';
import 'package:assab/features/cashier_my_shifts/presentation/widgets/cashier_my_shifts_list_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/enums/my_shifts_status.dart';
import '../cubits/cashier_my_shifts_state.dart';

class CashierPendingView extends StatelessWidget {
  const CashierPendingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CashierMyShiftsCubit, CashierMyShiftsState>(
      builder: (context, state) {
        final pendingState = state.pending;

        List<CashierShiftEntity> shifts = state.pending.items;

        if (pendingState.isLoading) {
          return const Center(child: AppLoadingWidget());
        } else if (pendingState.failure != null) {
          return Center(
            child: AppFailureWidget(
              failure: pendingState.failure!,
              onRetry: () {
                context.read<CashierMyShiftsCubit>().getPendingShifts();
              },
            ),
          );
        } else if (pendingState.items.isNotEmpty) {
          shifts = pendingState.items;
        }

        return CashierMyShiftsListView(
          shifts: shifts,
          shiftsType: MyShiftStatusType.pending,
          onRefresh: () async {
            context.read<CashierMyShiftsCubit>().getPendingShifts();
          },
        );
        // }
      },
    );
  }
}
