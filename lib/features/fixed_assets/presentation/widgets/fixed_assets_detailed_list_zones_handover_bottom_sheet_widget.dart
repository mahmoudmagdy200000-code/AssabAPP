import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/extensions/widget_extensions.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_asset_image.dart';
import 'package:assab/core/widgets/app_network_image.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/button_text_icon.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:flutter/material.dart';

import '../../../../core/services/navigation/navigation_service.dart';
import '../../data/models/fixed_assets_handover_included_zones_response.dart';

class FixedAssetsDetailedListZonesHandoverBottomSheetWidget
    extends StatelessWidget {
  final List<FixedAssetsHandoverIncludedZone> includedZones;

  const FixedAssetsDetailedListZonesHandoverBottomSheetWidget({
    super.key,
    required this.includedZones,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        top: 0,
        child: CustomScrollView(
          slivers: [
            Row(
              children: [
                AppAssetImage(
                  image: AppAssets.darkLogo,
                  width: 50.r,
                  borderRadius: BorderRadius.zero,
                ),
                const Spacer(),
                ButtonTextIcon(
                  onTap: () {
                    NavigationService.I.pop();
                  },
                  label: context.tr.close,
                  icon: Icon(Icons.close, size: 20.r),
                  backgroundColor: context.customColor.text2,
                  borderRadius: BorderRadius.circular(1000.r),
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.r,
                    vertical: 8.r,
                  ),
                ),
              ],
            ).sliverBoxAdapter,
            10.verticalSpace.sliverBoxAdapter,
            Text(
              context.tr.zonesDetailedView,
              style: AppStyles.s20W500.copyWith(
                color: context.customColor.text1,
              ),
            ).sliverBoxAdapter,
            3.verticalSpace.sliverBoxAdapter,
            Text(
              context.tr.seeAllZonesLocationsAndLinkedAssets,
              style: AppStyles.s13W400.copyWith(
                color: context.customColor.text3,
              ),
            ).sliverBoxAdapter,
            10.verticalSpace.sliverBoxAdapter,
            const CustomDivider().sliverBoxAdapter,
            10.verticalSpace.sliverBoxAdapter,
            DecoratedSliver(
              decoration: BoxDecoration(
                color: context.customColor.text2,
                borderRadius: BorderRadius.circular(15.r),
              ),
              sliver: SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 8.r, vertical: 8.r),
                sliver: SliverList.builder(
                  itemCount: includedZones.length,
                  itemBuilder: (context, index) {
                    final zone = includedZones[index];

                    return Container(
                      decoration: BoxDecoration(
                        color: context.customColor.reversedTextColor,
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      padding: EdgeInsets.all(10.r),
                      margin: EdgeInsets.only(
                        bottom: index == includedZones.length - 1 ? 0 : 8.r,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              zone.zoneName,
                              style: AppStyles.s14W400.copyWith(
                                color: context.customColor.text4,
                              ),
                            ),
                          ),
                          10.horizontalSpace,
                          Text(
                            '${zone.assetsInZone.length} ${context.tr.assets}',
                            style: AppStyles.s14W500.copyWith(
                              color: context.customColor.text1,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            SliverList.builder(
              itemCount: includedZones.length,
              itemBuilder: (context, index1) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    10.verticalSpace,
                    Text(
                      '${includedZones[index1].zoneName} ${context.tr.assets}\'s (${includedZones[index1].assetsInZone.length})',
                      style: AppStyles.s16W500.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                    10.verticalSpace,
                    Container(
                      decoration: BoxDecoration(
                        color: context.customColor.text2,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      padding: EdgeInsets.all(10.r),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        separatorBuilder: (context, index) => 10.verticalSpace,
                        itemCount: includedZones[index1].assetsInZone.length,
                        itemBuilder: (context, index2) {
                          final asset =
                              includedZones[index1].assetsInZone[index2];
                          return Container(
                            decoration: BoxDecoration(
                              color: context.customColor.reversedTextColor,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            padding: EdgeInsets.all(10.r),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: AppNetworkImage(
                                        image: asset.assetImageURL,
                                        height: 60.r,
                                        borderRadius: BorderRadius.circular(
                                          10.r,
                                        ),
                                      ),
                                    ),
                                    10.horizontalSpace,
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            asset.assetName,
                                            style: AppStyles.s14W500.copyWith(
                                              color: context.customColor.text1,
                                            ),
                                          ),
                                          5.verticalSpace,
                                          Text(
                                            includedZones[index1].zoneName,
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
                                Row(
                                  children: [
                                    Text(
                                      '${includedZones[index1].assetsInZone.length} ${asset.assetName}',
                                      style: AppStyles.s13W400.copyWith(
                                        color: context.customColor.text4,
                                      ),
                                    ),
                                    10.horizontalSpace,
                                    Flexible(
                                      child: Row(
                                        children: [
                                          if (asset
                                                  .totalExcellentConditionQuantityInZone >
                                              0) ...[
                                            Container(
                                              decoration: const BoxDecoration(
                                                color: AppColors.lightGreen,
                                                shape: BoxShape.circle,
                                              ),
                                              padding: EdgeInsets.all(7.r),
                                              child: Text(
                                                '${asset.totalExcellentConditionQuantityInZone}',
                                                style: AppStyles.s11W400
                                                    .copyWith(
                                                      color: context
                                                          .customColor
                                                          .reversedTextColor,
                                                    ),
                                              ),
                                            ),
                                            5.horizontalSpace,
                                          ],
                                          if (asset
                                                  .totalNeedAttentionConditionQuantityInZone >
                                              0) ...[
                                            Container(
                                              decoration: const BoxDecoration(
                                                color: AppColors.yellow,
                                                shape: BoxShape.circle,
                                              ),
                                              padding: EdgeInsets.all(7.r),
                                              child: Text(
                                                '${asset.totalNeedAttentionConditionQuantityInZone}',
                                                style: AppStyles.s11W400
                                                    .copyWith(
                                                      color: context
                                                          .customColor
                                                          .reversedTextColor,
                                                    ),
                                              ),
                                            ),
                                            5.horizontalSpace,
                                          ],
                                          if (asset
                                                  .totalProblemConditionQuantityInZone >
                                              0) ...[
                                            Container(
                                              decoration: const BoxDecoration(
                                                color: AppColors.errorLight,
                                                shape: BoxShape.circle,
                                              ),
                                              padding: EdgeInsets.all(7.r),
                                              child: Text(
                                                '${asset.totalProblemConditionQuantityInZone}',
                                                style: AppStyles.s11W400
                                                    .copyWith(
                                                      color: context
                                                          .customColor
                                                          .reversedTextColor,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
