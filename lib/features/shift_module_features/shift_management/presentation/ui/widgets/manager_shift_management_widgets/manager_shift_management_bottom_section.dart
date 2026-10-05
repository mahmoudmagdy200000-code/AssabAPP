import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/manager_shift/manager_shift_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/cubits/paging_cubit/paging_cubit.dart';
import '../../../../../../../core/cubits/paging_cubit/paging_state.dart';
import '../../../../../../../core/extensions/number_extensions.dart';
import '../../../../../../../core/widgets/app_failure_widget.dart';
import '../../../../../../../core/widgets/app_loading_widget.dart';
import '../../../strategies/manager_shift_Management_screen_strategy/manager_shift_main_screen_tabs_strategy/manager_shift_main_screen_tabs_strategy_factory.dart';

class ManagerShiftManagementBottomSection extends StatefulWidget {
  const ManagerShiftManagementBottomSection({super.key});

  @override
  State<ManagerShiftManagementBottomSection> createState() =>
      _ManagerShiftManagementBottomSectionState();
}

class _ManagerShiftManagementBottomSectionState
    extends State<ManagerShiftManagementBottomSection> {
  @override
  void initState() {
    _getCurrentManagerShift();
    super.initState();
  }

  void _getCurrentManagerShift() {
    context.read<ManagerShiftCubit>().getCurrentShift();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PagingCubit, PagingState>(
      builder: (context, pagingState) {
        return BlocBuilder<ManagerShiftCubit, ManagerShiftState>(
          builder: (context, state) {
            if (state is ManagerShiftLoading) {
              return const AppLoadingWidget();
            } else if (state is ManagerShiftFailure) {
              return AppFailureWidget(
                failure: state.failure,
                onRetry: _getCurrentManagerShift,
              );
            }

            final strategy =
                ManagerShiftMainScreenTabsStrategyFactory.getStrategy(
                  index: pagingState.currentIndex,
                  currentManagerShift: context
                      .read<ManagerShiftCubit>()
                      .managerShift,
                );
            return RefreshIndicator(
              child: AppPaddingWidget(
                right: 10.w,
                left: 10.w,
                top: 0,
                bottom: 0,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: strategy.buildTabContent(context),
                ),
              ),
              onRefresh: () =>
                  context.read<ManagerShiftCubit>().getCurrentShift(),
            );
          },
        );
      },
    );
  }
}
