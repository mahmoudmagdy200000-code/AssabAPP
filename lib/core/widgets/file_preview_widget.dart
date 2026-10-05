import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/models/media_file_model.dart';
import 'package:flutter/material.dart';

import '../constants/app_assets.dart';
import '../styles/app_styles.dart';
import 'app_asset_image.dart';
import 'app_gesture_detector_button.dart';
import 'app_svg.dart';

class FilePreviewWidget extends StatelessWidget {
  final MediaFile file;
  final VoidCallback? onTapIcon;
  final String? icon;
  final Color? iconColor;
  final bool showRemoveIcon;
  final Color? borderColor;

  const FilePreviewWidget({
    super.key,
    required this.file,
    this.onTapIcon,
    this.icon,
    this.iconColor,
    this.showRemoveIcon = true,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.r),
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: borderColor ?? context.customColor.border),
      ),
      child: Row(
        children: [
          AppAssetImage(
            image: file.isPDF ? AppAssets.pdf : AppAssets.jpg,
            width: 40.w,
          ),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file.name,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.s12W400.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                4.verticalSpace,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      file.formattedSize,
                      style: AppStyles.s11W400.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                    4.horizontalSpace,
                    Icon(
                      Icons.circle,
                      size: 4.r,
                      color: context.customColor.text3,
                    ),
                    4.horizontalSpace,
                    Text(
                      file.fileExtension,
                      style: AppStyles.s11W400.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          12.horizontalSpace,
          if (showRemoveIcon)
            AppGestureDetectorButton(
              onTap: onTapIcon ?? () {},
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(color: context.customColor.border),
                ),
                padding: EdgeInsets.all(6.r),
                child: AppSvg(
                  assetName: icon ?? '',
                  width: 12.w,
                  height: 12.h,
                  colorFilter: iconColor != null
                      ? ColorFilter.mode(iconColor!, BlendMode.srcIn)
                      : null,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
