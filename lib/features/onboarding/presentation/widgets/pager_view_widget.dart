import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_asset_image.dart';
import '../cubit/onboarding/onboarding_cubit.dart';

class PagerViewWidget extends StatelessWidget {
  final String title;
  final String desc;
  final String image;

  final int index;

  const PagerViewWidget({
    super.key,
    required this.title,
    required this.desc,
    required this.image,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      margin: EdgeInsets.only(
        top: context.watch<OnboardingCubit>().appBarAndNumRowHeight + 60.r,
      ),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppStyles.s32W600.copyWith(
              color: context.customColor.reversedTextColor,
            ),
          ),
          16.verticalSpace,
          Text(
            desc,
            textAlign: TextAlign.center,
            style: AppStyles.s18W600.copyWith(color: context.customColor.text5),
          ),
          if (index == 0) ...[
            7.verticalSpace,
            AppAssetImage(image: AppAssets.handUp, width: 32.r, height: 32.r),
            7.verticalSpace,
          ],
          Expanded(child: AppAssetImage(image: image)),
        ],
      ),
    );
  }
}
