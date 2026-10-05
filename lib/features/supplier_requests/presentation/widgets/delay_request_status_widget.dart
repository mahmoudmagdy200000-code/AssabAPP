import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/strategies/requests_order_type_strategy.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/utils/app_bottom_sheet.dart';
import '../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../../shared/models/delay_details_response.dart';
import 'report_delay_modification_details_view.dart';

class DelayRequestStatusWidget extends StatelessWidget {
  final String text;
  final Color? textColor;
  final DelayDetails delayDetails;
  final RequestsOrderTypeStrategy strategy;
  final Widget? customWidget;

  const DelayRequestStatusWidget({
    super.key,
    required this.text,
    required this.strategy,
    this.textColor,
    required this.delayDetails,
    this.customWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: context.customColor.border),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 10.r),
      margin: EdgeInsets.only(bottom: 12.r),
      child: Column(
        children: [
          Text(
            text,
            textAlign: TextAlign.center,
            style: AppStyles.s12W400.copyWith(
              color: textColor ?? AppColors.orange,
            ),
          ),
          if (customWidget != null) ...[5.verticalSpace, ?customWidget],
          5.verticalSpace,
          AppGestureDetectorButton(
            onTap: () {
              AppBottomSheet.show(
                context,
                (context) => ReportDelayModificationDetailsView(
                  strategy: strategy,
                  delayDetails: delayDetails,
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: context.customColor.border),
              ),
              padding: EdgeInsets.symmetric(vertical: 8.r, horizontal: 12.r),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    context.tr.tapToViewDelayRequestDetails,
                    style: AppStyles.s12W500.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                  5.horizontalSpace,
                  Icon(Icons.keyboard_arrow_down, size: 16.r),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
