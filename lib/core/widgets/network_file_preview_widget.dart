import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/features/branch_manager_expenses/data/models/attachment_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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

  Future<void> _preview(BuildContext context) async {
    final attachment = attachmentModel;
    final uri = Uri.tryParse(attachment?.url ?? '');
    final error = context.tr.somethingWentWrongPleaseTryAgain;
    if (attachment != null &&
        uri != null &&
        uri.host.isNotEmpty &&
        (uri.scheme == 'https' || (kDebugMode && uri.scheme == 'http'))) {
      final type = attachment.fileType.trim().toLowerCase();
      const imageTypes = {'jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'};
      final extension = attachment.fileName.split('.').last.toLowerCase();
      if (type.startsWith('image/') ||
          imageTypes.contains(type) ||
          imageTypes.contains(extension)) {
        await showDialog<void>(
          context: context,
          builder: (dialogContext) => Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(attachment.fileName),
                  trailing: CloseButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                  ),
                ),
                Flexible(
                  child: InteractiveViewer(
                    child: Image.network(
                      uri.toString(),
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, progress) =>
                          progress == null
                          ? child
                          : const Padding(
                              padding: EdgeInsets.all(24),
                              child: CircularProgressIndicator(),
                            ),
                      errorBuilder: (context, exception, stackTrace) => Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(error),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
        return;
      }
      try {
        if (await launchUrl(uri, mode: LaunchMode.externalApplication)) return;
      } catch (_, stackTrace) {
        debugPrintStack(
          label: 'Could not open attachment',
          stackTrace: stackTrace,
        );
      }
    }
    if (context.mounted) {
      ScaffoldMessenger.maybeOf(
        context,
      )?.showSnackBar(SnackBar(content: Text(error)));
    }
  }

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
                      () {
                        final bytes = attachmentModel?.fileSize ?? 0;
                        if (bytes < 1024 * 1024) {
                          return '${(bytes / 1024).toStringAsFixed(1)} KB';
                        }
                        return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
                      }(),
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

              _preview(context);
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
