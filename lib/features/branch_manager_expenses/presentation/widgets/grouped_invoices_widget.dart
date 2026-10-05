import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../domain/entities/grouped_invoice_entity.dart';
import '../../domain/strategies/grouped_invoice_draft_strategy.dart';
import 'grouped_invoices_purchases_section.dart';
import 'grouped_invoices_widget_fields.dart';
import 'grouped_invoices_widget_top_section.dart';

class GroupedInvoicesWidget extends StatefulWidget {
  final GroupedInvoiceDraftStrategy strategy;
  final GroupedInvoiceEntity? groupedInvoiceEntity;
  final String id;
  final int index;
  final VoidCallback onRemove;

  const GroupedInvoicesWidget({
    super.key,
    required this.id,
    required this.index,
    required this.onRemove,
    required this.strategy,
    required this.groupedInvoiceEntity,
  });

  @override
  State<GroupedInvoicesWidget> createState() => _GroupedInvoicesWidgetState();
}

class _GroupedInvoicesWidgetState extends State<GroupedInvoicesWidget> {
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

  void _removeValidationsFields() {
    context.read<ValidationCubit>().removeDynamicFields({
      'supplierId_${widget.id}',
      'supplierName_${widget.id}',
      'invoiceNumber_${widget.id}',
      'issueDate_${widget.id}',
      'photos_${widget.id}',
      'vatAmount_${widget.id}',
      'totalIncVat_${widget.id}',
      'taxId_${widget.id}',
      'taxSupplierName_${widget.id}',
      'netAmount_${widget.id}',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: context.customColor.border),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Column(
        children: [
          GroupedInvoicesWidgetTopSection(
            index: widget.index,
            id: widget.id,
            onRemove: () {
              _removeValidationsFields();
              widget.onRemove();
            },
            showDetailsNotifier: _showDetailsNotifier,
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            child: ValueListenableBuilder(
              valueListenable: _showDetailsNotifier,
              builder: (context, value, child) {
                return value != widget.index
                    ? const SizedBox.shrink()
                    : Container(
                        decoration: BoxDecoration(
                          color: context.customColor.text2,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15.r),
                            bottomRight: Radius.circular(15.r),
                          ),
                        ),
                        padding: EdgeInsets.all(10.r),
                        child: Column(
                          children: [
                            GroupedInvoicesWidgetFields(
                              id: widget.id,
                              strategy: widget.strategy,
                              attachments:
                                  widget
                                      .groupedInvoiceEntity
                                      ?.invoices[widget.index]
                                      .attachments ??
                                  [],
                            ),
                            10.verticalSpace,
                            GroupedInvoicesPurchasesSection(id: widget.id),
                          ],
                        ),
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}
