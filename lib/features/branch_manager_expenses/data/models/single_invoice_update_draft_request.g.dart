// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'single_invoice_update_draft_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SingleInvoiceUpdateDraftRequest _$SingleInvoiceUpdateDraftRequestFromJson(
  Map<String, dynamic> json,
) => SingleInvoiceUpdateDraftRequest(
  supplierId: json['supplier_id'] as String,
  invoiceNumber: json['invoice_number'] as String,
  issueDate: json['issue_date'] as String,
  isTaxInvoice: json['is_tax_invoice'] as bool,
  taxId: json['tax_id'] as String,
  taxInvoiceDetails: SingleInvoiceUpdateDraftRequestTaxInvoiceDetails.fromJson(
    json['tax_invoice_details'] as Map<String, dynamic>,
  ),
  items: (json['items'] as List<dynamic>)
      .map(
        (e) => SingleInvoiceUpdateDraftRequestItem.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
  expenses: (json['expenses'] as List<dynamic>)
      .map(
        (e) => SingleInvoiceUpdateDraftRequestExpense.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
  paymentType: json['payment_type'] as String,
  paymentMethod: json['payment_method'] as String,
  paymentSupplierId: json['payment_supplier_id'] as String,
  paidAmount: (json['paid_amount'] as num).toDouble(),
  dueDate: json['due_date'] as String,
  isDraft: json['is_draft'] as bool,
  deleteAttachments: (json['delete_attachments'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$SingleInvoiceUpdateDraftRequestToJson(
  SingleInvoiceUpdateDraftRequest instance,
) => <String, dynamic>{
  'supplier_id': instance.supplierId,
  'invoice_number': instance.invoiceNumber,
  'issue_date': instance.issueDate,
  'is_tax_invoice': instance.isTaxInvoice,
  'tax_id': instance.taxId,
  'tax_invoice_details': instance.taxInvoiceDetails.toJson(),
  'items': instance.items.map((e) => e.toJson()).toList(),
  'expenses': instance.expenses.map((e) => e.toJson()).toList(),
  'payment_type': instance.paymentType,
  'payment_method': instance.paymentMethod,
  'payment_supplier_id': instance.paymentSupplierId,
  'paid_amount': instance.paidAmount,
  'due_date': instance.dueDate,
  'is_draft': instance.isDraft,
  'delete_attachments': instance.deleteAttachments,
};

SingleInvoiceUpdateDraftRequestTaxInvoiceDetails
_$SingleInvoiceUpdateDraftRequestTaxInvoiceDetailsFromJson(
  Map<String, dynamic> json,
) => SingleInvoiceUpdateDraftRequestTaxInvoiceDetails(
  supplierName: json['supplier_name'] as String,
  netAmount: (json['net_amount'] as num).toDouble(),
  vatAmount: (json['vat_amount'] as num).toDouble(),
  totalAmount: (json['total_amount'] as num).toDouble(),
);

Map<String, dynamic> _$SingleInvoiceUpdateDraftRequestTaxInvoiceDetailsToJson(
  SingleInvoiceUpdateDraftRequestTaxInvoiceDetails instance,
) => <String, dynamic>{
  'supplier_name': instance.supplierName,
  'net_amount': instance.netAmount,
  'vat_amount': instance.vatAmount,
  'total_amount': instance.totalAmount,
};

SingleInvoiceUpdateDraftRequestItem
_$SingleInvoiceUpdateDraftRequestItemFromJson(Map<String, dynamic> json) =>
    SingleInvoiceUpdateDraftRequestItem(
      categoryId: json['category_id'] as String,
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unitPrice: (json['unit_price'] as num).toDouble(),
    );

Map<String, dynamic> _$SingleInvoiceUpdateDraftRequestItemToJson(
  SingleInvoiceUpdateDraftRequestItem instance,
) => <String, dynamic>{
  'category_id': instance.categoryId,
  'name': instance.name,
  'quantity': instance.quantity,
  'unit_price': instance.unitPrice,
};

SingleInvoiceUpdateDraftRequestExpense
_$SingleInvoiceUpdateDraftRequestExpenseFromJson(Map<String, dynamic> json) =>
    SingleInvoiceUpdateDraftRequestExpense(
      categoryId: json['category_id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
    );

Map<String, dynamic> _$SingleInvoiceUpdateDraftRequestExpenseToJson(
  SingleInvoiceUpdateDraftRequestExpense instance,
) => <String, dynamic>{
  'category_id': instance.categoryId,
  'name': instance.name,
  'price': instance.price,
};
