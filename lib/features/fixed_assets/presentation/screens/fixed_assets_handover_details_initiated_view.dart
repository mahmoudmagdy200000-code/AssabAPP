import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_check_box.dart';
import 'package:assab/core/widgets/app_network_image.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/profile_image_widget.dart';
import 'package:flutter/material.dart';

import '../../../../core/enums/purchasing_officer_notification_enum.dart';
import '../../../../core/styles/app_styles.dart';
import '../../data/models/fixed_assets_handover_details_response.dart';
import '../../domain/strategies/fixed_assets_handover_strategy.dart';

class FixedAssetsHandoverDetailsInitiatedView extends StatelessWidget {
  final FixedAssetsHandoverStrategy status;
  final FixedAssetsHandoverDetailsInitiated initiatedDetails;
  final String recipientName;

  const FixedAssetsHandoverDetailsInitiatedView({
    super.key,
    required this.status,
    required this.initiatedDetails,
    required this.recipientName,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          status.buildStatusDetailsWidget(
            context,
            recipientName: recipientName,
          ),
          10.verticalSpace,
          Container(
            decoration: BoxDecoration(
              color: context.customColor.text2,
              borderRadius: BorderRadius.circular(12.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 12.r),
            child: Column(
              spacing: 10.h,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: context.customColor.reversedTextColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.r,
                    vertical: 12.r,
                  ),
                  child: Column(
                    children: [
                      AppNetworkImage(
                        image: initiatedDetails.qrCodeImageUrl,
                        width: 150.h,
                        height: 150.h,
                        borderRadius: BorderRadius.zero,
                      ),
                      10.verticalSpace,
                      Text(
                        'Session Code:',
                        style: AppStyles.s14W400.copyWith(
                          color: context.customColor.text3,
                        ),
                      ),
                      10.verticalSpace,
                      Text(
                        initiatedDetails.sessionCode,
                        style: AppStyles.s15W500.copyWith(
                          color: context.customColor.text1,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${context.tr.recipient}:',
                  style: AppStyles.s16W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: context.customColor.reversedTextColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.r,
                    vertical: 12.r,
                  ),
                  child: Row(
                    children: [
                      const ProfileImageWidget(),
                      10.horizontalSpace,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              initiatedDetails.receiver.receiverName,
                              style: AppStyles.s14W400.copyWith(
                                color: context.customColor.text1,
                              ),
                            ),
                            Text(
                              initiatedDetails.receiver.receiverNumber,
                              style: AppStyles.s12W400.copyWith(
                                color: context.customColor.text3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${context.tr.zonesHandedOver}:',
                  style: AppStyles.s16W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: context.customColor.reversedTextColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.r,
                    vertical: 12.r,
                  ),
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  initiatedDetails.zones[index].zoneName,
                                  style: AppStyles.s14W400.copyWith(
                                    color: context.customColor.text3,
                                  ),
                                ),
                              ),
                              10.horizontalSpace,
                              Flexible(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        '${initiatedDetails.zones[index].assetsCountHandedOver} ${context.tr.assets}',
                                        style: AppStyles.s14W500.copyWith(
                                          color: context.customColor.text1,
                                        ),
                                      ),
                                    ),
                                    4.horizontalSpace,
                                    AppSvg(
                                      assetName: AppAssets.check,
                                      colorFilter: ColorFilter.mode(
                                        context.theme.primaryColor,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          if (index != initiatedDetails.zones.length - 1) ...[
                            8.verticalSpace,
                            const CustomDivider(),
                            8.verticalSpace,
                          ],
                        ],
                      );
                    },
                    separatorBuilder: (context, index) => 8.verticalSpace,
                    itemCount: initiatedDetails.zones.length,
                  ),
                ),
                Text(
                  '${context.tr.notesAndSummary}:',
                  style: AppStyles.s16W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: context.customColor.reversedTextColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.r,
                    vertical: 12.r,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.tr.additionalNote,
                        style: AppStyles.s15W500.copyWith(
                          color: context.customColor.text4,
                        ),
                      ),
                      5.verticalSpace,
                      Text(
                        initiatedDetails.note,
                        style: AppStyles.s14W400.copyWith(
                          color: context.customColor.text1,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${context.tr.notifications}:',
                  style: AppStyles.s16W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: context.customColor.reversedTextColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.r,
                    vertical: 12.r,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                context.tr.sms,
                                style: AppStyles.s14W400.copyWith(
                                  color: context.customColor.text1,
                                ),
                              ),
                            ),
                            5.horizontalSpace,
                            AppCheckBox(
                              onChanged: (value) {},
                              value: initiatedDetails.notifications.any(
                                (element) =>
                                    element ==
                                    PurchasingOfficerNotificationEnum.sms,
                              ),
                            ),
                          ],
                        ),
                      ),
                      10.horizontalSpace,
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                context.tr.whatsApp,
                                style: AppStyles.s14W400.copyWith(
                                  color: context.customColor.text1,
                                ),
                              ),
                            ),
                            5.horizontalSpace,
                            AppCheckBox(
                              onChanged: (value) {},
                              value: initiatedDetails.notifications.any(
                                (element) =>
                                    element ==
                                    PurchasingOfficerNotificationEnum.whatsApp,
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
        ],
      ),
    );
  }
}
