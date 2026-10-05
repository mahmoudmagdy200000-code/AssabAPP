import 'package:json_annotation/json_annotation.dart';

import '../../cashier_model.dart';

part 'reassignment_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ReassignmentModel {
  @JsonKey(name: 'reassigned_from')
  final CashierModel? reassignedFrom;

  @JsonKey(name: 'reassigned_by')
  final CashierModel? reassignedBy;

  @JsonKey(name: 'reassigned_to')
  final CashierModel? reassignedTo;

  ReassignmentModel({
    required this.reassignedFrom,
    required this.reassignedBy,
    required this.reassignedTo,
  });

  factory ReassignmentModel.fromJson(Map<String, dynamic> json) =>
      _$ReassignmentModelFromJson(json);
  Map<String, dynamic> toJson() => _$ReassignmentModelToJson(this);
}
