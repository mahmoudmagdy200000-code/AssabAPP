// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grouped_invoice_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupedInvoiceResponseModel _$GroupedInvoiceResponseModelFromJson(
  Map<String, dynamic> json,
) => GroupedInvoiceResponseModel(
  data: json['data'] == null
      ? null
      : GroupedInvoiceDataModel.fromJson(json['data'] as Map<String, dynamic>),
);

GroupedInvoiceDataModel _$GroupedInvoiceDataModelFromJson(
  Map<String, dynamic> json,
) => GroupedInvoiceDataModel(
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
  data: json['data'] == null
      ? null
      : GroupedInvoiceInnerDataModel.fromJson(
          json['data'] as Map<String, dynamic>,
        ),
  timelines: TimeLineResponse.fromJson(
    json['timelines'] as Map<String, dynamic>,
  ),
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

GroupedInvoiceInnerDataModel _$GroupedInvoiceInnerDataModelFromJson(
  Map<String, dynamic> json,
) => GroupedInvoiceInnerDataModel(
  defaultSupplierId: json['default_supplier_id'] as String?,
  defaultSupplierName: json['default_supplier_name'] as String?,
  numberOfSuppliers: (json['number_of_suppliers'] as num?)?.toInt(),
  supplierNames: (json['supplier_names'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  paymentType: json['payment_type'] as String?,
  paidAmount: json['paid_amount'] as num?,
  dueDate: json['due_date'] as String?,
  totalInvoices: (json['total_invoices'] as num?)?.toInt(),
  invoices: (json['invoices'] as List<dynamic>?)
      ?.map((e) => GroupedInvoiceModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

GroupedInvoiceModel _$GroupedInvoiceModelFromJson(Map<String, dynamic> json) =>
    GroupedInvoiceModel(
      id: json['id'] as String?,
      supplier: json['supplier'] == null
          ? null
          : SupplierModel.fromJson(json['supplier'] as Map<String, dynamic>),
      invoiceNumber: json['invoice_number'] as String?,
      issueDate: json['issue_date'] as String?,
      isTaxInvoice: json['is_tax_invoice'] as bool?,
      taxId: json['tax_id'] as String?,
      netAmount: json['net_amount'] as num?,
      vatAmount: json['vat_amount'] as num?,
      totalAmount: json['total_amount'] as num?,
      itemsCount: (json['items_count'] as num?)?.toInt(),
      expensesCount: (json['expenses_count'] as num?)?.toInt(),
      items: (json['items'] as List<dynamic>?)
          ?.map(
            (e) => GroupedInvoiceItemResponsetModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
      expenses: json['expenses'] as List<dynamic>?,
      receipts: (json['receipts'] as List<dynamic>?)
          ?.map((e) => AttachmentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

GroupedInvoiceItemResponsetModel _$GroupedInvoiceItemResponsetModelFromJson(
  Map<String, dynamic> json,
) => GroupedInvoiceItemResponsetModel(
  id: json['id'] as String?,
  category: json['category'] as String?,
  categoryId: json['category_id'] as String,
  name: json['name'] as String?,
  quantity: (json['quantity'] as num?)?.toInt(),
  unitPrice: json['unit_price'] as num?,
  totalAmount: json['total_amount'] as num?,
);
