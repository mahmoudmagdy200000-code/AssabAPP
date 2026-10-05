// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grouped_invoice_update_draft_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupedInvoiceUpdateDraftRequest _$GroupedInvoiceUpdateDraftRequestFromJson(
  Map<String, dynamic> json,
) => GroupedInvoiceUpdateDraftRequest(
  paymentType: json['payment_type'] as String,
  paymentMethod: json['payment_method'] as String,
  dueDate: json['due_date'] as String,
  defaultSupplierId: json['default_supplier_id'] as String,
  paymentSupplierId: json['payment_supplier_id'] as String,
  invoices: (json['invoices'] as List<dynamic>)
      .map(
        (e) => GroupedInvoiceUpdateDraftRequestInvoice.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
  isDraft: json['is_draft'] as bool,
);

Map<String, dynamic> _$GroupedInvoiceUpdateDraftRequestToJson(
  GroupedInvoiceUpdateDraftRequest instance,
) => <String, dynamic>{
  'payment_type': instance.paymentType,
  'payment_method': instance.paymentMethod,
  'due_date': instance.dueDate,
  'default_supplier_id': instance.defaultSupplierId,
  'payment_supplier_id': instance.paymentSupplierId,
  'invoices': instance.invoices.map((e) => e.toJson()).toList(),
  'is_draft': instance.isDraft,
};

GroupedInvoiceUpdateDraftRequestInvoice
_$GroupedInvoiceUpdateDraftRequestInvoiceFromJson(Map<String, dynamic> json) =>
    GroupedInvoiceUpdateDraftRequestInvoice(
      id: json['id'] as String,
      supplierId: json['supplier_id'] as String,
      invoiceNumber: json['invoice_number'] as String,
      issueDate: json['issue_date'] as String,
      isTaxInvoice: json['is_tax_invoice'] as bool,
      taxId: json['tax_id'] as String,
      taxInvoiceDetails: json['tax_invoice_details'] == null
          ? null
          : GroupedInvoiceUpdateDraftRequestTaxInvoiceDetails.fromJson(
              json['tax_invoice_details'] as Map<String, dynamic>,
            ),
      items: (json['items'] as List<dynamic>)
          .map(
            (e) => GroupedInvoiceUpdateDraftRequestItem.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
      deleteAttachments: (json['delete_attachments'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$GroupedInvoiceUpdateDraftRequestInvoiceToJson(
  GroupedInvoiceUpdateDraftRequestInvoice instance,
) => <String, dynamic>{
  'id': instance.id,
  'supplier_id': instance.supplierId,
  'invoice_number': instance.invoiceNumber,
  'issue_date': instance.issueDate,
  'is_tax_invoice': instance.isTaxInvoice,
  'tax_id': instance.taxId,
  'tax_invoice_details': instance.taxInvoiceDetails?.toJson(),
  'items': instance.items.map((e) => e.toJson()).toList(),
  'delete_attachments': instance.deleteAttachments,
};

GroupedInvoiceUpdateDraftRequestTaxInvoiceDetails
_$GroupedInvoiceUpdateDraftRequestTaxInvoiceDetailsFromJson(
  Map<String, dynamic> json,
) => GroupedInvoiceUpdateDraftRequestTaxInvoiceDetails(
  supplierName: json['supplier_name'] as String,
  netAmount: json['net_amount'] as String,
  vatAmount: json['vat_amount'] as String,
  totalAmount: json['total_amount'] as String,
);

Map<String, dynamic> _$GroupedInvoiceUpdateDraftRequestTaxInvoiceDetailsToJson(
  GroupedInvoiceUpdateDraftRequestTaxInvoiceDetails instance,
) => <String, dynamic>{
  'supplier_name': instance.supplierName,
  'net_amount': instance.netAmount,
  'vat_amount': instance.vatAmount,
  'total_amount': instance.totalAmount,
};

GroupedInvoiceUpdateDraftRequestItem
_$GroupedInvoiceUpdateDraftRequestItemFromJson(Map<String, dynamic> json) =>
    GroupedInvoiceUpdateDraftRequestItem(
      categoryId: json['category_id'] as String,
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unitPrice: (json['unit_price'] as num).toDouble(),
    );

Map<String, dynamic> _$GroupedInvoiceUpdateDraftRequestItemToJson(
  GroupedInvoiceUpdateDraftRequestItem instance,
) => <String, dynamic>{
  'category_id': instance.categoryId,
  'name': instance.name,
  'quantity': instance.quantity,
  'unit_price': instance.unitPrice,
};
