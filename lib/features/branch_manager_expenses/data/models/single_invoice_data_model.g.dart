// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'single_invoice_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SingleInvoiceDataModel _$SingleInvoiceDataModelFromJson(
  Map<String, dynamic> json,
) => SingleInvoiceDataModel(
  id: json['id'] as String?,
  expenseType: json['expense_type'] == null
      ? null
      : ExpenseTypeModel.fromJson(json['expense_type'] as Map<String, dynamic>),
  status: json['status'] == null
      ? null
      : ExpenseStatusModel.fromJson(json['status'] as Map<String, dynamic>),
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
  timelines: TimeLineResponse.fromJson(
    json['timelines'] as Map<String, dynamic>,
  ),
  singleInvoice: json['data'] == null
      ? null
      : SingleInvoiceModel.fromJson(json['data'] as Map<String, dynamic>),
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

SingleInvoiceModel _$SingleInvoiceModelFromJson(Map<String, dynamic> json) =>
    SingleInvoiceModel(
      invoiceNumber: json['invoice_number'] as String?,
      issueDate: json['issue_date'] as String?,
      isTaxInvoice: json['is_tax_invoice'] as bool?,
      taxId: json['tax_id'] as String?,
      paymentType: json['payment_type'] as String?,
      paidAmount: (json['paid_amount'] as num?)?.toDouble(),
      dueDate: json['due_date'] as String?,
      items: (json['items'] as List<dynamic>?)
          ?.map(
            (e) => SingleInvoiceItemModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      expenses: (json['expenses'] as List<dynamic>?)
          ?.map(
            (e) =>
                SingleInvoiceExpenseModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      taxInvoiceDetails: json['tax_invoice_details'] == null
          ? null
          : SingleInvoiceTaxDetailsModel.fromJson(
              json['tax_invoice_details'] as Map<String, dynamic>,
            ),
    );

SingleInvoiceItemModel _$SingleInvoiceItemModelFromJson(
  Map<String, dynamic> json,
) => SingleInvoiceItemModel(
  id: json['id'] as String?,
  category: json['category'] as String?,
  name: json['name'] as String?,
  quantity: (json['quantity'] as num?)?.toInt(),
  categoryId: json['category_id'] as String?,
  unitPrice: (json['unit_price'] as num?)?.toDouble(),
  totalAmount: (json['total_amount'] as num?)?.toDouble(),
);

SingleInvoiceExpenseModel _$SingleInvoiceExpenseModelFromJson(
  Map<String, dynamic> json,
) => SingleInvoiceExpenseModel(
  id: json['id'] as String?,
  category: json['category'] as String?,
  name: json['name'] as String?,
  categoryId: json['category_id'] as String?,
  price: (json['price'] as num?)?.toDouble(),
);

SingleInvoiceTaxDetailsModel _$SingleInvoiceTaxDetailsModelFromJson(
  Map<String, dynamic> json,
) => SingleInvoiceTaxDetailsModel(
  supplierName: json['supplier_name'] as String?,
  netAmount: (json['net_amount'] as num?)?.toDouble(),
  vatAmount: (json['vat_amount'] as num?)?.toDouble(),
  totalAmount: (json['total_amount'] as num?)?.toDouble(),
);
