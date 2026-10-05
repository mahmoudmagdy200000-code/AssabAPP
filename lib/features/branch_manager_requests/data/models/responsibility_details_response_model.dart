import 'package:assab/features/branch_manager_requests/data/models/responsibility_details_data_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'responsibility_details_response_model.g.dart';

@JsonSerializable()
class ResponsibilityDetailsResponseModel {
  final bool success;
  final String message;
  final ResponsibilityDetailsDataModel data;

  ResponsibilityDetailsResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ResponsibilityDetailsResponseModel.fromJson(
    Map<String, dynamic> json,
  ) => _$ResponsibilityDetailsResponseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ResponsibilityDetailsResponseModelToJson(this);
}
