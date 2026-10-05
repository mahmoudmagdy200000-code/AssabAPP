import 'package:assab/core/enums/shift_status/shift_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../../core/widgets/app_failure_widget.dart';
import '../../../../logic/shifts/cashier_shifts_management_cubit.dart';
import '../../../filters/cashier_shifts_status_impl.dart';
import '../shift_empty_widget.dart';
import '../shift_list_view_widget.dart';

class CashierFilteredShiftsView extends StatefulWidget {
  const CashierFilteredShiftsView({
    super.key,
    this.dateFilter,
    this.filterStatus,
    this.managerId,
  });

  final String? dateFilter;
  final String? managerId;
  final ShiftStatus? filterStatus;

  @override
  State<CashierFilteredShiftsView> createState() =>
      _CashierFilteredShiftsViewState();
}

class _CashierFilteredShiftsViewState extends State<CashierFilteredShiftsView> {
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();

    _controller = ScrollController();

    /// Initial fetch once when tab is created
    context.read<CashierShiftsManagementCubit>().fetchShiftsWithFilters(
      dateFilter: widget.dateFilter,
      managerIdFilter: widget.managerId,
      statusFilter: widget.filterStatus,
    );

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

    final tabState = cubit.state.filter;

    if (!tabState.hasMore || tabState.isLoading) return;

    await cubit.fetchShiftsWithFilters(
      dateFilter: widget.dateFilter,
      managerIdFilter: widget.managerId,
      statusFilter: widget.filterStatus,
      loadMore: true,
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_paginationListener);
    _controller.dispose();
    super.dispose();
  }

  /// Refresh Handler
  Future<void> _refresh() async {
    await context.read<CashierShiftsManagementCubit>().fetchShiftsWithFilters(
      dateFilter: widget.dateFilter,
      managerIdFilter: widget.managerId,
      statusFilter: widget.filterStatus,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      CashierShiftsManagementCubit,
      CashierShiftsManagementState
    >(
      builder: (context, state) {
        final tabState = state.filter;

        if (tabState.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (tabState.failure != null) {
          return Center(
            child: AppFailureWidget(
              failure: tabState.failure!,
              onRetry: () => context
                  .read<CashierShiftsManagementCubit>()
                  .fetchShiftsWithFilters(
                    dateFilter: widget.dateFilter,
                    managerIdFilter: widget.managerId,
                    statusFilter: widget.filterStatus,
                  ),
            ),
          );
        }

        if (tabState.items.isEmpty) {
          return RefreshIndicator(
            onRefresh: () async {
              context
                  .read<CashierShiftsManagementCubit>()
                  .fetchShiftsWithFilters(
                    dateFilter: widget.dateFilter,
                    managerIdFilter: widget.managerId,
                    statusFilter: widget.filterStatus,
                  );
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ShiftsEmptyWidget(
                status: CashierShiftsFilterShiftsStatus(),
              ),
            ),
          );
        }

        final shifts = tabState.items;

        return Expanded(
          child: ShiftsListView(
            shifts: shifts,
            controller: _controller,
            shiftStatusSelectedOption: CashierShiftsFilterShiftsStatus(),
            onRefresh: () async {
              context
                  .read<CashierShiftsManagementCubit>()
                  .fetchShiftsWithFilters(
                    dateFilter: widget.dateFilter,
                    managerIdFilter: widget.managerId,
                    statusFilter: widget.filterStatus,
                  );
            },
          ),
        );
      },
    );
  }
}
