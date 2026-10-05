import 'package:assab/core/widgets/custom_text_field.dart';

import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/extensions/build_context_extensions.dart';
import '../../../../core/extensions/number_extensions.dart';
import '../../../../core/widgets/app_svg.dart';

class FixedAssetsSearchBarWidget extends StatelessWidget {
  const FixedAssetsSearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: context.theme.primaryColor),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 14.r),
      child: Row(
        spacing: 12.w,
        children: [
          AppSvg(
            assetName: AppAssets.search,
            width: 18.r,
            colorFilter: ColorFilter.mode(
              context.customColor.text1,
              BlendMode.srcIn,
            ),
          ),
          Expanded(
            child: CustomTextField(
              onChanged: (value) {},
              hintText: context.tr.searchByName,
            ),
          ),
        ],
      ),
    );
  }
}
