import 'package:assab/shared/models/meta_model/meta_model.dart';

import '../../../../core/enums/supplier_returns_status_enum.dart';
import '../../domain/strategies/supplier_returns_status_strategy.dart';

class SupplierReturnsResponse {
  final List<SupplierReturnData> data;
  final MetaModel meta;

  SupplierReturnsResponse({required this.data, required this.meta});

  factory SupplierReturnsResponse.fromJson(Map<String, dynamic> json) {
    return SupplierReturnsResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => SupplierReturnData.fromJson(e))
          .toList(),
      meta: MetaModel.fromJson(json['meta']),
    );
  }
}

class SupplierReturnData {
  final String id;
  final SupplierReturnsStatusStrategy status;
  final String returnNumber;
  final String createdAt;

  SupplierReturnData({
    required this.id,
    required this.status,
    required this.returnNumber,
    required this.createdAt,
  });

  factory SupplierReturnData.fromJson(Map<String, dynamic> json) {
    return SupplierReturnData(
      id: json['id'],
      status: SupplierReturnsStatusEnum.fromString(json['status']).strategy,
      returnNumber: json['return_number'],
      createdAt: json['created_at'],
    );
  }
}
