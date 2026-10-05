import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/saudi_riyal_svg_widget.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/app_colors.dart';
import '../../../../shared/models/cancel_reason/cancel_reason_response.dart';
import '../../../branch_manager_requests/presentation/widgets/branch_requests_status_widget.dart';

abstract class BrandOwnerFixedAssetsHandoverReportsStatusStrategy {
  static BrandOwnerFixedAssetsHandoverReportsStatusStrategy fromStatus(
    String status,
  ) {
    switch (status) {
      case 'pending':
        return BrandOwnerFixedAssetsHandoverReportsPendingApprovalStatusStrategy();
      case 'approved':
        return BrandOwnerFixedAssetsHandoverReportsApprovedStatusStrategy();
      case 'salary_deduction':
        return BrandOwnerFixedAssetsHandoverReportsSalaryDeductedStatusStrategy();
      default:
        return BrandOwnerFixedAssetsHandoverReportsPendingApprovalStatusStrategy();
    }
  }

  Widget buildBrandOwnerHandoverDetailsWidget(
    BuildContext context, {
    String? branchName,
    String? branchNameTo,
    String? employeeResponsible,
    String? warningNote,
    String? salaryDeductionAmount,
    String? salaryDeductionReason,
    String? approvedOn,
    CancelReasonResponse? cancelReasonResponse,
  }) {
    return const SizedBox.shrink();
  }

  Widget buildStatusWidget(BuildContext context) {
    return const SizedBox.shrink();
  }
}

class BrandOwnerFixedAssetsHandoverReportsPendingApprovalStatusStrategy
    extends BrandOwnerFixedAssetsHandoverReportsStatusStrategy {
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
  Widget buildBrandOwnerHandoverDetailsWidget(
    BuildContext context, {
    String? branchName,
    String? branchNameTo,
    String? employeeResponsible,
    String? warningNote,
    String? salaryDeductionAmount,
    String? salaryDeductionReason,
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
            'From  $branchName → To: $branchNameTo',
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

class BrandOwnerFixedAssetsHandoverReportsApprovedStatusStrategy
    extends BrandOwnerFixedAssetsHandoverReportsStatusStrategy {
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
  Widget buildBrandOwnerHandoverDetailsWidget(
    BuildContext context, {
    String? branchName,
    String? branchNameTo,
    String? employeeResponsible,
    String? warningNote,
    String? salaryDeductionAmount,
    String? salaryDeductionReason,
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
            'You added a warning message to $employeeResponsible',
            style: AppStyles.s14W600.copyWith(color: context.customColor.text1),
            textAlign: TextAlign.center,
          ),
          4.verticalSpace,
          Text(
            'View details of your decision below.',
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
            textAlign: TextAlign.center,
          ),
          5.verticalSpace,
          ContainerCustomTextField(
            backgroundColor: context.customColor.reversedTextColor,
            padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 8.r),
            borderRadius: BorderRadius.circular(8.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Warning Note',
                  style: AppStyles.s12W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
                4.verticalSpace,
                Text(
                  warningNote ?? '',
                  style: AppStyles.s12W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BrandOwnerFixedAssetsHandoverReportsSalaryDeductedStatusStrategy
    extends BrandOwnerFixedAssetsHandoverReportsStatusStrategy {
  @override
  Widget buildStatusWidget(BuildContext context) {
    return BranchRequestsStatusWidget(
      status: 'Salary Deducted',
      textColor: context.theme.primaryColor,
      borderColor: Colors.transparent,
      backgroundColor: context.theme.primaryColor.withValues(alpha: 0.1),
    );
  }

  @override
  Widget buildBrandOwnerHandoverDetailsWidget(
    BuildContext context, {
    String? branchName,
    String? branchNameTo,
    String? employeeResponsible,
    String? warningNote,
    String? salaryDeductionAmount,
    String? salaryDeductionReason,
    String? approvedOn,
    CancelReasonResponse? cancelReasonResponse,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: context.theme.primaryColor),
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
              'Salary Deducted',
              style: AppStyles.s10W500.copyWith(
                color: context.theme.primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          8.verticalSpace,
          Text(
            'You’ve chosen to deduct from $employeeResponsible’s salary.',
            style: AppStyles.s14W600.copyWith(color: context.customColor.text1),
            textAlign: TextAlign.center,
          ),
          4.verticalSpace,
          Text(
            'View details of your decision below.',
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
            textAlign: TextAlign.center,
          ),
          5.verticalSpace,
          ContainerCustomTextField(
            backgroundColor: context.customColor.reversedTextColor,
            padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 8.r),
            borderRadius: BorderRadius.circular(8.r),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    'Amount',
                    style: AppStyles.s12W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                ),
                4.verticalSpace,
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SaudiRiyalSvgWidget(),
                      Flexible(
                        child: Text(
                          salaryDeductionAmount ?? '',
                          style: AppStyles.s12W500.copyWith(
                            color: context.customColor.text1,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          5.verticalSpace,
          ContainerCustomTextField(
            backgroundColor: context.customColor.reversedTextColor,
            padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 8.r),
            borderRadius: BorderRadius.circular(8.r),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    'Reason',
                    style: AppStyles.s12W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                ),
                4.verticalSpace,
                Flexible(
                  child: Text(
                    salaryDeductionReason ?? '',
                    style: AppStyles.s12W500.copyWith(
                      color: context.customColor.text1,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
