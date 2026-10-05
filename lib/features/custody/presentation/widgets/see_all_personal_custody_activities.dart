import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:assab/core/cubits/paging_cubit/paging_state.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_svg_button.dart';
import 'package:assab/features/custody/presentation/widgets/custody_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_bottom_sheet.dart';
import '../../data/models/personal_custody_transactions_response.dart';
import '../cubit/get_personal_balance_transactions/get_personal_balance_transactions_cubit.dart';
import '../cubit/get_personal_balance_transactions/get_personal_balance_transactions_state.dart';
import '../cubit/select_filter_account_statement/select_filter_account_statement_cubit.dart';
import 'custody_activities_daily_item_list_view.dart';
import 'custody_activities_detailed_item_list_view.dart';
import 'custody_empty_widget.dart';
import 'custody_personal_account_statement_filter_bottom_sheet.dart';
import 'see_all_personal_custody_activities_top_section.dart';

class SeeAllPersonalCustodyActivities extends StatefulWidget {
  const SeeAllPersonalCustodyActivities({super.key});

  @override
  State<SeeAllPersonalCustodyActivities> createState() =>
      _SeeAllPersonalCustodyActivitiesState();
}

class _SeeAllPersonalCustodyActivitiesState
    extends State<SeeAllPersonalCustodyActivities> {
  @override
  void initState() {
    super.initState();

    _getTransactions();
  }

  void _getTransactions() {
    context
        .read<GetPersonalBalanceTransactionsCubit>()
        .getPersonalBalanceTransactions();
  }

  void _onTapFilter(BuildContext context) {
    final getPersonalBalanceTransactionsCubit = context
        .read<GetPersonalBalanceTransactionsCubit>();

    AppBottomSheet.pageRoute(
      context,
      (context) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => getIt<SelectFilterAccountStatementCubit>(),
          ),
          BlocProvider.value(value: getPersonalBalanceTransactionsCubit),
        ],
        child: const CustodyPersonalAccountStatementFilterBottomSheet(),
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
                child: CustodyAppBar(
                  title: context.tr.accountStatement,
                  subtitle: context.tr.seeAllIncomingAndOutgoingActivity,
                  titleStyle: AppStyles.s16W600.copyWith(
                    color: context.customColor.text1,
                  ),
                  iconColor: context.customColor.text1,
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
              padding: EdgeInsets.all(12.r),
              child: Column(
                children: [
                  const SeeAllPersonalCustodyActivitiesTopSection(),
                  Expanded(
                    child:
                        BlocBuilder<
                          GetPersonalBalanceTransactionsCubit,
                          GetPersonalBalanceTransactionsState
                        >(
                          builder: (context, state) {
                            final List<PersonalCustodyTransaction>
                            transactions = [];

                            if (state
                                is GetPersonalBalanceTransactionsLoading) {
                              return const AppLoadingWidget();
                            } else if (state
                                is GetPersonalBalanceTransactionsFailure) {
                              return AppFailureWidget(
                                failure: state.failure,
                                onRetry: _getTransactions,
                              );
                            } else if (state
                                is GetPersonalBalanceTransactionsSuccess) {
                              transactions.addAll(
                                state.response.data.transactions,
                              );
                            }

                            if (transactions.isEmpty) {
                              return CustodyEmptyWidget(
                                asset: AppAssets.transaction,
                                title: context.tr.noTransactionsYet,
                                desc: context
                                    .tr
                                    .yourAccountActivityWillAppearHereOnceTransactionsAreRecorded,
                              );
                            }

                            return BlocBuilder<PagingCubit, PagingState>(
                              builder: (context, pagingState) {
                                return AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  child: pagingState.currentIndex == 0
                                      ? CustodyActivitiesDailyItemListView(
                                          transactions: transactions,
                                        )
                                      : CustodyActivitiesDetailedItemListView(
                                          transactions: transactions,
                                        ),
                                  transitionBuilder: (child, animation) {
                                    return ScaleTransition(
                                      scale: animation,
                                      child: child,
                                    );
                                  },
                                );
                              },
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
