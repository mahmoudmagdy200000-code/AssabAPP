import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../logic/shifts/cashier_shifts_management_cubit.dart';
import '../../../filters/cashier_shifts_status_impl.dart';
import '../shift_empty_widget.dart';
import '../shift_list_view_widget.dart';

class CashierInProgressShiftsView extends StatefulWidget {
  const CashierInProgressShiftsView({super.key});

  @override
  State<CashierInProgressShiftsView> createState() =>
      _CashierInProgressShiftsViewState();
}

class _CashierInProgressShiftsViewState
    extends State<CashierInProgressShiftsView> {
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();

    _controller = ScrollController();

    /// Initial fetch once when tab is created
    context.read<CashierShiftsManagementCubit>().getInProgressShifts();

    _controller.addListener(_paginationListener);
  }

  /// Pagination Listener
  void _paginationListener() async {
    if (!_controller.hasClients) return;

    final position = _controller.position;

    if (position.pixels < position.maxScrollExtent - 200) {
      return;
    }

    final cubit = context.read<CashierShiftsManagementCubit>();

    final tabState = cubit.state.inProgress;

    if (!tabState.hasMore || tabState.isLoading) return;

    await cubit.getInProgressShifts(loadMore: true);
  }

  @override
  void dispose() {
    _controller.removeListener(_paginationListener);
    _controller.dispose();
    super.dispose();
  }

  /// Refresh Handler
  Future<void> _refresh() async {
    await context.read<CashierShiftsManagementCubit>().getInProgressShifts();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      CashierShiftsManagementCubit,
      CashierShiftsManagementState
    >(
      builder: (context, state) {
        final tabState = state.inProgress;

        if (tabState.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (tabState.failure != null) {
          return Center(
            child: AppFailureWidget(
              failure: tabState.failure!,
              onRetry: () => context
                  .read<CashierShiftsManagementCubit>()
                  .getInProgressShifts(),
            ),
          );
        }

        if (tabState.items.isEmpty) {
          return RefreshIndicator(
            onRefresh: () async {
              context
                  .read<CashierShiftsManagementCubit>()
                  .getInProgressShifts();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ShiftsEmptyWidget(status: CashierShiftsInProgressStatus()),
            ),
          );
        }

        final shifts = tabState.items;

        return ShiftsListView(
          shifts: shifts,
          controller: _controller,
          shiftStatusSelectedOption: CashierShiftsInProgressStatus(),
          onRefresh: () async {
            context.read<CashierShiftsManagementCubit>().getInProgressShifts();
          },
        );
      },
    );
  }
}
