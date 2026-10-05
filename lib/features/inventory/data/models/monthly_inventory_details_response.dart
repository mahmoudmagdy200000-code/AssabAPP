import 'package:assab/shared/models/time_line_response.dart';

class MonthlyInventoryDetailsResponse {
  final MonthlyInventoryDetailsData data;

  MonthlyInventoryDetailsResponse({required this.data});

  factory MonthlyInventoryDetailsResponse.fromJson(Map<String, dynamic> json) {
    return MonthlyInventoryDetailsResponse(
      data: MonthlyInventoryDetailsData.fromJson(json['data']),
    );
  }
}

class MonthlyInventoryDetailsData {
  final String id;
  final String inventoryNumber;
  final MonthlyInventoryDetailsBranch branch;
  final MonthlyInventoryDetailsCreatedBy createdBy;
  final String inventoryDate;
  final String startTime;
  final String? endTime;
  final String? timeTaken;
  final int? timeTakenSeconds;
  final int numberOfProducts;
  final int expectedTimeMinutes;
  final String status;
  final String statusLabel;
  final String statusColor;
  final int productsCount;
  final int inventoriedCount;
  final List<MonthlyInventoryDetailsStaff> staff;
  final List<MonthlyInventoryDetailsProduct> products;
  final String? submittedAt;
  final String? approvedAt;
  final String? notes;
  final String createdAt;
  final String updatedAt;
  final TimeLineResponse timelines;

  MonthlyInventoryDetailsData({
    required this.id,
    required this.inventoryNumber,
    required this.branch,
    required this.createdBy,
    required this.inventoryDate,
    required this.startTime,
    this.endTime,
    this.timeTaken,
    this.timeTakenSeconds,
    required this.numberOfProducts,
    required this.expectedTimeMinutes,
    required this.status,
    required this.statusLabel,
    required this.statusColor,
    required this.productsCount,
    required this.inventoriedCount,
    required this.staff,
    required this.products,
    this.submittedAt,
    this.approvedAt,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.timelines,
  });

  factory MonthlyInventoryDetailsData.fromJson(Map<String, dynamic> json) {
    return MonthlyInventoryDetailsData(
      id: json['id'],
      inventoryNumber: json['inventory_number'],
      branch: MonthlyInventoryDetailsBranch.fromJson(json['branch']),
      createdBy: MonthlyInventoryDetailsCreatedBy.fromJson(json['created_by']),
      inventoryDate: json['inventory_date'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      timeTaken: json['time_taken'],
      timeTakenSeconds: json['time_taken_seconds'],
      numberOfProducts: json['number_of_products'],
      expectedTimeMinutes: json['expected_time_minutes'],
      status: json['status'],
      statusLabel: json['status_label'],
      statusColor: json['status_color'],
      productsCount: json['products_count'],
      inventoriedCount: json['inventoried_count'],
      staff: (json['staff'] as List)
          .map((e) => MonthlyInventoryDetailsStaff.fromJson(e))
          .toList(),
      products: (json['products'] as List)
          .map((e) => MonthlyInventoryDetailsProduct.fromJson(e))
          .toList(),
      submittedAt: json['submitted_at'],
      approvedAt: json['approved_at'],
      notes: json['notes'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      timelines: TimeLineResponse.fromJson(json),
    );
  }
}

/// ================= BRANCH =================
class MonthlyInventoryDetailsBranch {
  final String id;
  final String name;

  MonthlyInventoryDetailsBranch({required this.id, required this.name});

  factory MonthlyInventoryDetailsBranch.fromJson(Map<String, dynamic> json) {
    return MonthlyInventoryDetailsBranch(id: json['id'], name: json['name']);
  }
}

/// ================= CREATED BY =================
class MonthlyInventoryDetailsCreatedBy {
  final String id;
  final String name;

  MonthlyInventoryDetailsCreatedBy({required this.id, required this.name});

  factory MonthlyInventoryDetailsCreatedBy.fromJson(Map<String, dynamic> json) {
    return MonthlyInventoryDetailsCreatedBy(id: json['id'], name: json['name']);
  }
}

/// ================= STAFF =================
class MonthlyInventoryDetailsStaff {
  final String id;
  final String userId;
  final String userType;
  final String role;
  final String name;
  final int productsCounted;

  MonthlyInventoryDetailsStaff({
    required this.id,
    required this.userId,
    required this.userType,
    required this.role,
    required this.name,
    required this.productsCounted,
  });

  factory MonthlyInventoryDetailsStaff.fromJson(Map<String, dynamic> json) {
    return MonthlyInventoryDetailsStaff(
      id: json['id'],
      userId: json['user_id'],
      userType: json['user_type'],
      role: json['role'],
      name: json['name'],
      productsCounted: json['products_counted'],
    );
  }
}

/// ================= COUNTED BY =================
class MonthlyInventoryCountedBy {
  final String id;
  final String type;
  final String name;

  MonthlyInventoryCountedBy({
    required this.id,
    required this.type,
    required this.name,
  });

  factory MonthlyInventoryCountedBy.fromJson(Map<String, dynamic> json) {
    return MonthlyInventoryCountedBy(
      id: json['id'],
      type: json['type'],
      name: json['name'],
    );
  }
}

/// ================= PRODUCT =================
class MonthlyInventoryDetailsProduct {
  final String id;
  final String itemId;
  final String? purchaseOrderItemId;
  final String itemName;
  final String? itemLogo;
  final String unit;
  final double quantityInventory;
  final double unitPrice;
  final String category;
  final String subcategory;
  final String? countMethod;
  final String preferredCountMethod;
  final dynamic countMetadata;
  final String? handledBy;
  final MonthlyInventoryCountedBy? countedBy;
  final String? lockedAt;
  final String? notes;

  MonthlyInventoryDetailsProduct({
    required this.id,
    required this.itemId,
    this.purchaseOrderItemId,
    required this.itemName,
    required this.itemLogo,
    required this.unit,
    required this.quantityInventory,
    required this.unitPrice,
    required this.category,
    required this.subcategory,
    this.countMethod,
    required this.preferredCountMethod,
    this.countMetadata,
    this.handledBy,
    this.countedBy,
    this.lockedAt,
    this.notes,
  });

  factory MonthlyInventoryDetailsProduct.fromJson(Map<String, dynamic> json) {
    return MonthlyInventoryDetailsProduct(
      id: json['id'],
      itemId: json['item_id'],
      purchaseOrderItemId: json['purchase_order_item_id'],
      itemName: json['item_name'],
      itemLogo: json['item_logo'],
      unit: json['unit'],
      quantityInventory: (json['quantity_inventory'] as num).toDouble(),
      unitPrice: (json['unit_price'] as num).toDouble(),
      category: json['category'],
      subcategory: json['subcategory'],
      countMethod: json['count_method'],
      preferredCountMethod: json['preferred_count_method'],
      countMetadata: json['count_metadata'],
      handledBy: json['handled_by'],
      countedBy: json['counted_by'] != null
          ? MonthlyInventoryCountedBy.fromJson(json['counted_by'])
          : null,
      lockedAt: json['locked_at'],
      notes: json['notes'],
    );
  }
}
