import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/utils/date_formatter.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../../../core/widgets/saudi_riyal_svg_widget.dart';
import '../../../purchase/presentation/widgets/purchase_item_image.dart';
import '../../data/models/monthly_inventory_details_response.dart';

class MonthlyInventoryDetailsViewDetailsScreen extends StatelessWidget {
  final MonthlyInventoryDetailsData details;

  const MonthlyInventoryDetailsViewDetailsScreen({
    super.key,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                Container(
                  decoration: BoxDecoration(
                    color: context.customColor.reversedTextColor,
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.tr.inventorySummary,
                        style: AppStyles.s16W600.copyWith(
                          color: context.customColor.text1,
                        ),
                      ),
                      8.verticalSpace,
                      const CustomDivider(),
                      8.verticalSpace,
                      _buildInventorySummaryRow(
                        context: context,
                        icon: AppAssets.box,
                        label: context.tr.allProductsComplete,
                        value: Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                details.inventoriedCount.toString(),
                                style: AppStyles.s13W500.copyWith(
                                  color: context.customColor.text1,
                                ),
                              ),
                              Text(
                                '/${details.numberOfProducts}',
                                style: AppStyles.s13W500.copyWith(
                                  color: context.customColor.text3,
                                ),
                              ),
                              3.horizontalSpace,
                              Text(
                                '(${details.inventoriedCount / details.numberOfProducts * 100}%)',
                                style: AppStyles.s13W500.copyWith(
                                  color: AppColors.lightGreen,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      10.verticalSpace,
                      _buildInventorySummaryRow(
                        context: context,
                        icon: AppAssets.timer,
                        label: context.tr.timeTaken,
                        value: Text(
                          DateFormatter.timeAgo(
                            DateTime.tryParse(details.timeTaken ?? ''),
                          ),
                          style: AppStyles.s13W500.copyWith(
                            color: context.customColor.text1,
                          ),
                        ),
                      ),
                      10.verticalSpace,
                      _buildInventorySummaryRow(
                        context: context,
                        icon: AppAssets.timer,
                        label: context.tr.numberOfParticipants,
                        value: Text(
                          '${details.staff.length} ${context.tr.staff}',
                          style: AppStyles.s13W500.copyWith(
                            color: context.customColor.text1,
                          ),
                        ),
                      ),
                      10.verticalSpace,
                      _buildInventorySummaryRow(
                        context: context,
                        icon: AppAssets.timer,
                        label: '${context.tr.inventoryStatus}:',
                        value: Text(
                          details.staff.length == details.numberOfProducts
                              ? context.tr.successfullyCompleted
                              : context.tr.pending,
                          style: AppStyles.s13W500.copyWith(
                            color:
                                details.inventoriedCount ==
                                    details.numberOfProducts
                                ? AppColors.lightGreen
                                : AppColors.orange,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                12.verticalSpace,
                Text(
                  context.tr.teamContribution,
                  style: AppStyles.s16W600.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                12.verticalSpace,
                Container(
                  decoration: BoxDecoration(
                    color: context.customColor.reversedTextColor,
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    children: List.generate(details.staff.length, (index) {
                      return Column(
                        children: [
                          _buildTeamContributionWidget(
                            context: context,
                            name: details.staff[index].name,
                            value:
                                '${details.staff[index].productsCounted} ${context.tr.products}',
                          ),
                          if (index != details.staff.length - 1) ...[
                            10.verticalSpace,
                            const CustomDivider(),
                            10.verticalSpace,
                          ],
                        ],
                      );
                    }),
                  ),
                ),
                12.verticalSpace,
                Text(
                  context.tr.inventoriedProducts(details.products.length),
                  style: AppStyles.s16W600.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                12.verticalSpace,
                ListView.builder(
                  itemCount: details.products.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: context.customColor.reversedTextColor,
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      padding: EdgeInsets.all(16.r),
                      margin: EdgeInsets.only(bottom: 8.r),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              PurchaseItemImage(
                                image: details.products[index].itemLogo,
                              ),
                              10.horizontalSpace,
                              Flexible(
                                child: Text(
                                  details.products[index].itemName,
                                  style: AppStyles.s14W400.copyWith(
                                    color: context.customColor.text1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          10.verticalSpace,
                          const CustomDivider(),
                          10.verticalSpace,
                          _buildInventorySummaryRow(
                            context: context,
                            icon: AppAssets.box,
                            label: '${context.tr.quantity}:',
                            value: Text(
                              '${details.products[index].quantityInventory.toInt()} ${details.products[index].unit}',
                              style: AppStyles.s13W500.copyWith(
                                color: context.customColor.text1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Container(
                  decoration: BoxDecoration(
                    color: context.customColor.reversedTextColor,
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    children: [
                      Text(
                        context.tr.totalInventoryValue,
                        style: AppStyles.s12W500.copyWith(
                          color: context.customColor.text3,
                        ),
                      ),
                      5.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SaudiRiyalSvgWidget(),
                          Text(
                            details.products.isNotEmpty
                                ? '${details.products.map((e) => e.unitPrice * e.quantityInventory).reduce((a, b) => a + b).toStringAsFixed(2)} ${context.tr.sar}'
                                : '0',
                            style: AppStyles.s20W600.copyWith(
                              color: context.customColor.text1,
                            ),
                          ),
                        ],
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

  Widget _buildInventorySummaryRow({
    required BuildContext context,
    required String icon,
    required String label,
    Widget? value,
    Color? iconColor,
  }) {
    return Row(
      children: [
        AppSvg(
          assetName: icon,
          width: 14.w,
          height: 14.h,
          colorFilter: ColorFilter.mode(
            iconColor ?? context.customColor.text3,
            BlendMode.srcIn,
          ),
        ),
        8.horizontalSpace,
        Expanded(
          child: Text(
            label,
            style: AppStyles.s12W400.copyWith(color: context.customColor.text3),
          ),
        ),
        8.horizontalSpace,
        ?value,
      ],
    );
  }

  Widget _buildTeamContributionWidget({
    required BuildContext context,
    required String name,
    required String value,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                name,
                style: AppStyles.s13W500.copyWith(
                  color: context.customColor.text4,
                ),
              ),
            ),
            5.horizontalSpace,
            Text(
              value,
              style: AppStyles.s13W500.copyWith(
                color: context.customColor.text1,
              ),
            ),
          ],
        ),
        5.horizontalSpace,
        _buildInventorySummaryRow(
          context: context,
          icon: AppAssets.star,
          iconColor: AppColors.orange,
          label: context.tr.excellentPerformance,
        ),
      ],
    );
  }
}
