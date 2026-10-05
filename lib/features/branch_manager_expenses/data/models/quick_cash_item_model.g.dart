// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quick_cash_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuickCashItemModel _$QuickCashItemModelFromJson(Map<String, dynamic> json) =>
    QuickCashItemModel(
      title: json['title'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$QuickCashItemModelToJson(QuickCashItemModel instance) =>
    <String, dynamic>{'title': instance.title, 'amount': instance.amount};
