import 'package:json_annotation/json_annotation.dart';

part 'cashier_details_model.g.dart';

@JsonSerializable()
class CashierDetailsModel {
  final String id;
  final String name;

  @JsonKey(name: 'variance_reason')
  final String? varianceReason;

  const CashierDetailsModel({
    required this.id,
    required this.name,
    this.varianceReason,
  });

  factory CashierDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$CashierDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$CashierDetailsModelToJson(this);
}
