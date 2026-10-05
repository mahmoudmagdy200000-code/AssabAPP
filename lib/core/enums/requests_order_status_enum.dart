import '../strategies/requests_order_status_strategy.dart';

enum RequestsOrderStatusEnum {
  pending('pending'),
  rejected('rejected'),
  partialApproved('partial_approved'),
  fullyApproved('fully_approved'),
  confirmed('confirmed'),
  partialConfirmed('partial_confirmation'),
  confirmedNeedTime('confirmed_need_time'),
  confirmedAlternativeProduct('confirmed_alternative_product'),
  needsApprovalSupplier('needs_approval_supplier'),
  needsApprovalBranch('needs_approval_branch'),
  canceled('cancelled'),
  cancelledByBranch('cancelled_by_branch'),
  cancelledBySupplier('cancelled_by_supplier'),
  canceledModification('cancelled_modification'),
  preparing('preparing'),
  onTheWay('on_the_way'),
  delivered('delivered'),
  delayed('delayed'),
  delayedApproved('delayed_confirmed'),
  delayedRejected('delayed_canceled'),
  close('closed'),
  variance('variance'),
  emergency('emergency'),
  draft('draft');

  final String _value;

  const RequestsOrderStatusEnum(this._value);

  String get value => _value;

  static RequestsOrderStatusEnum fromString(String status) {
    return RequestsOrderStatusEnum.values.firstWhere(
      (e) => e.value.toLowerCase() == status.toLowerCase(),
      orElse: () => pending,
    );
  }

  static RequestsOrderStatusStrategy getStatusStrategy(
    RequestsOrderStatusEnum status,
  ) {
    switch (status) {
      case RequestsOrderStatusEnum.pending:
        return PendingStatusStrategyImpl();
      case RequestsOrderStatusEnum.rejected:
        return RejectedStatusStrategyImpl();
      case RequestsOrderStatusEnum.partialApproved:
        return PartialApprovedStatusStrategyImpl();
      case RequestsOrderStatusEnum.fullyApproved:
        return FullyApprovedStatusStrategyImpl();
      case RequestsOrderStatusEnum.draft:
        return DraftStatusStrategyImpl();
      case RequestsOrderStatusEnum.confirmed:
        return ConfirmedStatusStrategyImpl();
      case RequestsOrderStatusEnum.partialConfirmed:
        return PartialConfirmedStatusStrategyImpl();
      case RequestsOrderStatusEnum.close:
        return CloseStatusStrategyImpl();
      case RequestsOrderStatusEnum.canceled:
        return CanceledStatusStrategyImpl();
      case RequestsOrderStatusEnum.cancelledByBranch:
        return CanceledByBranchStatusStrategyImpl();
      case RequestsOrderStatusEnum.cancelledBySupplier:
        return CanceledBySupplierStatusStrategyImpl();
      case RequestsOrderStatusEnum.needsApprovalSupplier:
        return NeedsApprovalSupplierStatusStrategyImpl();
      case RequestsOrderStatusEnum.needsApprovalBranch:
        return NeedsApprovalBranchStatusStrategyImpl();
      case RequestsOrderStatusEnum.confirmedNeedTime:
        return ConfirmedNeedTimeStatusStrategyImpl();
      case RequestsOrderStatusEnum.confirmedAlternativeProduct:
        return ConfirmedAlternativeProductStatusStrategyImpl();
      case RequestsOrderStatusEnum.canceledModification:
        return CanceledModificationStatusStrategyImpl();
      case RequestsOrderStatusEnum.preparing:
        return PreparingStatusStrategyImpl();
      case RequestsOrderStatusEnum.onTheWay:
        return OutForDeliveryStatusStrategyImpl();
      case RequestsOrderStatusEnum.delivered:
        return DeliveredStatusStrategyImpl();
      case RequestsOrderStatusEnum.delayed:
        return DelayedStatusStrategyImpl();
      case RequestsOrderStatusEnum.delayedApproved:
        return DelayedApprovedStatusStrategyImpl();
      case RequestsOrderStatusEnum.delayedRejected:
        return DelayedRejectedStatusStrategyImpl();
      case RequestsOrderStatusEnum.variance:
        return VarianceStatusStrategyImpl();
      case RequestsOrderStatusEnum.emergency:
        return EmergencyStatusStrategyImpl();
    }
  }
}
