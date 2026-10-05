import 'package:json_annotation/json_annotation.dart';

part 'branch_model.g.dart';

@JsonSerializable()
class BranchModel {
  final String id;
  final String name;

  BranchModel({required this.id, required this.name});

  factory BranchModel.fromJson(Map<String, dynamic> json) =>
      _$BranchModelFromJson(json);

  Map<String, dynamic> toJson() => _$BranchModelToJson(this);
}
