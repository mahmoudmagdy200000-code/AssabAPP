import 'package:assab/core/enums/payment_method.dart';
import 'package:json_annotation/json_annotation.dart';

part 'single_invoice_update_draft_request.g.dart';

@JsonSerializable(explicitToJson: true)
class SingleInvoiceUpdateDraftRequest {
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
  final SingleInvoiceUpdateDraftRequestTaxInvoiceDetails taxInvoiceDetails;

  final List<SingleInvoiceUpdateDraftRequestItem> items;

  final List<SingleInvoiceUpdateDraftRequestExpense> expenses;

  @JsonKey(name: 'payment_type')
  final String paymentType;

  @JsonKey(name: 'payment_method')
  final String paymentMethod;

  @JsonKey(name: 'payment_supplier_id')
  final String paymentSupplierId;

  @JsonKey(name: 'paid_amount')
  final double paidAmount;

  @JsonKey(name: 'due_date')
  final String dueDate;

  @JsonKey(name: 'is_draft')
  final bool isDraft;

  @JsonKey(name: 'delete_attachments')
  final List<String> deleteAttachments;

  SingleInvoiceUpdateDraftRequest({
    required this.supplierId,
    required this.invoiceNumber,
    required this.issueDate,
    required this.isTaxInvoice,
    required this.taxId,
    required this.taxInvoiceDetails,
    required this.items,
    required this.expenses,
    required this.paymentType,
    required this.paymentMethod,
    required this.paymentSupplierId,
    required this.paidAmount,
    required this.dueDate,
    required this.isDraft,
    required this.deleteAttachments,
  });

  factory SingleInvoiceUpdateDraftRequest.fromJson(Map<String, dynamic> json) =>
      _$SingleInvoiceUpdateDraftRequestFromJson(json);

  Map<String, dynamic> toJson() {
    final json = {
      'supplier_id': supplierId,
      'invoice_number': invoiceNumber,
      'issue_date': issueDate,
      'is_tax_invoice': isTaxInvoice,
      'tax_id': taxId,
      'tax_invoice_details': taxInvoiceDetails.toJson(),
      'items': items.map((item) => item.toJson()).toList(),
      'expenses': expenses.map((expense) => expense.toJson()).toList(),
      'payment_type': paymentType,
      'payment_method': paymentMethod,
      'paid_amount': paidAmount,
      'is_draft': isDraft ? 1 : 0,
      'delete_attachments': deleteAttachments,
    };

    if (paymentSupplierId.isNotEmpty &&
        paymentMethod == PaymentMethod.supplier.paymentMethodToString()) {
      json['payment_supplier_id'] = paymentSupplierId;
    }

    if (dueDate.isNotEmpty) {
      json['due_date'] = dueDate;
    }

    return json;
  }
}

@JsonSerializable()
class SingleInvoiceUpdateDraftRequestTaxInvoiceDetails {
  @JsonKey(name: 'supplier_name')
  final String supplierName;
  @JsonKey(name: 'net_amount')
  final double netAmount;
  @JsonKey(name: 'vat_amount')
  final double vatAmount;
  @JsonKey(name: 'total_amount')
  final double totalAmount;

  const SingleInvoiceUpdateDraftRequestTaxInvoiceDetails({
    required this.supplierName,
    required this.netAmount,
    required this.vatAmount,
    required this.totalAmount,
  });

  factory SingleInvoiceUpdateDraftRequestTaxInvoiceDetails.fromJson(
    Map<String, dynamic> json,
  ) => _$SingleInvoiceUpdateDraftRequestTaxInvoiceDetailsFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SingleInvoiceUpdateDraftRequestTaxInvoiceDetailsToJson(this);
}

@JsonSerializable()
class SingleInvoiceUpdateDraftRequestItem {
  @JsonKey(name: 'category_id')
  final String categoryId;
  final String name;
  final double quantity;
  @JsonKey(name: 'unit_price')
  final double unitPrice;

  const SingleInvoiceUpdateDraftRequestItem({
    required this.categoryId,
    required this.name,
    required this.quantity,
    required this.unitPrice,
  });

  factory SingleInvoiceUpdateDraftRequestItem.fromJson(
    Map<String, dynamic> json,
  ) => _$SingleInvoiceUpdateDraftRequestItemFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SingleInvoiceUpdateDraftRequestItemToJson(this);
}

@JsonSerializable()
class SingleInvoiceUpdateDraftRequestExpense {
  @JsonKey(name: 'category_id')
  final String categoryId;
  final String name;
  final double price;

  const SingleInvoiceUpdateDraftRequestExpense({
    required this.categoryId,
    required this.name,
    required this.price,
  });

  factory SingleInvoiceUpdateDraftRequestExpense.fromJson(
    Map<String, dynamic> json,
  ) => _$SingleInvoiceUpdateDraftRequestExpenseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SingleInvoiceUpdateDraftRequestExpenseToJson(this);
}
