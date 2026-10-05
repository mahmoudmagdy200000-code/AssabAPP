import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_svg.dart';

class BranchManagerActionButton extends StatelessWidget {
  final VoidCallback onTap;
  final String assetName;
  final String label;

  const BranchManagerActionButton({
    super.key,
    required this.onTap,
    required this.assetName,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return AppGestureDetectorButton(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(color: context.customColor.border),
            ),
            padding: EdgeInsets.all(10.r),
            child: AppSvg(
              assetName: assetName,
              width: 13.w,
              height: 13.w,
              colorFilter: ColorFilter.mode(
                context.customColor.text4,
                BlendMode.srcIn,
              ),
            ),
          ),
          6.verticalSpace,
          SizedBox(
            width: 54.r,
            child: Text(
              label,
              softWrap: true,
              textAlign: TextAlign.center,
              style: AppStyles.s11W400.copyWith(
                color: context.customColor.text4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
