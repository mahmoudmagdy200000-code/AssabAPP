import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/button_text_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/styles/app_colors.dart';
import '../../../branch_manager_requests/presentation/widgets/branch_requests_status_widget.dart';
import '../../data/models/recurring_order_details_response.dart';
import '../../presentation/cubit/recurring_order_actions/recurring_order_actions_cubit.dart';
import '../../presentation/widgets/recurring_order_status_widget.dart';

abstract class RecurringOrderStatusStrategy {
  Widget buildStatus(BuildContext context) {
    return const SizedBox.shrink();
  }

  Widget buildStatusWidget(
    BuildContext context,
    RecurringOrderDetailsInspectionSummary inspectionSummary,
  ) {
    return const SizedBox.shrink();
  }

  Widget buildStatusHistoryItem(BuildContext context) {
    return const SizedBox.shrink();
  }

  Widget buildTextHistoryItem(BuildContext context) {
    return const SizedBox.shrink();
  }

  Widget buildButtonDetailsScreen(
    BuildContext context, {
    required String orderId,
  }) {
    return const SizedBox.shrink();
  }
}

class PendingRecurringOrderStatusStrategy extends RecurringOrderStatusStrategy {
  @override
  Widget buildStatusWidget(
    BuildContext context,
    RecurringOrderDetailsInspectionSummary inspectionSummary,
  ) {
    return RecurringOrderStatusWidget(
      title: context.tr.nextOrderWeeklyRepeat,
      description: context.tr.nextOrderWillBeGeneratedOn(
        inspectionSummary.nextOrderScheduling,
        inspectionSummary.schedulingTime,
      ),
      status: context.tr.pending,
      statusColor: AppColors.orange,
    );
  }

  @override
  Widget buildStatus(BuildContext context) {
    return BranchRequestsStatusWidget(
      status: context.tr.pending,
      textColor: AppColors.orange,
      borderColor: context.customColor.border,
    );
  }
}

class InProgressRecurringOrderStatusStrategy
    extends RecurringOrderStatusStrategy {
  @override
  Widget buildStatusWidget(
    BuildContext context,
    RecurringOrderDetailsInspectionSummary inspectionSummary,
  ) {
    return RecurringOrderStatusWidget(
      title: context.tr.generatedOrderConfirmed,
      description: context.tr.procurementStepsUnderway,
      status: context.tr.inProgress,
      statusColor: context.theme.primaryColor,
      image: AppAssets.inProgressRecurringOrder,
      imageSize: 239.r,
    );
  }

  @override
  Widget buildStatus(BuildContext context) {
    return BranchRequestsStatusWidget(
      status: context.tr.inProgress,
      textColor: context.theme.primaryColor,
      borderColor: context.customColor.border,
    );
  }
}

class GeneratedRecurringOrderStatusStrategy
    extends RecurringOrderStatusStrategy {
  @override
  Widget buildStatusWidget(
    BuildContext context,
    RecurringOrderDetailsInspectionSummary inspectionSummary,
  ) {
    return RecurringOrderStatusWidget(
      title: context.tr.generatedOrderConfirmation(
        inspectionSummary.directSupplierOrPurchasingOfficerName,
      ),
      description: context.tr.procurementStepsUnderway,
      status: context.tr.generated,
      statusColor: const Color(0xff046B6B),
      borderColor: Colors.transparent,
      backgroundColor: const Color(0xffDFFEFF),
      backgroundColorStatus: context.customColor.reversedTextColor,
    );
  }

  @override
  Widget buildStatus(BuildContext context) {
    return BranchRequestsStatusWidget(
      status: context.tr.generated,
      textColor: const Color(0xff046B6B),
      borderColor: context.customColor.border,
      backgroundColor: const Color(0xffDFFEFF),
    );
  }
}

class PausedRecurringOrderStatusStrategy extends RecurringOrderStatusStrategy {
  @override
  Widget buildStatusWidget(
    BuildContext context,
    RecurringOrderDetailsInspectionSummary inspectionSummary,
  ) {
    return RecurringOrderStatusWidget(
      title: context.tr.temporarilyOnHold,
      description: context.tr.noOrdersWillBeTriggeredUntilTheScheduleIsResumed,
      status: context.tr.paused,
      statusColor: context.customColor.text1,
      borderColor: Colors.transparent,
      backgroundColorStatus: context.customColor.reversedTextColor,
      image: AppAssets.lockPng,
      imageSize: 55.r,
      backgroundColor: context.customColor.text2,
    );
  }

  @override
  Widget buildStatus(BuildContext context) {
    return BranchRequestsStatusWidget(
      status: context.tr.paused,
      textColor: context.customColor.text1,
      borderColor: context.customColor.border,
      backgroundColor: context.customColor.text2,
    );
  }

  @override
  Widget buildButtonDetailsScreen(
    BuildContext context, {
    required String orderId,
  }) {
    return Column(
      children: [
        20.verticalSpace,
        ButtonTextIcon(
          onTap: () {
            context.read<RecurringOrderActionsCubit>().resumeRecurringOrder(
              id: orderId,
            );
          },
          label: context.tr.resumeSchedule,
          icon: AppSvg(
            assetName: AppAssets.check,
            colorFilter: ColorFilter.mode(
              context.customColor.reversedTextColor,
              BlendMode.srcIn,
            ),
            width: 16.r,
          ),
          backgroundColor: context.theme.primaryColor,
          borderRadius: BorderRadius.circular(1000.r),
          padding: EdgeInsets.symmetric(vertical: 15.r),
          spaceBetweenTextAndIcon: 7.w,
          textColor: context.customColor.reversedTextColor,
        ),
      ],
    );
  }
}

class CanceledRecurringOrderStatusStrategy
    extends RecurringOrderStatusStrategy {
  @override
  Widget buildStatusHistoryItem(BuildContext context) {
    return BranchRequestsStatusWidget(
      status: context.tr.canceled,
      textColor: context.customColor.error,
      borderColor: context.customColor.border,
    );
  }

  @override
  Widget buildTextHistoryItem(BuildContext context) {
    return Text(
      context.tr.thisCycleOrderCanceled('Monday, July 1'),
      style: AppStyles.s13W500.copyWith(color: context.customColor.error),
      textAlign: TextAlign.center,
    );
  }

  @override
  Widget buildStatus(BuildContext context) {
    return BranchRequestsStatusWidget(
      status: context.tr.canceled,
      textColor: context.customColor.error,
      borderColor: context.customColor.border,
    );
  }
}

class CompletedRecurringOrderStatusStrategy
    extends RecurringOrderStatusStrategy {
  @override
  Widget buildStatusHistoryItem(BuildContext context) {
    return BranchRequestsStatusWidget(
      status: context.tr.completed,
      textColor: AppColors.lightGreen,
      borderColor: context.customColor.border,
    );
  }

  @override
  Widget buildTextHistoryItem(BuildContext context) {
    return Text(
      context.tr.orderCycleComplete,
      style: AppStyles.s13W500.copyWith(color: AppColors.lightGreen),
      textAlign: TextAlign.center,
    );
  }

  @override
  Widget buildStatus(BuildContext context) {
    return BranchRequestsStatusWidget(
      status: context.tr.completed,
      textColor: AppColors.lightGreen,
      borderColor: context.customColor.border,
    );
  }
}
