import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/button_text_icon.dart';
import 'package:flutter/material.dart';

class InitialAuditZoneSetupWidget extends StatelessWidget {
  const InitialAuditZoneSetupWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 13.r, vertical: 17.r),
      decoration: BoxDecoration(
        color: context.customColor.text2,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: context.customColor.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSvg(assetName: AppAssets.branch, width: 20.r, height: 20.r),
              8.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr.zoneSetup,
                      style: AppStyles.s14W600.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                    4.verticalSpace,
                    Text(
                      context.tr.youCurrentlyHaveNZonesAdded('2'),
                      style: AppStyles.s13W400.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 40.r,
                  height: 40.r,
                  decoration: BoxDecoration(
                    color: context.customColor.reversedTextColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: context.customColor.border),
                  ),
                  child: Icon(
                    Icons.keyboard_arrow_up,
                    size: 20.r,
                    color: context.customColor.text1,
                  ),
                ),
              ),
            ],
          ),
          12.verticalSpace,
          _buildZoneItem(context, 'Kitchen', 35, showDelete: false),
          4.verticalSpace,
          _buildZoneItem(context, 'Dining', 28, showDelete: false),
          4.verticalSpace,
          _buildZoneItem(context, 'Store', 0, showDelete: true),
          12.verticalSpace,
          ButtonTextIcon(
            onTap: () {},
            label: context.tr.addNewZone,
            icon: AppSvg(
              assetName: AppAssets.add,
              width: 14.r,
              height: 14.r,
              colorFilter: ColorFilter.mode(
                context.theme.primaryColor,
                BlendMode.srcIn,
              ),
            ),
            isTransparent: false,
            backgroundColor: context.theme.primaryColor.withOpacity(0.07),
            borderColor: context.customColor.border,
            textColor: context.theme.primaryColor,
            padding: EdgeInsets.symmetric(horizontal: 13.r, vertical: 9.r),
            borderRadius: BorderRadius.circular(100.r),
            textStyle: AppStyles.s12W500.copyWith(
              color: context.theme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZoneItem(
    BuildContext context,
    String name,
    int count, {
    required bool showDelete,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 13.r, vertical: 9.r),
      decoration: BoxDecoration(
        color: context.customColor.reversedTextColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: context.customColor.border),
      ),
      child: Row(
        children: [
          Text(
            name,
            style: AppStyles.s12W400.copyWith(color: context.customColor.text3),
          ),
          8.horizontalSpace,
          Expanded(
            child: Divider(color: context.customColor.border, height: 1),
          ),
          8.horizontalSpace,
          Text(
            context.tr.assetsCount(count.toString()),
            style: AppStyles.s12W500.copyWith(color: context.customColor.text1),
          ),
          8.horizontalSpace,
          if (showDelete) ...[
            _buildSmallIconBtn(context, AppAssets.trashSvg),
            8.horizontalSpace,
          ],
          _buildSmallIconBtn(context, AppAssets.edit),
        ],
      ),
    );
  }

  Widget _buildSmallIconBtn(BuildContext context, String asset) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 24.r,
        height: 24.r,
        decoration: BoxDecoration(
          color: context.customColor.text2,
          shape: BoxShape.circle,
          border: Border.all(color: context.customColor.border),
        ),
        child: Center(
          child: AppSvg(assetName: asset, width: 12.r, height: 12.r),
        ),
      ),
    );
  }
}
