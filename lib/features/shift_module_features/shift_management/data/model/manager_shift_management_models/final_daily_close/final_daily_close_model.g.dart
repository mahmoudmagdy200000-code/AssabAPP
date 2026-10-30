// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'final_daily_close_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FinalDailyCloseResponse _$FinalDailyCloseResponseFromJson(
  Map<String, dynamic> json,
) => FinalDailyCloseResponse(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: FinalDailyCloseData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$FinalDailyCloseResponseToJson(
  FinalDailyCloseResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data.toJson(),
};

FinalDailyCloseData _$FinalDailyCloseDataFromJson(Map<String, dynamic> json) =>
    FinalDailyCloseData(
      managerWorkdayId: json['manager_workday_id'] as String?,
      businessDate: json['business_date'] as String?,
      serverTime: json['server_time'] as String?,
      timezone: json['timezone'] as String?,
      workdayDates:
          (json['workday_dates'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
      cashierBreakdown: (json['cashier_breakdown'] as List<dynamic>)
          .map((e) => CashierBreakdownModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totals: Totals.fromJson(json['totals'] as Map<String, dynamic>),
      aggregators: (json['aggregators'] as List<dynamic>?)
          ?.map(
            (e) => AggregatorFinalDailyCloseModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
    );

Map<String, dynamic> _$FinalDailyCloseDataToJson(
  FinalDailyCloseData instance,
) => <String, dynamic>{
  'manager_workday_id': instance.managerWorkdayId,
  'business_date': instance.businessDate,
  'server_time': instance.serverTime,
  'timezone': instance.timezone,
  'workday_dates': instance.workdayDates,
  'cashier_breakdown': instance.cashierBreakdown
      .map((e) => e.toJson())
      .toList(),
  'totals': instance.totals.toJson(),
  'aggregators': instance.aggregators?.map((e) => e.toJson()).toList(),
};

AggregatorFinalDailyCloseModel _$AggregatorFinalDailyCloseModelFromJson(
  Map<String, dynamic> json,
) => AggregatorFinalDailyCloseModel(
  id: json['id'] as String,
  name: json['name'] as String,
  logo: json['logo'] as String?,
  total: (json['total'] as num).toDouble(),
  cashierBreakdown: (json['cashier_breakdown'] as List<dynamic>?)
      ?.map(
        (e) => CashierBreakdownFinalDailyCloseModel.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
);

Map<String, dynamic> _$AggregatorFinalDailyCloseModelToJson(
  AggregatorFinalDailyCloseModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'logo': instance.logo,
  'total': instance.total,
  'cashier_breakdown': instance.cashierBreakdown
      ?.map((e) => e.toJson())
      .toList(),
};

CashierBreakdownFinalDailyCloseModel
_$CashierBreakdownFinalDailyCloseModelFromJson(Map<String, dynamic> json) =>
    CashierBreakdownFinalDailyCloseModel(
      cashierShiftId: json['cashier_shift_id'] as String?,
      notes: json['notes'] as String?,
      present: json['present'] as bool? ?? true,
      cashierId: json['cashier_id'] as String,
      cashierName: json['cashier_name'] as String,
      amount: (json['amount'] as num).toDouble(),
    );

Map<String, dynamic> _$CashierBreakdownFinalDailyCloseModelToJson(
  CashierBreakdownFinalDailyCloseModel instance,
) => <String, dynamic>{
  'cashier_shift_id': instance.cashierShiftId,
  'notes': instance.notes,
  'present': instance.present,
  'cashier_id': instance.cashierId,
  'cashier_name': instance.cashierName,
  'amount': instance.amount,
};

Totals _$TotalsFromJson(Map<String, dynamic> json) => Totals(
  totalCashCollected: (json['totalCashCollected'] as num?)?.toDouble(),
  totalCardPayments: (json['totalCardPayments'] as num?)?.toDouble(),
  totalDeliveryApps: (json['totalDeliveryApps'] as num?)?.toDouble(),
  totalVariance: (json['totalVariance'] as num?)?.toDouble(),
  totalSales: (json['totalSales'] as num?)?.toDouble(),
);

Map<String, dynamic> _$TotalsToJson(Totals instance) => <String, dynamic>{
  'totalCashCollected': instance.totalCashCollected,
  'totalCardPayments': instance.totalCardPayments,
  'totalDeliveryApps': instance.totalDeliveryApps,
  'totalVariance': instance.totalVariance,
  'totalSales': instance.totalSales,
};
