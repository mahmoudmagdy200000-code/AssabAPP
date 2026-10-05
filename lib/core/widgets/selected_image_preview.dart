import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/models/media_file_model.dart';
import 'package:assab/core/widgets/app_file_image.dart';
import 'package:assab/core/widgets/app_svg_button.dart';
import 'package:assab/core/widgets/media_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants/app_assets.dart';
import '../cubits/media/media_cubit.dart';
import '../services/navigation/navigation_service.dart';

class SelectedImagePreview extends StatelessWidget {
  final MediaFile mediaFile;
  final bool singleSelectionMode;

  const SelectedImagePreview({
    super.key,
    required this.mediaFile,
    this.singleSelectionMode = false,
  });

  void _openFilePicker(BuildContext context) {
    final mediaCubit = context.read<MediaCubit>();

    NavigationService.I.push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: mediaCubit,
          child: MediaMainScreen(selectSingleFile: singleSelectionMode),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AppFileImage(
          image: mediaFile.path,
          borderRadius: BorderRadius.zero,
          height: 123.h,
        ),
        PositionedDirectional(
          end: 0,
          bottom: 0,
          child: Container(
            padding: EdgeInsets.all(12.r),
            child: Row(
              children: [
                AppSvgButton(
                  assetName: AppAssets.refresh,
                  onTap: () {
                    _openFilePicker(context);
                  },
                  bgColor: context.customColor.text6.withValues(alpha: 0.3),
                  iconColor: context.customColor.reversedTextColor,
                  borderColor: context.customColor.reversedTextColor,
                  iconSize: 12.r,
                ),
                20.horizontalSpace,
                AppSvgButton(
                  assetName: AppAssets.trashSvg,
                  onTap: () {
                    context.read<MediaCubit>().unselectFile(mediaFile);
                  },
                  bgColor: context.customColor.text6.withValues(alpha: 0.3),
                  iconColor: context.customColor.error,
                  iconSize: 12.r,
                  borderColor: context.customColor.reversedTextColor,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
