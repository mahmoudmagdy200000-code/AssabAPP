import '../../features/returns_management/domain/strategies/item_return_status_strategy.dart';

enum ItemReturnStatusEnum {
  pending('pending'),
  approved('approved'),
  rejected('rejected'),
  escalated('escalated'),
  escalatedResolved('escalated_resolved'),
  escalatedRejected('escalated_rejected'),
  closed('closed');

  final String _value;

  const ItemReturnStatusEnum(this._value);

  String get value => _value;

  static ItemReturnStatusEnum fromString(String status) {
    return ItemReturnStatusEnum.values.firstWhere(
      (e) => e.value.toLowerCase() == status.toLowerCase(),
      orElse: () => ItemReturnStatusEnum.pending,
    );
  }

  ItemReturnStatusStrategy get strategy {
    switch (this) {
      case ItemReturnStatusEnum.pending:
        return PendingItemReturnStatusStrategy();
      case ItemReturnStatusEnum.approved:
        return ApprovedItemReturnStatusStrategy();
      case ItemReturnStatusEnum.rejected:
        return RejectItemReturnStatusStrategy();
      case ItemReturnStatusEnum.escalated:
        return PendingResolutionItemReturnStatusStrategy();
      case ItemReturnStatusEnum.escalatedResolved:
        return ResolvedByBrandManagerItemReturnStatusStrategy();
      case ItemReturnStatusEnum.escalatedRejected:
        return RejectedByBrandManagerItemReturnStatusStrategy();
      case ItemReturnStatusEnum.closed:
        return ClosedItemReturnStatusStrategy();
    }
  }
}
