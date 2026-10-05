import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_bottom_sheet.dart';
import 'brand_owner_approve_inventory_bottom_sheet.dart';
import 'brand_owner_reject_inventory_bottom_sheet.dart';

class BrandOwnerInventoryGeneralActionsBottomSheet extends StatelessWidget {
  final String id;
  final String approveDesc;
  final String rejectDesc;
  final List<String?> itemsImages;
  final List<String> itemNames;
  final VoidCallback onApproveAll;
  final VoidCallback rejectAllOnTap;

  const BrandOwnerInventoryGeneralActionsBottomSheet({
    super.key,
    required this.id,
    required this.approveDesc,
    required this.rejectDesc,
    required this.itemsImages,
    required this.itemNames,
    required this.onApproveAll,
    required this.rejectAllOnTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        top: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.tr.generalActionsAndLinks,
              style: AppStyles.s20W500.copyWith(
                color: context.customColor.text1,
              ),
            ),
            10.verticalSpace,
            Text(
              'How will you like to proceed with this report?',
              style: AppStyles.s14W400.copyWith(
                color: context.customColor.text3,
              ),
            ),
            10.verticalSpace,
            const CustomDivider(),
            10.verticalSpace,
            Text(
              context.tr.mainActions,
              style: AppStyles.s14W500.copyWith(
                color: context.customColor.text3,
              ),
            ),
            10.verticalSpace,
            AppGestureDetectorButton(
              onTap: () {
                NavigationService.I.pop();

                AppBottomSheet.showModal(
                  context,
                  isScrollControlled: true,
                  (context) => BrandOwnerApproveInventoryBottomSheet(
                    id: id,
                    desc: approveDesc,
                    itemNames: itemNames,
                    itemsImages: itemsImages,
                    approveAllOnTap: onApproveAll,
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: context.customColor.border),
                ),
                child: Row(
                  spacing: 10.w,
                  children: [
                    const AppSvg(
                      assetName: AppAssets.check,
                      colorFilter: ColorFilter.mode(
                        AppColors.lightGreen,
                        BlendMode.srcIn,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        'Comprehensive approval - Record as waste & damage',
                        style: AppStyles.s13W400.copyWith(
                          color: context.customColor.text1,
                        ),
                      ),
                    ),
                    AppSvg(
                      assetName: AppAssets.arrowRight,
                      colorFilter: ColorFilter.mode(
                        context.customColor.text1,
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            10.verticalSpace,
            AppGestureDetectorButton(
              onTap: () {
                NavigationService.I.pop();

                AppBottomSheet.showModal(
                  context,
                  isScrollControlled: true,
                  (context) => BrandOwnerRejectInventoryBottomSheet(
                    id: id,
                    desc: rejectDesc,
                    itemNames: itemNames,
                    itemsImages: itemsImages,
                    rejectAllOnTap: rejectAllOnTap,
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: context.customColor.border),
                ),
                child: Row(
                  spacing: 10.w,
                  children: [
                    Icon(Icons.close, color: context.customColor.error),
                    Flexible(
                      child: Text(
                        'Comprehensive rejection - Record as branch manager shortage',
                        style: AppStyles.s13W400.copyWith(
                          color: context.customColor.text1,
                        ),
                      ),
                    ),
                    AppSvg(
                      assetName: AppAssets.arrowRight,
                      colorFilter: ColorFilter.mode(
                        context.customColor.text1,
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            10.verticalSpace,
            Text(
              'Inquiry?',
              style: AppStyles.s14W500.copyWith(
                color: context.customColor.text3,
              ),
            ),
            10.verticalSpace,
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: context.customColor.border),
              ),
              child: Row(
                spacing: 10.w,
                children: [
                  const AppSvg(assetName: AppAssets.receipt),
                  Flexible(
                    child: Text(
                      'Request clarification from branch manager',
                      style: AppStyles.s13W400.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                  ),
                  AppSvg(
                    assetName: AppAssets.arrowRight,
                    colorFilter: ColorFilter.mode(
                      context.customColor.text1,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
