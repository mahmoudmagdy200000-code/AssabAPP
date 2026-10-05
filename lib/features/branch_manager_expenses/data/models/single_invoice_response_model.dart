import 'package:assab/features/branch_manager_expenses/data/models/expense_type_model.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../shared/models/time_line_response.dart';
import '../../domain/entities/single_invoice_entity.dart';
import 'single_invoice_data_model.dart';

part 'single_invoice_response_model.g.dart';

@JsonSerializable(explicitToJson: true, createToJson: false)
class SingleInvoiceResponseModel {
  final SingleInvoiceDataModel? data;

  SingleInvoiceResponseModel({this.data});

  factory SingleInvoiceResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SingleInvoiceResponseModelFromJson(json);

  SingleInvoiceEntity toEntity() {
    return SingleInvoiceEntity(
      id: data?.id ?? '0',
      status: data?.status?.label ?? 'N/A',
      createdAt: data?.createdAt ?? 'N/A',
      expenseName: data?.singleInvoice?.invoiceNumber ?? 'N/A',
      expenseType:
          data?.expenseType ?? ExpenseTypeModel(value: 'N/A', label: 'N/A'),
      totalAmount: data?.totalAmount?.toString() ?? 'N/A',
      invoiceNumber: data?.singleInvoice?.invoiceNumber ?? 'N/A',
      netAmount: data?.netAmount?.toString() ?? 'N/A',
      vatAmount: data?.vatAmount?.toString() ?? 'N/A',
      paymentMethod: data?.paymentMethod ?? 'N/A',
      taxId: data?.singleInvoice?.taxId ?? 'N/A',
      supplierName: data?.supplier?.name ?? 'N/A',
      supplierId: data?.supplier?.id ?? 'N/A',
      totalAmountPaid: data?.singleInvoice?.paidAmount?.toString() ?? 'N/A',
      issueDate: data?.singleInvoice?.issueDate ?? 'N/A',
      isTaxInvoice: data?.singleInvoice?.isTaxInvoice ?? false,
      totalInvoiceItems: data?.singleInvoice?.items?.length.toString() ?? 'N/A',
      items: data?.singleInvoice?.items ?? [],
      expenses: data?.singleInvoice?.expenses ?? [],
      attachments: data?.attachments ?? [],
      paymentType: data?.singleInvoice?.paymentType ?? 'N/A',
      dueDate: data?.singleInvoice?.dueDate ?? 'N/A',
      paymentSupplierId: data?.paymentSupplier?.id ?? 'N/A',
      paymentSupplier: data?.paymentSupplier,
      taxSupplierName:
          data?.singleInvoice?.taxInvoiceDetails?.supplierName ?? 'N/A',
      timelines: data?.timelines ?? const TimeLineResponse(timelines: []),
    );
  }
}
