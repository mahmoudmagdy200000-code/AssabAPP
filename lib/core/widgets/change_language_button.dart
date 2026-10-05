import 'package:assab/core/cubits/locale/locale_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants/app_assets.dart';
import '../styles/app_styles.dart';
import '../utils/app_bottom_sheet.dart';
import 'app_gesture_detector_button.dart';
import 'app_svg.dart';
import 'change_language_bottom_sheet_widget.dart';

class ChangeLanguageButton extends StatelessWidget {
  final Color? textColor;

  const ChangeLanguageButton({super.key, this.textColor});

  void _showChangeLanguageBottomSheet({required BuildContext context}) {
    AppBottomSheet.showModal(
      context,
      (context) => const ChangeLanguageBottomSheetWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: context.customColor.border),
        borderRadius: BorderRadius.circular(15.r),
      ),
      padding: EdgeInsets.all(12.r),
      child: AppGestureDetectorButton(
        onTap: () => _showChangeLanguageBottomSheet(context: context),
        child: Row(
          children: [
            AppSvg(
              assetName: context.watch<LocaleCubit>().isArabic
                  ? AppAssets.arFlag
                  : AppAssets.enFlag,
              width: 20.r,
              height: 20.r,
            ),
            8.horizontalSpace,
            Text(
              context.watch<LocaleCubit>().isArabic ? 'العربيه' : 'Eng',
              style: AppStyles.s11W400.copyWith(
                color: textColor ?? context.customColor.reversedTextColor,
              ),
            ),
            8.horizontalSpace,
            Icon(
              Icons.keyboard_arrow_down_outlined,
              color: textColor ?? context.customColor.text2,
            ),
          ],
        ),
      ),
    );
  }
}
