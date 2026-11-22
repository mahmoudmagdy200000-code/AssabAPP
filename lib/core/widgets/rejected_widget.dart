import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/utils/date_formatter.dart';
import 'package:flutter/material.dart';

import '../enums/cancel_reason_user_type_enum.dart';
import '../../shared/models/cancel_reason/cancel_reason_response.dart';
import '../../shared/models/rejection_record.dart';
import '../constants/app_assets.dart';
import '../styles/app_styles.dart';
import 'app_asset_image.dart';

class RejectedWidget extends StatelessWidget {
  /// Legacy compatibility for non-expense features still using cancellation DTOs.
  final CancelReasonResponse? reason;
  final RejectionRecord? rejection;
  final bool withBorder;

  const RejectedWidget({
    super.key,
    this.reason,
    this.rejection,
    this.withBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final rejectedBy = rejection?.rejectedBy;
    final legacyRejectedBy = reason?.cancelledBy;
    final rejectedAt = rejection?.rejectedAt ?? reason?.cancelledAt ?? '';
    final rejectionText = rejection?.reason ?? reason?.cancellationReason ?? '-';

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
                  '${rejectedBy?.name ?? legacyRejectedBy?.name ?? '-'} (${(rejectedBy?.type ?? legacyRejectedBy?.type ?? CancelReasonUserTypeEnum.branch).getRejectionType(context)})',
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
                  '${DateFormatter.formatDateMDY(DateTime.tryParse(rejectedAt))} – ${DateFormatter.formatTimeHM(DateTime.tryParse(rejectedAt))}',
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
                    rejectionText,
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
