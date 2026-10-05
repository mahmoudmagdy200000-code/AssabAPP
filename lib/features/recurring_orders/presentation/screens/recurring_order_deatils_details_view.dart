import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/saudi_riyal_svg_widget.dart';
import 'package:assab/features/purchase/presentation/widgets/purchase_item_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../data/models/recurring_order_details_response.dart';

class RecurringOrderDeatilsDetailsView extends StatelessWidget {
  final RecurringOrderDetailsResponse details;

  const RecurringOrderDeatilsDetailsView({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: context.customColor.text2,
              borderRadius: BorderRadius.circular(20.r),
            ),
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr.inspectionSummary,
                  style: AppStyles.s16W600.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                10.verticalSpace,
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    color: context.customColor.reversedTextColor,
                  ),
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    children: [
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
                        title: context.tr.activationPeriod,
                        value: details.data.frequencySettings.frequency
                            .getDisplayValue(context),
                      ),
                      8.verticalSpace,
                      const CustomDivider(),
                      8.verticalSpace,
                      _buildRowDetails(
                        context: context,
                        title: context.tr.endDate,
                        value: details.data.inspectionSummary.endDate,
                      ),
                    ],
                  ),
                ),
                10.verticalSpace,
                Text(
                  context.tr.itemsAndQuantities(
                    details.data.details.itemsSummary.length,
                  ),
                  style: AppStyles.s16W600.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                10.verticalSpace,
                ListView.builder(
                  itemCount: details.data.details.itemsSummary.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    final item = details.data.details.itemsSummary[index];

                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.r),
                        color: context.customColor.reversedTextColor,
                      ),
                      padding: EdgeInsets.all(16.r),
                      margin: EdgeInsets.only(bottom: 6.r),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              PurchaseItemImage(image: item.itemLogo),
                              12.horizontalSpace,
                              Expanded(
                                child: Text(
                                  item.itemName,
                                  style: AppStyles.s14W600.copyWith(
                                    color: context.customColor.text1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          8.verticalSpace,
                          const CustomDivider(),
                          8.verticalSpace,
                          _buildRowDetails(
                            context: context,
                            title: context.tr.qtyOrdered,
                            value: '${item.quantity} kg',
                          ),
                          8.verticalSpace,
                          const CustomDivider(),
                          8.verticalSpace,
                          _buildRowDetails(
                            context: context,
                            title: context.tr.unitPrice,
                            value: item.unitPrice.toStringAsFixed(2),
                            isCurrency: true,
                          ),
                          8.verticalSpace,
                          const CustomDivider(),
                          8.verticalSpace,
                          _buildRowDetails(
                            context: context,
                            title: context.tr.quality,
                            value: item.quality,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          12.verticalSpace,
          Container(
            decoration: BoxDecoration(
              color: context.customColor.text2,
              borderRadius: BorderRadius.circular(20.r),
            ),
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr.scheduleSettings,
                  style: AppStyles.s16W600.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                10.verticalSpace,
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    color: context.customColor.reversedTextColor,
                  ),
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    children: [
                      _buildRowDetails(
                        context: context,
                        title: context.tr.date,
                        value: details.data.frequencySettings.frequency
                            .getDisplayValue(context),
                      ),
                      8.verticalSpace,
                      const CustomDivider(),
                      8.verticalSpace,
                      details.data.frequencySettings.frequency
                          .buildScheduleSettingsForSummaryBasedOnApi(
                            context,
                            details.data.frequencySettings,
                          ),
                      8.verticalSpace,
                      const CustomDivider(),
                      8.verticalSpace,
                      _buildRowDetails(
                        context: context,
                        title: context.tr.notifications,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        customValue: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: details
                              .data
                              .details
                              .schedulingSettings
                              .notifications
                              .map((notification) {
                                return Column(
                                  children: [
                                    _buildColumnWidget(
                                      context: context,
                                      text: '${notification.label(context)} -',
                                    ),
                                    8.verticalSpace,
                                  ],
                                );
                              })
                              .toList(),
                        ),
                      ),
                      8.verticalSpace,
                      const CustomDivider(),
                      8.verticalSpace,
                      _buildRowDetails(
                        context: context,
                        title: context.tr.smartSettings,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        customValue: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: details
                              .data
                              .details
                              .schedulingSettings
                              .smartSettings
                              .map((setting) {
                                return Column(
                                  children: [
                                    _buildColumnWidget(
                                      context: context,
                                      text: '${setting.label(context)} -',
                                    ),
                                    8.verticalSpace,
                                  ],
                                );
                              })
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Text _buildColumnWidget({
    required BuildContext context,
    required String text,
  }) {
    return Text(
      text,
      style: AppStyles.s13W500.copyWith(color: context.customColor.text1),
      textAlign: TextAlign.end,
    );
  }

  Widget _buildRowDetails({
    required BuildContext context,
    required String title,
    String? value,
    bool isCurrency = false,
    Widget? customValue,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Flexible(
          child: Text(
            title,
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
          ),
        ),
        Flexible(
          child:
              customValue ??
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (isCurrency) const SaudiRiyalSvgWidget(),
                  3.horizontalSpace,
                  Flexible(
                    child: Text(
                      value ?? '',
                      style: AppStyles.s13W500.copyWith(
                        color: context.customColor.text1,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
        ),
      ],
    );
  }
}
