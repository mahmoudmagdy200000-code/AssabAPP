import 'package:assab/features/branch_manager_expenses/data/models/attachment_model.dart';
import 'package:assab/features/branch_manager_expenses/data/models/supplier_model.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../shared/models/cancel_reason/cancel_reason_in_order_response.dart';
import '../../../../shared/models/cancel_reason/cancel_reason_response.dart';
import '../../../../shared/models/time_line_response.dart';
import '../../domain/entities/grouped_invoice_entity.dart';
import 'expense_status_model.dart';
import 'expense_type_model.dart';
import 'expenses_approval_model.dart';

part 'grouped_invoice_response_model.g.dart';

@JsonSerializable(createToJson: false, explicitToJson: true)
class GroupedInvoiceResponseModel {
  final GroupedInvoiceDataModel? data;

  const GroupedInvoiceResponseModel({this.data});

  factory GroupedInvoiceResponseModel.fromJson(Map<String, dynamic> json) =>
      _$GroupedInvoiceResponseModelFromJson(json);

  GroupedInvoiceEntity toEntity() {
    return GroupedInvoiceEntity(
      id: data?.id ?? '0',
      defaultSupplier: SupplierModel(
        id: data?.data?.defaultSupplierId ?? '0',
        name: data?.data?.defaultSupplierName ?? 'N/A',
      ),
      totalGroupedInvoice: data?.data?.totalInvoices.toString() ?? 'N/A',
      paymentMethod: data?.paymentMethod ?? 'N/A',
      status: data?.status?.value ?? 'N/A',
      expenseType:
          data?.expenseType ?? ExpenseTypeModel(value: 'N/A', label: 'N/A'),
      paymentSupplier:
          data?.paymentSupplier ?? const SupplierModel(id: '0', name: 'N/A'),
      paymentType: data?.data?.paymentType ?? 'N/A',
      dueDate: data?.data?.dueDate ?? 'N/A',
      paidAmount: data?.data?.paidAmount?.toString() ?? 'N/A',
      invoices:
          data?.data?.invoices?.map((invoice) => invoice.toEntity()).toList() ??
          [],
      timelines: data?.timelines ?? const TimeLineResponse(timelines: []),
      cancelReason: data?.cancelReason,
      approval: data?.approval,
    );
  }
}

@JsonSerializable(createToJson: false, explicitToJson: true)
class GroupedInvoiceDataModel {
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
  final GroupedInvoiceInnerDataModel? data;
  final TimeLineResponse timelines;
  final CancelReasonResponse? cancelReason;
  final ExpensesApprovalModel? approval;

  const GroupedInvoiceDataModel({
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
    this.data,
    required this.timelines,
    this.cancelReason,
    this.approval,
  });

  factory GroupedInvoiceDataModel.fromJson(
    Map<String, dynamic> json,
  ) => GroupedInvoiceDataModel(
    id: json['id'] as String?,
    expenseType: json['expense_type'] == null
        ? null
        : ExpenseTypeModel.fromJson(
            json['expense_type'] as Map<String, dynamic>,
          ),
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
    data: json['data'] == null
        ? null
        : GroupedInvoiceInnerDataModel.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    timelines: TimeLineResponse.fromJson(json as Map<String, dynamic>? ?? {}),
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

@JsonSerializable(createToJson: false, explicitToJson: true)
class GroupedInvoiceInnerDataModel {
  @JsonKey(name: 'default_supplier_id')
  final String? defaultSupplierId;
  @JsonKey(name: 'default_supplier_name')
  final String? defaultSupplierName;
  @JsonKey(name: 'number_of_suppliers')
  final int? numberOfSuppliers;
  @JsonKey(name: 'supplier_names')
  final List<String>? supplierNames;
  @JsonKey(name: 'payment_type')
  final String? paymentType;
  @JsonKey(name: 'paid_amount')
  final num? paidAmount;
  @JsonKey(name: 'due_date')
  final String? dueDate;
  @JsonKey(name: 'total_invoices')
  final int? totalInvoices;
  final List<GroupedInvoiceModel>? invoices;

  const GroupedInvoiceInnerDataModel({
    this.defaultSupplierId,
    this.defaultSupplierName,
    this.numberOfSuppliers,
    this.supplierNames,
    this.paymentType,
    this.paidAmount,
    this.dueDate,
    this.totalInvoices,
    this.invoices,
  });

  factory GroupedInvoiceInnerDataModel.fromJson(Map<String, dynamic> json) =>
      _$GroupedInvoiceInnerDataModelFromJson(json);
}

@JsonSerializable(createToJson: false, explicitToJson: true)
class GroupedInvoiceModel {
  final String? id;
  final SupplierModel? supplier;
  @JsonKey(name: 'invoice_number')
  final String? invoiceNumber;
  @JsonKey(name: 'issue_date')
  final String? issueDate;
  @JsonKey(name: 'is_tax_invoice')
  final bool? isTaxInvoice;
  @JsonKey(name: 'tax_id')
  final String? taxId;
  @JsonKey(name: 'net_amount')
  final num? netAmount;
  @JsonKey(name: 'vat_amount')
  final num? vatAmount;
  @JsonKey(name: 'total_amount')
  final num? totalAmount;
  @JsonKey(name: 'items_count')
  final int? itemsCount;
  @JsonKey(name: 'expenses_count')
  final int? expensesCount;
  final List<GroupedInvoiceItemResponsetModel>? items;
  final List<dynamic>? expenses;
  final List<AttachmentModel>? receipts;

  const GroupedInvoiceModel({
    this.id,
    this.supplier,
    this.invoiceNumber,
    this.issueDate,
    this.isTaxInvoice,
    this.taxId,
    this.netAmount,
    this.vatAmount,
    this.totalAmount,
    this.itemsCount,
    this.expensesCount,
    this.items,
    this.expenses,
    this.receipts,
  });

  factory GroupedInvoiceModel.fromJson(Map<String, dynamic> json) =>
      _$GroupedInvoiceModelFromJson(json);

  GroupedInvoiceInvoiceEntity toEntity() {
    return GroupedInvoiceInvoiceEntity(
      id: id ?? '',
      supplier: supplier ?? const SupplierModel(id: 'N/A', name: 'N/A'),
      invoiceNumber: invoiceNumber ?? 'N/A',
      issuedDate: issueDate ?? 'N/A',
      tax: GroupedInvoiceTaxEntity(
        supplierName: supplier?.name ?? 'N/A',
        taxId: taxId ?? 'N/A',
        netAmount: netAmount?.toString() ?? 'N/A',
        vatAmount: vatAmount?.toString() ?? 'N/A',
        totalIncVat: totalAmount?.toString() ?? 'N/A',
      ),
      attachments: receipts ?? [],
      purchases:
          items
              ?.map(
                (item) => GroupedInvoicePurchasesEntity(
                  categoryId: item.categoryId,
                  name: item.name ?? 'N/A',
                  quantity: item.quantity?.toString() ?? 'N/A',
                  unitPrice: item.unitPrice?.toString() ?? 'N/A',
                  totalAmount: item.totalAmount?.toString() ?? 'N/A',
                ),
              )
              .toList() ??
          [],
    );
  }
}

@JsonSerializable(createToJson: false)
class GroupedInvoiceItemResponsetModel {
  final String? id;
  final String? category;
  @JsonKey(name: 'category_id')
  final String categoryId;
  final String? name;
  final int? quantity;
  @JsonKey(name: 'unit_price')
  final num? unitPrice;
  @JsonKey(name: 'total_amount')
  final num? totalAmount;

  const GroupedInvoiceItemResponsetModel({
    this.id,
    this.category,
    required this.categoryId,
    this.name,
    this.quantity,
    this.unitPrice,
    this.totalAmount,
  });

  factory GroupedInvoiceItemResponsetModel.fromJson(
    Map<String, dynamic> json,
  ) => _$GroupedInvoiceItemResponsetModelFromJson(json);
}
