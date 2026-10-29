import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/paging_cubit/paging_state.dart';
import '../widgets/branch_manager_request_app_bar.dart';
import '../widgets/branch_manager_request_top_section.dart';
import 'branch_manager_request_handovers_view.dart';
import 'branch_manager_request_order_view.dart';
import 'branch_manager_request_variance_view.dart';
import 'package:assab/core/strategies/user_type_strategy.dart';

class BranchManagerRequests extends StatelessWidget {
  const BranchManagerRequests({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColor.text2,
      body: Column(
        children: [
          const BranchManagerRequestAppBar(),
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
                  const BranchManagerRequestTopSection(),
                  8.verticalSpace,
                  Expanded(
                    child: BlocSelector<PagingCubit, PagingState, int>(
                      selector: (state) => state.currentIndex,
                      builder: (context, state) {
                        return IndexedStack(
                          index: state,
                          children: const [
                            BranchManagerRequestHandoversView(actorRole: UserType.branchManager),
                            BranchManagerRequestOrderView(),
                            BranchManagerRequestVarianceView(),
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
