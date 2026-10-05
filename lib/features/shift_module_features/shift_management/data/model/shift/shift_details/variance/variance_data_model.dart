import 'package:json_annotation/json_annotation.dart';

import '../../../manager_shift_management_models/variance_details.dart';

part 'variance_data_model.g.dart';

@JsonSerializable()
class VarianceDataModel {
  @JsonKey(name: 'has_variance')
  final bool hasVariance;

  @JsonKey(name: 'variance')
  final VarianceModel? variance;

  @JsonKey(name: 'variance_recorded')
  final bool varianceRecorded;

  VarianceDataModel({
    required this.hasVariance,
    this.variance,
    required this.varianceRecorded,
  });

  factory VarianceDataModel.fromJson(Map<String, dynamic> json) =>
      _$VarianceDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$VarianceDataModelToJson(this);
}

@JsonSerializable()
class VarianceModel {
  @JsonKey(name: 'responsibility_type')
  final String responsibilityType;

  @JsonKey(name: 'current_cashier_amount')
  final double currentCashierAmount;

  @JsonKey(name: 'other_cashiers')
  final List<VarianceOtherCashierModel> otherCashiers;

  final String? reason;

  @JsonKey(name: 'supporting_files')
  final List<String> supportingFiles;

  @JsonKey(name: 'total_variance_amount')
  final double totalVarianceAmount;

  @JsonKey(name: 'variance_type')
  final VarianceType varianceType;

  VarianceModel({
    required this.responsibilityType,
    required this.currentCashierAmount,
    required this.otherCashiers,
    required this.reason,
    required this.supportingFiles,
    required this.totalVarianceAmount,
    required this.varianceType,
  });

  factory VarianceModel.fromJson(Map<String, dynamic> json) =>
      _$VarianceModelFromJson(json);

  Map<String, dynamic> toJson() => _$VarianceModelToJson(this);
}

@JsonSerializable()
class VarianceOtherCashierModel {
  @JsonKey(name: 'cashier_id')
  final String cashierId;

  @JsonKey(name: 'cashier_name')
  final String cashierName;

  final double amount;
  final String? notes;

  VarianceOtherCashierModel({
    required this.cashierId,
    required this.cashierName,
    required this.amount,
    this.notes,
  });

  factory VarianceOtherCashierModel.fromJson(Map<String, dynamic> json) =>
      _$VarianceOtherCashierModelFromJson(json);

  Map<String, dynamic> toJson() => _$VarianceOtherCashierModelToJson(this);
}
