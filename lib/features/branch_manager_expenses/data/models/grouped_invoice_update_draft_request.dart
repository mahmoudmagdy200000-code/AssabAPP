import 'package:assab/core/enums/payment_method.dart';
import 'package:json_annotation/json_annotation.dart';

part 'grouped_invoice_update_draft_request.g.dart';

@JsonSerializable(explicitToJson: true)
class GroupedInvoiceUpdateDraftRequest {
  @JsonKey(name: 'payment_type')
  final String paymentType;

  @JsonKey(name: 'payment_method')
  final String paymentMethod;

  @JsonKey(name: 'due_date')
  final String dueDate;

  @JsonKey(name: 'default_supplier_id')
  final String defaultSupplierId;

  @JsonKey(name: 'payment_supplier_id')
  final String paymentSupplierId;

  final List<GroupedInvoiceUpdateDraftRequestInvoice> invoices;

  @JsonKey(name: 'is_draft')
  final bool isDraft;

  GroupedInvoiceUpdateDraftRequest({
    required this.paymentType,
    required this.paymentMethod,
    required this.dueDate,
    required this.defaultSupplierId,
    required this.paymentSupplierId,
    required this.invoices,
    required this.isDraft,
  });

  factory GroupedInvoiceUpdateDraftRequest.fromJson(
    Map<String, dynamic> json,
  ) => _$GroupedInvoiceUpdateDraftRequestFromJson(json);

  Map<String, dynamic> toJson() {
    final json = {
      'payment_type': paymentType,
      'payment_method': paymentMethod,
      'default_supplier_id': defaultSupplierId,
      'invoices': invoices.map((invoice) => invoice.toJson()).toList(),
      'is_draft': isDraft ? '1' : '0',
    };

    if (dueDate.isNotEmpty && paymentType == 'deferred') {
      json['due_date'] = dueDate;
    }

    if (paymentMethod == PaymentMethod.supplier.paymentMethodToString()) {
      json['payment_supplier_id'] = paymentSupplierId;
    }

    return json;
  }
}

@JsonSerializable(explicitToJson: true)
class GroupedInvoiceUpdateDraftRequestInvoice {
  final String id;

  @JsonKey(name: 'supplier_id')
  final String supplierId;

  @JsonKey(name: 'invoice_number')
  final String invoiceNumber;

  @JsonKey(name: 'issue_date')
  final String issueDate;

  @JsonKey(name: 'is_tax_invoice')
  final bool isTaxInvoice;

  @JsonKey(name: 'tax_id')
  final String taxId;

  @JsonKey(name: 'tax_invoice_details')
  final GroupedInvoiceUpdateDraftRequestTaxInvoiceDetails? taxInvoiceDetails;

  final List<GroupedInvoiceUpdateDraftRequestItem> items;

  @JsonKey(name: 'delete_attachments')
  final List<String> deleteAttachments;

  GroupedInvoiceUpdateDraftRequestInvoice({
    required this.id,
    required this.supplierId,
    required this.invoiceNumber,
    required this.issueDate,
    required this.isTaxInvoice,
    required this.taxId,
    required this.taxInvoiceDetails,
    required this.items,
    required this.deleteAttachments,
  });

  factory GroupedInvoiceUpdateDraftRequestInvoice.fromJson(
    Map<String, dynamic> json,
  ) => _$GroupedInvoiceUpdateDraftRequestInvoiceFromJson(json);

  Map<String, dynamic> toJson() {
    final json = {
      'id': id,
      'supplier_id': supplierId,
      'invoice_number': invoiceNumber,
      'issue_date': issueDate,
      'is_tax_invoice': isTaxInvoice,
      'items': items.map((item) => item.toJson()).toList(),
    };

    if (deleteAttachments.isNotEmpty) {
      json['delete_attachments'] = deleteAttachments;
    }

    if (isTaxInvoice) {
      if (taxId.isNotEmpty && taxId != 'N/A') {
        json['tax_id'] = taxId;
      }

      json['tax_invoice_details'] = taxInvoiceDetails?.toJson() ?? {};
    }

    return json;
  }
}

@JsonSerializable()
class GroupedInvoiceUpdateDraftRequestTaxInvoiceDetails {
  @JsonKey(name: 'supplier_name')
  final String supplierName;
  @JsonKey(name: 'net_amount')
  final String netAmount;
  @JsonKey(name: 'vat_amount')
  final String vatAmount;
  @JsonKey(name: 'total_amount')
  final String totalAmount;

  GroupedInvoiceUpdateDraftRequestTaxInvoiceDetails({
    required this.supplierName,
    required this.netAmount,
    required this.vatAmount,
    required this.totalAmount,
  });

  factory GroupedInvoiceUpdateDraftRequestTaxInvoiceDetails.fromJson(
    Map<String, dynamic> json,
  ) => _$GroupedInvoiceUpdateDraftRequestTaxInvoiceDetailsFromJson(json);

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};

    if (supplierName.isNotEmpty && supplierName != 'N/A') {
      json['supplier_name'] = supplierName;
    }

    if (netAmount.isNotEmpty && netAmount != 'N/A') {
      json['net_amount'] = netAmount;
    }

    if (vatAmount.isNotEmpty && vatAmount != 'N/A') {
      json['vat_amount'] = vatAmount;
    }

    if (totalAmount.isNotEmpty && totalAmount != 'N/A') {
      json['total_amount'] = totalAmount;
    }

    return json;
  }
}

@JsonSerializable()
class GroupedInvoiceUpdateDraftRequestItem {
  @JsonKey(name: 'category_id')
  final String categoryId;

  final String name;

  final double quantity;

  @JsonKey(name: 'unit_price')
  final double unitPrice;

  GroupedInvoiceUpdateDraftRequestItem({
    required this.categoryId,
    required this.name,
    required this.quantity,
    required this.unitPrice,
  });

  factory GroupedInvoiceUpdateDraftRequestItem.fromJson(
    Map<String, dynamic> json,
  ) => _$GroupedInvoiceUpdateDraftRequestItemFromJson(json);

  Map<String, dynamic> toJson() =>
      _$GroupedInvoiceUpdateDraftRequestItemToJson(this);
}
