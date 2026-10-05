import 'package:assab/features/shift_module_features/shift_management/data/model/shift/shift_details/variance/variance_data_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'variance_details_response_model.g.dart';

@JsonSerializable()
class VarianceResponseModel {
  final bool success;
  final String message;
  final VarianceDataModel data;

  VarianceResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory VarianceResponseModel.fromJson(Map<String, dynamic> json) =>
      _$VarianceResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$VarianceResponseModelToJson(this);
}
