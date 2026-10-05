import 'package:json_annotation/json_annotation.dart';

import '../../../../../shared/models/meta_model/meta_model.dart';
import 'manager_shift_management_models/branch_model.dart';

part 'branch_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class BranchesResponseModel {
  final bool success;
  final String message;
  final List<BranchModel> data;
  final MetaModel meta;

  BranchesResponseModel({
    required this.success,
    required this.message,
    required this.data,
    required this.meta,
  });

  factory BranchesResponseModel.fromJson(Map<String, dynamic> json) =>
      _$BranchesResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$BranchesResponseModelToJson(this);
}
