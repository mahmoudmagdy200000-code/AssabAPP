import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/extensions/build_context_extensions.dart';
import '../../../../core/widgets/app_svg.dart';
import 'fixed_assets_handover_bottom_sheet_widget.dart';

class FixedAssetsQuickActionsWidget extends StatelessWidget {
  const FixedAssetsQuickActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final quickActions = [
      {'title': context.tr.search, 'icon': AppAssets.search},
      // {'title': context.tr.receiveAssets, 'icon': AppAssets.assetCoinSvg},
      {
        'title': context.tr.transfersAndDisposal,
        'icon': AppAssets.arrowNorthEastSvg,
      },
      {'title': context.tr.handover, 'icon': AppAssets.personSvg},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.tr.quickAction,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: context.customColor.text1,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          height: 120.h,
          padding: EdgeInsets.all(6.r),
          decoration: BoxDecoration(
            color: context.customColor.text2,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              final action = quickActions[index];

              return _buildQuickActionItem(
                context,
                action['title']!,
                action['icon']!,
                onTap: () {
                  switch (index) {
                    case 0:
                      NavigationService.I.pushNamed(
                        AppRouteName.fixedAssetsSearchScreen,
                      );
                      break;
                    case 1:
                      NavigationService.I.pushNamed(
                        AppRouteName.fixedAssetsTransfersAndDisposalScreen,
                      );
                      break;
                    case 2:
                      AppBottomSheet.show(
                        context,
                        (c) => const FixedAssetsHandoverBottomSheetWidget(),
                      );
                      break;
                  }
                },
              );
            },
            separatorBuilder: (context, index) => 6.horizontalSpace,
            itemCount: quickActions.length,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionItem(
    BuildContext context,
    String title,
    String iconPath, {
    required VoidCallback onTap,
  }) {
    return AppGestureDetectorButton(
      onTap: onTap,
      child: Container(
        width: 90.w,
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: context.customColor.reversedTextColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: context.customColor.border),
              ),
              child: AppSvg(
                assetName: iconPath,
                width: 14.r,
                colorFilter: ColorFilter.mode(
                  context.theme.primaryColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              title,
              textAlign: TextAlign.center,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: AppStyles.s11W500.copyWith(
                color: context.customColor.text4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
