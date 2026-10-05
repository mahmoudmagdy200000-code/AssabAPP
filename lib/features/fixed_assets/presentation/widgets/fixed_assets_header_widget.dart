import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/utils/app_logger.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/extensions/build_context_extensions.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/app_svg.dart';
import '../screens/fixed_assets_handover_scanner_screen.dart';

class FixedAssetsHeaderWidget extends StatelessWidget {
  const FixedAssetsHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: context.customColor.reversedTextColor,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.r)),
      ),
      margin: EdgeInsets.only(top: 30.r, bottom: 12.r),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppBackButton(
            isTransparent: true,
            iconColor: context.customColor.text1,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr.assetManagement,
                  style: AppStyles.s16W600.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  context.tr.nakheelMainBranchNorth,
                  style: AppStyles.s12W500.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
              ],
            ),
          ),
          10.horizontalSpace,
          AppGestureDetectorButton(
            onTap: () {
              AppBottomSheet.customPageRoute(
                context,
                (context) => FixedAssetsHandoverScannerScreen(
                  onDetect: (data) async {
                    AppLogger.log('QR Code Detected: $data');

                    NavigationService.I.popUntil(
                      (route) =>
                          route.settings.name == AppRouteName.fixedAssetsScreen,
                    );

                    await NavigationService.I.pushNamed(
                      AppRouteName.fixedAssetsJoinHandoverScreen,
                      arguments: data['handoverId'].toString(),
                    );
                  },
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.customColor.reversedTextColor,
                border: Border.all(color: context.customColor.border),
              ),
              child: AppSvg(
                assetName: AppAssets.qrScanSvg,
                width: 20.r,
                height: 20.r,
              ),
            ),
          ),
          10.horizontalSpace,
          AppGestureDetectorButton(
            onTap: () {
              NavigationService.I.pushNamed(
                AppRouteName.fixedAssetsRequestsScreen,
              );
            },
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.customColor.reversedTextColor,
                    border: Border.all(color: context.customColor.border),
                  ),
                  child: AppSvg(
                    assetName: AppAssets.transactionHistorySvg,
                    width: 20.r,
                    height: 20.r,
                  ),
                ),
                // Positioned(
                //   right: -4.w,
                //   top: -4.h,
                //   child: Container(
                //     padding: EdgeInsets.all(4.r),
                //     decoration: const BoxDecoration(
                //       color: Color(0xFFE51B92),
                //       shape: BoxShape.circle,
                //     ),
                //     child: Text(
                //       '16',
                //       style: AppStyles.s10W500.copyWith(
                //         color: context.customColor.reversedTextColor,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
