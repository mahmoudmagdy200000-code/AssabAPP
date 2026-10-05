import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/features/branch_manager_expenses/data/models/attachment_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/media/media_cubit.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../domain/strategies/grouped_invoice_draft_strategy.dart';
import 'expense_summary_row_widget.dart';

class GroupedInvoiceSummaryExpenseDetailtsSliverListWidgetFieldsAndFilesSection
    extends StatelessWidget {
  final GroupedInvoiceDraftStrategy strategy;
  final List<AttachmentModel> apiAttachments;
  final Map<String, MediaCubit> mediaCubits;
  final ValueNotifier<int?> showDetailsNotifier;
  final String id;
  final int index;

  const GroupedInvoiceSummaryExpenseDetailtsSliverListWidgetFieldsAndFilesSection({
    super.key,
    required this.strategy,
    required this.apiAttachments,
    required this.mediaCubits,
    required this.showDetailsNotifier,
    required this.id,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      child: ValueListenableBuilder(
        valueListenable: showDetailsNotifier,
        builder: (context, value, child) {
          return value != index
              ? const SizedBox.shrink()
              : Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: context.customColor.border),
                  ),
                  padding: EdgeInsets.all(12.r),
                  margin: EdgeInsets.only(top: 12.r, bottom: 9.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlocSelector<ValidationCubit, ValidationState, String?>(
                        selector: (state) =>
                            state.fieldsValue['supplierName_$id'],
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
                      BlocSelector<ValidationCubit, ValidationState, String?>(
                        selector: (state) =>
                            state.fieldsValue['invoiceNumber_$id'],
                        builder: (context, state) {
                          return ExpenseSummaryRowWidget(
                            title: context.tr.invoiceNumber,
                            value: state ?? 'N/A',
                            showAmountIcon: false,
                          );
                        },
                      ),
                      14.verticalSpace,
                      const CustomDivider(),
                      14.verticalSpace,
                      BlocSelector<ValidationCubit, ValidationState, String?>(
                        selector: (state) => state.fieldsValue['issueDate_$id'],
                        builder: (context, state) {
                          return ExpenseSummaryRowWidget(
                            title: context.tr.issueDate,
                            value:
                                DateFormatter.formatDateMDY(
                                  DateTime.tryParse(state ?? ''),
                                ) ??
                                'N/A',
                            showAmountIcon: false,
                          );
                        },
                      ),
                      14.verticalSpace,
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(color: context.customColor.border),
                        ),
                        padding: EdgeInsets.all(12.r),
                        child: Column(
                          children: [
                            BlocSelector<
                              ValidationCubit,
                              ValidationState,
                              String?
                            >(
                              selector: (state) =>
                                  state.fieldsValue['taxSupplierName_$id'],
                              builder: (context, state) {
                                return ExpenseSummaryRowWidget(
                                  title: context.tr.supplierName,
                                  value: state ?? 'N/A',
                                  showAmountIcon: false,
                                );
                              },
                            ),
                            12.verticalSpace,
                            const CustomDivider(),
                            12.verticalSpace,
                            BlocSelector<
                              ValidationCubit,
                              ValidationState,
                              String?
                            >(
                              selector: (state) =>
                                  state.fieldsValue['taxId_$id'],
                              builder: (context, state) {
                                return ExpenseSummaryRowWidget(
                                  title: context.tr.taxId,
                                  value: state ?? 'N/A',
                                  showAmountIcon: false,
                                );
                              },
                            ),
                            12.verticalSpace,
                            const CustomDivider(),
                            12.verticalSpace,
                            BlocSelector<
                              ValidationCubit,
                              ValidationState,
                              String?
                            >(
                              selector: (state) =>
                                  state.fieldsValue['netAmount_$id'],
                              builder: (context, state) {
                                return ExpenseSummaryRowWidget(
                                  title: context.tr.netAmount,
                                  value: state ?? 'N/A',
                                );
                              },
                            ),
                            12.verticalSpace,
                            const CustomDivider(),
                            12.verticalSpace,
                            BlocSelector<
                              ValidationCubit,
                              ValidationState,
                              String?
                            >(
                              selector: (state) =>
                                  state.fieldsValue['vatAmount_$id'],
                              builder: (context, state) {
                                return ExpenseSummaryRowWidget(
                                  title: context.tr.vatAmount,
                                  value: state ?? 'N/A',
                                );
                              },
                            ),
                            12.verticalSpace,
                            const CustomDivider(),
                            12.verticalSpace,
                            BlocSelector<
                              ValidationCubit,
                              ValidationState,
                              String?
                            >(
                              selector: (state) =>
                                  state.fieldsValue['totalIncVat_$id'],
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
                      14.verticalSpace,
                      Text(
                        context.tr.attachments,
                        style: AppStyles.s14W500.copyWith(
                          color: context.customColor.text1,
                        ),
                      ),
                      8.verticalSpace,
                      strategy.buildSummaryAttachmentSection(
                        context,
                        apiAttachments,
                        id: id,
                        mediaCubit: mediaCubits[id]!,
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
