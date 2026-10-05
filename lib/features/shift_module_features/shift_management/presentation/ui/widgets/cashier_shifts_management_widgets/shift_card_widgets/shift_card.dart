import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../../../../../core/styles/app_styles.dart';
import '../../../../../../../../core/widgets/app_svg.dart';
import '../../../../../domain/entity/shift/shift_entity.dart';

abstract class ShiftCardStrategy {
  Widget buildCard(BuildContext context, ShiftEntity shift);
}

Widget buildShiftCardRowWidget({
  required BuildContext context,
  required String title,
  required String value,
  TextStyle? titleStyle,
  String? firstTitleSvgAsset,
  String? secondTitleSvgAsset,
  String? secondTitle,
  TextStyle? secondTitleStyle,
  String? secondValue,
  bool hasTwoRows = false,
  String? firstValueSvgAsset,
  String? secondValueSvgAsset,
  bool hasSpaceBetweenTitleAndValue = false,
}) {
  if (hasTwoRows && secondTitle != null && secondValue != null) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: buildShiftCardRowWidget(
              context: context,
              title: title,
              value: value,
              titleStyle: titleStyle,
              firstTitleSvgAsset: firstTitleSvgAsset,
              firstValueSvgAsset: firstValueSvgAsset,
              hasSpaceBetweenTitleAndValue: hasSpaceBetweenTitleAndValue,
            ),
          ),

          20.horizontalSpace,

          Expanded(
            flex: 1,
            child: buildShiftCardRowWidget(
              context: context,
              title: secondTitle,
              value: secondValue,
              titleStyle: secondTitleStyle,
              firstTitleSvgAsset: secondTitleSvgAsset,
              firstValueSvgAsset: secondValueSvgAsset,
              hasSpaceBetweenTitleAndValue: hasSpaceBetweenTitleAndValue,
            ),
          ),
        ],
      ),
    );
  }

  if (!hasSpaceBetweenTitleAndValue) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          if (firstTitleSvgAsset != null) ...[
            AppSvg(assetName: firstTitleSvgAsset, width: 15.h, height: 15.h),
            4.horizontalSpace,
          ],

          Text(
            title,
            style:
                titleStyle ??
                AppStyles.s12W400.copyWith(color: context.customColor.text4),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          2.horizontalSpace,

          if (firstValueSvgAsset != null) ...[
            AppSvg(assetName: firstValueSvgAsset, width: 15.h, height: 15.h),
            2.horizontalSpace,
          ],

          Flexible(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppStyles.s12W500,
            ),
          ),
        ],
      ),
    );
  }

  /// ===== CASE 2 → Title left edge, value right edge =====
  return Row(
    children: [
      Expanded(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (firstTitleSvgAsset != null) ...[
              AppSvg(assetName: firstTitleSvgAsset, width: 15.h, height: 15.h),
              6.horizontalSpace,
            ],

            Flexible(
              child: Text(
                title,
                style:
                    titleStyle ??
                    AppStyles.s12W400.copyWith(
                      color: context.customColor.text4,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),

      Expanded(
        child: Align(
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (firstValueSvgAsset != null) ...[
                AppSvg(
                  assetName: firstValueSvgAsset,
                  width: 15.h,
                  height: 15.h,
                ),
                4.horizontalSpace,
              ],

              Flexible(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.s12W500,
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
