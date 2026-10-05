import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:assab/core/cubits/paging_cubit/paging_state.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/extensions/widget_extensions.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_local_failure.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/custody_branch_balance_response.dart';
import '../cubit/get_branch_balance/get_branch_balance_cubit.dart';
import '../cubit/get_branch_balance/get_branch_balance_state.dart';
import 'branch_custody_balance_requests_view.dart';
import 'branch_custody_balance_transactions_view.dart';

class CustodyBranchCustodyBalanceView extends StatefulWidget {
  const CustodyBranchCustodyBalanceView({super.key});

  @override
  State<CustodyBranchCustodyBalanceView> createState() =>
      _CustodyBranchCustodyBalanceViewState();
}

class _CustodyBranchCustodyBalanceViewState
    extends State<CustodyBranchCustodyBalanceView> {
  List<Widget> _pages(CustodyBranchBalanceResponse balance) => [
    BranchCustodyBalanceRequestsView(requests: balance.requests),
    BranchCustodyBalanceTransactionsView(transactions: balance.transactions),
  ];

  @override
  void initState() {
    super.initState();

    _getBranchBalance();
  }

  void _getBranchBalance() {
    context.read<GetBranchBalanceCubit>().getBranchBalance();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      slivers: [
        Container(
          decoration: BoxDecoration(
            color: context.customColor.text2,
            borderRadius: BorderRadius.circular(1000.r),
          ),
          padding: EdgeInsets.all(7.r),
          margin: EdgeInsets.symmetric(horizontal: 20.r),
          child: Row(
            children: List.generate(2, (index) {
              final texts = [context.tr.requests, context.tr.transactions];
              return Expanded(
                child: Row(
                  children: [
                    BlocSelector<PagingCubit, PagingState, bool>(
                      selector: (state) => state.currentIndex == index,
                      builder: (context, state) {
                        return Expanded(
                          child: CustomTextButton(
                            text: texts[index],
                            borderRadius: 1000.r,
                            textColor: context.customColor.text1,
                            backgroundColor: state
                                ? context.customColor.reversedTextColor
                                : Colors.transparent,
                            borderColor: Colors.transparent,
                            onTap: () {
                              context.read<PagingCubit>().goToStep(index);
                            },
                          ),
                        );
                      },
                    ),
                    if (index == 0) 8.horizontalSpace,
                  ],
                ),
              );
            }),
          ),
        ).sliverBoxAdapter,
        BlocBuilder<PagingCubit, PagingState>(
          builder: (context, pagingState) {
            return BlocBuilder<GetBranchBalanceCubit, GetBranchBalanceState>(
              builder: (context, state) {
                if (state is GetBranchBalanceLoading) {
                  return SizedBox(
                    height: 400.r,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [AppLoadingWidget()],
                    ),
                  );
                } else if (state is GetBranchBalanceFailure) {
                  return SizedBox(
                    height: 300.r,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AppFailureWidget(
                          failure: state.failure,
                          onRetry: _getBranchBalance,
                          withBorder: false,
                        ),
                      ],
                    ),
                  );
                } else if (state is GetBranchBalanceSuccess) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: _pages(state.balance)[pagingState.currentIndex],
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                  );
                }

                return SizedBox(
                  height: 300.r,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppLocalFailure(
                        onRetry: _getBranchBalance,
                        withBorder: false,
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ).sliverBoxAdapter,
      ],
    );
  }
}
