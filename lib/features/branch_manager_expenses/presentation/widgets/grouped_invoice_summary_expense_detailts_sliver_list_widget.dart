import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/extensions/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/add_item/add_item_cubit.dart';
import '../../../../core/cubits/add_item/add_item_state.dart';
import '../../../../core/cubits/media/media_cubit.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/styles/app_styles.dart';
import '../../data/models/attachment_model.dart';
import '../../domain/strategies/grouped_invoice_draft_strategy.dart';
import 'custom_data_table.dart';
import 'grouped_invoice_summary_expense_details_sliver_list_widget_fields_and_files_section.dart';
import 'grouped_invoice_summary_expense_details_top_section.dart';

class GroupedInvoiceSummaryExpenseDetailsSliverListWidget
    extends StatelessWidget {
  final GroupedInvoiceDraftStrategy strategy;
  final List<AttachmentModel> apiAttachments;
  final Map<String, MediaCubit> mediaCubits;
  final List<String> invoiceGroups;
  final ValueNotifier<int?> showDetailsNotifier;
  final String id;
  final int index;

  const GroupedInvoiceSummaryExpenseDetailsSliverListWidget({
    super.key,
    required this.strategy,
    required this.apiAttachments,
    required this.mediaCubits,
    required this.invoiceGroups,
    required this.showDetailsNotifier,
    required this.id,
    required this.index,
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
      margin: EdgeInsets.only(
        bottom: index < invoiceGroups.length - 1 ? 10.r : 0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GroupedInvoiceSummaryExpenseDetailtsTopSection(
            index: index,
            id: id,
            showDetailsNotifier: showDetailsNotifier,
          ),
          GroupedInvoiceSummaryExpenseDetailtsSliverListWidgetFieldsAndFilesSection(
            id: id,
            mediaCubits: mediaCubits,
            showDetailsNotifier: showDetailsNotifier,
            strategy: strategy,
            apiAttachments: apiAttachments,
            index: index,
          ),
          5.verticalSpace,
          Text(
            context.tr.purchases,
            style: AppStyles.s14W500.copyWith(color: context.customColor.text1),
          ),
          8.verticalSpace,
          BlocSelector<AddItemCubit, AddItemState, List<String>>(
            selector: (state) => state.lists['purchases_$id'] ?? [],
            builder: (context, purchases) {
              final purchasesIds = purchases;

              return BlocSelector<
                ValidationCubit,
                ValidationState,
                List<Map<String, String>>
              >(
                selector: (state) => purchasesIds.map((purchaseId) {
                  final qty =
                      state.fieldsValue['purchaseQty_${id}_$purchaseId'] ?? '0';
                  final price =
                      state
                          .fieldsValue['purchaseUnitPrice_${id}_$purchaseId'] ??
                      '0';

                  final total = price.toDoubleOrZero() * qty.toDoubleOrZero();

                  return {
                    'description':
                        state.fieldsValue['itemPurchasedName_${id}_$purchaseId']
                            ?.toString() ??
                        'N/A',
                    'quantity': qty,
                    'price': price,
                    'total': total.toStringAsFixed(2),
                  };
                }).toList(),
                builder: (context, purchases) {
                  return CustomDataTable(
                    headers: [
                      context.tr.description,
                      context.tr.qty,
                      context.tr.price,
                      context.tr.total,
                    ],
                    keysOrder: const [
                      'description',
                      'quantity',
                      'price',
                      'total',
                    ],
                    items: purchases,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
