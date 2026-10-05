import 'package:json_annotation/json_annotation.dart';

part 'quick_cash_item_model.g.dart';

@JsonSerializable()
class QuickCashItemModel {
  final String? title;
  final double? amount;

  QuickCashItemModel({this.title, this.amount});

  factory QuickCashItemModel.fromJson(Map<String, dynamic> json) =>
      _$QuickCashItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$QuickCashItemModelToJson(this);
}
