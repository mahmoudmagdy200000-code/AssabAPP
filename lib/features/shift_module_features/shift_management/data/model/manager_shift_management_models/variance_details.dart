import 'package:json_annotation/json_annotation.dart';

import 'cashier_details_model.dart';
import 'other_cashier_model.dart';

part 'variance_details.g.dart';

@JsonSerializable()
class VarianceDetailsModel {
  @JsonKey(name: 'total_sales')
  final double totalSales;

  @JsonKey(name: 'handover_amount')
  final double handoverAmount;

  @JsonKey(name: 'variance_amount')
  final double varianceAmount;

  @JsonKey(name: 'variance_type')
  final VarianceType varianceType;

  @JsonKey(name: 'reason_for_variance')
  final String? reasonForVariance;

  @JsonKey(name: 'attached_files')
  final List<String> attachedFiles;

  @JsonKey(name: 'cashier_details')
  final CashierDetailsModel cashierDetails;

  @JsonKey(name: 'other_cashiers')
  final List<OtherCashierModel>? otherCashiers;

  const VarianceDetailsModel({
    required this.totalSales,
    required this.handoverAmount,
    required this.varianceAmount,
    required this.varianceType,
    this.reasonForVariance,
    required this.attachedFiles,
    required this.cashierDetails,
    required this.otherCashiers,
  });

  factory VarianceDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$VarianceDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$VarianceDetailsModelToJson(this);
}

enum VarianceType {
  @JsonValue('Over')
  over,

  @JsonValue('Short')
  short,

  @JsonValue('None')
  none,
}
