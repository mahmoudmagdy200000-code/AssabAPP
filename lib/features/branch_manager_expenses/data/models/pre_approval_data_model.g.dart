// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pre_approval_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PreApprovalDataModel _$PreApprovalDataModelFromJson(
  Map<String, dynamic> json,
) => PreApprovalDataModel(
  id: json['id'] as String?,
  expenseType: json['expense_type'] == null
      ? null
      : ExpenseTypeModel.fromJson(json['expense_type'] as Map<String, dynamic>),
  status: json['status'] == null
      ? null
      : ExpenseStatusModel.fromJson(json['status'] as Map<String, dynamic>),
  totalAmount: json['total_amount'] as num?,
  netAmount: json['net_amount'] as num?,
  vatAmount: json['vat_amount'] as num?,
  paymentMethod: json['payment_method'] as String?,
  paymentSupplier: json['payment_supplier'] == null
      ? null
      : SupplierModel.fromJson(
          json['payment_supplier'] as Map<String, dynamic>,
        ),
  createdAt: json['created_at'] as String?,
  submittedAt: json['submitted_at'] as String?,
  timelines: TimeLineResponse.fromJson(
    json['timelines'] as Map<String, dynamic>,
  ),
  data: json['data'] == null
      ? null
      : PreApprovalInnerDataModel.fromJson(
          json['data'] as Map<String, dynamic>,
        ),
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

PreApprovalInnerDataModel _$PreApprovalInnerDataModelFromJson(
  Map<String, dynamic> json,
) => PreApprovalInnerDataModel(
  purpose: json['purpose'] as String?,
  estimatedAmount: json['estimated_amount'] as num?,
  priority: json['priority'] == null
      ? null
      : PreApprovalPriorityModel.fromJson(
          json['priority'] as Map<String, dynamic>,
        ),
  items: (json['items'] as List<dynamic>?)
      ?.map((e) => PreApprovalItemModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  expenses: (json['expenses'] as List<dynamic>?)
      ?.map((e) => PreApprovalExpenseModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

PreApprovalPriorityModel _$PreApprovalPriorityModelFromJson(
  Map<String, dynamic> json,
) => PreApprovalPriorityModel(
  value: json['value'] as String?,
  label: json['label'] as String?,
);

PreApprovalItemModel _$PreApprovalItemModelFromJson(
  Map<String, dynamic> json,
) => PreApprovalItemModel(
  id: json['id'] as String?,
  categoryId: json['category_id'] as String?,
  category: json['category'] as String?,
  description: json['description'] as String?,
  quantity: (json['quantity'] as num?)?.toInt(),
  rate: json['rate'] as num?,
  total: json['total'] as num?,
);

PreApprovalExpenseModel _$PreApprovalExpenseModelFromJson(
  Map<String, dynamic> json,
) => PreApprovalExpenseModel(
  id: json['id'] as String?,
  categoryId: json['category_id'] as String?,
  category: json['category'] as String?,
  description: json['description'] as String?,
  price: json['price'] as num?,
);
