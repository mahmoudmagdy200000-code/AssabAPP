import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entity/enums/date_filter_options.dart';

part 'cashiers_filter_attributes_model.g.dart';

@JsonSerializable(includeIfNull: false)
class CashiersFilterAttributesModel {
  final String? status;
  final String? search;
  @JsonKey(name: 'date_filter')
  final DateFilterOptions? dateFilter;

  CashiersFilterAttributesModel({this.status, this.search, this.dateFilter});

  Map<String, dynamic> toJson() => _$CashiersFilterAttributesModelToJson(this);
}
