import 'package:assab/core/enums/time_keys.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/extensions/widget_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/features/custody/presentation/cubit/select_filter_custody_transactions/select_filter_custody_transactions_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/custody_transactions_types_enum.dart';
import '../../../../core/widgets/custom_text_button.dart';
import '../cubit/get_branch_balance_transactions/get_branch_balance_transactions_cubit.dart';
import '../cubit/select_filter_custody_transactions/select_filter_custody_transactions_cubit.dart';
import 'branch_custody_filter_sort_by_date_section.dart';

class BranchCustodyTransactionsFilterBottomSheetWidget extends StatelessWidget {
  const BranchCustodyTransactionsFilterBottomSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AppPaddingWidget(
        top: 10.r,
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      context.tr.filterCustodyStatementsListBy,
                      style: AppStyles.s16W600.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                  ).sliverBoxAdapter,
                  12.verticalSpace.sliverBoxAdapter,
                  const CustomDivider().sliverBoxAdapter,
                  12.verticalSpace.sliverBoxAdapter,
                  _buildText(context, context.tr.status),
                  8.verticalSpace.sliverBoxAdapter,
                  SliverGrid.builder(
                    itemCount: 4,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10.r,
                      crossAxisSpacing: 10.r,
                      childAspectRatio: 4.h,
                    ),
                    itemBuilder: (context, index) {
                      final texts = [
                        context.tr.all,
                        context.tr.cashHandover,
                        context.tr.bankTransfer,
                        context.tr.custodyRequests,
                      ];

                      final types = [
                        CustodyTransactionsTypesEnum.all,
                        CustodyTransactionsTypesEnum.cashHandover,
                        CustodyTransactionsTypesEnum.bankTransfer,
                        CustodyTransactionsTypesEnum.custodyRequests,
                      ];

                      return BlocSelector<
                        SelectFilterCustodyTransactionsCubit,
                        SelectFilterCustodyTransactionsState,
                        bool
                      >(
                        selector: (state) => state.type == types[index],
                        builder: (context, state) {
                          return CustomTextButton(
                            text: texts[index],
                            borderRadius: 1000.r,
                            textColor: state
                                ? context.theme.primaryColor
                                : context.customColor.text3,
                            borderColor: state
                                ? context.theme.primaryColor
                                : context.customColor.border,
                            onTap: () {
                              context
                                  .read<SelectFilterCustodyTransactionsCubit>()
                                  .setType(types[index]);
                            },
                          );
                        },
                      );
                    },
                  ),
                  20.verticalSpace.sliverBoxAdapter,
                  _buildText(context, context.tr.sortByDate),
                  8.verticalSpace.sliverBoxAdapter,
                  BranchCustodyFilterSortByDateSection<
                    SelectFilterCustodyTransactionsCubit,
                    SelectFilterCustodyTransactionsState
                  >(
                    onTap: (TimeKeys time) {
                      context
                          .read<SelectFilterCustodyTransactionsCubit>()
                          .setDate(time);
                    },
                    state: (state) => state.time,
                  ),
                ],
              ),
            ),
            20.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: CustomTextButton(
                    text: context.tr.defaultSettings,
                    onTap: () {
                      context
                          .read<SelectFilterCustodyTransactionsCubit>()
                          .clearFilters();
                    },
                    textColor: context.customColor.text3,
                    padding: EdgeInsets.symmetric(vertical: 18.r),
                  ),
                ),
                10.horizontalSpace,
                Expanded(
                  child:
                      BlocSelector<
                        SelectFilterCustodyTransactionsCubit,
                        SelectFilterCustodyTransactionsState,
                        bool
                      >(
                        selector: (state) =>
                            state.type != CustodyTransactionsTypesEnum.non ||
                            state.time != TimeKeys.non,
                        builder: (context, state) {
                          return AppButton(
                            onClick: () {
                              context
                                  .read<GetBranchBalanceTransactionsCubit>()
                                  .getBranchBalanceTransactions(
                                    status: context
                                        .read<
                                          SelectFilterCustodyTransactionsCubit
                                        >()
                                        .state
                                        .type
                                        .value,
                                    timePeriod: context
                                        .read<
                                          SelectFilterCustodyTransactionsCubit
                                        >()
                                        .state
                                        .time
                                        .key,
                                  );

                              NavigationService.I.pop();
                            },
                            text: context.tr.showResults,
                            enabled: state,
                            padding: EdgeInsets.symmetric(vertical: 18.r),
                            borderRadius: BorderRadius.circular(12.r),
                          );
                        },
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildText(BuildContext context, String text) {
    return Text(
      text,
      style: AppStyles.s14W500.copyWith(color: context.customColor.text3),
    ).sliverBoxAdapter;
  }
}
