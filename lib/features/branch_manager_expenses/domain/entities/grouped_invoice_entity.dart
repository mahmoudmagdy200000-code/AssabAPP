import 'package:assab/features/branch_manager_expenses/data/models/attachment_model.dart';
import 'package:assab/features/branch_manager_expenses/data/models/expense_type_model.dart';
import 'package:assab/features/branch_manager_expenses/data/models/supplier_model.dart';

import '../../../../shared/models/cancel_reason/cancel_reason_response.dart';
import '../../../../shared/models/time_line_response.dart';
import '../../data/models/expenses_approval_model.dart';

class GroupedInvoiceEntity {
  final String id;
  final SupplierModel defaultSupplier;
  final String totalGroupedInvoice;
  final String paymentMethod;
  final SupplierModel paymentSupplier;
  final String status;
  final ExpenseTypeModel expenseType;
  final String paymentType;
  final String dueDate;
  final String paidAmount;
  final List<GroupedInvoiceInvoiceEntity> invoices;
  final TimeLineResponse timelines;
  final CancelReasonResponse? cancelReason;
  final ExpensesApprovalModel? approval;

  GroupedInvoiceEntity({
    required this.id,
    required this.defaultSupplier,
    required this.totalGroupedInvoice,
    required this.paymentMethod,
    required this.paymentSupplier,
    required this.status,
    required this.expenseType,
    required this.paymentType,
    required this.dueDate,
    required this.paidAmount,
    required this.invoices,
    required this.timelines,
    required this.cancelReason,
    required this.approval,
  });
}

class GroupedInvoiceInvoiceEntity {
  final String id;
  final SupplierModel supplier;
  final String invoiceNumber;
  final String issuedDate;
  final GroupedInvoiceTaxEntity tax;
  final List<AttachmentModel> attachments;
  final List<GroupedInvoicePurchasesEntity> purchases;

  GroupedInvoiceInvoiceEntity({
    required this.id,
    required this.supplier,
    required this.invoiceNumber,
    required this.issuedDate,
    required this.tax,
    required this.attachments,
    required this.purchases,
  });
}

class GroupedInvoiceTaxEntity {
  final String supplierName;
  final String taxId;
  final String netAmount;
  final String vatAmount;
  final String totalIncVat;

  GroupedInvoiceTaxEntity({
    required this.supplierName,
    required this.taxId,
    required this.netAmount,
    required this.vatAmount,
    required this.totalIncVat,
  });
}

class GroupedInvoicePurchasesEntity {
  final String categoryId;
  final String name;
  final String quantity;
  final String unitPrice;
  final String totalAmount;

  GroupedInvoicePurchasesEntity({
    required this.categoryId,
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.totalAmount,
  });
}
