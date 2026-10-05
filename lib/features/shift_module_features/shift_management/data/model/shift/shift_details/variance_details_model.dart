import 'package:json_annotation/json_annotation.dart';

part 'variance_details_model.g.dart';

@JsonSerializable()
class VarianceDetailsModel {
  final int id;

  @JsonKey(name: 'responsible_cashier')
  final String responsibleCashier;

  final double amount;
  final String reason;

  VarianceDetailsModel({
    required this.id,
    required this.responsibleCashier,
    required this.amount,
    required this.reason,
  });

  factory VarianceDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$VarianceDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$VarianceDetailsModelToJson(this);
}
