import 'package:json_annotation/json_annotation.dart';

part 'branch_manager_model.g.dart';

@JsonSerializable()
class BranchManagerModel {
  final String id;
  final String name;

  BranchManagerModel({required this.id, required this.name});

  factory BranchManagerModel.fromJson(Map<String, dynamic> json) =>
      _$BranchManagerModelFromJson(json);

  Map<String, dynamic> toJson() => _$BranchManagerModelToJson(this);
}
