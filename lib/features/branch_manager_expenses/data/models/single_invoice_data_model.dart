import 'package:assab/features/branch_manager_expenses/data/models/supplier_model.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../shared/models/cancel_reason/cancel_reason_in_order_response.dart';
import '../../../../shared/models/cancel_reason/cancel_reason_response.dart';
import '../../../../shared/models/time_line_response.dart';
import '../../domain/entities/single_invoice_entity.dart';
import 'attachment_model.dart';
import 'expense_status_model.dart';
import 'expense_type_model.dart';
import 'expenses_approval_model.dart';

part 'single_invoice_data_model.g.dart';

@JsonSerializable(explicitToJson: true, createToJson: false)
class SingleInvoiceDataModel {
  final String? id;

  @JsonKey(name: 'expense_type')
  final ExpenseTypeModel? expenseType;

  final ExpenseStatusModel? status;

  @JsonKey(name: 'total_amount')
  final double? totalAmount;

  @JsonKey(name: 'net_amount')
  final double? netAmount;

  @JsonKey(name: 'vat_amount')
  final double? vatAmount;

  @JsonKey(name: 'payment_method')
  final String? paymentMethod;

  final SupplierModel? supplier;

  @JsonKey(name: 'payment_supplier')
  final SupplierModel? paymentSupplier;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'submitted_at')
  final String? submittedAt;

  @JsonKey(fromJson: TimeLineResponse.fromJson)
  final TimeLineResponse timelines;

  @JsonKey(name: 'data')
  final SingleInvoiceModel? singleInvoice;

  final List<AttachmentModel>? attachments;
  final CancelReasonResponse? cancelReason;
  final ExpensesApprovalModel? approval;

  SingleInvoiceDataModel({
    this.id,
    this.expenseType,
    this.status,
    this.totalAmount,
    this.netAmount,
    this.vatAmount,
    this.paymentMethod,
    this.paymentSupplier,
    this.supplier,
    this.createdAt,
    this.submittedAt,
    required this.timelines,
    this.singleInvoice,
    this.attachments,
    this.cancelReason,
    this.approval,
  });

  factory SingleInvoiceDataModel.fromJson(Map<String, dynamic> json) =>
      SingleInvoiceDataModel(
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
        totalAmount: (json['total_amount'] as num?)?.toDouble(),
        netAmount: (json['net_amount'] as num?)?.toDouble(),
        vatAmount: (json['vat_amount'] as num?)?.toDouble(),
        paymentMethod: json['payment_method'] as String?,
        paymentSupplier: json['payment_supplier'] == null
            ? null
            : SupplierModel.fromJson(
                json['payment_supplier'] as Map<String, dynamic>,
              ),
        supplier: json['supplier'] == null
            ? null
            : SupplierModel.fromJson(json['supplier'] as Map<String, dynamic>),
        createdAt: json['created_at'] as String?,
        submittedAt: json['submitted_at'] as String?,
        timelines: TimeLineResponse.fromJson(json),
        singleInvoice: json['data'] == null
            ? null
            : SingleInvoiceModel.fromJson(json['data'] as Map<String, dynamic>),
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

  SingleInvoiceEntity toEntity() {
    return SingleInvoiceEntity(
      id: id ?? '0',
      status: status?.label ?? 'N/A',
      createdAt: createdAt ?? 'N/A',
      expenseName: singleInvoice?.invoiceNumber ?? 'N/A',
      expenseType: expenseType ?? ExpenseTypeModel(value: 'N/A', label: 'N/A'),
      totalAmount: totalAmount?.toString() ?? 'N/A',
      invoiceNumber: singleInvoice?.invoiceNumber ?? 'N/A',
      netAmount: netAmount?.toString() ?? 'N/A',
      vatAmount: vatAmount?.toString() ?? 'N/A',
      paymentMethod: paymentMethod ?? 'N/A',
      taxId: singleInvoice?.taxId ?? 'N/A',
      supplierName: supplier?.name ?? 'N/A',
      supplierId: supplier?.id ?? 'N/A',
      totalAmountPaid: singleInvoice?.paidAmount?.toString() ?? 'N/A',
      issueDate: singleInvoice?.issueDate ?? 'N/A',
      isTaxInvoice: singleInvoice?.isTaxInvoice ?? false,
      items: singleInvoice?.items ?? [],
      expenses: singleInvoice?.expenses ?? [],
      totalInvoiceItems: singleInvoice?.items?.length.toString() ?? 'N/A',
      attachments: attachments ?? [],
      paymentType: singleInvoice?.paymentType ?? 'N/A',
      dueDate: singleInvoice?.dueDate ?? 'N/A',
      paymentSupplierId: paymentSupplier?.id ?? 'N/A',
      paymentSupplier: paymentSupplier,
      taxSupplierName: singleInvoice?.taxInvoiceDetails?.supplierName ?? 'N/A',
      timelines: timelines,
      cancelReason: cancelReason,
      approval: approval,
    );
  }
}

@JsonSerializable(explicitToJson: true, createToJson: false)
class SingleInvoiceModel {
  @JsonKey(name: 'invoice_number')
  final String? invoiceNumber;

  @JsonKey(name: 'issue_date')
  final String? issueDate;

  @JsonKey(name: 'is_tax_invoice')
  final bool? isTaxInvoice;

  @JsonKey(name: 'tax_id')
  final String? taxId;

  @JsonKey(name: 'payment_type')
  final String? paymentType;

  @JsonKey(name: 'paid_amount')
  final double? paidAmount;

  @JsonKey(name: 'due_date')
  final String? dueDate;

  final List<SingleInvoiceItemModel>? items;
  final List<SingleInvoiceExpenseModel>? expenses;

  @JsonKey(name: 'tax_invoice_details')
  final SingleInvoiceTaxDetailsModel? taxInvoiceDetails;

  SingleInvoiceModel({
    this.invoiceNumber,
    this.issueDate,
    this.isTaxInvoice,
    this.taxId,
    this.paymentType,
    this.paidAmount,
    this.dueDate,
    this.items,
    this.expenses,
    this.taxInvoiceDetails,
  });

  factory SingleInvoiceModel.fromJson(Map<String, dynamic> json) =>
      _$SingleInvoiceModelFromJson(json);
}

@JsonSerializable(createToJson: false)
class SingleInvoiceItemModel {
  final String? id;
  @JsonKey(name: 'category_id')
  final String? categoryId;
  final String? category;
  final String? name;
  final int? quantity;

  @JsonKey(name: 'unit_price')
  final double? unitPrice;

  @JsonKey(name: 'total_amount')
  final double? totalAmount;

  SingleInvoiceItemModel({
    this.id,
    this.category,
    this.name,
    this.quantity,
    this.categoryId,
    this.unitPrice,
    this.totalAmount,
  });

  factory SingleInvoiceItemModel.fromJson(Map<String, dynamic> json) =>
      _$SingleInvoiceItemModelFromJson(json);
}

@JsonSerializable(createToJson: false)
class SingleInvoiceExpenseModel {
  final String? id;
  @JsonKey(name: 'category_id')
  final String? categoryId;
  final String? category;
  final String? name;
  final double? price;

  SingleInvoiceExpenseModel({
    this.id,
    this.category,
    this.name,
    this.categoryId,
    this.price,
  });

  factory SingleInvoiceExpenseModel.fromJson(Map<String, dynamic> json) =>
      _$SingleInvoiceExpenseModelFromJson(json);
}

@JsonSerializable(createToJson: false)
class SingleInvoiceTaxDetailsModel {
  @JsonKey(name: 'supplier_name')
  final String? supplierName;

  @JsonKey(name: 'net_amount')
  final double? netAmount;

  @JsonKey(name: 'vat_amount')
  final double? vatAmount;

  @JsonKey(name: 'total_amount')
  final double? totalAmount;

  SingleInvoiceTaxDetailsModel({
    this.supplierName,
    this.netAmount,
    this.vatAmount,
    this.totalAmount,
  });

  factory SingleInvoiceTaxDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$SingleInvoiceTaxDetailsModelFromJson(json);
}
