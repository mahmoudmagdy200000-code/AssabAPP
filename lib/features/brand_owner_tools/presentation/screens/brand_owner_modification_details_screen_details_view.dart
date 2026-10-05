import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/widgets/app_button_loading.dart';
import 'package:assab/core/widgets/app_network_image.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/custom_divider.dart';
import '../../../../core/widgets/saudi_riyal_svg_widget.dart';
import '../../../fixed_assets/domain/strategies/fixed_assets_requests_status_strategy.dart';
import '../../data/models/brand_owner_fixed_assets_modification_details_response.dart';
import '../widgets/brand_owner_fixed_assets_reject_bottom_sheet.dart';

class BrandOwnerModificationDetailsScreenDetailsView extends StatelessWidget {
  final BrandOwnerFixedAssetsModificationDetailsResponse details;
  final bool isActionLoading;
  final VoidCallback onApprove;
  final void Function(String reason) onReject;

  const BrandOwnerModificationDetailsScreenDetailsView({
    super.key,
    required this.details,
    required this.isActionLoading,
    required this.onApprove,
    required this.onReject,
  });

  bool get _canTakeAction =>
      details.status is FixedAssetsRequestsPendingStatusStrategy;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                details.status.buildBrandOwnerModificationDetailsWidget(
                  context,
                  branchName: details.branchName,
                  approvedOn: details.approvedOn,
                  cancelReasonResponse: details.cancelReasonResponse,
                ),
                10.verticalSpace,
                Text(
                  'Financial Impact Analysis',
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
                    children: [
                      _buildRow(
                        context,
                        title: 'Financial Impact',
                        value: details.financialImpactAnalysis.financialImpact,
                        isCurrency: true,
                      ),
                      10.verticalSpace,
                      const CustomDivider(),
                      10.verticalSpace,
                      _buildRow(
                        context,
                        title: 'Operational Impact',
                        value:
                            details.financialImpactAnalysis.operationalImpact,
                      ),
                      10.verticalSpace,
                      const CustomDivider(),
                      10.verticalSpace,
                      _buildRow(
                        context,
                        title: 'Critical Assets',
                        value: details.financialImpactAnalysis.criticalAssets,
                      ),
                      10.verticalSpace,
                      const CustomDivider(),
                      10.verticalSpace,
                      _buildRow(
                        context,
                        title: 'Brand Impact Level',
                        value: details.financialImpactAnalysis.brandImpactLevel,
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
                        title: 'Branch',
                        value: details.asset.branchName,
                      ),
                      _buildRow(
                        context,
                        title: 'Manager',
                        value: details.asset.managerName,
                      ),
                      _buildStatusRow(context),
                      _buildRow(
                        context,
                        title: 'Reason',
                        value: details.asset.reason,
                      ),
                      _buildRow(
                        context,
                        title: 'Value',
                        value: details.asset.value,
                        isCurrency: true,
                      ),
                      _buildRow(
                        context,
                        title: 'Critical Asset',
                        value: details.asset.criticalAsset ? 'Yes' : 'No',
                      ),
                      _buildRow(
                        context,
                        title: 'Brand Impact',
                        value: details.asset.brandImpact,
                      ),
                      20.verticalSpace,
                      AppNetworkImage(
                        image: details.asset.documentationPhotoUrl,
                        height: 200.r,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      10.verticalSpace,
                      ContainerCustomTextField(
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                details.asset.additionalNotes,
                                style: AppStyles.s14W400.copyWith(
                                  color: context.customColor.text1,
                                ),
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
          ),
        ),
        if (_canTakeAction) ...[
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

  Widget _buildStatusRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12.r,
                height: 12.r,
                decoration: BoxDecoration(
                  color: details.asset.currentStatus.color,
                  shape: BoxShape.circle,
                ),
              ),
              5.horizontalSpace,
              Flexible(
                child: Text(
                  details.asset.currentStatus.label(context),
                  style: AppStyles.s13W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
              ),
            ],
          ),
        ),
        5.horizontalSpace,
        Icon(
          Icons.double_arrow_sharp,
          color: context.customColor.text3,
          size: 16.r,
        ),
        5.horizontalSpace,
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12.r,
                height: 12.r,
                decoration: BoxDecoration(
                  color: details.asset.newStatus.color,
                  shape: BoxShape.circle,
                ),
              ),
              5.horizontalSpace,
              Flexible(
                child: Text(
                  details.asset.newStatus.label(context),
                  style: AppStyles.s13W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
