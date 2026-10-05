import '../../../../core/enums/requests_order_status_enum.dart';
import '../../../../core/enums/supplier_returns_status_enum.dart';
import '../../../../core/strategies/requests_order_status_strategy.dart';
import '../../../../shared/models/branch_details_response.dart';
import '../../../../shared/models/branch_manager_details_response.dart';
import '../../../../shared/models/cancel_reason/cancel_reason_in_order_response.dart';
import '../../../../shared/models/time_line_response.dart';
import '../../../branch_manager_expenses/data/models/attachment_model.dart';
import '../../domain/strategies/supplier_returns_status_strategy.dart';

class SupplierReturnGoodsDetailsResponse {
  final SupplierReturnGoodsDetailsData data;

  SupplierReturnGoodsDetailsResponse({required this.data});

  factory SupplierReturnGoodsDetailsResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return SupplierReturnGoodsDetailsResponse(
      data: SupplierReturnGoodsDetailsData.fromJson(json['data']),
    );
  }
}

/* ======================= DATA ======================= */

class SupplierReturnGoodsDetailsData {
  final String id;
  final String returnNumber;
  final DateTime returnDate;
  final SupplierReturnsStatusStrategy status;
  final String statusLabel;
  final String statusColor;
  final String requiredAction;
  final String requiredActionLabel;
  final num totalReturnAmount;
  final num? refundAmount;
  final String? refundMethod;
  final String? additionalNotes;
  final String? responseNotes;
  final List<String>? responseFiles;
  final DateTime? respondedAt;
  final String? rejectionReason;
  final DateTime? rejectedAt;
  final CancelReasonInOrderResponse? cancellation;
  final bool isEscalated;
  final String? escalationReason;
  final DateTime? escalatedAt;
  final String? resolutionType;
  final String? resolutionNotes;
  final DateTime? resolvedAt;
  final DateTime submittedAt;
  final DateTime? approvedAt;
  final DateTime? closedAt;
  final DateTime createdAt;
  final bool isDraft;
  final bool isPending;
  final bool isCompleted;
  final SupplierReturnGoodsDetailsPurchaseOrder purchaseOrder;
  final BranchDetailsResponse branch;
  final BranchManagerDetailsResponse branchManager;
  final List<SupplierReturnGoodsDetailsItem> items;
  final TimeLineResponse timelines;

  SupplierReturnGoodsDetailsData({
    required this.id,
    required this.returnNumber,
    required this.returnDate,
    required this.status,
    required this.statusLabel,
    required this.statusColor,
    required this.requiredAction,
    required this.requiredActionLabel,
    required this.totalReturnAmount,
    this.refundAmount,
    this.refundMethod,
    this.additionalNotes,
    this.responseNotes,
    this.responseFiles,
    this.respondedAt,
    this.rejectionReason,
    this.rejectedAt,
    required this.isEscalated,
    required this.cancellation,
    this.escalationReason,
    this.escalatedAt,
    this.resolutionType,
    this.resolutionNotes,
    this.resolvedAt,
    required this.submittedAt,
    this.approvedAt,
    this.closedAt,
    required this.createdAt,
    required this.isDraft,
    required this.isPending,
    required this.isCompleted,
    required this.purchaseOrder,
    required this.branch,
    required this.branchManager,
    required this.items,
    required this.timelines,
  });

  factory SupplierReturnGoodsDetailsData.fromJson(Map<String, dynamic> json) {
    return SupplierReturnGoodsDetailsData(
      id: json['id'],
      returnNumber: json['return_number'],
      returnDate: DateTime.parse(json['return_date']),
      status: SupplierReturnsStatusEnum.fromString(json['status']).strategy,
      statusLabel: json['status_label'],
      statusColor: json['status_color'],
      requiredAction: json['required_action'],
      requiredActionLabel: json['required_action_label'],
      totalReturnAmount: json['total_return_amount'],
      refundAmount: json['refund_amount'],
      refundMethod: json['refund_method'],
      additionalNotes: json['additional_notes'],
      responseNotes: json['response_notes'],
      responseFiles: json['response_files'] == null
          ? null
          : List<String>.from(json['response_files']),
      respondedAt: json['responded_at'] == null
          ? null
          : DateTime.parse(json['responded_at']),
      rejectionReason: json['rejection_reason'],
      rejectedAt: json['rejected_at'] == null
          ? null
          : DateTime.parse(json['rejected_at']),
      isEscalated: json['is_escalated'],
      cancellation: json['cancellation'] == null
          ? null
          : CancelReasonInOrderResponse.fromJson(json['cancellation']),
      escalationReason: json['escalation_reason'],
      escalatedAt: json['escalated_at'] == null
          ? null
          : DateTime.parse(json['escalated_at']),
      resolutionType: json['resolution_type'],
      resolutionNotes: json['resolution_notes'],
      resolvedAt: json['resolved_at'] == null
          ? null
          : DateTime.parse(json['resolved_at']),
      submittedAt: DateTime.parse(json['submitted_at']),
      approvedAt: json['approved_at'] == null
          ? null
          : DateTime.parse(json['approved_at']),
      closedAt: json['closed_at'] == null
          ? null
          : DateTime.parse(json['closed_at']),
      createdAt: DateTime.parse(json['created_at']),
      isDraft: json['is_draft'],
      isPending: json['is_pending'],
      isCompleted: json['is_completed'],
      purchaseOrder: SupplierReturnGoodsDetailsPurchaseOrder.fromJson(
        json['purchase_order'],
      ),
      branch: BranchDetailsResponse.fromJson(json['branch']),
      branchManager: BranchManagerDetailsResponse.fromJson(
        json['branch_manager'],
      ),
      items: (json['items'] as List)
          .map((e) => SupplierReturnGoodsDetailsItem.fromJson(e))
          .toList(),
      timelines: TimeLineResponse.fromJson(json),
    );
  }
}

/* ======================= PURCHASE ORDER ======================= */

class SupplierReturnGoodsDetailsPurchaseOrder {
  final String id;
  final String orderNumber;
  final RequestsOrderStatusStrategy status;
  final String statusLabel;

  SupplierReturnGoodsDetailsPurchaseOrder({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.statusLabel,
  });

  factory SupplierReturnGoodsDetailsPurchaseOrder.fromJson(
    Map<String, dynamic> json,
  ) {
    return SupplierReturnGoodsDetailsPurchaseOrder(
      id: json['id'],
      orderNumber: json['order_number'],
      status: RequestsOrderStatusEnum.getStatusStrategy(
        RequestsOrderStatusEnum.fromString(json['status']),
      ),
      statusLabel: json['status_label'],
    );
  }
}

/* ======================= ITEMS ======================= */

class SupplierReturnGoodsDetailsItem {
  final String id;
  final String itemName;
  final String? itemLogo;
  final num returnQuantity;
  final String unitOfMeasurement;
  final String qualityReason;
  final String qualityReasonLabel;
  final num unitPrice;
  final num returnAmount;
  final List<AttachmentModel> files;
  final String? notes;

  SupplierReturnGoodsDetailsItem({
    required this.id,
    required this.itemName,
    this.itemLogo,
    required this.returnQuantity,
    required this.unitOfMeasurement,
    required this.qualityReason,
    required this.qualityReasonLabel,
    required this.unitPrice,
    required this.returnAmount,
    required this.files,
    this.notes,
  });

  factory SupplierReturnGoodsDetailsItem.fromJson(Map<String, dynamic> json) {
    return SupplierReturnGoodsDetailsItem(
      id: json['id'],
      itemName: json['item_name'],
      itemLogo: json['item_logo'],
      returnQuantity: json['return_quantity'],
      unitOfMeasurement: json['unit_of_measurement'],
      qualityReason: json['quality_reason'],
      qualityReasonLabel: json['quality_reason_label'],
      unitPrice: json['unit_price'],
      returnAmount: json['return_amount'],
      files: (json['files'] as List)
          .map((e) => AttachmentModel.fromJson(e))
          .toList(),
      notes: json['notes'],
    );
  }
}
