import 'package:assab/features/branch_manager_expenses/data/models/supplier_model.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../shared/models/cancel_reason/cancel_reason_in_order_response.dart';
import '../../../../shared/models/cancel_reason/cancel_reason_response.dart';
import '../../../../shared/models/time_line_response.dart';
import 'attachment_model.dart';
import 'expense_status_model.dart';
import 'expense_type_model.dart';
import 'expenses_approval_model.dart';

part 'pre_approval_data_model.g.dart';

@JsonSerializable(explicitToJson: true, createToJson: false)
class PreApprovalDataModel {
  final String? id;

  @JsonKey(name: 'expense_type')
  final ExpenseTypeModel? expenseType;

  final ExpenseStatusModel? status;

  @JsonKey(name: 'total_amount')
  final num? totalAmount;

  @JsonKey(name: 'net_amount')
  final num? netAmount;

  @JsonKey(name: 'vat_amount')
  final num? vatAmount;

  @JsonKey(name: 'payment_method')
  final String? paymentMethod;

  @JsonKey(name: 'payment_supplier')
  final SupplierModel? paymentSupplier;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'submitted_at')
  final String? submittedAt;

  @JsonKey(fromJson: TimeLineResponse.fromJson)
  final TimeLineResponse timelines;

  final PreApprovalInnerDataModel? data;

  final List<AttachmentModel>? attachments;
  final CancelReasonResponse? cancelReason;
  final ExpensesApprovalModel? approval;

  PreApprovalDataModel({
    this.id,
    this.expenseType,
    this.status,
    this.totalAmount,
    this.netAmount,
    this.vatAmount,
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

  factory PreApprovalDataModel.fromJson(Map<String, dynamic> json) =>
      PreApprovalDataModel(
        id: json['id'] as String?,
        expenseType: json['expense_type'] == null
            ? null
            : ExpenseTypeModel.fromJson(
                json['expense_type'] as Map<String, dynamic>,
              ),
        status: json['status'] == null
            ? null
            : ExpenseStatusModel.fromJson(
                json['status'] as Map<String, dynamic>,
              ),
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
        timelines: TimeLineResponse.fromJson(json),
        data: json['data'] == null
            ? null
            : PreApprovalInnerDataModel.fromJson(
                json['data'] as Map<String, dynamic>,
              ),
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
}

@JsonSerializable(explicitToJson: true, createToJson: false)
class PreApprovalInnerDataModel {
  final String? purpose;

  @JsonKey(name: 'estimated_amount')
  final num? estimatedAmount;

  final PreApprovalPriorityModel? priority;
  final List<PreApprovalItemModel>? items;
  final List<PreApprovalExpenseModel>? expenses;

  PreApprovalInnerDataModel({
    this.purpose,
    this.estimatedAmount,
    this.priority,
    this.items,
    this.expenses,
  });

  factory PreApprovalInnerDataModel.fromJson(Map<String, dynamic> json) =>
      _$PreApprovalInnerDataModelFromJson(json);
}

@JsonSerializable(createToJson: false)
class PreApprovalPriorityModel {
  final String? value;
  final String? label;

  PreApprovalPriorityModel({this.value, this.label});

  factory PreApprovalPriorityModel.fromJson(Map<String, dynamic> json) =>
      _$PreApprovalPriorityModelFromJson(json);
}

@JsonSerializable(createToJson: false)
class PreApprovalItemModel {
  final String? id;
  @JsonKey(name: 'category_id')
  final String? categoryId;
  final String? category;
  final String? description;
  final int? quantity;
  final num? rate;
  final num? total;

  PreApprovalItemModel({
    this.id,
    this.categoryId,
    this.category,
    this.description,
    this.quantity,
    this.rate,
    this.total,
  });

  factory PreApprovalItemModel.fromJson(Map<String, dynamic> json) =>
      _$PreApprovalItemModelFromJson(json);
}

@JsonSerializable(createToJson: false)
class PreApprovalExpenseModel {
  final String? id;
  @JsonKey(name: 'category_id')
  final String? categoryId;
  final String? category;
  final String? description;
  final num? price;

  PreApprovalExpenseModel({
    this.id,
    this.categoryId,
    this.category,
    this.description,
    this.price,
  });

  factory PreApprovalExpenseModel.fromJson(Map<String, dynamic> json) =>
      _$PreApprovalExpenseModelFromJson(json);
}
