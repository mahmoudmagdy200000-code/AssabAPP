// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meta_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MetaModel _$MetaModelFromJson(Map<String, dynamic> json) => MetaModel(
  currentPage: (json['current_page'] as num).toInt(),
  lastPage: (json['last_page'] as num).toInt(),
  total: (json['total'] as num).toInt(),
);

Map<String, dynamic> _$MetaModelToJson(MetaModel instance) => <String, dynamic>{
  'current_page': instance.currentPage,
  'last_page': instance.lastPage,
  'total': instance.total,
};
