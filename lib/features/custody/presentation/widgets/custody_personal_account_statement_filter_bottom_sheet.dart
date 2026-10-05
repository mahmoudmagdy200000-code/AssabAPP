import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/utils/date_formatter.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/custody_export_account_statement_export_format_enum.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_padding_widget.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../../../core/widgets/custom_text_button.dart';
import '../cubit/get_personal_balance_transactions/get_personal_balance_transactions_cubit.dart';
import '../cubit/select_filter_account_statement/select_filter_account_statement_cubit.dart';
import '../cubit/select_filter_account_statement/select_filter_account_statement_state.dart';
import 'custody_personal_account_statement_filter_sort_by_date_section.dart';

class CustodyPersonalAccountStatementFilterBottomSheet extends StatelessWidget {
  const CustodyPersonalAccountStatementFilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AppPaddingWidget(
        top: 0,
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      context.tr.filterTransactionHistoryBy,
                      style: AppStyles.s20W600.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                  ),
                  16.verticalSpace,
                  const CustomDivider(),
                  16.verticalSpace,
                  // _buildText(context, context.tr.type),
                  // 8.verticalSpace,
                  // Row(
                  //   children: List.generate(2, (index) {
                  //     final texts = [
                  //       context.tr.dailyView,
                  //       context.tr.detailedView,
                  //     ];

                  //     final frames = [
                  //       CustodyExportAccountStatementExportFormatEnum.dailyView,
                  //       CustodyExportAccountStatementExportFormatEnum
                  //           .detailedView,
                  //     ];

                  //     return Expanded(
                  //       child: Row(
                  //         children: [
                  //           Expanded(
                  //             child:
                  //                 BlocSelector<
                  //                   SelectFilterAccountStatementCubit,
                  //                   SelectFilterAccountStatementState,
                  //                   bool
                  //                 >(
                  //                   selector: (state) =>
                  //                       state.type == frames[index],
                  //                   builder: (context, state) {
                  //                     return CustomTextButton(
                  //                       text: texts[index],
                  //                       borderRadius: 1000.r,
                  //                       borderColor: state
                  //                           ? context.theme.primaryColor
                  //                           : context.customColor.border,
                  //                       textColor: state
                  //                           ? context.theme.primaryColor
                  //                           : context.customColor.text3,
                  //                       onTap: () {
                  //                         context
                  //                             .read<
                  //                               SelectFilterAccountStatementCubit
                  //                             >()
                  //                             .setType(frames[index]);
                  //                       },
                  //                     );
                  //                   },
                  //                 ),
                  //           ),
                  //           if (index == 0) 10.horizontalSpace,
                  //         ],
                  //       ),
                  //     );
                  //   }),
                  // ),
                  // 16.verticalSpace,
                  _buildText(context, context.tr.sortByDate),
                  8.verticalSpace,
                  const CustodyPersonalAccountStatementFilterSortByDateSection(),
                ],
              ),
            ),
            20.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: CustomTextButton(
                    text: context.tr.defaultSettings,
                    padding: EdgeInsets.symmetric(vertical: 18.r),
                    textColor: context.customColor.text3,
                    onTap: () {
                      context
                          .read<SelectFilterAccountStatementCubit>()
                          .clearFilters();
                    },
                  ),
                ),
                10.horizontalSpace,
                Expanded(
                  child:
                      BlocSelector<
                        SelectFilterAccountStatementCubit,
                        SelectFilterAccountStatementState,
                        bool
                      >(
                        selector: (state) =>
                            (state.selectedYear != null &&
                                state.selectedMonth != null) ||
                            state.type !=
                                CustodyExportAccountStatementExportFormatEnum
                                    .non,
                        builder: (context, state) {
                          return AppButton(
                            onClick: () {
                              context
                                  .read<GetPersonalBalanceTransactionsCubit>()
                                  .getPersonalBalanceTransactions(
                                    month: DateFormatter.getMonthNumber(
                                      context
                                              .read<
                                                SelectFilterAccountStatementCubit
                                              >()
                                              .state
                                              .selectedMonth ??
                                          '',
                                    ).toString(),
                                    year: context
                                        .read<
                                          SelectFilterAccountStatementCubit
                                        >()
                                        .state
                                        .selectedYear
                                        .toString(),
                                  );

                              NavigationService.I.pop();
                            },
                            text: context.tr.showResults,
                            enabled: state,
                            padding: EdgeInsets.symmetric(vertical: 18.r),
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
    );
  }
}
