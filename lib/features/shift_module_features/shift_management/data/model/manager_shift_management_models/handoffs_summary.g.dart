// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'handoffs_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HandoffsSummary _$HandoffsSummaryFromJson(Map<String, dynamic> json) =>
    HandoffsSummary(
      totalHandovers: (json['total_handovers'] as num).toInt(),
      approved: (json['approved'] as num).toInt(),
      pending: (json['pending'] as num).toInt(),
      rejected: (json['rejected'] as num).toInt(),
      rejectedFinal: (json['rejected_final'] as num).toInt(),
      totalAmount: json['total_amount'] as num,
      totalVariance: json['total_variance'] as num,
      allReceived: json['all_received'] as bool,
    );

Map<String, dynamic> _$HandoffsSummaryToJson(HandoffsSummary instance) =>
    <String, dynamic>{
      'total_handovers': instance.totalHandovers,
      'approved': instance.approved,
      'pending': instance.pending,
      'rejected': instance.rejected,
      'rejected_final': instance.rejectedFinal,
      'total_amount': instance.totalAmount,
      'total_variance': instance.totalVariance,
      'all_received': instance.allReceived,
    };
