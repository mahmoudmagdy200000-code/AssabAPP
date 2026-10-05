import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_assets.dart';
import '../../../../../../core/styles/app_styles.dart';
import '../../../../../../core/widgets/app_asset_image.dart';
import '../../../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../../../../core/widgets/app_svg.dart';
import '../../../domain/entity/network_image_item.dart';

class NetworkImagePreviewWidget extends StatelessWidget {
  final NetworkImageItem image;

  const NetworkImagePreviewWidget({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.r),
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: context.customColor.border),
      ),
      child: Row(
        children: [
          /// SVG thumbnail (clickable)
          AppAssetImage(image: AppAssets.jpg, width: 40.w),

          12.horizontalSpace,

          /// Image info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  image.name ?? 'Image',
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.s12W400.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                4.verticalSpace,
                Row(
                  children: [
                    Text(
                      'Image',
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
                      'jpg',
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

          AppGestureDetectorButton(
            onTap: () => _openImageViewer(context),
            child: Container(
              padding: EdgeInsets.all(6.r),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: context.customColor.border),
              ),
              child: AppSvg(
                assetName: AppAssets.eye,
                width: 12.w,
                height: 12.h,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Opens full image
  void _openImageViewer(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(16.r),
        child: InteractiveViewer(
          child: Image.network(image.url, fit: BoxFit.contain),
        ),
      ),
    );
  }
}
