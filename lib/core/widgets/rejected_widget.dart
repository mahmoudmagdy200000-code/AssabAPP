import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/utils/date_formatter.dart';
import 'package:flutter/material.dart';

import '../../shared/models/cancel_reason/cancel_reason_response.dart';
import '../constants/app_assets.dart';
import '../styles/app_styles.dart';
import 'app_asset_image.dart';

class RejectedWidget extends StatelessWidget {
  final CancelReasonResponse? reason;
  final bool withBorder;

  const RejectedWidget({super.key, this.reason, this.withBorder = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: withBorder
            ? Border.all(color: context.customColor.border)
            : null,
      ),
      padding: EdgeInsets.all(12.r),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppAssetImage(
            image: AppAssets.testProfile,
            width: 40.w,
            height: 40.w,
          ),
          8.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${reason?.cancelledBy.name} (${reason?.cancelledBy.type.getRejectionType(context)})',
                  style: AppStyles.s14W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                4.verticalSpace,
                Text(
                  context.tr.reasonForRejection,
                  style: AppStyles.s12W400.copyWith(
                    color: context.customColor.error,
                  ),
                ),
                4.verticalSpace,
                Text(
                  '${DateFormatter.formatDateMDY(DateTime.tryParse(reason?.cancelledAt ?? ''))} – ${DateFormatter.formatTimeHM(DateTime.tryParse(reason?.cancelledAt ?? ''))}',
                  style: AppStyles.s11W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
                4.verticalSpace,
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: context.customColor.text2,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: context.customColor.border),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 18.r,
                    horizontal: 16.r,
                  ),
                  child: Text(
                    '${reason?.cancellationReason}',
                    style: AppStyles.s14W500.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
