import '../../core/enums/supplier_status_enum.dart';
import '../../core/strategies/supplier_status_strategy.dart';

class SupplierDetailsResponse {
  final String id;
  final String name;
  final String? image;
  final SupplierStatusStrategy status;
  final String statusLabel;
  final List<String> contactMethods;
  final String? averageResponseTimeHours;
  final String? responseRatePercentage;

  SupplierDetailsResponse({
    required this.id,
    required this.name,
    this.image,
    required this.status,
    required this.statusLabel,
    required this.contactMethods,
    this.averageResponseTimeHours,
    this.responseRatePercentage,
  });

  factory SupplierDetailsResponse.fromJson(Map<String, dynamic> json) {
    return SupplierDetailsResponse(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      status: SupplierStatusEnum.getStrategy(
        SupplierStatusEnum.fromValue(json['status']),
      ),
      statusLabel: json['status_label'],
      contactMethods: json['contact_methods'] != null
          ? List<String>.from(json['contact_methods'])
          : [],
      averageResponseTimeHours: json['average_response_time_hours']?.toString(),
      responseRatePercentage: json['response_rate_percentage']?.toString(),
    );
  }
}
