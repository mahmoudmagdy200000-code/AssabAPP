import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/network_file_preview_widget.dart';
import 'package:flutter/material.dart';

import '../../../../core/strategies/requests_order_type_strategy.dart';
import '../../../../shared/models/delay_details_response.dart';

class ReportDelayModificationDetailsView extends StatelessWidget {
  final DelayDetails delayDetails;
  final RequestsOrderTypeStrategy strategy;

  const ReportDelayModificationDetailsView({
    super.key,
    required this.delayDetails,
    required this.strategy,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        top: 0,
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr.modificationDetails,
                    style: AppStyles.s20W600.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                  12.verticalSpace,
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      border: Border.all(color: context.customColor.border),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.r,
                      vertical: 12.r,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.tr.delayDetails,
                          style: AppStyles.s14W600.copyWith(
                            color: context.customColor.text3,
                          ),
                        ),
                        5.verticalSpace,
                        Text(
                          delayDetails.delayReason,
                          style: AppStyles.s14W400.copyWith(
                            color: context.customColor.text1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  12.verticalSpace,
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      border: Border.all(color: context.customColor.border),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.r,
                      vertical: 12.r,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildRowDetails(
                          context: context,
                          label: context.tr.newExpectedDeliveryDate,
                          value: delayDetails.newExpectedDeliveryDate,
                        ),
                        10.verticalSpace,
                        _buildRowDetails(
                          context: context,
                          label: context.tr.newDate,
                          value: delayDetails.newExpectedDeliveryDate,
                        ),
                        10.verticalSpace,
                        _buildRowDetails(
                          context: context,
                          label: context.tr.newTime,
                          value: delayDetails.newExpectedDeliveryTime,
                        ),
                      ],
                    ),
                  ),
                  if (delayDetails.delayAttachment != null) ...[
                    12.verticalSpace,
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.r),
                        border: Border.all(color: context.customColor.border),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.r,
                        vertical: 12.r,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.tr.attachment,
                            style: AppStyles.s14W600.copyWith(
                              color: context.customColor.text3,
                            ),
                          ),

                          5.verticalSpace,
                          NetworkFilePreviewWidget(
                            attachmentModel: delayDetails.delayAttachment,
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            20.verticalSpace,
            strategy.buildDelayedButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildRowDetails({
    required BuildContext context,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: AppStyles.s14W400.copyWith(color: context.customColor.text3),
          ),
        ),
        5.horizontalSpace,
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: AppStyles.s14W400.copyWith(
              color: valueColor ?? context.customColor.text1,
            ),
          ),
        ),
      ],
    );
  }
}
