import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/utils/date_formatter.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../../../core/widgets/network_file_preview_widget.dart';
import '../../domain/entities/grouped_invoice_entity.dart';
import 'custom_data_table.dart';
import 'expense_summary_row_widget.dart';

class ExpenseGroupedInvoieDetailsDetailsSliverListWidget
    extends StatelessWidget {
  final ValueNotifier<int?> showDetailsNotifier;
  final int index;
  final GroupedInvoiceInvoiceEntity invoice;

  const ExpenseGroupedInvoieDetailsDetailsSliverListWidget({
    super.key,
    required this.showDetailsNotifier,
    required this.index,
    required this.invoice,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: context.customColor.border),
        borderRadius: BorderRadius.circular(15.r),
      ),
      padding: EdgeInsets.all(12.r),
      margin: EdgeInsets.only(bottom: 10.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${index + 1}',
                style: AppStyles.s14W600.copyWith(
                  color: context.customColor.text3,
                ),
              ),
              14.horizontalSpace,
              Expanded(
                child: AppGestureDetectorButton(
                  onTap: () {},
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        invoice.invoiceNumber,
                        style: AppStyles.s14W600.copyWith(
                          color: context.customColor.text1,
                        ),
                      ),
                      const Spacer(),
                      AppGestureDetectorButton(
                        child: ValueListenableBuilder(
                          valueListenable: showDetailsNotifier,
                          builder: (context, value, child) {
                            return Icon(
                              value == index
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                            );
                          },
                        ),
                        onTap: () {
                          showDetailsNotifier.value =
                              showDetailsNotifier.value == index ? null : index;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          AnimatedSize(
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
                            ExpenseSummaryRowWidget(
                              title: context.tr.supplierName,
                              value: invoice.supplier.name,
                              showAmountIcon: false,
                            ),
                            14.verticalSpace,
                            const CustomDivider(),
                            14.verticalSpace,
                            ExpenseSummaryRowWidget(
                              title: context.tr.invoiceNumber,
                              value: invoice.invoiceNumber,
                              showAmountIcon: false,
                            ),
                            14.verticalSpace,
                            const CustomDivider(),
                            14.verticalSpace,
                            ExpenseSummaryRowWidget(
                              title: context.tr.issueDate,
                              value:
                                  DateFormatter.formatDateMDY(
                                    DateTime.tryParse(invoice.issuedDate),
                                  ) ??
                                  'N/A',
                              showAmountIcon: false,
                            ),
                            14.verticalSpace,
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(
                                  color: context.customColor.border,
                                ),
                              ),
                              padding: EdgeInsets.all(12.r),
                              child: Column(
                                children: [
                                  ExpenseSummaryRowWidget(
                                    title: context.tr.supplierName,
                                    value: invoice.tax.supplierName,
                                    showAmountIcon: false,
                                  ),
                                  12.verticalSpace,
                                  const CustomDivider(),
                                  12.verticalSpace,
                                  ExpenseSummaryRowWidget(
                                    title: context.tr.taxId,
                                    value: invoice.tax.taxId,
                                    showAmountIcon: false,
                                  ),
                                  12.verticalSpace,
                                  const CustomDivider(),
                                  12.verticalSpace,
                                  ExpenseSummaryRowWidget(
                                    title: context.tr.netAmount,
                                    value: invoice.tax.netAmount,
                                  ),
                                  12.verticalSpace,
                                  const CustomDivider(),
                                  12.verticalSpace,
                                  ExpenseSummaryRowWidget(
                                    title: context.tr.vatAmount,
                                    value: invoice.tax.vatAmount,
                                  ),
                                  12.verticalSpace,
                                  const CustomDivider(),
                                  12.verticalSpace,
                                  ExpenseSummaryRowWidget(
                                    title: context.tr.totalInclVat,
                                    value: invoice.tax.totalIncVat,
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
                            ListView.builder(
                              itemCount: invoice.attachments.length,
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) =>
                                  NetworkFilePreviewWidget(
                                    attachmentModel: invoice.attachments[index],
                                  ),
                            ),
                          ],
                        ),
                      );
              },
            ),
          ),
          5.verticalSpace,
          Text(
            context.tr.purchases,
            style: AppStyles.s14W500.copyWith(color: context.customColor.text1),
          ),
          8.verticalSpace,
          CustomDataTable(
            headers: [
              context.tr.description,
              context.tr.qty,
              context.tr.price,
              context.tr.total,
            ],
            keysOrder: const ['description', 'quantity', 'price', 'total'],
            items: invoice.purchases
                .map(
                  (e) => {
                    'description': e.name,
                    'quantity': e.quantity.toString(),
                    'price': e.unitPrice,
                    'total': e.totalAmount,
                  },
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
