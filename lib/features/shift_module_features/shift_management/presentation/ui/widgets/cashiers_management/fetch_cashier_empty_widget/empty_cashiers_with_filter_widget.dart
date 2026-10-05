import 'package:flutter/material.dart';

import '../../../../../../../../core/constants/app_assets.dart';
import '../../../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../../../core/extensions/number_extensions.dart';
import '../../../../../../../../core/styles/app_styles.dart';
import '../../../../../../../../core/widgets/app_svg.dart';

class EmptyCashiersWithFilterWidget extends StatelessWidget {
  const EmptyCashiersWithFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        40.verticalSpace,

        AppSvg(assetName: AppAssets.basketSvg, height: 140.h, width: 70.w),

        20.verticalSpace,

        Text(context.tr.noResults, style: AppStyles.s16W500),

        15.verticalSpace,

        SizedBox(
          width: 260.w,
          child: Text(
            context.tr.pleaseRefineYourFilter,
            style: AppStyles.s14W400,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
