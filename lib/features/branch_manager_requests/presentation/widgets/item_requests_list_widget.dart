import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/strategies/requests_order_type_strategy.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/dynamic_steps/dynamic_steps_cubit.dart';
import '../../../../core/cubits/paging_cubit/paging_cubit.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../data/models/orders_response.dart';
import '../cubit/get_order_details/get_order_details_cubit.dart';
import '../cubit/get_orders/get_orders_cubit.dart';
import '../screens/request_details_screen.dart';

class ItemRequestsListWidget extends StatelessWidget {
  final OrderData request;

  const ItemRequestsListWidget({super.key, required this.request});

  String itemText(BuildContext context) {
    String text = '';

    if (request.items.length == 1) {
      text = request.items[0].itemName;
    } else {
      text = '${request.items.length} ${context.tr.itemsRequired}';
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
                id: request.id,
                strategy: request.orderType,
                isBranchOrderTypeStrategy: false,
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
                request.status.buildStatus(context),
              ],
            ),
            4.verticalSpace,
            request.orderType.buildRowType(context),
            4.verticalSpace,
            Text(
              '${DateFormatter.formatDateMDY(DateTime.tryParse(request.createdAt))} - ${DateFormatter.formatTimeHM(DateTime.tryParse(request.createdAt))}',
              style: AppStyles.s12W400.copyWith(
                color: context.customColor.text3,
              ),
            ),
            4.verticalSpace,
            Text(
              request.sourceName ?? context.tr.purchasingOfficer,
              style: AppStyles.s12W500.copyWith(color: const Color(0xff049899)),
            ),
            BranchRequestTypeStrategy(
              request.status,
              request: request,
            ).buildButtons(context),
          ],
        ),
      ),
    );
  }
}
