import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/cubits/media/media_cubit.dart';
import '../../../../../../../core/services/navigation/navigation_service.dart';
import '../../../../../../../core/styles/app_styles.dart';
import '../../../../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../../../../../core/widgets/container_custom_text_field.dart';
import '../../../../../../../core/widgets/media_main_screen.dart';

class VarianceUploadFilesButton extends StatelessWidget {
  const VarianceUploadFilesButton({super.key});

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
    return AppGestureDetectorButton(
      onTap: () => _chooseAttachment(context),
      child: ContainerCustomTextField(
        child: Column(
          children: [
            Icon(
              Icons.upload_rounded,
              size: 24.r,
              color: context.customColor.text3,
            ),
            8.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  context.tr.tapTo,
                  style: AppStyles.s14W400.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                5.horizontalSpace,
                Text(
                  context.tr.upload,
                  style: AppStyles.s14W400.copyWith(
                    color: context.theme.primaryColor,
                  ),
                ),
                5.horizontalSpace,
                Text(
                  context.tr.fromDevice,
                  style: AppStyles.s14W400.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
              ],
            ),
            8.verticalSpace,
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
  }
}
