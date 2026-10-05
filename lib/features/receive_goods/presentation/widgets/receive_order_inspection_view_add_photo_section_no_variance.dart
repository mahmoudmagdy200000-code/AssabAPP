import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/cubits/media/media_state.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/models/media_file_model.dart';
import 'package:assab/core/widgets/app_file_image.dart';
import 'package:assab/core/widgets/app_svg_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/media/media_cubit.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/button_text_icon.dart';

class ReceiveOrderInspectionViewAddPhotoSectionNoVariance
    extends StatelessWidget {
  final ValueChanged<MediaFile?> onPhotoAdded;

  const ReceiveOrderInspectionViewAddPhotoSectionNoVariance({
    super.key,
    required this.onPhotoAdded,
  });

  void _captureImage(BuildContext context) {
    context.read<MediaCubit>().captureImage();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<MediaCubit>(),
      child: BlocSelector<MediaCubit, MediaState, MediaFile?>(
        selector: (state) {
          if (state is MediaLoaded) {
            final file = state.allFiles.cast<MediaFile?>().firstWhere(
              (f) => f!.selected,
              orElse: () => null,
            );

            onPhotoAdded(file);

            return file;
          }

          onPhotoAdded(null);
          return null;
        },
        builder: (context, state) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: (state != null)
                ? Stack(
                    children: [
                      AppFileImage(
                        image: state.path,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      PositionedDirectional(
                        end: 0,
                        child: Container(
                          padding: EdgeInsets.all(10.r),
                          child: AppSvgButton(
                            assetName: AppAssets.trashSvg,
                            onTap: () {
                              context.read<MediaCubit>().unselectFile(state);
                            },
                            iconColor: context.customColor.error,
                            bgColor: context.customColor.text1.withValues(
                              alpha: 0.4,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : ButtonTextIcon(
                    onTap: () => _captureImage(context),
                    label: context.tr.openCamera,
                    textStyle: AppStyles.s14W500.copyWith(
                      color: context.customColor.text1,
                    ),
                    icon: Icon(
                      Icons.camera_alt_rounded,
                      size: 16.r,
                      color: context.theme.primaryColor,
                    ),
                    spaceBetweenTextAndIcon: 8.w,
                    backgroundColor: context.customColor.reversedTextColor,
                  ),
          );
        },
      ),
    );
  }
}
