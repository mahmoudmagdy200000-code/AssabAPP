// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cashiers_filter_attributes_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CashiersFilterAttributesModel _$CashiersFilterAttributesModelFromJson(
  Map<String, dynamic> json,
) => CashiersFilterAttributesModel(
  status: json['status'] as String?,
  search: json['search'] as String?,
  dateFilter: $enumDecodeNullable(
    _$DateFilterOptionsEnumMap,
    json['date_filter'],
  ),
);

Map<String, dynamic> _$CashiersFilterAttributesModelToJson(
  CashiersFilterAttributesModel instance,
) => <String, dynamic>{
  'status': ?instance.status,
  'search': ?instance.search,
  'date_filter': ?_$DateFilterOptionsEnumMap[instance.dateFilter],
};

const _$DateFilterOptionsEnumMap = {
  DateFilterOptions.last_24_hours: 'last_24_hours',
  DateFilterOptions.last_7_days: 'last_7_days',
  DateFilterOptions.last_14_days: 'last_14_days',
  DateFilterOptions.last_30_days: 'last_30_days',
  DateFilterOptions.last_1_year: 'last_1_year',
};
