import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/extensions/widget_extensions.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_icon_button.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/features/purchase/presentation/widgets/purchase_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/widgets/button_text_icon.dart';
import '../../data/models/recurring_orders_response.dart';
import '../cubit/get_in_progress_recurring_orders/get_in_progress_recurring_orders_cubit.dart';
import '../cubit/get_in_progress_recurring_orders/get_in_progress_recurring_orders_state.dart';
import '../cubit/get_next_scheduled_recurring_orders/get_next_scheduled_recurring_orders_cubit.dart';
import '../cubit/get_next_scheduled_recurring_orders/get_next_scheduled_recurring_orders_state.dart';
import '../cubit/get_paused_recurring_orders/get_paused_recurring_orders_cubit.dart';
import '../cubit/get_paused_recurring_orders/get_paused_recurring_orders_state.dart';
import '../widgets/recuring_orders_list_view_item.dart';
import '../widgets/recurring_orders_empty_widget.dart';

class RecurringOrdersScreen extends StatefulWidget {
  const RecurringOrdersScreen({super.key});

  @override
  State<RecurringOrdersScreen> createState() => _RecurringOrdersScreenState();
}

class _RecurringOrdersScreenState extends State<RecurringOrdersScreen> {
  @override
  void initState() {
    _getInitOrders();

    super.initState();
  }

  Future<void> _getInitOrders() async {
    await Future.wait([
      _getInProgressRecurringOrders(),
      _getNextSchedulingRecurringOrders(),
      _getPausedRecurringOrders(),
    ]);
  }

  Future<void> _getInProgressRecurringOrders() async {
    await context
        .read<GetInProgressRecurringOrdersCubit>()
        .getInProgressRecurringOrders();
  }

  Future<void> _getNextSchedulingRecurringOrders() async {
    await context
        .read<GetNextScheduledRecurringOrdersCubit>()
        .getNextScheduledRecurringOrders();
  }

  Future<void> _getPausedRecurringOrders() async {
    await context
        .read<GetPausedRecurringOrdersCubit>()
        .getPausedRecurringOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColor.text2,
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: PurchaseAppBar(
                  title: context.tr.recurringOrders,
                  subtitle: context.tr.recurringOrdersSubtitle,
                  titleColor: context.customColor.text1,
                  iconColor: context.customColor.text1,
                ),
              ),
              AppIconButton(
                icon: Icons.add,
                onPressed: () {
                  NavigationService.I.pushNamed(AppRouteName.purchaseScreen);
                },
                backgroundColor: context.theme.primaryColor,
                iconColor: context.customColor.reversedTextColor,
              ),
              20.horizontalSpace,
            ],
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: context.customColor.reversedTextColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
              ),
              padding: EdgeInsets.all(20.r),
              child: RefreshIndicator(
                onRefresh: _getInitOrders,
                child: CustomScrollView(
                  slivers: [
                    BlocBuilder<
                          GetInProgressRecurringOrdersCubit,
                          GetInProgressRecurringOrdersState
                        >(
                          buildWhen: (previous, current) =>
                              current is GetInProgressRecurringOrdersSuccess,
                          builder: (context, state) {
                            return Text(
                              context.tr.inProgressCount(
                                state is GetInProgressRecurringOrdersSuccess
                                    ? state.orders.data.length
                                    : 0,
                              ),
                              style: AppStyles.s14W500.copyWith(
                                color: context.customColor.text1,
                              ),
                            );
                          },
                        )
                        .sliverBoxAdapter,
                    6.verticalSpace.sliverBoxAdapter,
                    DecoratedSliver(
                      decoration: BoxDecoration(
                        color: context.customColor.text2,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      sliver: SliverPadding(
                        padding: EdgeInsets.all(4.r),
                        sliver:
                            BlocBuilder<
                              GetInProgressRecurringOrdersCubit,
                              GetInProgressRecurringOrdersState
                            >(
                              builder: (context, state) {
                                final orders = <RecurringOrderItemResponse>[];

                                if (state
                                    is GetInProgressRecurringOrdersLoading) {
                                  return const SliverFillRemaining(
                                    child: AppLoadingWidget(),
                                  );
                                } else if (state
                                    is GetInProgressRecurringOrdersFailure) {
                                  return AppFailureWidget(
                                    failure: state.failure,
                                    onRetry: _getInProgressRecurringOrders,
                                    withBorder: false,
                                  ).sliverBoxAdapter;
                                } else if (state
                                    is GetInProgressRecurringOrdersSuccess) {
                                  orders.addAll(state.orders.data);
                                }

                                if (orders.isEmpty) {
                                  return RecurringOrdersEmptyWidget(
                                    icon: AppAssets.refresh,
                                    text: context.tr.noActiveRecurringOrders,
                                  ).sliverBoxAdapter;
                                }

                                return SliverList.builder(
                                  itemCount: orders.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        RecuringOrdersListViewItem(
                                          orderName: orders[index].orderName,
                                          statusStrategy:
                                              orders[index].statusValue,
                                          purchaseSourceStrategy:
                                              orders[index].typeValue,
                                          orderId: orders[index].id,
                                        ),
                                        if (index != orders.length - 1)
                                          4.verticalSpace,
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                      ),
                    ),
                    16.verticalSpace.sliverBoxAdapter,
                    BlocBuilder<
                          GetNextScheduledRecurringOrdersCubit,
                          GetNextScheduledRecurringOrdersState
                        >(
                          buildWhen: (previous, current) =>
                              current is GetNextScheduledRecurringOrdersSuccess,
                          builder: (context, state) {
                            return Text(
                              context.tr.nextScheduledRun(
                                state is GetNextScheduledRecurringOrdersSuccess
                                    ? state.orders.data.length
                                    : 0,
                              ),
                              style: AppStyles.s14W500.copyWith(
                                color: context.customColor.text1,
                              ),
                            );
                          },
                        )
                        .sliverBoxAdapter,
                    6.verticalSpace.sliverBoxAdapter,
                    DecoratedSliver(
                      decoration: BoxDecoration(
                        color: context.customColor.text2,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      sliver: SliverPadding(
                        padding: EdgeInsets.all(4.r),
                        sliver:
                            BlocBuilder<
                              GetNextScheduledRecurringOrdersCubit,
                              GetNextScheduledRecurringOrdersState
                            >(
                              builder: (context, state) {
                                final orders = <RecurringOrderItemResponse>[];

                                if (state
                                    is GetNextScheduledRecurringOrdersLoading) {
                                  return const SliverFillRemaining(
                                    child: AppLoadingWidget(),
                                  );
                                } else if (state
                                    is GetNextScheduledRecurringOrdersFailure) {
                                  return AppFailureWidget(
                                    failure: state.failure,
                                    onRetry: _getNextSchedulingRecurringOrders,
                                    withBorder: false,
                                  ).sliverBoxAdapter;
                                } else if (state
                                    is GetNextScheduledRecurringOrdersSuccess) {
                                  orders.addAll(state.orders.data);
                                }

                                if (orders.isEmpty) {
                                  return RecurringOrdersEmptyWidget(
                                    icon: AppAssets.refresh,
                                    text: context.tr.noActiveRecurringOrders,
                                    customWidgetAfterText: ButtonTextIcon(
                                      onTap: () {
                                        NavigationService.I.pushNamed(
                                          AppRouteName.purchaseScreen,
                                        );
                                      },
                                      label: context.tr.createNewSchedule,
                                      icon: Icon(
                                        Icons.add,
                                        size: 25.r,
                                        color: context.theme.primaryColor,
                                      ),
                                      textStyle: AppStyles.s14W500.copyWith(
                                        color: context.theme.primaryColor,
                                      ),
                                      borderColor: context.theme.primaryColor,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 32.r,
                                        vertical: 18.r,
                                      ),
                                    ),
                                  ).sliverBoxAdapter;
                                }

                                return SliverList.builder(
                                  itemCount: orders.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        RecuringOrdersListViewItem(
                                          orderName: orders[index].orderName,
                                          statusStrategy:
                                              orders[index].statusValue,
                                          purchaseSourceStrategy:
                                              orders[index].typeValue,
                                          nextSchedule:
                                              orders[index].nextScheduleDate,
                                          orderId: orders[index].id,
                                        ),
                                        if (index != orders.length - 1)
                                          4.verticalSpace,
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                      ),
                    ),
                    16.verticalSpace.sliverBoxAdapter,
                    BlocBuilder<
                          GetPausedRecurringOrdersCubit,
                          GetPausedRecurringOrdersState
                        >(
                          buildWhen: (previous, current) =>
                              current is GetPausedRecurringOrdersSuccess,
                          builder: (context, state) {
                            return Text(
                              context.tr.pausedSchedules(
                                state is GetPausedRecurringOrdersSuccess
                                    ? state.orders.data.length
                                    : 0,
                              ),
                              style: AppStyles.s14W500.copyWith(
                                color: context.customColor.text1,
                              ),
                            );
                          },
                        )
                        .sliverBoxAdapter,
                    6.verticalSpace.sliverBoxAdapter,
                    DecoratedSliver(
                      decoration: BoxDecoration(
                        color: context.customColor.text2,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      sliver: SliverPadding(
                        padding: EdgeInsets.all(4.r),
                        sliver:
                            BlocBuilder<
                              GetPausedRecurringOrdersCubit,
                              GetPausedRecurringOrdersState
                            >(
                              builder: (context, state) {
                                final orders = <RecurringOrderItemResponse>[];

                                if (state is GetPausedRecurringOrdersLoading) {
                                  return const SliverFillRemaining(
                                    child: AppLoadingWidget(),
                                  );
                                } else if (state
                                    is GetPausedRecurringOrdersFailure) {
                                  return AppFailureWidget(
                                    failure: state.failure,
                                    onRetry: _getPausedRecurringOrders,
                                    withBorder: false,
                                  ).sliverBoxAdapter;
                                } else if (state
                                    is GetPausedRecurringOrdersSuccess) {
                                  orders.addAll(state.orders.data);
                                }

                                if (orders.isEmpty) {
                                  return RecurringOrdersEmptyWidget(
                                    icon: AppAssets.wait,
                                    text: context.tr.noPausedSchedules,
                                  ).sliverBoxAdapter;
                                }

                                return SliverList.builder(
                                  itemCount: orders.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        RecuringOrdersListViewItem(
                                          orderName: orders[index].orderName,
                                          statusStrategy:
                                              orders[index].statusValue,
                                          purchaseSourceStrategy:
                                              orders[index].typeValue,
                                          nextSchedule:
                                              orders[index].nextScheduleDate,
                                          orderId: orders[index].id,
                                        ),
                                        if (index != orders.length - 1)
                                          4.verticalSpace,
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
