import 'package:json_annotation/json_annotation.dart';

part 'sales_breakdown_model.g.dart';

@JsonSerializable()
class SalesBreakdownModel {
  final int id;
  final String aggregator;
  final double amount;

  SalesBreakdownModel({
    required this.id,
    required this.aggregator,
    required this.amount,
  });

  factory SalesBreakdownModel.fromJson(Map<String, dynamic> json) =>
      _$SalesBreakdownModelFromJson(json);

  Map<String, dynamic> toJson() => _$SalesBreakdownModelToJson(this);
}
