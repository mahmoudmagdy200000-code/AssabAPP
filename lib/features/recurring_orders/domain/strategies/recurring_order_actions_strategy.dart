import 'package:assab/features/recurring_orders/presentation/cubit/recurring_order_actions/recurring_order_actions_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_bottom_sheet.dart';
import '../../presentation/cubit/get_recurring_order_details/get_recurring_order_details_cubit.dart';
import '../../presentation/cubit/get_recurring_order_details/get_recurring_order_details_state.dart';
import '../../presentation/screens/recurring_order_setting_screen.dart';
import 'create_recurring_order_strategy.dart';

abstract class RecurringOrderActionsStrategy {
  void action(BuildContext context, {required String id});
}

class PauseScheduleRecurringOrderActionsStrategy
    extends RecurringOrderActionsStrategy {
  @override
  void action(BuildContext context, {required String id}) {
    context.read<RecurringOrderActionsCubit>().pauseRecurringOrder(id: id);
  }
}

class EditScheduleRecurringOrderActionsStrategy
    extends RecurringOrderActionsStrategy {
  @override
  void action(BuildContext context, {required String id}) {
    final detailsState = context.read<GetRecurringOrderDetailsCubit>().state;
    if (detailsState is! GetRecurringOrderDetailsSuccess) return;

    final actionsCubit = context.read<RecurringOrderActionsCubit>();

    AppBottomSheet.customPageRoute(
      context,
      (context) => BlocProvider.value(
        value: actionsCubit,
        child: RecurringOrderSettingScreen(
          strategy: EditCreateRecurringOrderStrategy(orderId: id),
          initialData: detailsState.details.data,
        ),
      ),
    );
  }
}

class DeleteScheduleRecurringOrderActionsStrategy
    extends RecurringOrderActionsStrategy {
  @override
  void action(BuildContext context, {required String id}) {
    context.read<RecurringOrderActionsCubit>().deleteRecurringOrder(id: id);
  }
}
