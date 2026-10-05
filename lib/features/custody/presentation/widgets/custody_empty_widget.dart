import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_asset_image.dart';
import 'package:flutter/material.dart';

class CustodyEmptyWidget extends StatelessWidget {
  final String asset;
  final String title;
  final String desc;
  final bool isScrollable;

  const CustodyEmptyWidget({
    super.key,
    required this.asset,
    required this.title,
    required this.desc,
    this.isScrollable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.customColor.text2,
        borderRadius: BorderRadius.circular(15.r),
      ),
      padding: EdgeInsets.all(12.r),
      child: Container(
        decoration: BoxDecoration(
          color: context.customColor.reversedTextColor,
          borderRadius: BorderRadius.circular(15.r),
        ),
        padding: EdgeInsets.symmetric(vertical: 40.r, horizontal: 40.r),
        child: isScrollable
            ? SingleChildScrollView(child: _buildContent(context))
            : _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppAssetImage(
          image: asset,
          width: 80.r,
          height: 80.r,
          borderRadius: BorderRadius.zero,
        ),
        16.verticalSpace,
        Text(
          title,
          style: AppStyles.s16W600.copyWith(color: context.customColor.text1),
          textAlign: TextAlign.center,
        ),
        16.verticalSpace,
        Text(
          desc,
          style: AppStyles.s14W400.copyWith(color: context.customColor.text3),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
