import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/custom_text_field.dart';

class PurchaseSearchBar extends StatelessWidget {
  final String hintText;
  final VoidCallback? onFilterTap;
  final bool isFilterActive;
  final ValueChanged<String>? onChanged;
  final Color? searchIconColor;
  final double? searchIconSize;
  final double? borderRadius;
  final int? countFilter;

  const PurchaseSearchBar({
    super.key,
    required this.hintText,
    this.onFilterTap,
    this.isFilterActive = true,
    this.onChanged,
    this.searchIconColor,
    this.searchIconSize,
    this.borderRadius,
    this.countFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.customColor.text2,
        borderRadius: BorderRadius.circular(borderRadius ?? 15.r),
        border: Border.all(color: context.customColor.border),
      ),
      padding: EdgeInsets.symmetric(vertical: 12.r, horizontal: 12.r),
      child: Row(
        children: [
          AppSvg(
            assetName: AppAssets.search,
            width: searchIconSize ?? 14.r,
            height: searchIconSize ?? 14.r,
            colorFilter: ColorFilter.mode(
              searchIconColor ?? context.theme.primaryColor,
              BlendMode.srcIn,
            ),
          ),
          8.horizontalSpace,
          Expanded(
            child: CustomTextField(
              hintText: context.tr.searchForItems,
              onChanged: onChanged,
            ),
          ),
          if (isFilterActive) ...[
            8.horizontalSpace,
            AppGestureDetectorButton(
              onTap: onFilterTap ?? () {},
              child: Stack(
                children: [
                  AppSvg(
                    assetName: AppAssets.filter,
                    width: 20.r,
                    height: 20.r,
                    colorFilter: ColorFilter.mode(
                      context.customColor.text1,
                      BlendMode.srcIn,
                    ),
                  ),
                  if (countFilter != null && (countFilter ?? 0) > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: context.theme.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        padding: EdgeInsets.all(5.r),
                        child: Text(
                          countFilter.toString(),
                          style: AppStyles.s10W500.copyWith(
                            color: context.customColor.reversedTextColor,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
