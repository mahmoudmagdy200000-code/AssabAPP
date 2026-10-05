part of 'inventory_approve_reject_staff_submition_cubit.dart';

sealed class InventoryApproveRejectStaffSubmitionState extends Equatable {
  const InventoryApproveRejectStaffSubmitionState();

  @override
  List<Object> get props => [];
}

final class InventoryApproveRejectStaffSubmitionInitial
    extends InventoryApproveRejectStaffSubmitionState {
  const InventoryApproveRejectStaffSubmitionInitial();
}

final class InventoryApproveRejectStaffSubmitionLoading
    extends InventoryApproveRejectStaffSubmitionState {
  const InventoryApproveRejectStaffSubmitionLoading();
}

final class InventoryApproveRejectStaffSubmitionSuccess
    extends InventoryApproveRejectStaffSubmitionState {
  const InventoryApproveRejectStaffSubmitionSuccess();
}

final class InventoryApproveRejectStaffSubmitionFailure
    extends InventoryApproveRejectStaffSubmitionState {
  final ApiFailure failure;

  const InventoryApproveRejectStaffSubmitionFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
