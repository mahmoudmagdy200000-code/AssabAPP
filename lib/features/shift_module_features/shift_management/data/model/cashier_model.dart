import 'package:assab/features/shift_module_features/shift_management/data/model/working_shift_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cashier_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CashierModel {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final String? image;
  final CashierStatus? status;

  @JsonKey(name: 'store_branch_name')
  final String? branchName;

  @JsonKey(name: 'created_by_name')
  final String? createdByName;

  @JsonKey(name: 'store_branch_id')
  final String? branchId;

  @JsonKey(name: 'number_of_shifts_per_day')
  final int? shiftsCount;
  @JsonKey(name: 'status_label')
  final String? statusLabel;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'working_shifts')
  final List<WorkingShiftModel>? workingShifts;

  CashierModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.branchName,
    required this.branchId,
    required this.createdAt,
    this.createdByName,
    this.statusLabel,
    this.image,
    this.status,
    this.shiftsCount,
    this.workingShifts,
  });

  factory CashierModel.fromJson(Map<String, dynamic> json) =>
      _$CashierModelFromJson(json);

  Map<String, dynamic> toJson() => _$CashierModelToJson(this);
}

// @JsonSerializable()
// class StatusModel {
//   final CashierStatus? value;
//
//   StatusModel({this.value});
//
//   factory StatusModel.fromJson(Map<String, dynamic> json) =>
//       _$StatusModelFromJson(json);
//
//   Map<String, dynamic> toJson() => _$StatusModelToJson(this);
// }

enum CashierStatus {
  @JsonValue('active')
  active,

  @JsonValue('pending')
  pending,

  @JsonValue('deactivated')
  deactivated,
}
