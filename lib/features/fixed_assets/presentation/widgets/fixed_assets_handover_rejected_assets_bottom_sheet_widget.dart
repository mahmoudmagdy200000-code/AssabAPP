import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/extensions/widget_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_asset_image.dart';
import 'package:assab/core/widgets/app_network_image.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/button_text_icon.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';

import '../../../../core/routing/app_route_name.dart';
import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/widgets/saudi_riyal_svg_widget.dart';
import '../../data/models/fixed_assets_overview_response.dart';
import '../../domain/enums/fixed_assets_handover_status_filter_enum.dart';

class FixedAssetsHandoverRejectedAssetsBottomSheetWidget
    extends StatelessWidget {
  final List<FixedAssetsOverviewAssetRejectedItem> rejectedAssets;

  const FixedAssetsHandoverRejectedAssetsBottomSheetWidget({
    super.key,
    required this.rejectedAssets,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        top: 30.r,
        child: Column(
          children: [
            Expanded(
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
                  SliverList.builder(
                    itemCount: rejectedAssets.length,
                    itemBuilder: (context, index1) {
                      final asset = rejectedAssets[index1];

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
                                    image: asset.imageUrl,
                                    height: 60.r,
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
                                        asset.name,
                                        style: AppStyles.s14W500.copyWith(
                                          color: context.customColor.text1,
                                        ),
                                      ),
                                      5.verticalSpace,
                                      Text(
                                        asset.zoneName,
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
                            _buildRow(
                              context: context,
                              label: context.tr.zone,
                              value: asset.zoneName,
                            ),
                            10.verticalSpace,
                            const CustomDivider(),
                            10.verticalSpace,
                            _buildRow(
                              context: context,
                              label: context.tr.type,
                              value: asset.assetType,
                            ),
                            // 10.verticalSpace,
                            // const CustomDivider(),
                            // 10.verticalSpace,
                            // _buildRow(
                            //   context: context,
                            //   label: context.tr.value,
                            //   value: asset.value.toString(),
                            //   showCurrency: true,
                            // ),
                            10.verticalSpace,
                            const CustomDivider(),
                            10.verticalSpace,
                            _buildRow(
                              context: context,
                              label: context.tr.age,
                              value: asset.age,
                            ),
                            10.verticalSpace,
                            const CustomDivider(),
                            10.verticalSpace,
                            _buildRow(
                              context: context,
                              label: context.tr.handoverDescription,
                              value: asset.handoverDescription,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            20.verticalSpace,
            CustomTextButton(
              text: context.tr.startNewHandoverForAll,
              onTap: () {
                NavigationService.I.pop();

                NavigationService.I.pushNamed(
                  AppRouteName.fixedAssetsHandoverScreen,
                  arguments: FixedAssetsHandoverStatusFilterEnum.rejected.value,
                );
              },
              backgroundColor: context.theme.primaryColor,
              textColor: context.customColor.reversedTextColor,
              padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 14.r),
              borderRadius: 12.r,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow({
    required BuildContext context,
    required String label,
    required String value,
    bool showCurrency = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            label,
            style: AppStyles.s14W400.copyWith(color: context.customColor.text3),
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
}
