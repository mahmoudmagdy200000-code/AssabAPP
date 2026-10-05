import 'package:assab/features/branch_manager_expenses/data/models/expense_type_model.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../shared/models/time_line_response.dart';
import '../../domain/entities/pre_approval_entity.dart';
import 'pre_approval_data_model.dart';
import 'supplier_model.dart';

part 'pre_approval_response_model.g.dart';

@JsonSerializable(createToJson: false)
class PreApprovalResponseModel {
  final PreApprovalDataModel? data;

  PreApprovalResponseModel({this.data});

  factory PreApprovalResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PreApprovalResponseModelFromJson(json);

  PreApprovalEntity toEntity() {
    return PreApprovalEntity(
      id: data?.id ?? '0',
      status: data?.status?.label ?? 'N/A',
      estimatedAmount: data?.data?.estimatedAmount?.toString() ?? 'N/A',
      paymentMethod: data?.paymentMethod ?? 'N/A',
      paymentSupplier:
          data?.paymentSupplier ?? const SupplierModel(id: '0', name: 'N/A'),
      expenseType:
          data?.expenseType ?? ExpenseTypeModel(value: 'N/A', label: 'N/A'),
      createdAt: data?.createdAt ?? 'N/A',
      attachments: data?.attachments ?? [],
      purpose: data?.data?.purpose ?? 'N/A',
      expenses: data?.data?.expenses ?? [],
      items: data?.data?.items ?? [],
      priority:
          data?.data?.priority ??
          PreApprovalPriorityModel(value: 'N/A', label: 'N/A'),
      timelines: data?.timelines ?? const TimeLineResponse(timelines: []),
      cancelReason: data?.cancelReason,
      approval: data?.approval,
    );
  }
}
