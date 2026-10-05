import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/selection_circule.dart';
import 'package:flutter/material.dart';

class ExportInventoryBottomSheet extends StatelessWidget {
  const ExportInventoryBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        top: 0,
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr.exportReport,
                    style: AppStyles.s20W600.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                  5.verticalSpace,
                  Text(
                    context.tr
                        .howWouldYouLikeToExportDateMonthlyRegularInventory(
                          'June 2025',
                        ),
                    style: AppStyles.s14W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                  14.verticalSpace,
                  _buildExportOptionItem(
                    context: context,
                    title: context.tr.exportAsPdf,
                    asset: AppAssets.pdfSvg,
                    onTap: () {},
                  ),
                  12.verticalSpace,
                  _buildExportOptionItem(
                    context: context,
                    title: context.tr.exportAsExcel,
                    asset: AppAssets.excelSvg,
                    onTap: () {},
                  ),
                ],
              ),
            ),
            20.verticalSpace,
            AppButton(
              onClick: () {},
              text: context.tr.exportNow,
              borderRadius: BorderRadius.circular(15.r),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExportOptionItem({
    required BuildContext context,
    required String title,
    required String asset,
    required VoidCallback onTap,
  }) {
    return AppGestureDetectorButton(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(color: context.customColor.border),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 20.r),
        child: Row(
          children: [
            AppSvg(assetName: asset, width: 20.r),
            10.horizontalSpace,
            Expanded(
              child: Text(
                title,
                style: AppStyles.s14W500.copyWith(
                  color: context.customColor.text1,
                ),
              ),
            ),
            5.horizontalSpace,
            const SelectionCircule(isSelected: false),
          ],
        ),
      ),
    );
  }
}
