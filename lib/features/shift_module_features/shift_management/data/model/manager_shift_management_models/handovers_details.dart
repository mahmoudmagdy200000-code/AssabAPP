import 'package:json_annotation/json_annotation.dart';

import 'handover_details_models/handover_details_item_model.dart';

part 'handovers_details.g.dart';

@JsonSerializable()
class HandoversDetailsModel {
  @JsonKey(name: 'to_branch_manager')
  final List<HandoverDetailsItemModel> toBranchManager;

  const HandoversDetailsModel({required this.toBranchManager});

  factory HandoversDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$HandoversDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$HandoversDetailsModelToJson(this);
}
