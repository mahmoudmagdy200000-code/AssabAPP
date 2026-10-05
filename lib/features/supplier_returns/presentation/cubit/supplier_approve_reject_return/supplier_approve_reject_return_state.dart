import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

sealed class SupplierApproveRejectReturnState extends Equatable {
  const SupplierApproveRejectReturnState();

  @override
  List<Object> get props => [];
}

final class SupplierApproveRejectReturnInit
    extends SupplierApproveRejectReturnState {
  const SupplierApproveRejectReturnInit();
}

final class SupplierApproveRejectReturnLoading
    extends SupplierApproveRejectReturnState {
  const SupplierApproveRejectReturnLoading();
}

final class SupplierApproveRejectReturnSuccess
    extends SupplierApproveRejectReturnState {
  const SupplierApproveRejectReturnSuccess();
}

final class SupplierApproveRejectReturnFailure
    extends SupplierApproveRejectReturnState {
  final ApiFailure failure;

  const SupplierApproveRejectReturnFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
