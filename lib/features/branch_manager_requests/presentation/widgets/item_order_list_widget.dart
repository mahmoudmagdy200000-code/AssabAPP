import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/utils/date_formatter.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/dynamic_steps/dynamic_steps_cubit.dart';
import '../../../../core/cubits/paging_cubit/paging_cubit.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/strategies/requests_order_status_strategy.dart';
import '../../../../core/strategies/requests_order_type_strategy.dart';
import '../../../../core/styles/app_styles.dart';
import '../../data/models/orders_response.dart';
import '../cubit/get_order_details/get_order_details_cubit.dart';
import '../cubit/get_orders/get_orders_cubit.dart';
import '../screens/order_draft_details_screen.dart';
import '../screens/request_details_screen.dart';

class ItemOrderListWidget extends StatelessWidget {
  final OrderData order;

  const ItemOrderListWidget({super.key, required this.order});

  String itemText(BuildContext context) {
    String text = '';

    if (order.items.length == 1) {
      text = order.items[0].itemName;
    } else {
      text = '${order.items.length} ${context.tr.itemsRequired}';
    }

    return text;
  }

  void _getOrders(BuildContext context) {
    context.read<GetOrdersCubit>().getOrders();
  }

  @override
  Widget build(BuildContext context) {
    return AppGestureDetectorButton(
      onTap: () async {
        await NavigationService.I.push(
          MaterialPageRoute(
            builder: (context) => MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => PagingCubit(totalSteps: 3)),
                BlocProvider(create: (context) => DynamicStepsCubit()),
                BlocProvider(
                  create: (context) => getIt<GetOrderDetailsCubit>(),
                ),
                BlocProvider(
                  create: (context) => ValidationCubit(
                    requiredFields: {'approval', 'timelines'},
                  ),
                ),
              ],
              child: RequestDetailsScreen(
                id: order.id,
                strategy: order.orderType,
              ),
            ),
          ),
        );

        if (context.mounted) {
          _getOrders(context);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: context.customColor.border),
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
                    itemText(context),
                    style: AppStyles.s13W600.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                ),
                10.horizontalSpace,
                AppGestureDetectorButton(
                  onTap: () async {
                    if (order.status is DraftStatusStrategyImpl) {
                      await NavigationService.I.push(
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) => getIt<GetOrderDetailsCubit>(),
                            child: OrderDraftDetailsScreen(
                              id: order.id,
                              strategy: order.orderType,
                            ),
                          ),
                        ),
                      );

                      if (context.mounted) {
                        _getOrders(context);
                      }
                    }
                  },
                  child: order.status.buildStatus(context),
                ),
              ],
            ),
            4.verticalSpace,
            order.orderType.buildRowType(context),
            4.verticalSpace,
            Text(
              '${DateFormatter.formatDateMDY(DateTime.tryParse(order.createdAt))} - ${DateFormatter.formatTimeHM(DateTime.tryParse(order.createdAt))}',
              style: AppStyles.s12W400.copyWith(
                color: context.customColor.text3,
              ),
            ),
            BranchOrderTypeStrategy(
              order.status,
              orderId: order.id,
            ).buildButtons(context),
          ],
        ),
      ),
    );
  }
}
