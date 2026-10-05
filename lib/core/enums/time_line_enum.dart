import '../strategies/time_line_strategy.dart';

enum TimeLineEnum {
  orderCreated('order_created'),
  orderViewed('order_viewed'),
  orderConfirmed('order_confirmed'),
  orderRejected('order_rejected'),
  orderCanceled('order_canceled'),
  orderModified('order_modified'),
  inspectionStarted('inspection_started'),
  returnCreated('return_created'),
  returnApproved('return_approved'),
  returnRejected('return_rejected'),
  returnEscalated('return_escalated'),
  returnResolved('return_resolved'),
  expenseCreated('expense_created'),
  expenseUpdated('expense_updated'),
  expenseViewed('expense_viewed'),
  expenseApproved('expense_approved'),
  expenseRejected('expense_rejected'),
  expenseResubmitted('expense_resubmitted'),
  expenseEdited('expense_edited');

  final String _value;

  const TimeLineEnum(this._value);

  String get value => _value;

  static TimeLineEnum fromValue(String value) {
    return TimeLineEnum.values.firstWhere(
      (e) => e.value.toLowerCase() == value.toLowerCase(),
      orElse: () => orderCreated,
    );
  }

  TimeLineStrategy get strategy {
    switch (this) {
      case TimeLineEnum.orderCreated:
        return OrderCreatedTimeLineStrategy();
      case TimeLineEnum.orderViewed:
        return OrderViewedTimeLineStrategy();
      case TimeLineEnum.orderConfirmed:
        return OrderConfirmedTimeLineStrategy();
      case TimeLineEnum.orderRejected:
        return OrderRejectedTimeLineStrategy();
      case TimeLineEnum.orderModified:
        return OrderModifiedTimeLineStrategy();
      case TimeLineEnum.orderCanceled:
        return OrderCanceledTimeLineStrategy();
      case TimeLineEnum.inspectionStarted:
        return OrderReceivedTimeLineStrategy();
      case TimeLineEnum.returnCreated:
        return ReturnCreatedTimeLineStrategy();
      case TimeLineEnum.returnApproved:
        return ReturnApprovedTimeLineStrategy();
      case TimeLineEnum.returnRejected:
        return ReturnRejectedTimeLineStrategy();
      case TimeLineEnum.returnEscalated:
        return ReturnEscalatedTimeLineStrategy();
      case TimeLineEnum.returnResolved:
        return ReturnResolvedTimeLineStrategy();
      case TimeLineEnum.expenseCreated:
        return ExpenseCreatedTimeLineStrategy();
      case TimeLineEnum.expenseUpdated:
      case TimeLineEnum.expenseEdited:
        return ExpenseUpdatedTimeLineStrategy();
      case TimeLineEnum.expenseViewed:
        return ExpenseViewedTimeLineStrategy();
      case TimeLineEnum.expenseApproved:
        return ExpenseApprovedTimeLineStrategy();
      case TimeLineEnum.expenseRejected:
        return ExpenseRejectedTimeLineStrategy();
      case TimeLineEnum.expenseResubmitted:
        return ExpenseResubmittedTimeLineStrategy();
    }
  }
}
