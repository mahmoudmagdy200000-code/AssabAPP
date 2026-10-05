import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:flutter/material.dart';

import '../../../../core/routing/app_route_name.dart';
import '../../data/models/fixed_assets_search_response.dart';
import '../../domain/strategies/fixed_assets_transfers_and_disposal_strategy.dart';
import '../arguments/fixed_assets_transfers_and_disposal_arguments.dart';

class FixedAssetsSearchScreenItemActionsBottomSheet extends StatelessWidget {
  final FixedAssetsSearchItem item;

  const FixedAssetsSearchScreenItemActionsBottomSheet({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        top: 30.r,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              item.name,
              style: AppStyles.s20W600.copyWith(
                color: context.customColor.text1,
              ),
            ),
            3.verticalSpace,
            Text(
              item.code,
              style: AppStyles.s20W600.copyWith(
                color: context.customColor.text1,
              ),
            ),
            14.verticalSpace,
            const CustomDivider(),
            14.verticalSpace,
            Text(
              context.tr.transfer,
              style: AppStyles.s14W500.copyWith(
                color: context.customColor.text3,
              ),
            ),
            12.verticalSpace,
            _buildActionItem(
              context: context,
              title: context.tr.transferAsset,
              icon: AppAssets.callOutArrowSvg,
              onTap: () {
                NavigationService.I.pushNamed(
                  AppRouteName.fixedAssetsTransfersAndDisposalScreen,
                  arguments: FixedAssetsTransfersAndDisposalArguments(
                    strategy:
                        TransferToBranchFixedAssetsTransfersAndDisposalStrategy(),
                    assets: [item],
                  ),
                );
              },
            ),
            16.verticalSpace,
            Text(
              context.tr.update,
              style: AppStyles.s14W500.copyWith(
                color: context.customColor.text3,
              ),
            ),
            12.verticalSpace,
            _buildActionItem(
              context: context,
              title: context.tr.modifyAssetStatus,
              icon: AppAssets.edit,
              onTap: () {
                NavigationService.I.pop();

                NavigationService.I.pushNamed(
                  AppRouteName.fixedAssetsModifyAssetStatusScreen,
                  arguments: item,
                );
              },
            ),
            12.verticalSpace,
            Text(
              context.tr.requests,
              style: AppStyles.s14W500.copyWith(
                color: context.customColor.text3,
              ),
            ),
            16.verticalSpace,
            _buildActionItem(
              context: context,
              title: context.tr.assetsDisposalRequest,
              icon: AppAssets.truckSvg,
              onTap: () {
                NavigationService.I.pushNamed(
                  AppRouteName.fixedAssetsTransfersAndDisposalScreen,
                  arguments: FixedAssetsTransfersAndDisposalArguments(
                    strategy: DisposalFixedAssetsTransfersAndDisposalStrategy(),
                    assets: [item],
                  ),
                );
              },
            ),
            24.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem({
    required BuildContext context,
    required String title,
    required String icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: context.theme.scaffoldBackgroundColor,
          border: Border.all(color: context.customColor.border),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            AppSvg(
              assetName: icon,
              width: 16.r,
              colorFilter: ColorFilter.mode(
                context.theme.primaryColor,
                BlendMode.srcIn,
              ),
            ),
            16.horizontalSpace,
            Expanded(
              child: Text(
                title,
                style: AppStyles.s14W500.copyWith(
                  color: context.customColor.text4,
                ),
              ),
            ),
            AppSvg(
              assetName: AppAssets.arrowRight,
              width: 14.r,
              colorFilter: ColorFilter.mode(
                context.customColor.text1,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
