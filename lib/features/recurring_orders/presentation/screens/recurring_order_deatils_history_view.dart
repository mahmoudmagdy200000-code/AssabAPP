import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/extensions/widget_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:flutter/material.dart';

import '../../../../core/strategies/purchase_source_strategy.dart';
import '../../domain/strategies/recurring_order_status_strategy.dart';

class RecurringOrderDeatilsHistoryView extends StatelessWidget {
  const RecurringOrderDeatilsHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        Align(
          alignment: Alignment.center,
          child: Text(
            context.tr.completedOrdersCount(16),
            style: AppStyles.s14W500.copyWith(color: context.customColor.text1),
          ),
        ).sliverBoxAdapter,
        10.verticalSpace.sliverBoxAdapter,
        DecoratedSliver(
          decoration: BoxDecoration(
            color: context.customColor.text2,
            borderRadius: BorderRadius.circular(15.r),
          ),
          sliver: SliverPadding(
            padding: EdgeInsets.all(4.r),
            sliver: SliverList.builder(
              itemCount: 16,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    color: context.customColor.reversedTextColor,
                  ),
                  padding: EdgeInsets.all(16.r),
                  margin: EdgeInsets.only(bottom: 4.r),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Order Name',
                                  style: AppStyles.s13W600.copyWith(
                                    color: context.customColor.text1,
                                  ),
                                ),
                                5.verticalSpace,
                                OfficerPurchaseSourceStrategy().buildRowType(
                                  context,
                                ),
                              ],
                            ),
                          ),
                          CanceledRecurringOrderStatusStrategy()
                              .buildStatusHistoryItem(context),
                        ],
                      ),
                      24.verticalSpace,
                      CanceledRecurringOrderStatusStrategy()
                          .buildTextHistoryItem(context),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
