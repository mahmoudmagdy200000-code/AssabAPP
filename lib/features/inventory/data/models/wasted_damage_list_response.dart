import 'package:assab/core/enums/wasted_problem_type_enum.dart';
import 'package:assab/features/inventory/domain/strategies/daily_inventory_status_strategy.dart';
import 'package:assab/shared/models/meta_model/meta_model.dart';
import 'package:assab/shared/models/time_line_response.dart';

import '../../../../core/enums/daily_inventory_type_enum.dart';
import '../../domain/enums/inventory_status_enum.dart';
import '../../domain/strategies/cause_of_damage_strategy.dart';

class WastedDamageListResponse {
  final List<WastedDamageListEntry> data;
  final MetaModel meta;

  WastedDamageListResponse({required this.data, required this.meta});

  factory WastedDamageListResponse.fromJson(Map<String, dynamic> json) {
    return WastedDamageListResponse(
      data: (json['data'] as List)
          .map((e) => WastedDamageListEntry.fromJson(e))
          .toList(),
      meta: MetaModel.fromJson(json['meta']),
    );
  }
}

class WastedDamageListEntry {
  final String id;
  final WastedProblemTypeEnum reportType;
  final String displayTitle;
  final DailyInventoryStatusStrategy status;
  final String statusLabel;
  final String submissionDate;
  final int itemsCount;
  final bool isEditable;
  final WastedDamageListDetails details;

  WastedDamageListEntry({
    required this.id,
    required this.reportType,
    required this.displayTitle,
    required this.status,
    required this.statusLabel,
    required this.submissionDate,
    required this.itemsCount,
    required this.isEditable,
    required this.details,
  });

  factory WastedDamageListEntry.fromJson(Map<String, dynamic> json) {
    return WastedDamageListEntry(
      id: json['id'],
      reportType: WastedProblemTypeEnum.fromString(
        json['report_type'] as String,
      ),
      displayTitle: json['display_title'],
      status: DailyInventoryStatusStrategy.getStrategy(
        InventoryStatusEnum.fromString(json['status'] as String),
      ),
      statusLabel: json['status_label'],
      submissionDate: json['submission_date'],
      itemsCount: json['items_count'],
      isEditable: json['is_editable'],
      details: WastedDamageListDetails.fromJson(json['details']),
    );
  }
}

class WastedDamageListDetails {
  final String id;
  final String branchId;
  final WastedDamageListBranch branch;
  final String createdBy;
  final WastedDamageListCreator creator;
  final DailyInventoryTypeEnum assignedToType;
  final String? assignedToId;
  final dynamic assignedTo;
  final DailyInventoryStatusStrategy status;
  final String statusLabel;
  final String? submittedAt;
  final String submissionDate;
  final WastedProblemTypeEnum reportType;
  final String displayTitle;
  final int itemsCount;
  final bool isEditable;
  final List<WastedDamageListItem> items;
  final bool isStaffInventored;
  final bool isBranchManagerConfirm;
  final String createdAt;
  final String updatedAt;
  final WastedDamageListAssignmentInformation assignmentInformation;
  final TimeLineResponse timelines;

  WastedDamageListDetails({
    required this.id,
    required this.branchId,
    required this.branch,
    required this.createdBy,
    required this.creator,
    required this.assignedToType,
    required this.assignedToId,
    required this.assignedTo,
    required this.status,
    required this.statusLabel,
    required this.submittedAt,
    required this.submissionDate,
    required this.reportType,
    required this.displayTitle,
    required this.itemsCount,
    required this.isEditable,
    required this.items,
    required this.isStaffInventored,
    required this.isBranchManagerConfirm,
    required this.createdAt,
    required this.updatedAt,
    required this.assignmentInformation,
    required this.timelines,
  });

  factory WastedDamageListDetails.fromJson(Map<String, dynamic> json) {
    return WastedDamageListDetails(
      id: json['id'],
      branchId: json['branch_id'],
      branch: WastedDamageListBranch.fromJson(json['branch']),
      createdBy: json['created_by'],
      creator: WastedDamageListCreator.fromJson(json['creator']),
      assignedToType: DailyInventoryTypeEnum.fromValue(
        json['assigned_to_type'],
      ),
      assignedToId: json['assigned_to_id'],
      assignedTo: json['assigned_to'],
      status: DailyInventoryStatusStrategy.getStrategy(
        InventoryStatusEnum.fromString(json['status'] as String),
      ),
      statusLabel: json['status_label'],
      submittedAt: json['submitted_at'],
      submissionDate: json['submission_date'],
      reportType: WastedProblemTypeEnum.fromString(
        json['report_type'] as String,
      ),
      displayTitle: json['display_title'],
      itemsCount: json['items_count'],
      isEditable: json['is_editable'],
      isStaffInventored: json['isStaffInventored'] ?? false,
      isBranchManagerConfirm: json['isBranchManagerConfirm'] ?? false,
      items: (json['items'] as List)
          .map((e) => WastedDamageListItem.fromJson(e))
          .toList(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      assignmentInformation: WastedDamageListAssignmentInformation.fromJson(
        json['assignment_information'],
      ),
      timelines: TimeLineResponse.fromJson(json),
    );
  }
}

class WastedDamageListBranch {
  final String id;
  final String name;
  final String location;

  WastedDamageListBranch({
    required this.id,
    required this.name,
    required this.location,
  });

  factory WastedDamageListBranch.fromJson(Map<String, dynamic> json) {
    return WastedDamageListBranch(
      id: json['id'],
      name: json['name'],
      location: json['location'],
    );
  }
}

class WastedDamageListCreator {
  final String id;
  final String name;
  final String role;

  WastedDamageListCreator({
    required this.id,
    required this.name,
    required this.role,
  });

  factory WastedDamageListCreator.fromJson(Map<String, dynamic> json) {
    return WastedDamageListCreator(
      id: json['id'],
      name: json['name'],
      role: json['role'],
    );
  }
}

class WastedDamageListItem {
  final String id;
  final String wasteDamageReportId;
  final String branchId;
  final String itemId;
  final String purchaseOrderItemId;

  final String productName;

  final WastedProblemTypeEnum problemType;
  final String problemTypeLabel;

  final CauseOfDamageStrategy? causeOfDamage;
  final String? causeOfDamageLabel;
  final String? responsibility;

  final double quantity;
  final double quantityWasted;

  final String reason;
  final String reasonLabel;

  final String unit;

  final double totalValue;
  final double pricePerUnit;

  final String? justificationText;
  final String? justificationNote;

  final String? photoPath;
  final String? photoUrl;
  final String? explanatoryPhotoUrl;
  final String? explanatoryPhotoWarning;

  final List<WastedDamageListResponsibleEmployee> responsibleEmployees;

  final WastedDamageListItemDetails item;

  final String createdAt;
  final String updatedAt;

  WastedDamageListItem({
    required this.id,
    required this.wasteDamageReportId,
    required this.branchId,
    required this.itemId,
    required this.purchaseOrderItemId,
    required this.productName,
    required this.problemType,
    required this.problemTypeLabel,
    required this.causeOfDamage,
    required this.causeOfDamageLabel,
    required this.responsibility,
    required this.quantity,
    required this.quantityWasted,
    required this.reason,
    required this.reasonLabel,
    required this.unit,
    required this.totalValue,
    required this.pricePerUnit,
    required this.justificationText,
    required this.justificationNote,
    required this.photoPath,
    required this.photoUrl,
    required this.explanatoryPhotoUrl,
    required this.explanatoryPhotoWarning,
    required this.responsibleEmployees,
    required this.item,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WastedDamageListItem.fromJson(Map<String, dynamic> json) {
    return WastedDamageListItem(
      id: json['id'],
      wasteDamageReportId: json['waste_damage_report_id'],
      branchId: json['branch_id'],
      itemId: json['item_id'],
      purchaseOrderItemId: json['purchase_order_item_id'],
      productName: json['product_name'],
      problemType: WastedProblemTypeEnum.fromString(
        json['problem_type'] as String,
      ),
      problemTypeLabel: json['problem_type_label'],
      causeOfDamage: json['cause_of_damage'] == null
          ? null
          : CauseOfDamageStrategy.getStrategy(
              json['cause_of_damage'] as String,
            ),
      causeOfDamageLabel: json['cause_of_damage_label'],
      responsibility: json['responsibility'],
      quantity: (json['quantity'] as num).toDouble(),
      quantityWasted: (json['quantity_wasted'] as num).toDouble(),
      reason: json['reason'],
      reasonLabel: json['reason_label'],
      unit: json['unit'] as String,
      totalValue: (json['total_value'] as num).toDouble(),
      pricePerUnit: (json['price_per_unit'] as num).toDouble(),
      justificationText: json['justification_text'],
      justificationNote: json['justification_note'],
      photoPath: json['photo_path'],
      photoUrl: json['photo_url'],
      explanatoryPhotoUrl: json['explanatory_photo_url'],
      explanatoryPhotoWarning: json['explanatory_photo_warning'],
      responsibleEmployees: (json['responsible_employees'] as List)
          .map((e) => WastedDamageListResponsibleEmployee.fromJson(e))
          .toList(),
      item: WastedDamageListItemDetails.fromJson(json['item']),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class WastedDamageListResponsibleEmployee {
  final String id;
  final double quantityAccountable;
  final String employeeName;

  WastedDamageListResponsibleEmployee({
    required this.id,
    required this.quantityAccountable,
    required this.employeeName,
  });

  factory WastedDamageListResponsibleEmployee.fromJson(
    Map<String, dynamic> json,
  ) {
    return WastedDamageListResponsibleEmployee(
      id: json['id'],
      quantityAccountable: (json['quantity_accountable'] as num).toDouble(),
      employeeName: json['employee_name'],
    );
  }
}

class WastedDamageListItemDetails {
  final String id;
  final String name;
  final String unit;

  WastedDamageListItemDetails({
    required this.id,
    required this.name,
    required this.unit,
  });

  factory WastedDamageListItemDetails.fromJson(Map<String, dynamic> json) {
    return WastedDamageListItemDetails(
      id: json['id'],
      name: json['name'],
      unit: json['unit'] as String,
    );
  }
}

class WastedDamageListAssignmentInformation {
  final String assignedByName;
  final String assignedByRole;
  final String responsibility;
  final String timing;
  final String review;
  final String reminder;

  WastedDamageListAssignmentInformation({
    required this.assignedByName,
    required this.assignedByRole,
    required this.responsibility,
    required this.timing,
    required this.review,
    required this.reminder,
  });

  factory WastedDamageListAssignmentInformation.fromJson(
    Map<String, dynamic> json,
  ) {
    return WastedDamageListAssignmentInformation(
      assignedByName: json['assigned_by_name'],
      assignedByRole: json['assigned_by_role'],
      responsibility: json['responsibility'],
      timing: json['timing'],
      review: json['review'],
      reminder: json['reminder'],
    );
  }
}
