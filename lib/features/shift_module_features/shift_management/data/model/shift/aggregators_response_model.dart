// data/models/aggregators_response_model.dart
import 'package:json_annotation/json_annotation.dart';

import '../../../../../../shared/models/meta_model/meta_model.dart';
import 'aggregator_model.dart';

part 'aggregators_response_model.g.dart';

@JsonSerializable()
class AggregatorsResponseModel {
  final bool success;
  final String message;
  final List<AggregatorModel> data;
  final MetaModel meta;

  const AggregatorsResponseModel({
    required this.success,
    required this.message,
    required this.data,
    required this.meta,
  });

  factory AggregatorsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AggregatorsResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$AggregatorsResponseModelToJson(this);
}
