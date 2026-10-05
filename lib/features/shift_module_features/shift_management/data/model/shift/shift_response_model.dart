import 'package:json_annotation/json_annotation.dart';

import '../../../../../../shared/models/meta_model/meta_model.dart';
import 'shift_model.dart';

part 'shift_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ShiftResponseModel {
  final bool success;
  final String message;
  final List<ShiftModel> data;
  final MetaModel meta;

  ShiftResponseModel({
    required this.success,
    required this.message,
    required this.data,
    required this.meta,
  });

  factory ShiftResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ShiftResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShiftResponseModelToJson(this);
}
