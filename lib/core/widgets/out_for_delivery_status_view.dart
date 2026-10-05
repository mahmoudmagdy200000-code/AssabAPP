import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/date_formatter.dart';
import 'package:assab/core/widgets/app_network_image.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:flutter/material.dart';

import '../../shared/models/order_track_response.dart';

class OutForDeliveryStatusView extends StatelessWidget {
  final OrderTrackResponseOutForDeliveryStage stage;

  const OutForDeliveryStatusView({super.key, required this.stage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        top: 0,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr.orderDeliveryDetails,
                style: AppStyles.s20W600.copyWith(
                  color: context.customColor.text1,
                ),
              ),
              12.verticalSpace,
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: context.customColor.border),
                ),
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRowDetails(
                      context: context,
                      label: context.tr.deliveryAddress,
                      value: stage.deliveryAddress,
                    ),
                    10.verticalSpace,
                    _buildRowDetails(
                      context: context,
                      label: context.tr.driversName,
                      value: stage.driverDetails.name,
                    ),
                    10.verticalSpace,
                    _buildRowDetails(
                      context: context,
                      label: context.tr.vehicleNumber,
                      value: stage.driverDetails.vehicleNumber,
                    ),
                    10.verticalSpace,
                    _buildRowDetails(
                      context: context,
                      label: context.tr.expectedDeliveryTime,
                      value:
                          DateFormatter.formatTimeHM(
                            DateTime.tryParse(stage.arrivalTime),
                          ) ??
                          '--:--',
                      valueColor: context.theme.primaryColor,
                    ),
                  ],
                ),
              ),
              if (stage.driverDetails.photo != null) ...[
                12.verticalSpace,
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: context.customColor.border),
                  ),
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.tr.driversPicture,
                        style: AppStyles.s14W600.copyWith(
                          color: context.customColor.text3,
                        ),
                      ),
                      5.verticalSpace,
                      AppNetworkImage(
                        image: stage.driverDetails.photo?.url ?? '',
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                    ],
                  ),
                ),
              ],
              if (stage.deliveryNotes?.isNotEmpty ?? false) ...[
                12.verticalSpace,
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: context.customColor.border),
                  ),
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.tr.deliveryNotes,
                        style: AppStyles.s14W600.copyWith(
                          color: context.customColor.text3,
                        ),
                      ),
                      5.verticalSpace,
                      Text(
                        stage.deliveryNotes ?? '',
                        style: AppStyles.s14W400.copyWith(
                          color: context.customColor.text1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
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

/*

  "url": "https://ivory-snail-183262.hostingersite.com/storage/supplier/drivers/vwWMZiLp8lwz8WpTybwu4pI9IgnkpNc6Um6N2WVe.jpg"

*/
