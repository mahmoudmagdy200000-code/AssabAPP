import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/core/utils/date_formatter.dart';
import 'package:assab/core/widgets/rejected_widget.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../../shared/models/cancel_reason/cancel_reason_response.dart';
import '../../../branch_manager_requests/presentation/widgets/branch_requests_status_widget.dart';
import '../enums/fixed_assets_requests_status_enum.dart';
import 'fixed_assets_transfer_types_strategy.dart';

abstract class FixedAssetsRequestsStatusStrategy {
  static FixedAssetsRequestsStatusStrategy fromStatus(String status) {
    if (status == FixedAssetsRequestsStatusEnum.pending.value) {
      return FixedAssetsRequestsPendingStatusStrategy();
    } else if (status ==
        FixedAssetsRequestsStatusEnum.pendingFinalApproval.value) {
      return FixedAssetsRequestsPendingFinalApprovalStatusStrategy();
    } else if (status == FixedAssetsRequestsStatusEnum.rejected.value) {
      return FixedAssetsRequestsRejectedStatusStrategy();
    } else if (status == FixedAssetsRequestsStatusEnum.approved.value) {
      return FixedAssetsRequestsApprovedStatusStrategy();
    } else {
      return FixedAssetsRequestsPendingStatusStrategy();
    }
  }

  FixedAssetsRequestsStatusEnum get status;

  Widget buildStatusWidget(BuildContext context);

  Widget buildButtonsTransferWidget(
    BuildContext context,
    FixedAssetsTransferTypesStrategy transferTypeStrategy, {
    required String requestId,
  }) {
    return const SizedBox.shrink();
  }

  Widget buildStatusModificationDetailsWidget(BuildContext context) {
    return const SizedBox.shrink();
  }

  Widget buildDisposalStatusWidget(BuildContext context, {String? approvedOn}) {
    return const SizedBox.shrink();
  }

  Widget buildBrandOwnerModificationDetailsWidget(
    BuildContext context, {
    required String branchName,
    String? approvedOn,
    CancelReasonResponse? cancelReasonResponse,
  }) {
    return const SizedBox.shrink();
  }

  Widget buildBrandOwnerReviewAuditDetailsWidget(
    BuildContext context, {
    required String branchName,
    String? approvedOn,
    CancelReasonResponse? cancelReasonResponse,
  }) {
    return const SizedBox.shrink();
  }

  Widget buildBrandOwnerDisposalAndExternalTransferDetailsWidget(
    BuildContext context, {
    required String branchName,
    String? approvedOn,
    CancelReasonResponse? cancelReasonResponse,
  }) {
    return const SizedBox.shrink();
  }

  Widget buildBrandOwnerTransferBranchToBranchDetailsWidget(
    BuildContext context, {
    String? branchName,
    String? branchNameTo,
    String? approvedOn,
    CancelReasonResponse? cancelReasonResponse,
  }) {
    return const SizedBox.shrink();
  }
}

class FixedAssetsRequestsPendingStatusStrategy
    extends FixedAssetsRequestsStatusStrategy {
  @override
  FixedAssetsRequestsStatusEnum get status =>
      FixedAssetsRequestsStatusEnum.pending;

  @override
  Widget buildStatusWidget(BuildContext context) {
    return BranchRequestsStatusWidget(
      status: context.tr.pending,
      textColor: AppColors.orange,
      borderColor: Colors.transparent,
      backgroundColor: AppColors.orange.withValues(alpha: 0.1),
    );
  }

  @override
  Widget buildButtonsTransferWidget(
    BuildContext context,
    FixedAssetsTransferTypesStrategy transferTypeStrategy, {
    required String requestId,
  }) {
    return transferTypeStrategy.buildButtonPendingWidget(
      context,
      type: transferTypeStrategy,
      requestId: requestId,
    );
  }

  @override
  Widget buildStatusModificationDetailsWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        color: context.customColor.text2,
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 13.r, vertical: 9.r),
            decoration: BoxDecoration(
              color: context.customColor.reversedTextColor,
              borderRadius: BorderRadius.circular(1000.r),
              border: Border.all(color: context.customColor.border),
            ),
            child: Text(
              context.tr.pendingReview,
              style: AppStyles.s10W500.copyWith(color: AppColors.darkOrange),
              textAlign: TextAlign.center,
            ),
          ),
          8.verticalSpace,
          Text(
            context.tr.modificationSubmitted,
            style: AppStyles.s14W600.copyWith(color: context.customColor.text1),
            textAlign: TextAlign.center,
          ),
          4.verticalSpace,
          Text(
            context.tr.yourAssetStatusUpdateHasBeenSent,
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget buildDisposalStatusWidget(BuildContext context, {String? approvedOn}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.customColor.text2,
        borderRadius: BorderRadius.circular(20.r),
      ),
      padding: EdgeInsets.all(16.r),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: context.customColor.reversedTextColor,
              borderRadius: BorderRadius.circular(1000.r),
            ),
            padding: EdgeInsets.all(8.r),
            child: Text(
              context.tr.pendingConfirmation,
              style: AppStyles.s10W500.copyWith(color: AppColors.orange),
              textAlign: TextAlign.center,
            ),
          ),
          5.verticalSpace,
          Text(
            context.tr.requestSubmitted,
            style: AppStyles.s16W500.copyWith(color: context.customColor.text1),
            textAlign: TextAlign.center,
          ),
          5.verticalSpace,
          Text(
            context.tr.pendingOwnerApproval,
            style: AppStyles.s12W400.copyWith(color: context.customColor.text4),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget buildBrandOwnerDisposalAndExternalTransferDetailsWidget(
    BuildContext context, {
    required String branchName,
    String? approvedOn,
    CancelReasonResponse? cancelReasonResponse,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        color: AppColors.orange.withValues(alpha: 0.055),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 13.r, vertical: 9.r),
            decoration: BoxDecoration(
              color: context.customColor.reversedTextColor,
              borderRadius: BorderRadius.circular(1000.r),
              border: Border.all(color: context.customColor.border),
            ),
            child: Text(
              context.tr.pendingApproval,
              style: AppStyles.s10W500.copyWith(color: AppColors.orange),
              textAlign: TextAlign.center,
            ),
          ),
          8.verticalSpace,
          Text(
            'From $branchName',
            style: AppStyles.s14W600.copyWith(color: context.customColor.text1),
            textAlign: TextAlign.center,
          ),
          4.verticalSpace,
          Text(
            'Initial asset count has been submitted for review.',
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget buildBrandOwnerModificationDetailsWidget(
    BuildContext context, {
    required String branchName,
    String? approvedOn,
    CancelReasonResponse? cancelReasonResponse,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        color: AppColors.orange.withValues(alpha: 0.055),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 13.r, vertical: 9.r),
            decoration: BoxDecoration(
              color: context.customColor.reversedTextColor,
              borderRadius: BorderRadius.circular(1000.r),
              border: Border.all(color: context.customColor.border),
            ),
            child: Text(
              context.tr.pendingApproval,
              style: AppStyles.s10W500.copyWith(color: AppColors.orange),
              textAlign: TextAlign.center,
            ),
          ),
          8.verticalSpace,
          Text(
            'From $branchName',
            style: AppStyles.s14W600.copyWith(color: context.customColor.text1),
            textAlign: TextAlign.center,
          ),
          4.verticalSpace,
          Text(
            'Initial asset count has been submitted for review.',
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class FixedAssetsRequestsPendingFinalApprovalStatusStrategy
    extends FixedAssetsRequestsStatusStrategy {
  @override
  FixedAssetsRequestsStatusEnum get status =>
      FixedAssetsRequestsStatusEnum.pendingFinalApproval;

  @override
  Widget buildStatusWidget(BuildContext context) {
    return BranchRequestsStatusWidget(
      status: context.tr.pendingApproval,
      textColor: AppColors.orange,
      borderColor: Colors.transparent,
      backgroundColor: AppColors.orange.withValues(alpha: 0.1),
    );
  }

  @override
  Widget buildButtonsTransferWidget(
    BuildContext context,
    FixedAssetsTransferTypesStrategy transferTypeStrategy, {
    required String requestId,
  }) {
    return transferTypeStrategy.buildButtonPendingApprovalWidget(
      context,
      requestId: requestId,
    );
  }

  @override
  Widget buildBrandOwnerReviewAuditDetailsWidget(
    BuildContext context, {
    required String branchName,
    String? approvedOn,
    CancelReasonResponse? cancelReasonResponse,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        color: AppColors.orange.withValues(alpha: 0.055),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 13.r, vertical: 9.r),
            decoration: BoxDecoration(
              color: context.customColor.reversedTextColor,
              borderRadius: BorderRadius.circular(1000.r),
              border: Border.all(color: context.customColor.border),
            ),
            child: Text(
              context.tr.pendingApproval,
              style: AppStyles.s10W500.copyWith(color: AppColors.orange),
              textAlign: TextAlign.center,
            ),
          ),
          8.verticalSpace,
          Text(
            'From $branchName',
            style: AppStyles.s14W600.copyWith(color: context.customColor.text1),
            textAlign: TextAlign.center,
          ),
          4.verticalSpace,
          Text(
            'Initial asset count is pending final review and approval.',
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget buildBrandOwnerTransferBranchToBranchDetailsWidget(
    BuildContext context, {
    String? branchName,
    String? branchNameTo,
    String? approvedOn,
    CancelReasonResponse? cancelReasonResponse,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        color: AppColors.orange.withValues(alpha: 0.055),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 13.r, vertical: 9.r),
            decoration: BoxDecoration(
              color: context.customColor.reversedTextColor,
              borderRadius: BorderRadius.circular(1000.r),
              border: Border.all(color: context.customColor.border),
            ),
            child: Text(
              context.tr.pendingApproval,
              style: AppStyles.s10W500.copyWith(color: AppColors.orange),
              textAlign: TextAlign.center,
            ),
          ),
          8.verticalSpace,
          Text(
            'From: $branchName → To: $branchNameTo',
            style: AppStyles.s14W600.copyWith(color: context.customColor.text1),
            textAlign: TextAlign.center,
          ),
          4.verticalSpace,
          Text(
            'Pending your review and actions.',
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class FixedAssetsRequestsApprovedStatusStrategy
    extends FixedAssetsRequestsStatusStrategy {
  @override
  FixedAssetsRequestsStatusEnum get status =>
      FixedAssetsRequestsStatusEnum.approved;

  @override
  Widget buildStatusWidget(BuildContext context) {
    return BranchRequestsStatusWidget(
      status: context.tr.approved,
      textColor: AppColors.lightGreen,
      borderColor: Colors.transparent,
      backgroundColor: AppColors.lightGreen.withValues(alpha: 0.1),
    );
  }

  @override
  Widget buildButtonsTransferWidget(
    BuildContext context,
    FixedAssetsTransferTypesStrategy transferTypeStrategy, {
    required String requestId,
  }) {
    return transferTypeStrategy.buildButtonApprovedWidget(
      context,
      requestId: requestId,
    );
  }

  @override
  Widget buildStatusModificationDetailsWidget(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        color: context.customColor.text2,
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 13.r, vertical: 9.r),
            decoration: BoxDecoration(
              color: context.customColor.reversedTextColor,
              borderRadius: BorderRadius.circular(1000.r),
              border: Border.all(color: context.customColor.border),
            ),
            child: Text(
              context.tr.approved,
              style: AppStyles.s10W500.copyWith(color: AppColors.lightGreen),
              textAlign: TextAlign.center,
            ),
          ),
          8.verticalSpace,
          Text(
            context.tr.modificationApproved,
            style: AppStyles.s14W600.copyWith(color: context.customColor.text1),
            textAlign: TextAlign.center,
          ),
          4.verticalSpace,
          Text(
            context.tr.modificationApprovedDesc,
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget buildDisposalStatusWidget(BuildContext context, {String? approvedOn}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.customColor.text2,
        borderRadius: BorderRadius.circular(20.r),
      ),
      padding: EdgeInsets.all(16.r),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: context.customColor.reversedTextColor,
              borderRadius: BorderRadius.circular(1000.r),
            ),
            padding: EdgeInsets.all(8.r),
            child: Text(
              context.tr.approvedByOwner,
              style: AppStyles.s10W500.copyWith(color: AppColors.lightGreen),
              textAlign: TextAlign.center,
            ),
          ),
          5.verticalSpace,
          Text(
            context.tr.requestSubmitted,
            style: AppStyles.s16W500.copyWith(color: context.customColor.text1),
            textAlign: TextAlign.center,
          ),
          5.verticalSpace,
          Text(
            context.tr.finalDisposalConfirmed(
              DateFormatter.formatDateMDY(
                    DateTime.tryParse(approvedOn ?? ''),
                  ) ??
                  '-',
              DateFormatter.formatTimeHM(DateTime.tryParse(approvedOn ?? '')) ??
                  '-',
            ),
            style: AppStyles.s12W400.copyWith(color: context.customColor.text4),
            textAlign: TextAlign.center,
          ),
          5.verticalSpace,
          Text(
            context.tr.approvedOn(
              '${DateFormatter.formatDateMDY(DateTime.tryParse(approvedOn ?? '')) ?? '-'} - ${DateFormatter.formatTimeHM(DateTime.tryParse(approvedOn ?? '')) ?? '-'}',
            ),
            style: AppStyles.s12W400.copyWith(color: context.customColor.text3),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget buildBrandOwnerModificationDetailsWidget(
    BuildContext context, {
    required String branchName,
    String? approvedOn,
    CancelReasonResponse? cancelReasonResponse,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        color: AppColors.lightGreen.withValues(alpha: 0.055),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 13.r, vertical: 9.r),
            decoration: BoxDecoration(
              color: context.customColor.reversedTextColor,
              borderRadius: BorderRadius.circular(1000.r),
              border: Border.all(color: context.customColor.border),
            ),
            child: Text(
              context.tr.approved,
              style: AppStyles.s10W500.copyWith(color: AppColors.lightGreen),
              textAlign: TextAlign.center,
            ),
          ),
          8.verticalSpace,
          Text(
            'From $branchName',
            style: AppStyles.s14W600.copyWith(color: context.customColor.text1),
            textAlign: TextAlign.center,
          ),
          4.verticalSpace,
          Text(
            'Initial asset count has been approved.',
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
            textAlign: TextAlign.center,
          ),
          4.verticalSpace,
          Text(
            'Executed on: $approvedOn',
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget buildBrandOwnerReviewAuditDetailsWidget(
    BuildContext context, {
    required String branchName,
    String? approvedOn,
    CancelReasonResponse? cancelReasonResponse,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        color: AppColors.lightGreen.withValues(alpha: 0.055),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 13.r, vertical: 9.r),
            decoration: BoxDecoration(
              color: context.customColor.reversedTextColor,
              borderRadius: BorderRadius.circular(1000.r),
              border: Border.all(color: context.customColor.border),
            ),
            child: Text(
              context.tr.approved,
              style: AppStyles.s10W500.copyWith(color: AppColors.lightGreen),
              textAlign: TextAlign.center,
            ),
          ),
          8.verticalSpace,
          Text(
            'From $branchName',
            style: AppStyles.s14W600.copyWith(color: context.customColor.text1),
            textAlign: TextAlign.center,
          ),
          4.verticalSpace,
          Text(
            'Initial asset count has been approved.',
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget buildBrandOwnerDisposalAndExternalTransferDetailsWidget(
    BuildContext context, {
    required String branchName,
    String? approvedOn,
    CancelReasonResponse? cancelReasonResponse,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: AppColors.lightGreen),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 13.r, vertical: 9.r),
            decoration: BoxDecoration(
              color: context.customColor.reversedTextColor,
              borderRadius: BorderRadius.circular(1000.r),
              border: Border.all(color: context.customColor.border),
            ),
            child: Text(
              context.tr.approved,
              style: AppStyles.s10W500.copyWith(color: AppColors.lightGreen),
              textAlign: TextAlign.center,
            ),
          ),
          8.verticalSpace,
          Text(
            'You approved asset without issues.',
            style: AppStyles.s14W600.copyWith(color: context.customColor.text1),
            textAlign: TextAlign.center,
          ),
          4.verticalSpace,
          Text(
            'Approved on: $approvedOn',
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget buildBrandOwnerTransferBranchToBranchDetailsWidget(
    BuildContext context, {
    String? branchName,
    String? branchNameTo,
    String? approvedOn,
    CancelReasonResponse? cancelReasonResponse,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: AppColors.lightGreen),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 13.r, vertical: 9.r),
            decoration: BoxDecoration(
              color: context.customColor.reversedTextColor,
              borderRadius: BorderRadius.circular(1000.r),
              border: Border.all(color: context.customColor.border),
            ),
            child: Text(
              context.tr.approved,
              style: AppStyles.s10W500.copyWith(color: AppColors.lightGreen),
              textAlign: TextAlign.center,
            ),
          ),
          8.verticalSpace,
          Text(
            'From: $branchName → To: $branchNameTo',
            style: AppStyles.s14W600.copyWith(color: context.customColor.text1),
            textAlign: TextAlign.center,
          ),
          4.verticalSpace,
          Text(
            'Approved by you.\nApproved on: $approvedOn',
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class FixedAssetsRequestsRejectedStatusStrategy
    extends FixedAssetsRequestsStatusStrategy {
  @override
  FixedAssetsRequestsStatusEnum get status =>
      FixedAssetsRequestsStatusEnum.rejected;

  @override
  Widget buildStatusWidget(BuildContext context) {
    return BranchRequestsStatusWidget(
      status: context.tr.rejected,
      textColor: context.customColor.error,
      borderColor: Colors.transparent,
      backgroundColor: context.customColor.error.withValues(alpha: 0.1),
    );
  }

  @override
  Widget buildButtonsTransferWidget(
    BuildContext context,
    FixedAssetsTransferTypesStrategy transferTypeStrategy, {
    required String requestId,
  }) {
    return transferTypeStrategy.buildButtonRejectedWidget(
      context,
      requestId: requestId,
    );
  }

  @override
  Widget buildStatusModificationDetailsWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        color: context.customColor.text2,
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 13.r, vertical: 9.r),
            decoration: BoxDecoration(
              color: context.customColor.reversedTextColor,
              borderRadius: BorderRadius.circular(1000.r),
              border: Border.all(color: context.customColor.border),
            ),
            child: Text(
              context.tr.rejected,
              style: AppStyles.s10W500.copyWith(
                color: context.customColor.error,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          8.verticalSpace,
          Text(
            'Modification Rejected',
            style: AppStyles.s14W600.copyWith(color: context.customColor.text1),
            textAlign: TextAlign.center,
          ),
          4.verticalSpace,
          Text(
            'Your asset status update has been rejected.',
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget buildDisposalStatusWidget(BuildContext context, {String? approvedOn}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.customColor.text2,
        borderRadius: BorderRadius.circular(20.r),
      ),
      padding: EdgeInsets.all(16.r),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: context.customColor.reversedTextColor,
              borderRadius: BorderRadius.circular(1000.r),
            ),
            padding: EdgeInsets.all(8.r),
            child: Text(
              context.tr.rejected,
              style: AppStyles.s10W500.copyWith(
                color: context.customColor.error,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          5.verticalSpace,
          Text(
            'Request Rejected',
            style: AppStyles.s16W500.copyWith(color: context.customColor.text1),
            textAlign: TextAlign.center,
          ),
          5.verticalSpace,
          Text(
            'Your disposal request has been rejected.',
            style: AppStyles.s12W400.copyWith(color: context.customColor.text4),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget buildBrandOwnerModificationDetailsWidget(
    BuildContext context, {
    required String branchName,
    String? approvedOn,
    CancelReasonResponse? cancelReasonResponse,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: context.customColor.error),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 13.r, vertical: 9.r),
            decoration: BoxDecoration(
              color: context.customColor.reversedTextColor,
              borderRadius: BorderRadius.circular(1000.r),
              border: Border.all(color: context.customColor.border),
            ),
            child: Text(
              context.tr.rejected,
              style: AppStyles.s10W500.copyWith(
                color: context.customColor.error,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          8.verticalSpace,
          Text(
            'From $branchName',
            style: AppStyles.s14W600.copyWith(color: context.customColor.text1),
            textAlign: TextAlign.center,
          ),
          4.verticalSpace,
          Text(
            'You rejected this request. Feedback has been shared with the requesting branch..',
            style: AppStyles.s13W400.copyWith(color: context.customColor.text4),
            textAlign: TextAlign.center,
          ),
          4.verticalSpace,
          Text(
            'Reported on: ${cancelReasonResponse?.cancelledAt}',
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
            textAlign: TextAlign.center,
          ),
          10.verticalSpace,
          RejectedWidget(reason: cancelReasonResponse),
        ],
      ),
    );
  }

  @override
  Widget buildBrandOwnerReviewAuditDetailsWidget(
    BuildContext context, {
    required String branchName,
    String? approvedOn,
    CancelReasonResponse? cancelReasonResponse,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: context.customColor.error),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 13.r, vertical: 9.r),
            decoration: BoxDecoration(
              color: context.customColor.reversedTextColor,
              borderRadius: BorderRadius.circular(1000.r),
              border: Border.all(color: context.customColor.border),
            ),
            child: Text(
              context.tr.rejected,
              style: AppStyles.s10W500.copyWith(
                color: context.customColor.error,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          8.verticalSpace,
          Text(
            'From $branchName',
            style: AppStyles.s14W600.copyWith(color: context.customColor.text1),
            textAlign: TextAlign.center,
          ),
          4.verticalSpace,
          Text(
            'You rejected this audit. pending your executive order to finzlize',
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
            textAlign: TextAlign.center,
          ),
          4.verticalSpace,
          Text(
            'Reported on: ${cancelReasonResponse?.cancelledAt}',
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
            textAlign: TextAlign.center,
          ),
          10.verticalSpace,
          RejectedWidget(reason: cancelReasonResponse),
        ],
      ),
    );
  }

  @override
  Widget buildBrandOwnerDisposalAndExternalTransferDetailsWidget(
    BuildContext context, {
    required String branchName,
    String? approvedOn,
    CancelReasonResponse? cancelReasonResponse,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: context.customColor.error),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 13.r, vertical: 9.r),
            decoration: BoxDecoration(
              color: context.customColor.reversedTextColor,
              borderRadius: BorderRadius.circular(1000.r),
              border: Border.all(color: context.customColor.border),
            ),
            child: Text(
              context.tr.rejected,
              style: AppStyles.s10W500.copyWith(
                color: context.customColor.error,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          8.verticalSpace,
          Text(
            'Your reason for rejection has ben shared with requesting branch manager.',
            style: AppStyles.s14W600.copyWith(color: context.customColor.text1),
            textAlign: TextAlign.center,
          ),
          4.verticalSpace,
          RejectedWidget(reason: cancelReasonResponse),
        ],
      ),
    );
  }

  @override
  Widget buildBrandOwnerTransferBranchToBranchDetailsWidget(
    BuildContext context, {
    String? branchName,
    String? branchNameTo,
    String? approvedOn,
    CancelReasonResponse? cancelReasonResponse,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: context.customColor.error),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 13.r, vertical: 9.r),
            decoration: BoxDecoration(
              color: context.customColor.reversedTextColor,
              borderRadius: BorderRadius.circular(1000.r),
              border: Border.all(color: context.customColor.border),
            ),
            child: Text(
              context.tr.rejected,
              style: AppStyles.s10W500.copyWith(
                color: context.customColor.error,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          8.verticalSpace,
          Text(
            'From: $branchName → To: $branchNameTo',
            style: AppStyles.s14W600.copyWith(color: context.customColor.text1),
            textAlign: TextAlign.center,
          ),
          4.verticalSpace,
          Text(
            'You rejected this transfer request. Feedback has been shared with the requesting branch.',
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
            textAlign: TextAlign.center,
          ),
          4.verticalSpace,
          RejectedWidget(reason: cancelReasonResponse),
        ],
      ),
    );
  }
}
