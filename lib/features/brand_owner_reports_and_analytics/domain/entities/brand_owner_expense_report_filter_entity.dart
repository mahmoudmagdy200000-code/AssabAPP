import '../enums/brand_owner_expense_report_status.dart';
import '../enums/brand_owner_expense_report_type.dart';

class ExpenseReportDateFilterEntity {
  final int month;
  final int year;

  const ExpenseReportDateFilterEntity({
    required this.month,
    required this.year,
  });
}

class BrandOwnerExpenseReportFilterEntity {
  final BrandOwnerExpenseReportType? type;
  final BrandOwnerExpenseReportStatus? status;
  final ExpenseReportDateFilterEntity? date;
  final String? branchId;
  final String? branchName;

  const BrandOwnerExpenseReportFilterEntity({
    this.type,
    this.status,
    this.date,
    this.branchId,
    this.branchName,
  });

  BrandOwnerExpenseReportFilterEntity copyWith({
    BrandOwnerExpenseReportType? type,
    BrandOwnerExpenseReportStatus? status,
    ExpenseReportDateFilterEntity? date,
    String? branchId,
    String? branchName,
  }) {
    return BrandOwnerExpenseReportFilterEntity(
      type: type ?? this.type,
      status: status ?? this.status,
      date: date ?? this.date,
      branchId: branchId ?? this.branchId,
      branchName: branchName ?? this.branchName,
    );
  }
}
