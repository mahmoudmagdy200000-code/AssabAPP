import 'package:flutter/material.dart';

import '../../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../../core/extensions/number_extensions.dart';
import '../../../../../../../core/styles/app_styles.dart';
import '../../../../../../../core/widgets/app_svg.dart';

class VarianceIconsInfoDetails extends StatelessWidget {
  const VarianceIconsInfoDetails({
    super.key,
    required this.svgAsset,
    required this.title,
    required this.richTextFirstPart,
    required this.richTextSecondStyledPart,
    required this.richTextThirdPart,
    required this.isolatedDesc,
  });

  final String svgAsset;
  final String title;

  final String richTextFirstPart;
  final String richTextSecondStyledPart;
  final String richTextThirdPart;

  final String isolatedDesc;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsetsDirectional.only(top: 15.h),
          child: AppSvg(assetName: svgAsset, height: 12.r, width: 12.r),
        ),

        15.horizontalSpace,

        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppStyles.s15W500.copyWith(
                  color: context.customColor.text4,
                ),
              ),
              6.verticalSpace,

              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: richTextFirstPart,
                      style: AppStyles.s13W400.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                    TextSpan(
                      text: richTextSecondStyledPart,
                      style: AppStyles.s13W500.copyWith(
                        color: context.customColor.text4,
                      ),
                    ),
                    TextSpan(
                      text: richTextThirdPart,
                      style: AppStyles.s13W400.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                  ],
                ),
              ),
              15.verticalSpace,

              Text(
                isolatedDesc,
                style: AppStyles.s13W400.copyWith(
                  color: context.customColor.text3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
