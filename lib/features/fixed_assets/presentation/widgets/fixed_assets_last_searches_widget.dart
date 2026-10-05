import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/extensions/build_context_extensions.dart';
import '../../../../core/extensions/number_extensions.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_svg.dart';

class FixedAssetsLastSearchesWidget extends StatelessWidget {
  const FixedAssetsLastSearchesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final searches = [
      'Kitchen Equipment - 1 Hour',
      'In Salem\'s Custody - Yesterday',
      'Critical Assets - 2 Days',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.tr.last3Searches,
          style: AppStyles.s14W500.copyWith(color: context.customColor.text4),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: context.customColor.text2,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            children: searches
                .map(
                  (search) => Column(
                    children: [
                      _buildSearchItem(context, search),
                      if (search != searches.last) SizedBox(height: 12.h),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchItem(BuildContext context, String text) {
    return Container(
      decoration: BoxDecoration(
        color: context.customColor.reversedTextColor,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: context.customColor.border),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 10.r),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              text,
              style: AppStyles.s13W500.copyWith(
                color: context.customColor.text1,
              ),
            ),
          ),
          12.horizontalSpace,
          AppSvg(
            assetName: AppAssets.arrowRight,
            width: 14.r,
            colorFilter: ColorFilter.mode(
              context.theme.primaryColor,
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
    );
  }
}
