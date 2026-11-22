import 'package:assab/features/branch_manager_expenses/data/models/supplier_model.dart';
import 'package:assab/shared/models/time_line_response.dart';

import '../../../../shared/models/rejection_record.dart';
import '../../data/models/attachment_model.dart';
import '../../data/models/expense_item_model.dart';
import '../../data/models/expense_type_model.dart';
import '../../data/models/expenses_approval_model.dart';

class QuickCashEntity {
  final String id;
  final int reviewRevision;
  final String status;
  final String createdAt;
  final String expenseName;
  final String expenseDate;
  final ExpenseTypeModel expenseType;
  final String totalAmount;
  final String invoiceNumber;
  final String paymentMethod;
  final SupplierModel paymentSupplier;
  final List<ExpenseItemModel> expenseItems;
  final List<AttachmentModel> attachments;
  final TimeLineResponse timelines;
  final RejectionRecord? rejection;
  final ExpensesApprovalModel? approval;

  QuickCashEntity({
    required this.id,
    this.reviewRevision = 1,
    required this.status,
    required this.createdAt,
    required this.expenseName,
    required this.expenseDate,
    required this.expenseType,
    required this.totalAmount,
    required this.invoiceNumber,
    required this.paymentMethod,
    required this.paymentSupplier,
    required this.expenseItems,
    required this.attachments,
    required this.timelines,
    this.rejection,
    this.approval,
  });
}
