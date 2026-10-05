import 'package:assab/features/shift_module_features/shift_management/data/model/manager_shift_management_models/variance_details.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/enums/responsibility_status.dart';

part 'responsibility_details_data_model.g.dart';

@JsonSerializable()
class ResponsibilityDetailsDataModel {
  @JsonKey(name: 'shift_id')
  final String shiftId;

  @JsonKey(name: 'cashier_name')
  final String cashierName;

  @JsonKey(name: 'branch_name')
  final String branchName;

  @JsonKey(name: 'variance_amount')
  final double varianceAmount;

  @JsonKey(name: 'variance_type')
  final VarianceType varianceType;

  @JsonKey(name: 'shift_date')
  final String shiftDate;

  @JsonKey(
    name: 'responsibility_status',
    fromJson: ResponsibilityStatusX.fromJson,
    toJson: _statusToJson,
  )
  final ResponsibilityStatus responsibilityStatus;

  @JsonKey(name: 'reviewed_at')
  final String? reviewedAt;

  ResponsibilityDetailsDataModel({
    required this.shiftId,
    required this.cashierName,
    required this.branchName,
    required this.varianceAmount,
    required this.varianceType,
    required this.shiftDate,
    required this.responsibilityStatus,
    this.reviewedAt,
  });

  factory ResponsibilityDetailsDataModel.fromJson(Map<String, dynamic> json) =>
      _$ResponsibilityDetailsDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResponsibilityDetailsDataModelToJson(this);

  static String _statusToJson(ResponsibilityStatus status) => status.value;
}
