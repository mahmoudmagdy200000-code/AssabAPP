import 'package:json_annotation/json_annotation.dart';

import '../../../../shared/models/meta_model/meta_model.dart';
import 'single_invoice_data_model.dart';

part 'single_invoice_previous_response.g.dart';

@JsonSerializable(createToJson: false)
class SingleInvoicePreviousResponseModel {
  final List<SingleInvoiceDataModel> data;
  final MetaModel meta;

  SingleInvoicePreviousResponseModel({required this.data, required this.meta});

  factory SingleInvoicePreviousResponseModel.fromJson(
    Map<String, dynamic> json,
  ) => _$SingleInvoicePreviousResponseModelFromJson(json);
}
