import '../../features/supplier_returns/domain/strategies/supplier_returns_status_strategy.dart';

enum SupplierReturnsStatusEnum {
  pending('pending'),
  approved('approved'),
  rejected('rejected'),
  escalated('escalated'),
  escalatedResolved('escalated_resolved'),
  escalatedRejected('escalated_rejected'),
  closed('closed');

  final String _value;

  const SupplierReturnsStatusEnum(this._value);

  String get value => _value;

  static SupplierReturnsStatusEnum fromString(String status) {
    return SupplierReturnsStatusEnum.values.firstWhere(
      (e) => e.value.toLowerCase() == status.toLowerCase(),
      orElse: () => SupplierReturnsStatusEnum.pending,
    );
  }

  SupplierReturnsStatusStrategy get strategy {
    switch (this) {
      case SupplierReturnsStatusEnum.pending:
        return PendingSupplierReturnsStatusStrategy();
      case SupplierReturnsStatusEnum.approved:
        return ApprovedSupplierReturnsStatusStrategy();
      case SupplierReturnsStatusEnum.rejected:
        return RejectSupplierReturnsStatusStrategy();
      case SupplierReturnsStatusEnum.escalated:
        return PendingResolutionSupplierReturnsStatusStrategy();
      case SupplierReturnsStatusEnum.escalatedResolved:
        return ResolvedByBrandManagerSupplierReturnsStatusStrategy();
      case SupplierReturnsStatusEnum.escalatedRejected:
        return RejectedByBrandManagerSupplierReturnsStatusStrategy();
      case SupplierReturnsStatusEnum.closed:
        return ClosedSupplierReturnsStatusStrategy();
    }
  }
}
