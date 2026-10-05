import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/cubits/add_item/add_item_cubit.dart';
import 'package:assab/core/cubits/switch_button/switch_button_cubit.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/date_formatter.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/features/branch_manager_expenses/data/models/attachment_model.dart';
import 'package:assab/features/branch_manager_expenses/domain/strategies/single_invoice_draft_strategy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/add_item/add_item_state.dart';
import '../../../../core/cubits/paging_cubit/paging_cubit.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../widgets/expense_summary_row_widget.dart';
import '../widgets/top_section_of_single_expense_views.dart';

class SingleExpenseSummeryView extends StatelessWidget {
  final SingleInvoiceDraftStrategy strategy;
  final List<AttachmentModel> apiAttachments;

  const SingleExpenseSummeryView({
    super.key,
    required this.strategy,
    required this.apiAttachments,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          TopSectionOfSingleExpenseViews(
            title: context.tr.reviewExpenseSummary,
            desc: context.tr.reviewExpenseSummaryDesc,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: context.customColor.border),
              borderRadius: BorderRadius.circular(20.r),
            ),
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.tr.expenseSummary,
                      style: AppStyles.s16W600.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                    AppGestureDetectorButton(
                      onTap: () => context.read<PagingCubit>().goToStep(0),
                      child: AppSvg(
                        assetName: AppAssets.edit,
                        width: 20.r,
                        colorFilter: ColorFilter.mode(
                          context.theme.primaryColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ],
                ),
                14.verticalSpace,
                const CustomDivider(),
                14.verticalSpace,
                BlocSelector<ValidationCubit, ValidationState, String?>(
                  selector: (state) => state.fieldsValue['issueDate'],
                  builder: (context, state) {
                    return ExpenseSummaryRowWidget(
                      title: context.tr.issueDate,
                      value:
                          DateFormatter.formatDateMDY(
                            DateTime.tryParse(state ?? ''),
                          ) ??
                          'No Date',
                      showAmountIcon: false,
                    );
                  },
                ),
                14.verticalSpace,
                const CustomDivider(),
                14.verticalSpace,
                BlocSelector<ValidationCubit, ValidationState, String?>(
                  selector: (state) => state.fieldsValue['taxId'],
                  builder: (context, state) {
                    return state != null
                        ? Column(
                            children: [
                              ExpenseSummaryRowWidget(
                                title: context.tr.taxId,
                                value: state,
                                showAmountIcon: false,
                              ),
                              14.verticalSpace,
                              const CustomDivider(),
                              14.verticalSpace,
                            ],
                          )
                        : const SizedBox.shrink();
                  },
                ),
                BlocSelector<ValidationCubit, ValidationState, String?>(
                  selector: (state) => state.fieldsValue['supplierName'],
                  builder: (context, state) {
                    return ExpenseSummaryRowWidget(
                      title: context.tr.supplierName,
                      value: state ?? 'No Supplier Name',
                      showAmountIcon: false,
                    );
                  },
                ),
                14.verticalSpace,
                const CustomDivider(),
                14.verticalSpace,
                BlocSelector<AddItemCubit, AddItemState, int>(
                  selector: (state) {
                    return (state.lists['purchases']?.length ?? 0) +
                        (state.lists['expenses']?.length ?? 0);
                  },
                  builder: (context, state) {
                    return ExpenseSummaryRowWidget(
                      title: context.tr.totalInvoiceItems,
                      value: state.toString(),
                      showAmountIcon: false,
                    );
                  },
                ),
                14.verticalSpace,
                const CustomDivider(),
                14.verticalSpace,
                BlocSelector<ValidationCubit, ValidationState, String>(
                  selector: (state) {
                    final addItemCubit = context.read<AddItemCubit>();

                    double total = 0;

                    final items = addItemCubit.state.lists['purchases'] ?? [];
                    final expenses = addItemCubit.state.lists['expenses'] ?? [];

                    if (state.fieldsValue['partialPaidAmount'] != null ||
                        state.fieldsValue['partialPaidAmount']?.isNotEmpty ==
                            true) {
                      total =
                          double.tryParse(
                            state.fieldsValue['partialPaidAmount']!.toString(),
                          ) ??
                          0;
                    } else {
                      for (final id in items) {
                        final qty =
                            double.tryParse(
                              state.fieldsValue['purchaseQty_$id']
                                      ?.toString() ??
                                  '',
                            ) ??
                            0;
                        final unit =
                            double.tryParse(
                              state.fieldsValue['purchaseUnitPrice_$id']
                                      ?.toString() ??
                                  '',
                            ) ??
                            0;
                        total += qty * unit;
                      }

                      for (final id in expenses) {
                        final price =
                            double.tryParse(
                              state.fieldsValue['expenseUnitPrice_$id']
                                      ?.toString() ??
                                  '',
                            ) ??
                            0;
                        total += price;
                      }
                    }

                    return total.toString();
                  },
                  builder: (context, state) {
                    return ExpenseSummaryRowWidget(
                      title: context.tr.totalAmountPaid,
                      value: state,
                      showAmountIcon: false,
                    );
                  },
                ),
                BlocBuilder<SwitchButtonCubit, bool>(
                  builder: (context, state) {
                    return state
                        ? Column(
                            children: [
                              14.verticalSpace,
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(
                                    color: context.customColor.border,
                                  ),
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                padding: EdgeInsets.all(16.r),
                                child: Column(
                                  children: [
                                    Text(
                                      context.tr.thisExpenseIncludesVat,
                                      style: AppStyles.s16W600.copyWith(
                                        color: context.customColor.text1,
                                      ),
                                    ),
                                    14.verticalSpace,
                                    const CustomDivider(),
                                    14.verticalSpace,
                                    BlocSelector<
                                      ValidationCubit,
                                      ValidationState,
                                      String?
                                    >(
                                      selector: (state) =>
                                          state.fieldsValue['taxId'],
                                      builder: (context, state) {
                                        return ExpenseSummaryRowWidget(
                                          title: context.tr.taxId,
                                          value: state ?? 'N/A',
                                          showAmountIcon: false,
                                        );
                                      },
                                    ),
                                    14.verticalSpace,
                                    const CustomDivider(),
                                    14.verticalSpace,
                                    BlocSelector<
                                      ValidationCubit,
                                      ValidationState,
                                      String?
                                    >(
                                      selector: (state) =>
                                          state.fieldsValue['taxSupplierName'],
                                      builder: (context, state) {
                                        return ExpenseSummaryRowWidget(
                                          title: context.tr.supplierName,
                                          value: state ?? 'N/A',
                                          showAmountIcon: false,
                                        );
                                      },
                                    ),
                                    14.verticalSpace,
                                    const CustomDivider(),
                                    14.verticalSpace,
                                    BlocSelector<
                                      ValidationCubit,
                                      ValidationState,
                                      String?
                                    >(
                                      selector: (state) =>
                                          state.fieldsValue['netAmount'],
                                      builder: (context, state) {
                                        return ExpenseSummaryRowWidget(
                                          title: context.tr.netAmount,
                                          value: state ?? 'N/A',
                                        );
                                      },
                                    ),
                                    14.verticalSpace,
                                    const CustomDivider(),
                                    14.verticalSpace,
                                    BlocSelector<
                                      ValidationCubit,
                                      ValidationState,
                                      String?
                                    >(
                                      selector: (state) =>
                                          state.fieldsValue['vatAmount'],
                                      builder: (context, state) {
                                        return ExpenseSummaryRowWidget(
                                          title: context.tr.vatAmount,
                                          value: state ?? 'N/A',
                                        );
                                      },
                                    ),
                                    14.verticalSpace,
                                    const CustomDivider(),
                                    14.verticalSpace,
                                    BlocSelector<
                                      ValidationCubit,
                                      ValidationState,
                                      String?
                                    >(
                                      selector: (state) =>
                                          state.fieldsValue['totalIncVat'],
                                      builder: (context, state) {
                                        return ExpenseSummaryRowWidget(
                                          title: context.tr.totalInclVat,
                                          value: state ?? 'N/A',
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : const SizedBox.shrink();
                  },
                ),
                14.verticalSpace,
                Text(
                  context.tr.expenseInvoiceReceipt,
                  style: AppStyles.s14W600.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                10.verticalSpace,
                strategy.buildSummaryAttachmentSection(context, apiAttachments),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
