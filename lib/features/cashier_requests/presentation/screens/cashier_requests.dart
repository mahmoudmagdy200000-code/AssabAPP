import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/features/branch_manager_requests/presentation/screens/branch_manager_request_variance_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/paging_cubit/paging_state.dart';
import '../../../branch_manager_requests/presentation/screens/branch_manager_request_handovers_view.dart';
import '../cubits/accept_reassigned_shift/accept_reassigned_shift_cubit.dart';
import '../widgets/cashier_request_app_bar.dart';
import '../widgets/cashier_requests_request_top_section.dart';
import 'cashier_request_reassignments_view.dart';

class CashierRequests extends StatelessWidget {
  const CashierRequests({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColor.text2,
      body: Column(
        children: [
          const CashierRequestAppBar(),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.customColor.reversedTextColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
              ),
              child: Column(
                children: [
                  const CashierRequestsRequestTopSection(),
                  8.verticalSpace,
                  Expanded(
                    child: BlocSelector<PagingCubit, PagingState, int>(
                      selector: (state) => state.currentIndex,
                      builder: (context, state) {
                        return IndexedStack(
                          index: state,
                          children: [
                            const BranchManagerRequestHandoversView(),
                            const BranchManagerRequestVarianceView(),

                            BlocProvider(
                              create: (context) =>
                                  getIt<AcceptReassignedShiftCubit>(),
                              child: const CashierRequestReassignmentsView(),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
