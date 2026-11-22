// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pre_approval_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
