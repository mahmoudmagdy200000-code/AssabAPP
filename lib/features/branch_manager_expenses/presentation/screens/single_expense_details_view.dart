import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/features/branch_manager_expenses/data/models/attachment_model.dart';
import 'package:assab/features/branch_manager_expenses/presentation/widgets/top_section_of_single_expense_views.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/label_text_field.dart';
import '../../../../core/widgets/upload_expense_invoice_receipt.dart';
import '../../domain/strategies/single_invoice_draft_strategy.dart';
import '../widgets/single_expense_details_view_middle_section.dart';

class SingleExpenseDetailsView extends StatelessWidget {
  final SingleInvoiceDraftStrategy strategy;
  final List<AttachmentModel> attachments;

  const SingleExpenseDetailsView({
    super.key,
    required this.strategy,
    required this.attachments,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TopSectionOfSingleExpenseViews(
                title: context.tr.invoiceDetails,
                desc: context.tr.invoiceDetailsDesc,
              ),
              SingleExpenseDetailsViewMiddleSection(strategy: strategy),
              14.verticalSpace,
              LabelTextField(text: context.tr.uploadInvoiceReceipt),
              10.verticalSpace,
              const UploadExpenseInvoiceReceipt(),
              10.verticalSpace,
            ],
          ),
        ),
        strategy.buildAttachmentsSection(context, attachments),
      ],
    );
  }
}
