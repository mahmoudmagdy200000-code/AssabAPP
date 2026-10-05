import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/paging_cubit/paging_cubit.dart';
import '../../../../core/cubits/paging_cubit/paging_state.dart';
import '../widgets/cashier_my_shifts_top_section.dart';
import 'cashier_completed_view.dart';
import 'cashier_in_progress_view .dart';
import 'cashier_pending_view.dart';
import 'cashier_reassigned_view.dart';

class CashierShiftsView extends StatelessWidget {
  const CashierShiftsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PagingCubit(totalSteps: 4),
      child: const _CashierShiftsView(),
    );
  }
}

class _CashierShiftsView extends StatelessWidget {
  const _CashierShiftsView();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CashierMyShiftsTopSection(),
        Expanded(
          child: BlocSelector<PagingCubit, PagingState, int>(
            selector: (state) => state.currentIndex,
            builder: (context, state) {
              return IndexedStack(
                index: state,
                children: const [
                  CashierPendingView(),
                  CashierInProgressView(),
                  CashierCompletedView(),
                  CashierReassignedView(),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
