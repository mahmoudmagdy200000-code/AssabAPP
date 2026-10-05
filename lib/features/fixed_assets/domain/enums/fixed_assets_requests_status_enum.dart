enum FixedAssetsRequestsStatusEnum {
  pending('pending'),
  pendingFinalApproval('pending_final_approval'),
  rejected('rejected'),
  approved('approved');

  final String _value;

  const FixedAssetsRequestsStatusEnum(this._value);

  String get value => _value;
}
