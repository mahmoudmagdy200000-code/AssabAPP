import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:flutter/material.dart';

class InitialAuditBottomButtonsWidget extends StatelessWidget {
  const InitialAuditBottomButtonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 16.r,
        bottom: 24.r,
        left: 20.r,
        right: 20.r,
      ),
      decoration: BoxDecoration(
        color: context.customColor.reversedTextColor,
        border: Border(top: BorderSide(color: context.customColor.border)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: AppButton(
              onClick: () {},
              text: context.tr.saveAndAdd,
              isTransparent: true,
              borderColor: context.customColor.border,
              icon: AppSvg(
                assetName: AppAssets.bookCheck,
                width: 20.r,
                height: 20.r,
                colorFilter: ColorFilter.mode(
                  context.customColor.text1,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          12.horizontalSpace,
          Expanded(
            flex: 3,
            child: AppButton(
              onClick: () {},
              text: context.tr.completeAndSend,
              enabled: true,
              icon: AppSvg(
                assetName: AppAssets.arrowNorthEastSvg,
                width: 20.r,
                height: 20.r,
                colorFilter: ColorFilter.mode(
                  context.customColor.reversedTextColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
