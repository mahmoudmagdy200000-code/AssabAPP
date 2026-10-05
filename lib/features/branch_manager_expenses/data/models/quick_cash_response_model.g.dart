// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quick_cash_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuickCashResponseModel _$QuickCashResponseModelFromJson(
  Map<String, dynamic> json,
) => QuickCashResponseModel(
  data: json['data'] == null
      ? null
      : QuickCashDataModel.fromJson(json['data'] as Map<String, dynamic>),
);

QuickCashDataModel _$QuickCashDataModelFromJson(
  Map<String, dynamic> json,
) => QuickCashDataModel(
  id: json['id'] as String?,
  expenseType: json['expenseType'] == null
      ? null
      : ExpenseTypeModel.fromJson(json['expenseType'] as Map<String, dynamic>),
  status: json['status'] == null
      ? null
      : ExpenseStatusModel.fromJson(json['status'] as Map<String, dynamic>),
  totalAmount: (json['totalAmount'] as num?)?.toDouble(),
  paymentMethod: json['paymentMethod'] as String?,
  paymentSupplier: json['paymentSupplier'] == null
      ? null
      : SupplierModel.fromJson(json['paymentSupplier'] as Map<String, dynamic>),
  createdAt: json['createdAt'] as String?,
  submittedAt: json['submittedAt'] as String?,
  timelines: TimeLineResponse.fromJson(
    json['timelines'] as Map<String, dynamic>,
  ),
  data: json['data'] == null
      ? null
      : QuickCashDetailsModel.fromJson(json['data'] as Map<String, dynamic>),
  attachments: (json['attachments'] as List<dynamic>?)
      ?.map((e) => AttachmentModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  cancelReason: json['cancelReason'] == null
      ? null
      : CancelReasonResponse.fromJson(
          json['cancelReason'] as Map<String, dynamic>,
        ),
  approval: json['approval'] == null
      ? null
      : ExpensesApprovalModel.fromJson(
          json['approval'] as Map<String, dynamic>,
        ),
);

QuickCashDetailsModel _$QuickCashDetailsModelFromJson(
  Map<String, dynamic> json,
) => QuickCashDetailsModel(
  expenseDate: json['expense_date'] as String?,
  expenseName: json['expense_name'] as String?,
  invoiceNumber: json['invoice_number'] as String?,
  items: (json['items'] as List<dynamic>?)
      ?.map((e) => ExpenseItemModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);
