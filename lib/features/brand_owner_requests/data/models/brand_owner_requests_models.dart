import 'package:assab/core/enums/custody_requests_status_enum.dart';
import 'package:assab/core/utils/date_formatter.dart';
import 'package:assab/shared/models/meta_model/meta_model.dart';
import 'package:assab/shared/models/time_line_response.dart';
import 'package:equatable/equatable.dart';

import '../../../../shared/models/cancel_reason/cancel_reason_in_order_response.dart';
import '../../../../shared/models/cancel_reason/cancel_reason_response.dart';

class BrandOwnerRequestsCustodySalesTransfersResponse extends Equatable {
  final List<BrandOwnerSalesTransferItemModel> data;
  final MetaModel meta;

  const BrandOwnerRequestsCustodySalesTransfersResponse({
    required this.data,
    required this.meta,
  });

  @override
  List<Object> get props => [data, meta];

  factory BrandOwnerRequestsCustodySalesTransfersResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return BrandOwnerRequestsCustodySalesTransfersResponse(
      data: (json['data']['data'] as List? ?? [])
          .map((e) => BrandOwnerSalesTransferItemModel.fromJson(e))
          .toList(),
      meta: MetaModel.fromJson(json['data']['meta'] as Map<String, dynamic>),
    );
  }
}

class BrandOwnerSalesTransferItemModel extends Equatable {
  final String id;
  final String submittedBy;
  final num amount;
  final String dateTime;
  final CustodyRequestsStatusEnum status;

  const BrandOwnerSalesTransferItemModel({
    required this.id,
    required this.submittedBy,
    required this.amount,
    required this.dateTime,
    required this.status,
  });

  @override
  List<Object> get props => [id, submittedBy, amount, dateTime, status];

  factory BrandOwnerSalesTransferItemModel.fromJson(Map<String, dynamic> json) {
    return BrandOwnerSalesTransferItemModel(
      id: json['id'] as String,
      submittedBy: json['submittedBy'] as String,
      amount: (json['amount'] as num),
      dateTime: json['dateTime'] as String,
      status: CustodyRequestsStatusEnum.fromValue(json['status'] as String),
    );
  }
}

class BrandOwnerSalesTransferDetailsModel {
  final String requestId;
  final CustodyRequestsStatusEnum status;
  final BrandOwnerSalesTransferDetailsSummaryModel summary;
  final BrandOwnerSalesTransferDetailsSenderModel sender;
  final TimeLineResponse timelines;
  final CancelReasonResponse? cancelReason;
  final List<BrandOwnerSalesTransferApproverModel> approvers;

  const BrandOwnerSalesTransferDetailsModel({
    required this.requestId,
    required this.status,
    required this.summary,
    required this.sender,
    required this.timelines,
    this.cancelReason,
    required this.approvers,
  });

  factory BrandOwnerSalesTransferDetailsModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data'] as Map<String, dynamic>;

    return BrandOwnerSalesTransferDetailsModel(
      requestId: data['requestId'] as String,
      status: CustodyRequestsStatusEnum.fromValue(data['status'] as String),
      summary: BrandOwnerSalesTransferDetailsSummaryModel.fromJson(
        data['summary'] as Map<String, dynamic>,
      ),
      sender: BrandOwnerSalesTransferDetailsSenderModel.fromJson(
        data['senderDetails'] as Map<String, dynamic>,
      ),
      timelines: TimeLineResponse.fromJson(data),
      cancelReason: data['cancellation'] == null
          ? null
          : CancelReasonInOrderResponse.fromJson(
              data['cancellation'] as Map<String, dynamic>,
            ).toCancelReasonResponse(),
      approvers: (data['approval'] as List? ?? [])
          .map((e) => BrandOwnerSalesTransferApproverModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'requestId': requestId,
      'status': status.value,
      'summary': summary.toJson(),
      'sender': sender.toJson(),
      'timelines': {
        'timelines': timelines.timelines.map((t) => t.toJson()).toList(),
      },
      'approvers': approvers.map((a) => a.toJson()).toList(),
    };
  }
}

class BrandOwnerSalesTransferDetailsSummaryModel extends Equatable {
  final String transferFrom;
  final String recipientName;
  final num handoverAmount;
  final String handoverMethod;
  final String handoverDate;

  const BrandOwnerSalesTransferDetailsSummaryModel({
    required this.transferFrom,
    required this.recipientName,
    required this.handoverAmount,
    required this.handoverMethod,
    required this.handoverDate,
  });

  @override
  List<Object> get props => [
    transferFrom,
    recipientName,
    handoverAmount,
    handoverMethod,
    handoverDate,
  ];

  factory BrandOwnerSalesTransferDetailsSummaryModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return BrandOwnerSalesTransferDetailsSummaryModel(
      transferFrom: json['transferFrom'] as String,
      recipientName: json['recipient'] as String,
      handoverAmount: (json['handOverAmount'] as num),
      handoverMethod: json['handoverMethod'] as String,
      handoverDate:
          DateFormatter.formatDateMDY(
            DateTime.tryParse(json['handoverDate'] as String),
          ) ??
          '-',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transferFrom': transferFrom,
      'recipientName': recipientName,
      'handoverAmount': handoverAmount,
      'handoverMethod': handoverMethod,
      'handoverDate': handoverDate,
    };
  }
}

class BrandOwnerSalesTransferDetailsSenderModel extends Equatable {
  final String name;
  final String? image;
  final String branchName;

  const BrandOwnerSalesTransferDetailsSenderModel({
    required this.name,
    required this.image,
    required this.branchName,
  });

  @override
  List<Object?> get props => [name, image, branchName];

  factory BrandOwnerSalesTransferDetailsSenderModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return BrandOwnerSalesTransferDetailsSenderModel(
      name: json['name'] as String,
      image: json['image'] as String?,
      branchName: json['branchName'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'image': image, 'branchName': branchName};
  }
}

class BrandOwnerSalesTransferApproverModel extends Equatable {
  final String id;
  final String name;
  final String role;
  final String? imageUrl;
  final CustodyRequestsStatusEnum status;

  const BrandOwnerSalesTransferApproverModel({
    required this.id,
    required this.name,
    required this.role,
    this.imageUrl,
    required this.status,
  });

  @override
  List<Object?> get props => [id, name, role, imageUrl, status];

  factory BrandOwnerSalesTransferApproverModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return BrandOwnerSalesTransferApproverModel(
      id: json['id'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
      imageUrl: json['imageUrl'] as String?,
      status: CustodyRequestsStatusEnum.fromValue(json['status'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'imageUrl': imageUrl,
      'status': status.value,
    };
  }
}

class BrandOwnerPaymentLogFilterQuery extends Equatable {
  final String? type;
  final String? sortByDate;
  final String? branchId;

  const BrandOwnerPaymentLogFilterQuery({
    this.type,
    this.sortByDate,
    this.branchId,
  });

  bool get isEmpty => type == null && sortByDate == null && branchId == null;

  @override
  List<Object?> get props => [type, sortByDate, branchId];

  factory BrandOwnerPaymentLogFilterQuery.fromJson(Map<String, dynamic> json) {
    return BrandOwnerPaymentLogFilterQuery(
      type: json['type'] as String?,
      sortByDate: json['sortByDate'] as String?,
      branchId: json['branchId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'type': type, 'sortByDate': sortByDate, 'branchId': branchId};
  }
}

class BrandOwnerPaymentLogResponse extends Equatable {
  final BrandOwnerPaymentLogSummaryModel summary;
  final List<BrandOwnerPaymentLogItemModel> data;
  final MetaModel meta;

  const BrandOwnerPaymentLogResponse({
    required this.summary,
    required this.data,
    required this.meta,
  });

  @override
  List<Object> get props => [summary, data];

  factory BrandOwnerPaymentLogResponse.fromJson(Map<String, dynamic> json) {
    return BrandOwnerPaymentLogResponse(
      summary: BrandOwnerPaymentLogSummaryModel.fromJson(
        json['data']['summary'] as Map<String, dynamic>,
      ),
      data: (json['data']['data'] as List? ?? [])
          .map((e) => BrandOwnerPaymentLogItemModel.fromJson(e))
          .toList(),
      meta: MetaModel.fromJson(json['data']['meta'] as Map<String, dynamic>),
    );
  }
}

class BrandOwnerPaymentLogSummaryModel extends Equatable {
  final num totalCashIn;
  final num totalCashOut;

  const BrandOwnerPaymentLogSummaryModel({
    required this.totalCashIn,
    required this.totalCashOut,
  });

  @override
  List<Object> get props => [totalCashIn, totalCashOut];

  factory BrandOwnerPaymentLogSummaryModel.fromJson(Map<String, dynamic> json) {
    return BrandOwnerPaymentLogSummaryModel(
      totalCashIn: (json['totalCashIn'] as num),
      totalCashOut: (json['totalCashOut'] as num),
    );
  }

  Map<String, dynamic> toJson() {
    return {'totalCashIn': totalCashIn, 'totalCashOut': totalCashOut};
  }
}

class BrandOwnerPaymentLogItemModel extends Equatable {
  final String id;
  final String title;
  final String branchName;
  final num amount;
  final String dateTime;
  final bool isIncome;
  final String methodLabel;
  final String submittedBy;

  const BrandOwnerPaymentLogItemModel({
    required this.id,
    required this.title,
    required this.branchName,
    required this.amount,
    required this.dateTime,
    required this.isIncome,
    required this.methodLabel,
    required this.submittedBy,
  });

  @override
  List<Object> get props => [
    id,
    title,
    branchName,
    amount,
    dateTime,
    isIncome,
    methodLabel,
    submittedBy,
  ];

  factory BrandOwnerPaymentLogItemModel.fromJson(Map<String, dynamic> json) {
    return BrandOwnerPaymentLogItemModel(
      id: json['id'] as String,
      title: json['title'] as String,
      branchName: json['branchName'] as String? ?? '-',
      amount: (json['amount'] as num),
      dateTime: json['dateTime'] as String,
      isIncome: json['isIncome'] as bool,
      methodLabel: json['methodLabel'] as String? ?? '-',
      submittedBy: json['submittedBy'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'branchName': branchName,
      'amount': amount,
      'dateTime': dateTime,
      'isIncome': isIncome,
      'methodLabel': methodLabel,
      'submittedBy': submittedBy,
    };
  }
}

class BrandOwnerPaymentLogDetailsModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final num amount;
  final String branchName;
  final String managerName;
  final String dateTime;
  final String methodLabel;
  final bool isIncome;

  const BrandOwnerPaymentLogDetailsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.branchName,
    required this.managerName,
    required this.dateTime,
    required this.methodLabel,
    required this.isIncome,
  });

  @override
  List<Object> get props => [
    id,
    title,
    description,
    amount,
    branchName,
    managerName,
    dateTime,
    methodLabel,
    isIncome,
  ];

  factory BrandOwnerPaymentLogDetailsModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;

    return BrandOwnerPaymentLogDetailsModel(
      id: data['id'] as String,
      title: data['title'] as String,
      description: data['description'] as String,
      amount: (data['amount'] as num),
      branchName: data['branchName'] as String,
      managerName: data['managerName'] as String,
      dateTime: data['dateTime'] as String,
      methodLabel: data['methodLabel'] as String,
      isIncome: data['isIncome'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'amount': amount,
      'branchName': branchName,
      'managerName': managerName,
      'dateTime': dateTime,
      'methodLabel': methodLabel,
      'isIncome': isIncome,
    };
  }
}

class BrandOwnerPaymentLogBranchModel extends Equatable {
  final List<BrandOwnerPaymentLogBranchItem> branches;

  const BrandOwnerPaymentLogBranchModel({required this.branches});

  @override
  List<Object> get props => [branches];

  factory BrandOwnerPaymentLogBranchModel.fromJson(Map<String, dynamic> json) {
    final branches = (json['data']['branches'] as List)
        .map(
          (e) => BrandOwnerPaymentLogBranchItem.fromJson(
            e as Map<String, dynamic>,
          ),
        )
        .toList();

    return BrandOwnerPaymentLogBranchModel(branches: branches);
  }
}

class BrandOwnerPaymentLogBranchItem extends Equatable {
  final String id;
  final String name;
  final String managerName;

  const BrandOwnerPaymentLogBranchItem({
    required this.id,
    required this.name,
    required this.managerName,
  });

  @override
  List<Object> get props => [id, name, managerName];

  factory BrandOwnerPaymentLogBranchItem.fromJson(Map<String, dynamic> json) {
    return BrandOwnerPaymentLogBranchItem(
      id: json['id'] as String,
      name: json['name'] as String,
      managerName: json['managerName'] as String,
    );
  }
}
