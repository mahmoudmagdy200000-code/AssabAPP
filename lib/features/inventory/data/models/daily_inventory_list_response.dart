import 'package:assab/shared/models/meta_model/meta_model.dart';

import '../../../../core/enums/daily_inventory_type_enum.dart';
import '../../../../shared/models/time_line_response.dart';
import '../../domain/enums/inventory_status_enum.dart';
import '../../domain/strategies/daily_inventory_status_strategy.dart';

class DailyInventoryListResponse {
  final List<DailyInventoryListResponseSession> data;
  final MetaModel meta;

  const DailyInventoryListResponse({required this.data, required this.meta});

  factory DailyInventoryListResponse.fromJson(Map<String, dynamic> json) {
    return DailyInventoryListResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => DailyInventoryListResponseSession.fromJson(e))
          .toList(),
      meta: MetaModel.fromJson(json['meta'] as Map<String, dynamic>),
    );
  }
}

class DailyInventoryListResponseSession {
  final String id;
  final String sessionNumber;
  final DailyInventoryListResponseBranch branch;
  final DailyInventoryListResponseUser performedBy;
  final DailyInventoryListResponseUser createdBy;
  final DailyInventoryTypeEnum assignedToType;
  final String? inventoryDate;
  final String startTime;
  final String? endTime;
  final String? timeTaken;
  final int? timeTakenSeconds;
  final DailyInventoryStatusStrategy status;
  final String statusLabel;
  final String statusColor;
  final String? notes;
  final int itemsCount;
  final List<DailyInventoryListResponseItem> items;
  final bool isStaffInventored;
  final bool isBranchManagerConfirm;
  final String? submittedAt;
  final String? rejectedAt;
  final String? rejectionComment;
  final String? approvedAt;
  final String createdAt;
  final String updatedAt;
  final TimeLineResponse timelines;

  const DailyInventoryListResponseSession({
    required this.id,
    required this.sessionNumber,
    required this.branch,
    required this.performedBy,
    required this.createdBy,
    required this.assignedToType,
    required this.inventoryDate,
    required this.startTime,
    this.endTime,
    this.timeTaken,
    this.timeTakenSeconds,
    required this.status,
    required this.statusLabel,
    required this.statusColor,
    this.notes,
    required this.itemsCount,
    required this.items,
    required this.isStaffInventored,
    required this.isBranchManagerConfirm,
    this.submittedAt,
    this.rejectedAt,
    this.rejectionComment,
    this.approvedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.timelines,
  });

  factory DailyInventoryListResponseSession.fromJson(
    Map<String, dynamic> json,
  ) {
    return DailyInventoryListResponseSession(
      id: json['id'],
      sessionNumber: json['session_number'],
      branch: DailyInventoryListResponseBranch.fromJson(json['branch']),
      performedBy: DailyInventoryListResponseUser.fromJson(
        json['performed_by'],
      ),
      createdBy: DailyInventoryListResponseUser.fromJson(json['created_by']),
      assignedToType: DailyInventoryTypeEnum.fromValue(
        json['assigned_to_type'] as String,
      ),
      inventoryDate: json['inventory_date'],
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'],
      timeTaken: json['time_taken'],
      timeTakenSeconds: json['time_taken_seconds'],
      status: DailyInventoryStatusStrategy.getStrategy(
        InventoryStatusEnum.fromString(json['status'] as String),
      ),
      statusLabel: json['status_label'],
      statusColor: json['status_color'],
      notes: json['notes'],
      itemsCount: json['items_count'],
      items: (json['items'] as List<dynamic>)
          .map((e) => DailyInventoryListResponseItem.fromJson(e))
          .toList(),
      isStaffInventored: json['isStaffInventored'] ?? false,
      isBranchManagerConfirm: json['isBranchManagerConfirm'] ?? false,
      submittedAt: json['submitted_at'],
      rejectedAt: json['rejected_at'],
      rejectionComment: json['rejection_comment'],
      approvedAt: json['approved_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      timelines: TimeLineResponse.fromJson(json),
    );
  }
}

class DailyInventoryListResponseBranch {
  final String id;
  final String name;

  const DailyInventoryListResponseBranch({
    required this.id,
    required this.name,
  });

  factory DailyInventoryListResponseBranch.fromJson(Map<String, dynamic> json) {
    return DailyInventoryListResponseBranch(id: json['id'], name: json['name']);
  }
}

class DailyInventoryListResponseUser {
  final String id;
  final String name;

  const DailyInventoryListResponseUser({required this.id, required this.name});

  factory DailyInventoryListResponseUser.fromJson(Map<String, dynamic> json) {
    return DailyInventoryListResponseUser(id: json['id'], name: json['name']);
  }
}

class DailyInventoryListResponseItem {
  final String id;
  final DailyInventoryListResponseInventoryItem item;
  final DailyInventoryListResponsePurchaseOrderItem purchaseOrderItem;
  final int quantityInventory;
  final String? notes;
  final String createdAt;
  final String updatedAt;

  const DailyInventoryListResponseItem({
    required this.id,
    required this.item,
    required this.purchaseOrderItem,
    required this.quantityInventory,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DailyInventoryListResponseItem.fromJson(Map<String, dynamic> json) {
    return DailyInventoryListResponseItem(
      id: json['id'],
      item: DailyInventoryListResponseInventoryItem.fromJson(json['item']),
      purchaseOrderItem: DailyInventoryListResponsePurchaseOrderItem.fromJson(
        json['purchase_order_item'],
      ),
      quantityInventory: json['quantity_inventory'],
      notes: json['notes'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class DailyInventoryListResponseInventoryItem {
  final String id;
  final String name;
  final String code;
  final String? logo;
  final String unit;

  const DailyInventoryListResponseInventoryItem({
    required this.id,
    required this.name,
    required this.code,
    this.logo,
    required this.unit,
  });

  factory DailyInventoryListResponseInventoryItem.fromJson(
    Map<String, dynamic> json,
  ) {
    return DailyInventoryListResponseInventoryItem(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      logo: json['logo'],
      unit: json['unit'],
    );
  }
}

class DailyInventoryListResponsePurchaseOrderItem {
  final String? id;
  final String? orderNumber;
  final String quantityOrdered;

  const DailyInventoryListResponsePurchaseOrderItem({
    this.id,
    this.orderNumber,
    required this.quantityOrdered,
  });

  factory DailyInventoryListResponsePurchaseOrderItem.fromJson(
    Map<String, dynamic> json,
  ) {
    return DailyInventoryListResponsePurchaseOrderItem(
      id: json['id'],
      orderNumber: json['order_number'],
      quantityOrdered: json['quantity_ordered'].toString(),
    );
  }
}
