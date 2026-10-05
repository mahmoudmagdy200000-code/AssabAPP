import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/features/purchase/presentation/widgets/purchase_item_image.dart';
import 'package:flutter/material.dart';

import '../../data/models/recurring_order_details_response.dart';

class RecurringOrderDeatilsStatusView extends StatelessWidget {
  final RecurringOrderDetailsResponse details;

  const RecurringOrderDeatilsStatusView({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(color: context.customColor.border),
        ),
        padding: EdgeInsets.all(12.r),
        child: Column(
          children: [
            details.data.statusSection.statusValue.buildStatusWidget(
              context,
              details.data.inspectionSummary,
            ),
            8.verticalSpace,
            _buildRowDetails(
              context: context,
              title: context.tr.orderName,
              value: details.data.inspectionSummary.orderName,
            ),
            8.verticalSpace,
            const CustomDivider(),
            8.verticalSpace,
            _buildRowDetails(
              context: context,
              title: context.tr.supplier,
              value: details
                  .data
                  .inspectionSummary
                  .directSupplierOrPurchasingOfficerName,
            ),
            8.verticalSpace,
            const CustomDivider(),
            8.verticalSpace,
            _buildRowDetails(
              context: context,
              title: context.tr.repeatFrequency,
              value: details.data.frequencySettings.frequency.getDisplayValue(
                context,
              ),
            ),
            8.verticalSpace,
            const CustomDivider(),
            8.verticalSpace,
            _buildRowDetails(
              context: context,
              title: context.tr.nextOrderSchedule,
              value: details.data.inspectionSummary.nextOrderScheduling,
            ),
            8.verticalSpace,
            const CustomDivider(),
            8.verticalSpace,
            _buildRowDetails(
              context: context,
              title: context.tr.scheduleTime,
              value: details.data.inspectionSummary.schedulingTime,
            ),
            32.verticalSpace,
            Container(
              width: double.infinity,
              color: context.customColor.text2,
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr.itemCountAndAvailability(
                      details.data.itemCountAndAvailability.length,
                    ),
                    style: AppStyles.s14W600.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                  10.verticalSpace,
                  SizedBox(
                    height: 130.h,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: details.data.itemCountAndAvailability.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 250.w,
                          decoration: BoxDecoration(
                            color: context.customColor.reversedTextColor,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          padding: EdgeInsets.all(16.r),
                          margin: EdgeInsetsDirectional.only(end: 8.r),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            details
                                                .data
                                                .itemCountAndAvailability[index]
                                                .itemName,
                                            style: AppStyles.s14W400.copyWith(
                                              color: context.customColor.text1,
                                            ),
                                          ),
                                          6.verticalSpace,
                                          details.data.orderType.buildRowType(
                                            context,
                                          ),
                                        ],
                                      ),
                                    ),
                                    10.horizontalSpace,
                                    PurchaseItemImage(
                                      image: details
                                          .data
                                          .itemCountAndAvailability[index]
                                          .itemLogo,
                                    ),
                                  ],
                                ),
                                12.verticalSpace,
                                const CustomDivider(),
                                12.verticalSpace,
                                Row(
                                  children: [
                                    Expanded(
                                      child: Stack(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: context.customColor.text2,
                                              borderRadius:
                                                  BorderRadius.circular(1000.r),
                                            ),
                                            height: 5.h,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: AppColors.lightGreen,
                                              borderRadius:
                                                  BorderRadius.circular(1000.r),
                                            ),
                                            height: 5.h,
                                            width:
                                                (details
                                                            .data
                                                            .itemCountAndAvailability[index]
                                                            .quantityInStock /
                                                        details
                                                            .data
                                                            .itemCountAndAvailability[index]
                                                            .quantityPurchased *
                                                        100)
                                                    .w,
                                          ),
                                        ],
                                      ),
                                    ),
                                    16.horizontalSpace,
                                    Text(
                                      '${details.data.itemCountAndAvailability[index].quantityInStock}',
                                      style: AppStyles.s12W500.copyWith(
                                        color: context.customColor.text1,
                                      ),
                                    ),
                                    Text(
                                      '/${details.data.itemCountAndAvailability[index].quantityPurchased} Kg',
                                      style: AppStyles.s12W500.copyWith(
                                        color: context.customColor.text3,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            details.data.statusSection.statusValue.buildButtonDetailsScreen(
              context,
              orderId: details.data.id,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRowDetails({
    required BuildContext context,
    required String title,
    required String value,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppStyles.s13W500.copyWith(color: context.customColor.text1),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
