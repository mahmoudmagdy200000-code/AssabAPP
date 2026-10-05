import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/download_service.dart';
import 'package:assab/features/branch_manager_expenses/data/models/attachment_model.dart';
import 'package:flutter/material.dart';

import '../constants/app_assets.dart';
import '../styles/app_styles.dart';
import 'app_asset_image.dart';
import 'app_gesture_detector_button.dart';
import 'app_svg.dart';

class NetworkFilePreviewWidget extends StatelessWidget {
  final AttachmentModel? attachmentModel;
  final bool delete;
  final bool restore;
  final VoidCallback? onDelete;
  final VoidCallback? onRestore;
  final bool withBorder;

  const NetworkFilePreviewWidget({
    super.key,
    required this.attachmentModel,
    this.delete = false,
    this.restore = false,
    this.onDelete,
    this.onRestore,
    this.withBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.r),
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12.r),
        border: withBorder
            ? Border.all(color: context.customColor.border)
            : null,
      ),
      child: Row(
        children: [
          AppAssetImage(
            image: attachmentModel?.fileType == 'pdf'
                ? AppAssets.pdf
                : AppAssets.jpg,
            width: 40.w,
          ),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  attachmentModel?.fileName ?? 'N/A',
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
                      '${(attachmentModel?.fileSize ?? 0 / (1024 * 1024)).toStringAsFixed(2)} MB',
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
                      attachmentModel?.fileType.toUpperCase() ?? 'N/A',
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
            onTap: () {
              if (restore) {
                onRestore?.call();
                return;
              }

              if (delete) {
                onDelete?.call();
                return;
              }

              getIt<DownloadService>().downloadFile(
                url: attachmentModel?.url ?? '',
                fileName: attachmentModel?.fileName ?? '',
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(color: context.customColor.border),
              ),
              padding: EdgeInsets.all(6.r),
              child: AppSvg(
                assetName: restore
                    ? AppAssets.refresh
                    : delete
                    ? AppAssets.trashSvg
                    : AppAssets.eye,
                width: 12.w,
                height: 12.h,
                colorFilter: ColorFilter.mode(
                  restore
                      ? context.customColor.text1
                      : delete
                      ? context.customColor.error
                      : context.customColor.text1,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
