import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/strategies/requests_order_type_strategy.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../data/models/receive_goods_in_progress_orders_response.dart';

class ReceiveGoodsItemListWidget extends StatelessWidget {
  final ReceiveGoodsOrder order;

  const ReceiveGoodsItemListWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.customColor.reversedTextColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 16.r),
      margin: EdgeInsets.only(bottom: 8.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${order.itemsCount} ${context.tr.itemsRequired}',
                  style: AppStyles.s13W600.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
              ),
              10.horizontalSpace,
              order.status.buildStatus(context),
            ],
          ),
          4.verticalSpace,
          order.orderType.buildRowType(context),
          4.verticalSpace,
          Text(
            '${DateFormatter.formatDateMDY(DateTime.tryParse(order.date))} - ${DateFormatter.formatTimeHM(DateTime.tryParse(order.date))}',
            style: AppStyles.s12W400.copyWith(color: context.customColor.text3),
          ),
          BranchOrderTypeStrategy(
            order.status,
            orderId: order.orderId,
          ).buildButtons(context),
        ],
      ),
    );
  }
}
