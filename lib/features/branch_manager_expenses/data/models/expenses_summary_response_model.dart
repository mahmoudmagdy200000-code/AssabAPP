import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/expenses_summary_entity.dart';
import 'date_filter_model.dart';

part 'expenses_summary_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ExpensesSummaryResponseModel {
  final ExpensesSummaryDataModel data;

  ExpensesSummaryResponseModel({required this.data});

  factory ExpensesSummaryResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ExpensesSummaryResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExpensesSummaryResponseModelToJson(this);
}

@JsonSerializable()
class ExpensesSummaryDataModel {
  @JsonKey(name: 'date_filter')
  final DateFilterModel dateFilter;

  @JsonKey(name: 'total_expenses')
  final int totalExpenses;

  @JsonKey(name: 'total_amount')
  final double totalAmount;

  @JsonKey(name: 'quick_cash_total')
  final double quickCashTotal;

  @JsonKey(name: 'single_invoice_total')
  final double singleInvoiceTotal;

  @JsonKey(name: 'grouped_invoice_total')
  final double groupedInvoiceTotal;

  @JsonKey(name: 'pre_approval_total')
  final double preApprovalTotal;

  ExpensesSummaryDataModel({
    required this.dateFilter,
    required this.totalExpenses,
    required this.totalAmount,
    required this.quickCashTotal,
    required this.singleInvoiceTotal,
    required this.groupedInvoiceTotal,
    required this.preApprovalTotal,
  });

  factory ExpensesSummaryDataModel.fromJson(Map<String, dynamic> json) =>
      _$ExpensesSummaryDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExpensesSummaryDataModelToJson(this);

  ExpensesSummaryEntity toEntity() {
    return ExpensesSummaryEntity(
      totalExpenses: totalExpenses,
      totalAmount: totalAmount,
      quickCashTotal: quickCashTotal,
      singleInvoiceTotal: singleInvoiceTotal,
      groupedInvoiceTotal: groupedInvoiceTotal,
      preApprovalTotal: preApprovalTotal,
    );
  }
}
