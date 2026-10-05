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
import '../../../fixed_assets/domain/enums/fixed_assets_transfer_types_enum.dart';
import '../../../fixed_assets/domain/enums/fixed_assets_transfers_and_disposal_enum.dart';
import '../../../fixed_assets/domain/strategies/fixed_assets_requests_status_strategy.dart';
import '../../domain/stragegies/brand_owner_fixed_assets_handover_reports_status_strategy.dart';
import '../../data/models/brand_owner_fixed_assets_disposal_and_external_transfer_details_response.dart';
import '../widgets/brand_owner_fixed_assets_deduction_amount_bottom_sheet.dart';
import '../widgets/brand_owner_fixed_assets_reject_bottom_sheet.dart';
import '../widgets/brand_owner_fixed_assets_written_warning_bottom_sheet.dart';

class BrandOwnerDisposalAndExternalTransferDetailsScreenDetailsView
    extends StatelessWidget {
  final BrandOwnerFixedAssetsDisposalAndExternalTransferDetailsResponse details;
  final bool isActionLoading;
  final VoidCallback onApprove;
  final void Function(String reason) onReject;

  const BrandOwnerDisposalAndExternalTransferDetailsScreenDetailsView({
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
                    .buildBrandOwnerDisposalAndExternalTransferDetailsWidget(
                      context,
                      branchName: details.branchName,
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
                      _buildDetailRow(
                        context,
                        'Submitted By',
                        '${details.submittedByBranchName} - Manager: ${details.submittedByManagerName}',
                      ),
                      _buildDetailRow(
                        context,
                        'Request Type',
                        details.type.strategy.labelText(context),
                      ),
                      _buildRow(
                        context,
                        title: 'Submitted On',
                        value: details.submittedOn,
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
                    spacing: 15.h,
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
                        title: 'Zone',
                        value: details.asset.zoneName,
                      ),
                      _buildRow(
                        context,
                        title: 'Condition',
                        value: details.asset.condition.condition.label(context),
                      ),
                      _buildRow(
                        context,
                        title: 'Reason',
                        value: details.asset.reasonForDisposal,
                      ),
                      2.verticalSpace,
                      Text(
                        'Visual Evidence',
                        style: AppStyles.s13W400.copyWith(
                          color: context.customColor.text3,
                        ),
                      ),
                      AppNetworkImage(
                        image: details.asset.evidenceImageUrl,
                        height: 200.r,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (details.status is FixedAssetsRequestsPendingStatusStrategy) ...[
          20.verticalSpace,
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
