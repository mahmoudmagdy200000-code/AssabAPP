// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'date_filter_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DateFilterModel _$DateFilterModelFromJson(Map<String, dynamic> json) =>
    DateFilterModel(
      month: (json['month'] as num).toInt(),
      year: (json['year'] as num).toInt(),
    );

Map<String, dynamic> _$DateFilterModelToJson(DateFilterModel instance) =>
    <String, dynamic>{'month': instance.month, 'year': instance.year};
