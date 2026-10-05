import 'package:json_annotation/json_annotation.dart';

import '../../../../shared/models/meta_model/meta_model.dart';
import 'pre_approval_data_model.dart';

part 'pre_approval_previous_response.g.dart';

@JsonSerializable(createToJson: false)
class PreApprovalPreviousResponse {
  final List<PreApprovalDataModel> data;
  final MetaModel meta;

  PreApprovalPreviousResponse({required this.data, required this.meta});

  factory PreApprovalPreviousResponse.fromJson(Map<String, dynamic> json) =>
      _$PreApprovalPreviousResponseFromJson(json);
}
