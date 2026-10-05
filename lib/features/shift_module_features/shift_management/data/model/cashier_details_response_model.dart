import 'package:json_annotation/json_annotation.dart';

import 'cashier_model.dart';

part 'cashier_details_response_model.g.dart';

@JsonSerializable()
class CashierResponseModel {
  final bool success;
  final String message;
  final CashierData data;

  CashierResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CashierResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CashierResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$CashierResponseModelToJson(this);
}

@JsonSerializable()
class CashierData {
  final CashierModel cashier;

  CashierData({required this.cashier});

  factory CashierData.fromJson(Map<String, dynamic> json) =>
      _$CashierDataFromJson(json);

  Map<String, dynamic> toJson() => _$CashierDataToJson(this);
}
