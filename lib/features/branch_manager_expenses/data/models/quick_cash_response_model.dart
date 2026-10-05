import 'package:assab/features/branch_manager_expenses/data/models/attachment_model.dart';
import 'package:assab/features/branch_manager_expenses/data/models/expense_status_model.dart';
import 'package:assab/features/branch_manager_expenses/data/models/expense_type_model.dart';
import 'package:assab/features/branch_manager_expenses/data/models/supplier_model.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../shared/models/cancel_reason/cancel_reason_in_order_response.dart';
import '../../../../shared/models/cancel_reason/cancel_reason_response.dart';
import '../../../../shared/models/time_line_response.dart';
import '../../domain/entities/quick_cash_entity.dart';
import 'expense_item_model.dart';
import 'expenses_approval_model.dart';

part 'quick_cash_response_model.g.dart';

@JsonSerializable(explicitToJson: true, createToJson: false)
class QuickCashResponseModel {
  final QuickCashDataModel? data;

  QuickCashResponseModel({this.data});

  factory QuickCashResponseModel.fromJson(Map<String, dynamic> json) =>
      _$QuickCashResponseModelFromJson(json);

  QuickCashEntity toEntity() {
    return QuickCashEntity(
      id: data?.id ?? '0',
      status: data?.status?.label ?? 'N/A',
      createdAt: data?.createdAt ?? 'N/A',
      expenseName: data?.data?.expenseName ?? 'N/A',
      expenseDate: data?.data?.expenseDate ?? 'N/A',
      expenseType:
          data?.expenseType ?? ExpenseTypeModel(value: 'N/A', label: 'N/A'),
      totalAmount: data?.totalAmount?.toString() ?? 'N/A',
      invoiceNumber: data?.data?.invoiceNumber ?? 'N/A',
      paymentMethod: data?.paymentMethod ?? 'N/A',
      paymentSupplier:
          data?.paymentSupplier ?? const SupplierModel(id: '0', name: 'N/A'),
      expenseItems: data?.data?.items ?? [],
      attachments: data?.attachments ?? [],
      timelines: data?.timelines ?? const TimeLineResponse(timelines: []),
      cancelReason: data?.cancelReason,
      approval: data?.approval,
    );
  }
}

@JsonSerializable(explicitToJson: true, createToJson: false)
class QuickCashDataModel {
  final String? id;

  final ExpenseTypeModel? expenseType;

  final ExpenseStatusModel? status;

  final double? totalAmount;

  final String? paymentMethod;

  final SupplierModel? paymentSupplier;

  final String? createdAt;

  final String? submittedAt;

  final TimeLineResponse timelines;

  final QuickCashDetailsModel? data;

  final List<AttachmentModel>? attachments;
  final CancelReasonResponse? cancelReason;
  final ExpensesApprovalModel? approval;

  QuickCashDataModel({
    this.id,
    this.expenseType,
    this.status,
    this.totalAmount,
    this.paymentMethod,
    this.paymentSupplier,
    this.createdAt,
    this.submittedAt,
    required this.timelines,
    this.data,
    this.attachments,
    this.cancelReason,
    this.approval,
  });

  factory QuickCashDataModel.fromJson(
    Map<String, dynamic> json,
  ) => QuickCashDataModel(
    id: json['id'] as String?,
    expenseType: json['expense_type'] == null
        ? null
        : ExpenseTypeModel.fromJson(
            json['expense_type'] as Map<String, dynamic>,
          ),
    status: json['status'] == null
        ? null
        : ExpenseStatusModel.fromJson(json['status'] as Map<String, dynamic>),
    totalAmount: QuickCashDataModel._toDouble(json['total_amount']),
    paymentMethod: json['payment_method'] as String?,
    paymentSupplier: json['payment_supplier'] == null
        ? null
        : SupplierModel.fromJson(
            json['payment_supplier'] as Map<String, dynamic>,
          ),
    createdAt: json['created_at'] as String?,
    submittedAt: json['submitted_at'] as String?,
    timelines: TimeLineResponse.fromJson(json),
    data: json['data'] == null
        ? null
        : QuickCashDetailsModel.fromJson(json['data'] as Map<String, dynamic>),
    attachments: (json['attachments'] as List<dynamic>?)
        ?.map((e) => AttachmentModel.fromJson(e as Map<String, dynamic>))
        .toList(),
    cancelReason: json['cancellation'] == null
        ? null
        : CancelReasonInOrderResponse.fromJson(
            json['cancellation'] as Map<String, dynamic>,
          ).toCancelReasonResponse(),
    approval: json['approval'] == null
        ? null
        : ExpensesApprovalModel.fromJson(
            json['approval'] as Map<String, dynamic>,
          ),
  );

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    return double.tryParse(value.toString());
  }
}

@JsonSerializable(explicitToJson: true, createToJson: false)
class QuickCashDetailsModel {
  @JsonKey(name: 'expense_date')
  final String? expenseDate;

  @JsonKey(name: 'expense_name')
  final String? expenseName;

  @JsonKey(name: 'invoice_number')
  final String? invoiceNumber;

  final List<ExpenseItemModel>? items;

  QuickCashDetailsModel({
    this.expenseDate,
    this.expenseName,
    this.invoiceNumber,
    this.items,
  });

  factory QuickCashDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$QuickCashDetailsModelFromJson(json);
}
