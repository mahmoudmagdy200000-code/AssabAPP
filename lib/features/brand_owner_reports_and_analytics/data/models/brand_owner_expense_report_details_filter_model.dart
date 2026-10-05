import '../../domain/entities/brand_owner_expense_report_filter_entity.dart';
import '../../domain/enums/brand_owner_expense_report_status.dart';
import '../../domain/enums/brand_owner_expense_report_type.dart';

class BrandOwnerExpenseReportDetailsFilterModel {
  final String? type;
  final String? status;
  final int? month;
  final int? year;
  final String? branchId;
  final String? branchName;

  const BrandOwnerExpenseReportDetailsFilterModel({
    this.type,
    this.status,
    this.month,
    this.year,
    this.branchId,
    this.branchName,
  });

  factory BrandOwnerExpenseReportDetailsFilterModel.fromEntity(
    BrandOwnerExpenseReportFilterEntity? entity,
  ) {
    if (entity == null) return const BrandOwnerExpenseReportDetailsFilterModel();

    return BrandOwnerExpenseReportDetailsFilterModel(
      type: entity.type?.value,
      status: entity.status?.value,
      month: entity.date?.month,
      year: entity.date?.year,
      branchId: entity.branchId,
      branchName: entity.branchName,
    );
  }

  BrandOwnerExpenseReportFilterEntity toEntity() {
    return BrandOwnerExpenseReportFilterEntity(
      type: BrandOwnerExpenseReportType.fromValue(type),
      status: BrandOwnerExpenseReportStatus.fromValue(status),
      date: (month != null && year != null)
          ? ExpenseReportDateFilterEntity(month: month!, year: year!)
          : null,
      branchId: branchId,
      branchName: branchName,
    );
  }

  BrandOwnerExpenseReportDetailsFilterModel copyWith({
    String? type,
    String? status,
    int? month,
    int? year,
    String? branchId,
    String? branchName,
  }) {
    return BrandOwnerExpenseReportDetailsFilterModel(
      type: type ?? this.type,
      status: status ?? this.status,
      month: month ?? this.month,
      year: year ?? this.year,
      branchId: branchId ?? this.branchId,
      branchName: branchName ?? this.branchName,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    if (type != null && type!.isNotEmpty) data['type'] = type;
    if (status != null && status!.isNotEmpty) data['status'] = status;
    if (month != null) data['month'] = month;
    if (year != null) data['year'] = year;
    if (branchId != null && branchId!.isNotEmpty) {
      data['branch_id'] = branchId;
    }

    return data;
  }
}
