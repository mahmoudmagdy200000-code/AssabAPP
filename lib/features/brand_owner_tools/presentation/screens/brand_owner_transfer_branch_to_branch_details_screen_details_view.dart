import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/widgets/app_network_image.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/enums/cancel_reason_user_type_enum.dart';
import '../../../../core/widgets/app_button_loading.dart';
import '../../../../core/widgets/profile_image_widget.dart';
import '../../../../core/widgets/saudi_riyal_svg_widget.dart';
import '../../../../shared/models/cancel_reason/cancel_reason_response.dart';
import '../../../fixed_assets/domain/enums/fixed_assets_condition_enum.dart';
import '../../../fixed_assets/domain/strategies/fixed_assets_requests_status_strategy.dart';
import '../../domain/stragegies/brand_owner_fixed_assets_handover_reports_status_strategy.dart';
import '../../data/models/brand_owner_fixed_assets_transfer_details_response.dart';
import '../widgets/brand_owner_fixed_assets_deduction_amount_bottom_sheet.dart';
import '../widgets/brand_owner_fixed_assets_reject_bottom_sheet.dart';
import '../widgets/brand_owner_fixed_assets_written_warning_bottom_sheet.dart';

class BrandOwnerTransferBranchToBranchDetailsScreenDetailsView
    extends StatelessWidget {
  final BrandOwnerFixedAssetsTransferDetailsResponse details;
  final bool isActionLoading;
  final VoidCallback onApprove;
  final void Function(String reason) onReject;

  const BrandOwnerTransferBranchToBranchDetailsScreenDetailsView({
    super.key,
    required this.details,
    required this.isActionLoading,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                details.status
                    .buildBrandOwnerTransferBranchToBranchDetailsWidget(
                      context,
                      branchName: details.fromBranchName,
                      branchNameTo: details.toBranchName,
                      approvedOn: details.approvedOn,
                      cancelReasonResponse: details.cancelReasonResponse,
                    ),
                10.verticalSpace,
                Text(
                  'Request Details:',
                  style: AppStyles.s16W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                5.verticalSpace,
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: context.customColor.border),
                  ),
                  padding: EdgeInsets.all(12.r),
                  child: Column(
                    spacing: 12.h,
                    children: [
                      _buildDetailRow(context, 'Request ID', details.id),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Text(
                              'Destination',
                              style: AppStyles.s12W400.copyWith(
                                color: context.customColor.text3,
                              ),
                            ),
                          ),
                          10.horizontalSpace,
                          Flexible(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: 'From: ',
                                    style: AppStyles.s13W400.copyWith(
                                      color: context.customColor.text3,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: details.fromBranchName,
                                        style: AppStyles.s13W500.copyWith(
                                          color: context.customColor.text1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                10.verticalSpace,
                                Icon(
                                  Icons.keyboard_double_arrow_down_outlined,
                                  color: context.theme.primaryColor,
                                  size: 18.r,
                                ),
                                10.verticalSpace,
                                RichText(
                                  text: TextSpan(
                                    text: 'To: ',
                                    style: AppStyles.s13W400.copyWith(
                                      color: context.customColor.text3,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: details.toBranchName,
                                        style: AppStyles.s13W500.copyWith(
                                          color: context.customColor.text1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      _buildRow(
                        context,
                        title: 'Requested by',
                        value: details.submittedByManagerName,
                      ),
                      _buildRow(
                        context,
                        title: 'Supported by',
                        value: details.supportedByManagerName,
                      ),
                      _buildRow(
                        context,
                        title: 'Request Date',
                        value: details.submittedOn,
                      ),
                      _buildRow(
                        context,
                        title: 'Asset Value',
                        value: details.asset.affectedValue,
                        isCurrency: true,
                      ),
                    ],
                  ),
                ),
                10.verticalSpace,
                Text(
                  'Asset Details',
                  style: AppStyles.s16W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                5.verticalSpace,
                Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: context.customColor.reversedTextColor,
                    border: Border.all(
                      color: context.customColor.text2,
                      width: 5.r,
                    ),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Column(
                    spacing: 12.h,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: AppNetworkImage(
                              image: details.asset.imageUrl,
                              height: 70.r,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  details.asset.name,
                                  style: AppStyles.s14W500.copyWith(
                                    color: context.customColor.text1,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  details.asset.code,
                                  style: AppStyles.s14W500.copyWith(
                                    color: context.customColor.text1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Divider(color: context.customColor.text2, height: 1),
                      _buildRow(
                        context,
                        title: 'Brand Standard',
                        value: details.asset.brandStandard,
                      ),
                      _buildRow(
                        context,
                        title: 'Status',
                        value: details.asset.condition.label(context),
                      ),
                      _buildRow(
                        context,
                        title: 'Critical Asset',
                        value: details.asset.isCritical ? 'Yes' : 'No',
                      ),
                      _buildRow(
                        context,
                        title: 'Last Service',
                        value: details.asset.lastService,
                      ),
                    ],
                  ),
                ),
                10.verticalSpace,
                Text(
                  'Business Justification',
                  style: AppStyles.s16W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                5.verticalSpace,
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: context.customColor.border),
                  ),
                  padding: EdgeInsets.all(12.r),
                  child: Column(
                    spacing: 12.h,
                    children: [
                      _buildDetailRow(
                        context,
                        'North Branch',
                        '"Low drink sales, excess capacity"',
                      ),
                      _buildRow(
                        context,
                        title: 'East Branch',
                        value: '"30% increase in drink sales"',
                      ),
                      _buildRow(
                        context,
                        title: 'Strategic Impacty',
                        value: 'Optimal resource allocation',
                      ),
                      _buildRow(
                        context,
                        title: 'Brand Standards',
                        value: 'Maintained at both locations',
                      ),
                    ],
                  ),
                ),
                10.verticalSpace,
                Text(
                  'Brand Impact Analysis',
                  style: AppStyles.s16W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                5.verticalSpace,
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: context.customColor.border),
                  ),
                  padding: EdgeInsets.all(12.r),
                  child: Column(
                    spacing: 12.h,
                    children: [
                      _buildDetailRow(
                        context,
                        'Customer Experience:',
                        'Enhanced',
                      ),
                      _buildRow(
                        context,
                        title: 'Brand Consistency:',
                        value: 'Maintained',
                      ),
                      _buildRow(
                        context,
                        title: 'Operational Efficiency:',
                        value: 'Improved',
                      ),
                      _buildRow(
                        context,
                        title: 'Financial Impact:',
                        value: 'Neutral (Internal)',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        20.verticalSpace,
        if (details.status
            is FixedAssetsRequestsPendingFinalApprovalStatusStrategy) ...[
          isActionLoading
              ? const AppButtonLoading()
              : Row(
                  spacing: 10.w,
                  children: [
                    Expanded(
                      child: CustomTextButton(
                        text: context.tr.reject,
                        onTap: () {
                          AppBottomSheet.customPageRoute(
                            context,
                            (context) => BrandOwnerFixedAssetsRejectBottomSheet(
                              onReject: onReject,
                            ),
                          );
                        },
                        backgroundColor: Colors.transparent,
                        borderRadius: 15.r,
                        padding: EdgeInsets.symmetric(vertical: 14.r),
                        textColor: context.customColor.text1,
                      ),
                    ),
                    Expanded(
                      child: CustomTextButton(
                        text: context.tr.approve,
                        onTap: onApprove,
                        backgroundColor: context.theme.primaryColor,
                        borderRadius: 15.r,
                        padding: EdgeInsets.symmetric(vertical: 14.r),
                        textColor: context.customColor.reversedTextColor,
                      ),
                    ),
                  ],
                ),
        ],
      ],
    );
  }

  Widget _buildRow(
    BuildContext context, {
    required String title,
    required String value,
    bool isCurrency = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            title,
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
          ),
        ),
        5.horizontalSpace,
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isCurrency) const SaudiRiyalSvgWidget(),
              Flexible(
                child: Text(
                  value,
                  style: AppStyles.s13W500.copyWith(
                    color: context.customColor.text1,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value, {
    Color? statusColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            label,
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
          ),
        ),
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  value,
                  style: AppStyles.s13W500.copyWith(
                    color: context.customColor.text1,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
              if (statusColor != null) ...[
                SizedBox(width: 8.w),
                Container(
                  width: 8.r,
                  height: 8.r,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
