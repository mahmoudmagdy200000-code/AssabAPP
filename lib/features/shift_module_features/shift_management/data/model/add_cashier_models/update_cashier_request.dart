class UpdateCashierRequest {
  final String? name;
  final String? email;
  final String? storeBranchId;
  final String? status;
  final List<String>? shiftIds;

  UpdateCashierRequest({
    this.name,
    this.email,
    this.storeBranchId,
    this.status,
    this.shiftIds,
  });

  Map<String, dynamic> toForm() => {
    if (name != null) 'name': name,
    if (email != null) 'email': email,
    if (storeBranchId != null) 'store_branch_id': storeBranchId,
    if (status != null) 'status': status,
    if (shiftIds?.isNotEmpty == true) 'shift_ids': shiftIds,
  };
}
