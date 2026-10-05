import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/cubits/media/media_cubit.dart';
import '../../../../core/cubits/media/media_state.dart';
import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/button_text_icon.dart';
import '../../../../core/widgets/container_custom_text_field.dart';
import '../../../../core/widgets/label_text_field.dart';
import '../../../../core/widgets/list_view_files_preview.dart';
import '../../../../core/widgets/media_main_screen.dart';

class CustodyRequestAttachmentSection extends StatelessWidget {
  const CustodyRequestAttachmentSection({super.key});

  void _chooseAttachment(BuildContext context) {
    final mediaCubit = context.read<MediaCubit>();

    NavigationService.I.push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: mediaCubit,
          child: const MediaMainScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocSelector<MediaCubit, MediaState, bool>(
          selector: (state) {
            if (state is MediaLoaded) {
              final files = state.allFiles.where((f) => f.selected).toList();

              return files.isNotEmpty;
            }

            return false;
          },
          builder: (context, state) {
            return Row(
              children: [
                Expanded(
                  child: LabelTextField(
                    text: context.tr.attachments,
                    isLabelOptional: true,
                    isLabelRequired: false,
                  ),
                ),
                10.horizontalSpace,
                if (state)
                  ButtonTextIcon(
                    label: context.tr.addFile,
                    icon: AppSvg(
                      assetName: AppAssets.upload,
                      width: 12.w,
                      colorFilter: ColorFilter.mode(
                        context.theme.primaryColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    onTap: () => _chooseAttachment(context),
                    borderColor: context.theme.primaryColor,
                    textColor: context.theme.primaryColor,
                    spaceBetweenTextAndIcon: 6.r,
                    padding: EdgeInsets.symmetric(
                      vertical: 11.r,
                      horizontal: 12.r,
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
              ],
            );
          },
        ),
        BlocSelector<MediaCubit, MediaState, bool>(
          selector: (state) {
            if (state is MediaLoaded) {
              final files = state.allFiles.where((f) => f.selected).toList();

              return files.isNotEmpty;
            }

            return false;
          },
          builder: (context, state) {
            if (state) {
              return const SizedBox.shrink();
            }

            return AppGestureDetectorButton(
              onTap: () => _chooseAttachment(context),
              child: ContainerCustomTextField(
                padding: EdgeInsets.all(15.r),
                child: Column(
                  children: [
                    const AppSvg(assetName: AppAssets.upload),
                    12.verticalSpace,
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: context.tr.tapTo,
                        style: AppStyles.s14W400.copyWith(
                          color: context.customColor.text1,
                        ),
                        children: [
                          TextSpan(
                            text: ' ${context.tr.upload} ',
                            style: AppStyles.s14W400.copyWith(
                              color: context.theme.primaryColor,
                            ),
                          ),
                          TextSpan(
                            text: '${context.tr.egPreviousExpenseReport} ',
                            style: AppStyles.s14W400.copyWith(
                              color: context.customColor.text3,
                            ),
                          ),
                          TextSpan(
                            text: context.tr.fromDevice,
                            style: AppStyles.s14W400.copyWith(
                              color: context.customColor.text1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    12.verticalSpace,
                    Text(
                      '${context.tr.maxSize}: 5GB',
                      style: AppStyles.s12W400.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        5.verticalSpace,
        ListViewFilesPreview(
          mediaCubit: context.read<MediaCubit>(),
          isSilver: false,
          physics: const NeverScrollableScrollPhysics(),
        ),
      ],
    );
  }
}
