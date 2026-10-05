import '../../../../shared/models/cancel_reason/cancel_reason_response.dart';
import '../../../../shared/models/time_line_response.dart';
import '../../data/models/attachment_model.dart';
import '../../data/models/expense_type_model.dart';
import '../../data/models/expenses_approval_model.dart';
import '../../data/models/single_invoice_data_model.dart';
import '../../data/models/supplier_model.dart';

class SingleInvoiceEntity {
  final String id;
  final String status;
  final String createdAt;
  final String expenseName;
  final ExpenseTypeModel expenseType;
  final String totalAmount;
  final String invoiceNumber;
  final String netAmount;
  final String vatAmount;
  final String paymentMethod;
  final String taxId;
  final String supplierId;
  final String supplierName;
  final String totalAmountPaid;
  final String issueDate;
  final bool isTaxInvoice;
  final String totalInvoiceItems;
  final String paymentType;
  final String dueDate;
  final String paymentSupplierId;
  final SupplierModel? paymentSupplier;
  final String taxSupplierName;
  final List<SingleInvoiceItemModel> items;
  final List<SingleInvoiceExpenseModel> expenses;
  final List<AttachmentModel> attachments;
  final TimeLineResponse timelines;
  final CancelReasonResponse? cancelReason;
  final ExpensesApprovalModel? approval;

  SingleInvoiceEntity({
    required this.id,
    required this.status,
    required this.createdAt,
    required this.expenseName,
    required this.expenseType,
    required this.totalAmount,
    required this.invoiceNumber,
    required this.netAmount,
    required this.vatAmount,
    required this.paymentMethod,
    required this.attachments,
    required this.taxId,
    required this.supplierId,
    required this.supplierName,
    required this.totalAmountPaid,
    required this.issueDate,
    required this.isTaxInvoice,
    required this.items,
    required this.expenses,
    required this.totalInvoiceItems,
    required this.paymentType,
    required this.dueDate,
    required this.paymentSupplierId,
    this.paymentSupplier,
    required this.taxSupplierName,
    required this.timelines,
    this.cancelReason,
    this.approval,
  });
}
