import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/widgets/time_line_image.dart';
import 'package:assab/core/widgets/time_line_svg.dart';
import 'package:assab/core/widgets/time_line_widget.dart';
import 'package:assab/shared/models/time_line_response.dart';
import 'package:flutter/material.dart';

import '../styles/app_colors.dart';

abstract class TimeLineStrategy {
  Widget buildTimeLineItem(BuildContext context, TimeLineItem timeline);
}

/// ================== Expense Strategies ==================
class ExpenseCreatedTimeLineStrategy extends TimeLineStrategy {
  @override
  Widget buildTimeLineItem(BuildContext context, TimeLineItem timeline) {
    return TimeLineWidget(
      title: context.tr.submitted,
      date: timeline.occurredAt,
      desc: context.tr.expenseSubmittedForApproval,
      icon: const TimeLineSvg(assetName: AppAssets.cash),
    );
  }
}

class ExpenseUpdatedTimeLineStrategy extends TimeLineStrategy {
  @override
  Widget buildTimeLineItem(BuildContext context, TimeLineItem timeline) {
    return TimeLineWidget(
      title: context.tr.modified,
      date: timeline.occurredAt,
      desc: context.tr.expenseModifiedDesc,
      icon: const TimeLineSvg(assetName: AppAssets.edit),
    );
  }
}

class ExpenseViewedTimeLineStrategy extends TimeLineStrategy {
  @override
  Widget buildTimeLineItem(BuildContext context, TimeLineItem timeline) {
    return TimeLineWidget(
      title: context.tr.viewedByBrandManager,
      date: timeline.occurredAt,
      desc: context.tr.expenseViewedByManager,
      icon: TimeLineImage(image: timeline.image),
    );
  }
}

class ExpenseApprovedTimeLineStrategy extends TimeLineStrategy {
  @override
  Widget buildTimeLineItem(BuildContext context, TimeLineItem timeline) {
    return TimeLineWidget(
      title: context.tr.approved,
      date: timeline.occurredAt,
      desc: context.tr.expenseApprovedDesc,
      icon: const TimeLineSvg(
        assetName: AppAssets.check,
        color: AppColors.lightGreen,
      ),
    );
  }
}

class ExpenseRejectedTimeLineStrategy extends TimeLineStrategy {
  @override
  Widget buildTimeLineItem(BuildContext context, TimeLineItem timeline) {
    return TimeLineWidget(
      title: context.tr.rejected,
      date: timeline.occurredAt,
      desc: context.tr.expenseRejectedDesc,
      icon: TimeLineSvg(
        assetName: AppAssets.cancelSvg,
        color: context.customColor.error,
      ),
    );
  }
}

class ExpenseResubmittedTimeLineStrategy extends TimeLineStrategy {
  @override
  Widget buildTimeLineItem(BuildContext context, TimeLineItem timeline) {
    return TimeLineWidget(
      title: context.tr.resubmitted,
      date: timeline.occurredAt,
      desc: context.tr.expenseResubmittedDesc,
      icon: const TimeLineSvg(assetName: AppAssets.edit),
    );
  }
}

/// ================== Order Strategies ==================
class OrderCreatedTimeLineStrategy extends TimeLineStrategy {
  @override
  Widget buildTimeLineItem(BuildContext context, TimeLineItem timeline) {
    return TimeLineWidget(
      title: context.tr.submittedFromBranchName(timeline.name),
      date: timeline.occurredAt,
      desc: context.tr.managerNameSubmittedThisOrderRequestForReviewAndApproval(
        timeline.name,
      ),
      icon: const TimeLineSvg(assetName: AppAssets.returnsManagement),
    );
  }
}

class OrderViewedTimeLineStrategy extends TimeLineStrategy {
  @override
  Widget buildTimeLineItem(BuildContext context, TimeLineItem timeline) {
    return TimeLineWidget(
      title: context.tr.viewedBySupplier,
      date: timeline.occurredAt,
      desc: context.tr.requestWasOpenedAndReviewedButNoActionHasBeenTakenYet,
      icon: TimeLineImage(image: timeline.image),
    );
  }
}

class OrderConfirmedTimeLineStrategy extends TimeLineStrategy {
  @override
  Widget buildTimeLineItem(BuildContext context, TimeLineItem timeline) {
    return TimeLineWidget(
      title: context.tr.orderConfirmated,
      date: timeline.occurredAt,
      desc: context.tr.requestWasReviewedAndApproved,
      icon: const TimeLineSvg(
        assetName: AppAssets.check,
        color: AppColors.lightGreen,
      ),
    );
  }
}

class OrderRejectedTimeLineStrategy extends TimeLineStrategy {
  @override
  Widget buildTimeLineItem(BuildContext context, TimeLineItem timeline) {
    return TimeLineWidget(
      title: context.tr.rejected,
      date: timeline.occurredAt,
      desc: context.tr.requestWasRejectedYoullFindTheReasonAttachedInDetails,
      icon: TimeLineSvg(
        assetName: AppAssets.cancelSvg,
        color: context.customColor.error,
      ),
    );
  }
}

class OrderCanceledTimeLineStrategy extends TimeLineStrategy {
  @override
  Widget buildTimeLineItem(BuildContext context, TimeLineItem timeline) {
    return TimeLineWidget(
      title: context.tr.canceled,
      date: timeline.occurredAt,
      desc: context.tr.requestWasCanceledYoullFindTheReasonAttachedInDetails,
      icon: TimeLineSvg(
        assetName: AppAssets.cancelSvg,
        color: context.customColor.error,
      ),
    );
  }
}

class OrderModifiedTimeLineStrategy extends TimeLineStrategy {
  @override
  Widget buildTimeLineItem(BuildContext context, TimeLineItem timeline) {
    return TimeLineWidget(
      title: context.tr.modified,
      date: timeline.occurredAt,
      desc: context.tr.orderModifiedDesc,
      icon: const TimeLineSvg(assetName: AppAssets.edit),
    );
  }
}

class OrderReceivedTimeLineStrategy extends TimeLineStrategy {
  @override
  Widget buildTimeLineItem(BuildContext context, TimeLineItem timeline) {
    return TimeLineWidget(
      title: context.tr.markedAsReceived,
      date: timeline.occurredAt,
      desc: context.tr.youMarkedThisOrderAsDeliveryNowConfirmedAsReceived,
      icon: const TimeLineSvg(assetName: AppAssets.edit),
    );
  }
}

/// ================== Return Strategies ==================
class ReturnCreatedTimeLineStrategy extends TimeLineStrategy {
  @override
  Widget buildTimeLineItem(BuildContext context, TimeLineItem timeline) {
    return TimeLineWidget(
      title: context.tr.submitted,
      date: timeline.occurredAt,
      desc: context.tr
          .managerNameSubmittedThisItemReturnRequestForReviewAndApproval(
            timeline.name,
          ),
      icon: const TimeLineSvg(assetName: AppAssets.returnsManagement),
    );
  }
}

class ReturnApprovedTimeLineStrategy extends TimeLineStrategy {
  @override
  Widget buildTimeLineItem(BuildContext context, TimeLineItem timeline) {
    return TimeLineWidget(
      title: context.tr.approved,
      date: timeline.occurredAt,
      desc: context.tr.returnApprovedDesc,
      icon: const TimeLineSvg(
        assetName: AppAssets.check,
        color: AppColors.lightGreen,
      ),
    );
  }
}

class ReturnRejectedTimeLineStrategy extends TimeLineStrategy {
  @override
  Widget buildTimeLineItem(BuildContext context, TimeLineItem timeline) {
    return TimeLineWidget(
      title: context.tr.rejected,
      date: timeline.occurredAt,
      desc: context.tr.returnRejectedDesc,
      icon: TimeLineSvg(
        assetName: AppAssets.cancelSvg,
        color: context.customColor.error,
      ),
    );
  }
}

class ReturnEscalatedTimeLineStrategy extends TimeLineStrategy {
  @override
  Widget buildTimeLineItem(BuildContext context, TimeLineItem timeline) {
    return TimeLineWidget(
      title: context.tr.escalated,
      date: timeline.occurredAt,
      desc: context.tr.returnEscalatedDesc,
      icon: TimeLineSvg(
        assetName: AppAssets.cancelSvg,
        color: context.customColor.error,
      ),
    );
  }
}

class ReturnResolvedTimeLineStrategy extends TimeLineStrategy {
  @override
  Widget buildTimeLineItem(BuildContext context, TimeLineItem timeline) {
    return TimeLineWidget(
      title: context.tr.resolved,
      date: timeline.occurredAt,
      desc: context.tr.returnResolvedDesc,
      icon: const TimeLineSvg(
        assetName: AppAssets.check,
        color: AppColors.lightGreen,
      ),
    );
  }
}

/// ================== Inventory Strategies ==================
// inventory_created
class InventoryCreatedTimeLineStrategy extends TimeLineStrategy {
  @override
  Widget buildTimeLineItem(BuildContext context, TimeLineItem timeline) {
    return TimeLineWidget(
      title: context.tr.submitted,
      date: timeline.occurredAt,
      desc: context.tr.managerSubmittedDailyInventory(timeline.name),
      icon: const TimeLineSvg(assetName: AppAssets.time04),
    );
  }
}

// inventory_reassigned
// inventory_viewd
// inventory_rejected
// inventory_approved
