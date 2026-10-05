// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginationModel _$PaginationModelFromJson(Map<String, dynamic> json) =>
    PaginationModel(
      page: (json['page'] as num?)?.toInt(),
      perPage: (json['perPage'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PaginationModelToJson(PaginationModel instance) =>
    <String, dynamic>{'page': ?instance.page, 'perPage': ?instance.perPage};
