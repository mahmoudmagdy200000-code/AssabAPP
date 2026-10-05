import '../../../../shared/models/meta_model/meta_model.dart';
import '../../domain/strategies/monthly_inventory_status_strategy.dart';
import 'monthly_inventory_details_response.dart';

class MonthlyInventoryListResponse {
  final List<MonthlyInventoryListItem> data;
  final MetaModel meta;

  MonthlyInventoryListResponse({required this.data, required this.meta});

  factory MonthlyInventoryListResponse.fromJson(Map<String, dynamic> json) {
    return MonthlyInventoryListResponse(
      data: List<MonthlyInventoryListItem>.from(
        json['data'].map((x) => MonthlyInventoryListItem.fromJson(x)),
      ),
      meta: MetaModel.fromJson(json['meta']),
    );
  }
}

class MonthlyInventoryListItem {
  final String id;
  final String inventoryNumber;
  final String inventoryDate;
  final String startTime;
  final MonthlyInventoryStatusStrategy status;
  final String statusLabel;
  final String statusColor;
  final String performedBy;
  final int productsCount;
  final MonthlyInventoryDetailsData details;

  MonthlyInventoryListItem({
    required this.id,
    required this.inventoryNumber,
    required this.inventoryDate,
    required this.startTime,
    required this.status,
    required this.statusLabel,
    required this.statusColor,
    required this.performedBy,
    required this.productsCount,
    required this.details,
  });

  factory MonthlyInventoryListItem.fromJson(Map<String, dynamic> json) {
    return MonthlyInventoryListItem(
      id: json['id'],
      inventoryNumber: json['inventory_number'],
      inventoryDate: json['inventory_date'],
      startTime: json['start_time'],
      status: MonthlyInventoryStatusStrategy.getStrategy(json['status']),
      statusLabel: json['status_label'],
      statusColor: json['status_color'],
      performedBy: json['performed_by'],
      productsCount: json['products_count'],
      details: MonthlyInventoryDetailsData.fromJson(json['details']),
    );
  }
}
