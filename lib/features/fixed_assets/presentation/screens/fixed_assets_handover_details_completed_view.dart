import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/utils/date_formatter.dart';
import 'package:assab/features/fixed_assets/data/models/fixed_assets_handover_details_response.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/button_text_icon.dart';
import '../../../../core/widgets/container_custom_text_field.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../../../core/widgets/profile_image_widget.dart';
import '../../../../core/widgets/saudi_riyal_svg_widget.dart';
import '../../domain/strategies/fixed_assets_handover_strategy.dart';
import '../../domain/strategies/fixed_assets_handover_type_strategy.dart';

class FixedAssetsHandoverDetailsCompletedView extends StatelessWidget {
  final String handoverId;
  final FixedAssetsHandoverStrategy status;
  final FixedAssetsHandoverTypeStrategy type;
  final FixedAssetsHandoverDetailsCompleted completedDetails;
  final String recipientName;
  final bool isDeduction;
  final FixedAssetsHandoverDetailsCompletedDeduction? deductionDetails;

  const FixedAssetsHandoverDetailsCompletedView({
    super.key,
    required this.handoverId,
    required this.status,
    required this.type,
    required this.completedDetails,
    required this.recipientName,
    required this.isDeduction,
    required this.deductionDetails,
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
                if (isDeduction) ...[
                  _buildDeductionDetails(context, deductionDetails),
                  10.verticalSpace,
                ],
                status.buildStatusDetailsWidget(
                  context,
                  recipientName: recipientName,
                ),
                10.verticalSpace,
                Text(
                  context.tr.sessionResults,
                  style: AppStyles.s16W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                5.verticalSpace,
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: context.customColor.text2,
                      width: 6.r,
                    ),
                    color: context.customColor.reversedTextColor,
                  ),
                  padding: EdgeInsets.all(12.r),
                  child: Column(
                    children: [
                      _buildRow(
                        context: context,
                        label: context.tr.date,
                        value:
                            DateFormatter.formatDateMDY(
                              DateTime.tryParse(completedDetails.date),
                            ) ??
                            '-',
                        icon: AppSvg(
                          assetName: AppAssets.calendar,
                          width: 15.w,
                          colorFilter: ColorFilter.mode(
                            context.customColor.text3,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      10.verticalSpace,
                      const CustomDivider(),
                      10.verticalSpace,
                      _buildRow(
                        context: context,
                        label: context.tr.duration,
                        value: completedDetails.duration,
                        icon: AppSvg(
                          assetName: AppAssets.clockSvg,
                          width: 15.w,
                          colorFilter: ColorFilter.mode(
                            context.customColor.text3,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      10.verticalSpace,
                      const CustomDivider(),
                      10.verticalSpace,
                      _buildRow(
                        context: context,
                        label: context.tr.assets,
                        value: completedDetails.assetsCount.toString(),
                        icon: AppSvg(
                          assetName: AppAssets.fixedAssets,
                          width: 15.w,
                          colorFilter: ColorFilter.mode(
                            context.customColor.text3,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      10.verticalSpace,
                      const CustomDivider(),
                      10.verticalSpace,
                      _buildRow(
                        context: context,
                        label: context.tr.value,
                        value: completedDetails.value.toString(),
                        showCurrency: true,
                        icon: AppSvg(
                          assetName: AppAssets.cash,
                          width: 15.w,
                          colorFilter: ColorFilter.mode(
                            context.customColor.text3,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      10.verticalSpace,
                      const CustomDivider(),
                      10.verticalSpace,
                      _buildRow(
                        context: context,
                        label: context.tr.accepted,
                        value:
                            '${completedDetails.acceptedCount} (${completedDetails.acceptedPercentage}%)',
                        icon: AppSvg(
                          assetName: AppAssets.check,
                          width: 15.w,
                          colorFilter: const ColorFilter.mode(
                            AppColors.lightGreen,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      10.verticalSpace,
                      const CustomDivider(),
                      10.verticalSpace,
                      _buildRow(
                        context: context,
                        label: context.tr.notes,
                        value: completedDetails.noteCount.toString(),
                        icon: AppSvg(
                          assetName: AppAssets.warning,
                          width: 15.w,
                          colorFilter: const ColorFilter.mode(
                            AppColors.yellow,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      10.verticalSpace,
                      const CustomDivider(),
                      10.verticalSpace,
                      _buildRow(
                        context: context,
                        label: context.tr.rejected,
                        value: completedDetails.rejectedCount.toString(),
                        icon: Icon(
                          Icons.close,
                          size: 15.r,
                          color: context.customColor.error,
                        ),
                      ),
                      10.verticalSpace,
                      const CustomDivider(),
                      10.verticalSpace,
                      _buildRow(
                        context: context,
                        label: context.tr.photosTaken,
                        value: completedDetails.photoTakenCount.toString(),
                        icon: Icon(
                          Icons.camera_alt,
                          size: 15.r,
                          color: context.theme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                10.verticalSpace,
                Text(
                  context.tr.recordedDiscrepancies,
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
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: completedDetails.recordedDiscrepancies.length,
                    itemBuilder: (context, index) {
                      final discrepancy =
                          completedDetails.recordedDiscrepancies[index];

                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          color: context.customColor.reversedTextColor,
                        ),
                        padding: EdgeInsets.all(12.r),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: AppNetworkImage(
                                    image: discrepancy.assetImageUrl,
                                    height: 100.r,
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                ),
                                10.horizontalSpace,
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        discrepancy.assetName,
                                        style: AppStyles.s14W500.copyWith(
                                          color: context.customColor.text1,
                                        ),
                                      ),
                                      5.verticalSpace,
                                      Text(
                                        discrepancy.assetCode,
                                        style: AppStyles.s13W400.copyWith(
                                          color: context.customColor.text3,
                                        ),
                                      ),
                                      5.verticalSpace,
                                      Text(
                                        discrepancy.zoneName,
                                        style: AppStyles.s13W400.copyWith(
                                          color: context.customColor.text3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            10.verticalSpace,
                            const CustomDivider(),
                            10.verticalSpace,
                            ButtonTextIcon(
                              onTap: () {},
                              label: context.tr.viewAttachedDiscrepancy,
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                size: 15.r,
                                color: context.customColor.text4,
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.r,
                                vertical: 8.r,
                              ),
                              reversed: true,
                              backgroundColor: context.customColor.text2,
                              textColor: context.customColor.text4,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
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
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          color: context.customColor.reversedTextColor,
                        ),
                        padding: EdgeInsets.all(8.r),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ProfileImageWidget(width: 40.r, height: 40.r),
                            10.horizontalSpace,
                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          '${completedDetails.sender.name} (${context.tr.handover})',
                                          style: AppStyles.s15W500.copyWith(
                                            color: context.customColor.text1,
                                          ),
                                        ),
                                      ),
                                      10.horizontalSpace,
                                      Flexible(
                                        child: Text(
                                          DateFormatter.formatTimeHM(
                                                DateTime.tryParse(
                                                  completedDetails
                                                      .senderSignedAt,
                                                ),
                                              ) ??
                                              '-',
                                          style: AppStyles.s12W400.copyWith(
                                            color: context.customColor.text4,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  5.verticalSpace,
                                  Text(
                                    context
                                        .tr
                                        .iConfirmHandoverWithNotedDiscrepancies,
                                    style: AppStyles.s13W400.copyWith(
                                      color: const Color(0xFF046B6B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      10.verticalSpace,
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          color: context.customColor.reversedTextColor,
                        ),
                        padding: EdgeInsets.all(8.r),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ProfileImageWidget(width: 40.r, height: 40.r),
                            10.horizontalSpace,
                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          '${completedDetails.receiver.name} (${context.tr.recipient})',
                                          style: AppStyles.s15W500.copyWith(
                                            color: context.customColor.text1,
                                          ),
                                        ),
                                      ),
                                      10.horizontalSpace,
                                      Flexible(
                                        child: Text(
                                          DateFormatter.formatTimeHM(
                                                DateTime.tryParse(
                                                  completedDetails
                                                      .receiverSignedAt,
                                                ),
                                              ) ??
                                              '-',
                                          style: AppStyles.s12W400.copyWith(
                                            color: context.customColor.text4,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  5.verticalSpace,
                                  Text(
                                    context
                                        .tr
                                        .receivedAssetsWithRequiredDocumentation,
                                    style: AppStyles.s13W400.copyWith(
                                      color: const Color(0xFF046B6B),
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
                10.verticalSpace,
                Text(
                  context.tr.automaticDispatch,
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
                      _buildRow(
                        context: context,
                        label: context.tr.owner,
                        value: context.tr.fullReport,
                      ),
                      10.verticalSpace,
                      const CustomDivider(),
                      10.verticalSpace,
                      _buildRow(
                        context: context,
                        label: context.tr.brandManager,
                        value: context.tr.executiveSummary,
                      ),
                      10.verticalSpace,
                      const CustomDivider(),
                      10.verticalSpace,
                      _buildRow(
                        context: context,
                        label: context.tr.finance,
                        value: context.tr.assetValueUpdate,
                      ),
                      10.verticalSpace,
                      const CustomDivider(),
                      10.verticalSpace,
                      _buildRow(
                        context: context,
                        label: context.tr.message,
                        value: context.tr
                            .handoverCompleteWithRecordedDiscrepancies(
                              completedDetails.rejectedCount,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        type.buildButtonDetailsWidget(
          context,
          handoverId: handoverId,
          status: status,
        ),
      ],
    );
  }

  Widget _buildRow({
    required BuildContext context,
    required String label,
    required String value,
    Widget? icon,
    bool showCurrency = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Row(
            children: [
              ?icon,
              if (icon != null) 5.horizontalSpace,
              Flexible(
                child: Text(
                  label,
                  style: AppStyles.s14W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
              ),
            ],
          ),
        ),
        10.horizontalSpace,
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showCurrency) const SaudiRiyalSvgWidget(),
              2.horizontalSpace,
              Flexible(
                child: Text(
                  value,
                  style: AppStyles.s14W500.copyWith(
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

  Widget _buildDeductionDetails(
    BuildContext context,
    FixedAssetsHandoverDetailsCompletedDeduction? deductionDetails,
  ) {
    final String employeeResponsible = deductionDetails?.employeeName ?? '-';
    final String salaryDeductionAmount =
        deductionDetails?.amount.toString() ?? '-';
    final String salaryDeductionReason = deductionDetails?.reason ?? '-';

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
                          salaryDeductionAmount,
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
                    salaryDeductionReason,
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
