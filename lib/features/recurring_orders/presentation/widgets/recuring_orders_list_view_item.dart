import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/strategies/purchase_source_strategy.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../domain/strategies/recurring_order_status_strategy.dart';
import '../cubit/get_in_progress_recurring_orders/get_in_progress_recurring_orders_cubit.dart';
import '../cubit/get_next_scheduled_recurring_orders/get_next_scheduled_recurring_orders_cubit.dart';
import '../cubit/get_paused_recurring_orders/get_paused_recurring_orders_cubit.dart';

class RecuringOrdersListViewItem extends StatelessWidget {
  final RecurringOrderStatusStrategy statusStrategy;
  final PurchaseSourceStrategy purchaseSourceStrategy;
  final String orderName;
  final String? nextSchedule;
  final String orderId;

  const RecuringOrdersListViewItem({
    super.key,
    required this.statusStrategy,
    required this.purchaseSourceStrategy,
    required this.orderName,
    this.nextSchedule,
    required this.orderId,
  });

  Future<void> _getInitOrders(BuildContext context) async {
    await Future.wait([
      _getInProgressRecurringOrders(context),
      _getNextSchedulingRecurringOrders(context),
      _getPausedRecurringOrders(context),
    ]);
  }

  Future<void> _getInProgressRecurringOrders(BuildContext context) async {
    await context
        .read<GetInProgressRecurringOrdersCubit>()
        .getInProgressRecurringOrders();
  }

  Future<void> _getNextSchedulingRecurringOrders(BuildContext context) async {
    await context
        .read<GetNextScheduledRecurringOrdersCubit>()
        .getNextScheduledRecurringOrders();
  }

  Future<void> _getPausedRecurringOrders(BuildContext context) async {
    await context
        .read<GetPausedRecurringOrdersCubit>()
        .getPausedRecurringOrders();
  }

  @override
  Widget build(BuildContext context) {
    return AppGestureDetectorButton(
      onTap: () async {
        await NavigationService.I.pushNamed(
          AppRouteName.recurringOrderDetailsScreen,
          arguments: orderId,
        );

        if (context.mounted) {
          await _getInitOrders(context);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: context.customColor.reversedTextColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 16.r),
        child: Column(
          spacing: 4.h,
          children: [
            Row(
              spacing: 8.w,
              children: [
                Expanded(
                  child: Text(
                    orderName,
                    style: AppStyles.s13W500.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                ),
                statusStrategy.buildStatus(context),
              ],
            ),
            purchaseSourceStrategy.buildRowType(context),
            if (nextSchedule != null)
              Row(
                children: [
                  AppSvg(
                    assetName: AppAssets.calendar02,
                    width: 14.w,
                    height: 14.w,
                    colorFilter: ColorFilter.mode(
                      context.customColor.text3,
                      BlendMode.srcIn,
                    ),
                  ),
                  5.horizontalSpace,
                  Expanded(
                    child: Text(
                      context.tr.nextSchedule(nextSchedule ?? ''),
                      softWrap: true,
                      style: AppStyles.s12W400.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
