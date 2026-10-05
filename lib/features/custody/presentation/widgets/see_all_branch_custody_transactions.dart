import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_svg_button.dart';
import 'package:assab/features/custody/presentation/widgets/branch_custody_transactions_view_item_list_widget.dart';
import 'package:assab/features/custody/presentation/widgets/custody_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/branch_custody_transactions_response.dart';
import '../cubit/get_branch_balance_transactions/get_branch_balance_transactions_cubit.dart';
import '../cubit/get_branch_balance_transactions/get_branch_balance_transactions_state.dart';
import '../cubit/select_filter_custody_transactions/select_filter_custody_transactions_cubit.dart';
import 'branch_custody_transactions_filter_bottom_sheet_widget.dart';
import 'custody_empty_widget.dart';

class SeeAllBranchCustodyTransactions extends StatefulWidget {
  const SeeAllBranchCustodyTransactions({super.key});

  @override
  State<SeeAllBranchCustodyTransactions> createState() =>
      _SeeAllBranchCustodyTransactionsState();
}

class _SeeAllBranchCustodyTransactionsState
    extends State<SeeAllBranchCustodyTransactions> {
  @override
  void initState() {
    super.initState();

    _getTransactions();
  }

  void _getTransactions() {
    context
        .read<GetBranchBalanceTransactionsCubit>()
        .getBranchBalanceTransactions();
  }

  void _onTapFilter(BuildContext context) {
    final custodyGetTransactionsCubit = context
        .read<GetBranchBalanceTransactionsCubit>();
    AppBottomSheet.pageRoute(
      context,
      (context) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => getIt<SelectFilterCustodyTransactionsCubit>(),
          ),
          BlocProvider.value(value: custodyGetTransactionsCubit),
        ],
        child: const BranchCustodyTransactionsFilterBottomSheetWidget(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColor.text2,
      body: Column(
        children: [
          20.verticalSpace,
          Row(
            children: [
              Expanded(
                child:
                    BlocSelector<
                      GetBranchBalanceTransactionsCubit,
                      GetBranchBalanceTransactionsState,
                      int
                    >(
                      selector: (state) =>
                          state is GetBranchBalanceTransactionsSuccess
                          ? state.response.data.transactions.length
                          : 0,
                      builder: (context, state) {
                        return CustodyAppBar(
                          title: '${context.tr.custodyStatement} ($state)',
                          subtitle: context.tr.sortAndViewDetailsOfTransactions,
                          titleStyle: AppStyles.s16W600.copyWith(
                            color: context.customColor.text1,
                          ),
                          iconColor: context.customColor.text1,
                        );
                      },
                    ),
              ),
              10.horizontalSpace,
              AppSvgButton(
                assetName: AppAssets.filter,
                onTap: () => _onTapFilter(context),
                bgColor: context.customColor.reversedTextColor,
                iconColor: context.customColor.text1,
                withBorder: false,
                padding: EdgeInsets.all(15.r),
              ),
              20.horizontalSpace,
            ],
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.customColor.reversedTextColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
              ),
              padding: EdgeInsets.all(8.r),
              child: Container(
                decoration: BoxDecoration(
                  color: context.customColor.text2,
                  borderRadius: BorderRadius.circular(24.r),
                ),
                padding: EdgeInsets.all(8.r),
                child:
                    BlocBuilder<
                      GetBranchBalanceTransactionsCubit,
                      GetBranchBalanceTransactionsState
                    >(
                      builder: (context, state) {
                        final List<BranchCustodyTransaction> transactions = [];

                        if (state is GetBranchBalanceTransactionsLoading) {
                          return const AppLoadingWidget();
                        } else if (state
                            is GetBranchBalanceTransactionsFailure) {
                          return AppFailureWidget(failure: state.failure);
                        } else if (state
                            is GetBranchBalanceTransactionsSuccess) {
                          transactions.addAll(state.response.data.transactions);
                        }

                        if (transactions.isEmpty) {
                          return CustodyEmptyWidget(
                            asset: AppAssets.transaction,
                            title: context.tr.noTransactionsYet,
                            desc: context
                                .tr
                                .thisBranchHasntReceivedAnyPaymentsOrRecordedAnyExpensesYet,
                          );
                        }

                        return ListView.builder(
                          itemCount: transactions.length,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(
                                bottom: index < transactions.length - 1
                                    ? 8.r
                                    : 0,
                              ),
                              child:
                                  BranchCustodyTransactionsViewItemListWidget(
                                    transaction: transactions[index],
                                  ),
                            );
                          },
                        );
                      },
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
