import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_svg.dart';

class SupplierStatusWidget extends StatelessWidget {
  final String status;
  final String iconAssetName;
  final Color borderColor;

  const SupplierStatusWidget({
    super.key,
    required this.status,
    required this.iconAssetName,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.customColor.reversedTextColor,
        borderRadius: BorderRadius.circular(1000.r),
        border: Border.all(color: borderColor),
      ),
      padding: EdgeInsets.only(left: 10.r),
      child: Row(
        children: [
          Text(status, style: AppStyles.s10W500.copyWith(color: borderColor)),
          4.horizontalSpace,
          AppSvg(assetName: iconAssetName, width: 19.w, height: 19.w),
        ],
      ),
    );
  }
}
