import 'package:assab/features/branch_manager_expenses/data/models/expense_type_model.dart';

import '../../../../shared/models/rejection_record.dart';
import '../../../../shared/models/time_line_response.dart';
import '../../data/models/attachment_model.dart';
import '../../data/models/expenses_approval_model.dart';
import '../../data/models/pre_approval_data_model.dart';
import '../../data/models/supplier_model.dart';

class PreApprovalEntity {
  final String id;
  final int reviewRevision;
  final String purpose;
  final PreApprovalPriorityModel priority;
  final ExpenseTypeModel expenseType;
  final String status;
  final String estimatedAmount;
  final String paymentMethod;
  final SupplierModel paymentSupplier;
  final String createdAt;
  final List<AttachmentModel> attachments;
  final List<PreApprovalItemModel> items;
  final List<PreApprovalExpenseModel> expenses;
  final TimeLineResponse timelines;
  final RejectionRecord? rejection;
  final ExpensesApprovalModel? approval;

  PreApprovalEntity({
    required this.id,
    this.reviewRevision = 1,
    required this.expenseType,
    required this.status,
    required this.estimatedAmount,
    required this.paymentMethod,
    required this.paymentSupplier,
    required this.createdAt,
    required this.purpose,
    required this.priority,
    required this.attachments,
    required this.items,
    required this.expenses,
    required this.timelines,
    required this.rejection,
    required this.approval,
  });
}
