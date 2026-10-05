import 'package:json_annotation/json_annotation.dart';

import '../../../../../shared/models/meta_model/meta_model.dart';
import 'cashier_model.dart';

part 'cashiers_response_model.g.dart';

@JsonSerializable()
class CashiersResponseModel {
  final bool success;
  final String message;
  final List<CashierModel> data;
  final MetaModel meta;
  CashiersResponseModel({
    required this.success,
    required this.message,
    required this.data,
    required this.meta,
  });

  factory CashiersResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CashiersResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$CashiersResponseModelToJson(this);
}
