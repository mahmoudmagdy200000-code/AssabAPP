// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'handover_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HandoversSummary _$HandoversSummaryFromJson(Map<String, dynamic> json) =>
    HandoversSummary(
      totalHandovers: (json['total_handovers'] as num).toInt(),
      approved: (json['approved'] as num).toInt(),
      pending: (json['pending'] as num).toInt(),
      rejected: (json['rejected'] as num).toInt(),
      totalAmount: json['total_amount'] as num,
    );

Map<String, dynamic> _$HandoversSummaryToJson(HandoversSummary instance) =>
    <String, dynamic>{
      'total_handovers': instance.totalHandovers,
      'approved': instance.approved,
      'pending': instance.pending,
      'rejected': instance.rejected,
      'total_amount': instance.totalAmount,
    };
