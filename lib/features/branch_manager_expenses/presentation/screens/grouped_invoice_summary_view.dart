import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/cubits/add_item/add_item_cubit.dart';
import 'package:assab/core/cubits/add_item/add_item_state.dart';
import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/cubits/validation/validation_state.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_svg_button.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/features/branch_manager_expenses/domain/entities/grouped_invoice_entity.dart';
import 'package:assab/features/branch_manager_expenses/domain/strategies/grouped_invoice_draft_strategy.dart';
import 'package:assab/features/branch_manager_expenses/presentation/widgets/expense_summary_row_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/media/media_cubit.dart';
import '../widgets/grouped_invoice_summary_expense_detailts_sliver_list_widget.dart';

class GroupedInvoiceSummaryView extends StatefulWidget {
  final GroupedInvoiceDraftStrategy strategy;
  final GroupedInvoiceEntity? groupedInvoiceEntity;
  final Map<String, MediaCubit> mediaCubits;

  const GroupedInvoiceSummaryView({
    super.key,
    required this.mediaCubits,
    required this.strategy,
    this.groupedInvoiceEntity,
  });

  @override
  State<GroupedInvoiceSummaryView> createState() =>
      _GroupedInvoiceSummaryViewState();
}

class _GroupedInvoiceSummaryViewState extends State<GroupedInvoiceSummaryView> {
  late final ValueNotifier<int?> _showDetailsNotifier;

  @override
  void initState() {
    _showDetailsNotifier = ValueNotifier<int?>(null);
    super.initState();
  }

  @override
  void dispose() {
    _showDetailsNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      context.tr.totalInvoiceSummary,
                      style: AppStyles.s16W600.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                  ),
                  12.horizontalSpace,
                  AppSvgButton(
                    assetName: AppAssets.edit,
                    onTap: () {
                      context.read<PagingCubit>().goToStep(0);
                    },
                    borderColor: Colors.transparent,
                  ),
                ],
              ),
              12.verticalSpace,
              const CustomDivider(),
              12.verticalSpace,
              Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: context.customColor.border),
                ),
                padding: EdgeInsets.all(16.r),
                child: Column(
                  children: [
                    BlocSelector<ValidationCubit, ValidationState, String?>(
                      selector: (state) => state.fieldsValue['supplierName'],
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
                    BlocSelector<AddItemCubit, AddItemState, int>(
                      selector: (state) =>
                          state.lists['invoiceGroup']?.length ?? 0,
                      builder: (context, state) {
                        return ExpenseSummaryRowWidget(
                          title: context.tr.totalGroupedInvoice,
                          value: state.toString(),
                          showAmountIcon: false,
                        );
                      },
                    ),
                  ],
                ),
              ),
              15.verticalSpace,
            ],
          ),
        ),
        BlocSelector<AddItemCubit, AddItemState, List<String>>(
          selector: (state) => state.lists['invoiceGroup'] ?? [],
          builder: (context, invoiceGroups) {
            return SliverList.builder(
              itemCount: invoiceGroups.length,
              itemBuilder: (context, index) {
                return GroupedInvoiceSummaryExpenseDetailsSliverListWidget(
                  key: ValueKey(invoiceGroups[index]),
                  id: invoiceGroups[index],
                  mediaCubits: widget.mediaCubits,
                  invoiceGroups: invoiceGroups,
                  showDetailsNotifier: _showDetailsNotifier,
                  strategy: widget.strategy,
                  apiAttachments:
                      widget
                          .groupedInvoiceEntity
                          ?.invoices[index]
                          .attachments ??
                      [],
                  index: index,
                );
              },
            );
          },
        ),
      ],
    );
  }
}
