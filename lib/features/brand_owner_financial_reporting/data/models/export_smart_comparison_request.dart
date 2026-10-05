import '../../domain/enums/brand_owner_smart_compare_type_enum.dart';

class ExportSmartComparisonRequest {
  final int year;
  final int month;
  final int comparedYear;
  final int comparedMonth;
  final BrandOwnerSmartCompareTypeEnum type;
  final String branchId;
  final String? comparedBranchId;
  final String formatType;
  final String? email;

  const ExportSmartComparisonRequest({
    required this.year,
    required this.month,
    required this.comparedYear,
    required this.comparedMonth,
    required this.type,
    required this.branchId,
    this.comparedBranchId,
    required this.formatType,
    this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'year': year,
      'month': month,
      'compared_year': comparedYear,
      'compared_month': comparedMonth,
      'type': type.value,
      'branch_id': branchId,
      'compared_branch_id': comparedBranchId,
      'format_type': formatType,
      if (email != null) 'email': email,
    };
  }
}
