import '../../../inventory/data/models/daily_inventory_items_response.dart';

class CashierTasksResponse {
  final List<CashierTasksResponseDailyQuick> dailyQuick;
  final List<CashierTasksResponseMonthly> monthly;
  final List<CashierTasksResponseWasteDamage> wasteDamage;

  CashierTasksResponse({
    required this.dailyQuick,
    required this.monthly,
    required this.wasteDamage,
  });

  factory CashierTasksResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    return CashierTasksResponse(
      dailyQuick: (data['daily_quick'] as List)
          .map((e) => CashierTasksResponseDailyQuick.fromJson(e))
          .toList(),
      monthly: (data['monthly'] as List)
          .map((e) => CashierTasksResponseMonthly.fromJson(e))
          .toList(),
      wasteDamage: (data['waste_damage'] as List)
          .map((e) => CashierTasksResponseWasteDamage.fromJson(e))
          .toList(),
    );
  }
}

/// ================= DAILY QUICK =================
class CashierTasksResponseDailyQuick {
  final String id;
  final String type;
  final String status;
  final String statusLabel;
  final String? inventoryDate;
  final String sessionNumber;
  final String? startTime;
  final String createdAt;
  final List<DailyInventoryItem> items;

  CashierTasksResponseDailyQuick({
    required this.id,
    required this.type,
    required this.status,
    required this.statusLabel,
    this.inventoryDate,
    required this.sessionNumber,
    this.startTime,
    required this.createdAt,
    required this.items,
  });

  factory CashierTasksResponseDailyQuick.fromJson(Map<String, dynamic> json) {
    return CashierTasksResponseDailyQuick(
      id: json['id'],
      type: json['type'],
      status: json['status'],
      statusLabel: json['status_label'],
      inventoryDate: json['inventory_date'],
      sessionNumber: json['session_number'],
      startTime: json['start_time'],
      createdAt: json['created_at'],
      items: json['items'] != null
          ? (json['items'] as List)
                .map((e) => DailyInventoryItem.fromJson(e))
                .toList()
          : [],
    );
  }
}

/// ================= MONTHLY =================
class CashierTasksResponseMonthly {
  final String id;
  final String type;
  final String status;
  final String statusLabel;
  final String inventoryDate;
  final String inventoryNumber;
  final String createdAt;

  CashierTasksResponseMonthly({
    required this.id,
    required this.type,
    required this.status,
    required this.statusLabel,
    required this.inventoryDate,
    required this.inventoryNumber,
    required this.createdAt,
  });

  factory CashierTasksResponseMonthly.fromJson(Map<String, dynamic> json) {
    return CashierTasksResponseMonthly(
      id: json['id'],
      type: json['type'],
      status: json['status'],
      statusLabel: json['status_label'],
      inventoryDate: json['inventory_date'],
      inventoryNumber: json['inventory_number'],
      createdAt: json['created_at'],
    );
  }
}

/// ================= WASTE DAMAGE =================
class CashierTasksResponseWasteDamage {
  final String id;
  final String type;
  final String status;
  final String statusLabel;
  final String createdAt;

  CashierTasksResponseWasteDamage({
    required this.id,
    required this.type,
    required this.status,
    required this.statusLabel,
    required this.createdAt,
  });

  factory CashierTasksResponseWasteDamage.fromJson(Map<String, dynamic> json) {
    return CashierTasksResponseWasteDamage(
      id: json['id'],
      type: json['type'],
      status: json['status'],
      statusLabel: json['status_label'],
      createdAt: json['created_at'],
    );
  }
}
