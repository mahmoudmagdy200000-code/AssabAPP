import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_asset_image.dart';

class ResetPasswordTopSection extends StatelessWidget {
  final String title;
  final String? textDesc;
  final Widget? textWidget;

  const ResetPasswordTopSection({
    super.key,
    required this.title,
    this.textDesc,
    this.textWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 130.w,
          height: 4.h,
          decoration: BoxDecoration(
            color: context.customColor.text1,
            borderRadius: BorderRadius.circular(1000.r),
          ),
        ),
        30.verticalSpace,
        AppAssetImage(
          image: AppAssets.resetPassword2,
          width: 160.h,
          height: 160.h,
        ),
        16.verticalSpace,
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppStyles.s20W500.copyWith(color: context.customColor.text1),
        ),
        16.verticalSpace,
        ?textWidget,
        if (textDesc != null && textWidget == null)
          Text(
            textDesc!,
            textAlign: TextAlign.center,
            style: AppStyles.s14W400.copyWith(color: context.customColor.text3),
          ),
      ],
    );
  }
}
