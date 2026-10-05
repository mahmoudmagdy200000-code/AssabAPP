// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expenses_summary_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExpensesSummaryResponseModel _$ExpensesSummaryResponseModelFromJson(
  Map<String, dynamic> json,
) => ExpensesSummaryResponseModel(
  data: ExpensesSummaryDataModel.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ExpensesSummaryResponseModelToJson(
  ExpensesSummaryResponseModel instance,
) => <String, dynamic>{'data': instance.data.toJson()};

ExpensesSummaryDataModel _$ExpensesSummaryDataModelFromJson(
  Map<String, dynamic> json,
) => ExpensesSummaryDataModel(
  dateFilter: DateFilterModel.fromJson(
    json['date_filter'] as Map<String, dynamic>,
  ),
  totalExpenses: (json['total_expenses'] as num).toInt(),
  totalAmount: (json['total_amount'] as num).toDouble(),
  quickCashTotal: (json['quick_cash_total'] as num).toDouble(),
  singleInvoiceTotal: (json['single_invoice_total'] as num).toDouble(),
  groupedInvoiceTotal: (json['grouped_invoice_total'] as num).toDouble(),
  preApprovalTotal: (json['pre_approval_total'] as num).toDouble(),
);

Map<String, dynamic> _$ExpensesSummaryDataModelToJson(
  ExpensesSummaryDataModel instance,
) => <String, dynamic>{
  'date_filter': instance.dateFilter,
  'total_expenses': instance.totalExpenses,
  'total_amount': instance.totalAmount,
  'quick_cash_total': instance.quickCashTotal,
  'single_invoice_total': instance.singleInvoiceTotal,
  'grouped_invoice_total': instance.groupedInvoiceTotal,
  'pre_approval_total': instance.preApprovalTotal,
};
