import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/widgets/app_button_loading.dart';
import 'package:assab/core/widgets/app_network_image.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/profile_image_widget.dart';
import '../../../../core/widgets/saudi_riyal_svg_widget.dart';
import '../../data/models/brand_owner_fixed_assets_handover_report_details_response.dart';
import '../../domain/stragegies/brand_owner_fixed_assets_handover_reports_status_strategy.dart';
import '../widgets/brand_owner_fixed_assets_deduction_amount_bottom_sheet.dart';
import '../widgets/brand_owner_fixed_assets_written_warning_bottom_sheet.dart';

class BrandOwnerHandoverDetailsDetailsScreenDetailsView
    extends StatelessWidget {
  final BrandOwnerFixedAssetsHandoverReportDetailsResponse details;
  final bool isActionLoading;
  final void Function(String warningNote) onWrittenWarning;
  final void Function(String amount, String reason) onSalaryDeduction;

  const BrandOwnerHandoverDetailsDetailsScreenDetailsView({
    super.key,
    required this.details,
    required this.isActionLoading,
    required this.onWrittenWarning,
    required this.onSalaryDeduction,
  });

  bool get _canTakeAction =>
      details.status
          is BrandOwnerFixedAssetsHandoverReportsPendingApprovalStatusStrategy;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                details.status.buildBrandOwnerHandoverDetailsWidget(
                  context,
                  branchName: details.routeDetails.fromBranchName,
                  branchNameTo: details.routeDetails.toBranchName,
                  employeeResponsible: details.employeeResponsible,
                  warningNote: details.warningNote,
                  salaryDeductionAmount: details.salaryDeductionAmount,
                  salaryDeductionReason: details.salaryDeductionReason,
                  approvedOn: details.approvedOn,
                  cancelReasonResponse: details.cancelReasonResponse,
                ),
                10.verticalSpace,
                Text(
                  'Request Details',
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
                      _buildRow(
                        context,
                        title: 'Request ID',
                        value: details.routeDetails.requestId,
                      ),
                      _buildRow(
                        context,
                        title: 'Session Code',
                        value: details.routeDetails.sessionCode,
                      ),
                      _buildDestinationRow(context),
                      _buildRow(
                        context,
                        title: 'Success rate',
                        value: details.routeDetails.successRate,
                      ),
                      _buildRow(
                        context,
                        title: 'Discrepancies',
                        value: details.routeDetails.discrepancies,
                      ),
                      _buildRow(
                        context,
                        title: 'Handover Date',
                        value: details.routeDetails.handoverDate,
                      ),
                      _buildRow(
                        context,
                        title: 'Session Duration',
                        value: details.routeDetails.sessionDuration,
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
                ListView.builder(
                  itemCount: details.assets.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    final asset = details.assets[index];
                    return Container(
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
                                  image: asset.imageUrl,
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
                                      asset.name,
                                      style: AppStyles.s14W500.copyWith(
                                        color: context.customColor.text1,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      asset.subtitle,
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
                            title: 'Affected Value',
                            value: asset.affectedValue,
                            isCurrency: true,
                          ),
                          Text(
                            asset.evidenceCaption,
                            style: AppStyles.s13W400.copyWith(
                              color: context.customColor.text3,
                            ),
                          ),
                          AppNetworkImage(
                            image: asset.evidenceImageUrl,
                            height: 200.r,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                10.verticalSpace,
                Text(
                  context.tr.digitalSignatures,
                  style: AppStyles.s16W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                5.verticalSpace,
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: context.customColor.text2,
                  ),
                  padding: EdgeInsets.all(8.r),
                  child: Column(
                    children: [
                      _buildSignatureCard(
                        context,
                        title:
                            '${details.signatureDetails.sender.name} (${details.signatureDetails.sender.roleLabel})',
                        signedAt: details.signatureDetails.sender.signedAt,
                        note: details.signatureDetails.sender.note,
                      ),
                      10.verticalSpace,
                      _buildSignatureCard(
                        context,
                        title:
                            '${details.signatureDetails.receiver.name} (${details.signatureDetails.receiver.roleLabel})',
                        signedAt: details.signatureDetails.receiver.signedAt,
                        note: details.signatureDetails.receiver.note,
                      ),
                    ],
                  ),
                ),
                10.verticalSpace,
                Text(
                  'Financial Analysis',
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
                      _buildRow(
                        context,
                        title: 'Total Affected Value',
                        value: details.financialAnalysis.totalAffectedValue,
                        isCurrency: true,
                      ),
                      _buildRow(
                        context,
                        title: 'Impact Ratio',
                        value: details.financialAnalysis.impactRatio,
                      ),
                      _buildRow(
                        context,
                        title:
                            'Employee Record (${details.employeeResponsible ?? '-'})',
                        value: details.financialAnalysis.employeeRecord,
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
                        text: 'Written Warning',
                        onTap: () {
                          AppBottomSheet.customPageRoute(
                            context,
                            (context) =>
                                BrandOwnerFixedAssetsWrittenWarningBottomSheet(
                                  onWarning: onWrittenWarning,
                                  senderName:
                                      details.employeeResponsible ?? '-',
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
                        text: 'Salary Deduction',
                        onTap: () {
                          AppBottomSheet.customPageRoute(
                            context,
                            (context) =>
                                BrandOwnerFixedAssetsDeductionAmountBottomSheet(
                                  onDeduction: onSalaryDeduction,
                                  senderName:
                                      details.employeeResponsible ?? '-',
                                ),
                          );
                        },
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

  Widget _buildSignatureCard(
    BuildContext context, {
    required String title,
    required String signedAt,
    required String note,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: context.customColor.reversedTextColor,
      ),
      padding: EdgeInsets.all(8.r),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ProfileImageWidget(width: 40, height: 40),
          10.horizontalSpace,
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        style: AppStyles.s15W500.copyWith(
                          color: context.customColor.text1,
                        ),
                      ),
                    ),
                    10.horizontalSpace,
                    Flexible(
                      child: Text(
                        signedAt,
                        style: AppStyles.s12W400.copyWith(
                          color: context.customColor.text4,
                        ),
                      ),
                    ),
                  ],
                ),
                5.verticalSpace,
                Text(
                  note,
                  style: AppStyles.s13W400.copyWith(
                    color: const Color(0xFF046B6B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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

  Widget _buildDestinationRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Text(
            'Destination',
            style: AppStyles.s12W400.copyWith(color: context.customColor.text3),
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
                      text: details.routeDetails.fromBranchName,
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
                      text: details.routeDetails.toBranchName,
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
    );
  }
}
