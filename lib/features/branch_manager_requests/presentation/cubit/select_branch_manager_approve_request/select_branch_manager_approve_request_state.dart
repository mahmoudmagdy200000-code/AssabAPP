import 'package:equatable/equatable.dart';

import '../../../../../core/enums/approve_request_type_enum.dart';

class SelectBranchManagerApproveRequestState extends Equatable {
  final ApproveRequestTypeEnum approveRequestType;

  const SelectBranchManagerApproveRequestState({
    this.approveRequestType = ApproveRequestTypeEnum.non,
  });

  SelectBranchManagerApproveRequestState copyWith({
    ApproveRequestTypeEnum? approveRequestType,
  }) {
    return SelectBranchManagerApproveRequestState(
      approveRequestType: approveRequestType ?? this.approveRequestType,
    );
  }

  @override
  List<Object> get props => [approveRequestType];
}
