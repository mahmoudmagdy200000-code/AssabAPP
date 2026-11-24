import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/extensions/widget_extensions.dart';
import 'package:assab/core/utils/date_formatter.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/features/receive_goods/presentation/cubit/get_receiving_orders/get_receiving_orders_state.dart';
import 'package:assab/features/receive_goods/presentation/widgets/receive_goods_empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/styles/app_styles.dart';
import '../../data/models/receive_goods_in_progress_orders_response.dart';
import '../cubit/get_receiving_orders/get_receiving_orders_cubit.dart';
import '../widgets/receive_goods_item_list_widget.dart';
import '../widgets/receive_without_prior_order_button.dart';

class ReceiveGoodsInProgressView extends StatefulWidget {
  const ReceiveGoodsInProgressView({super.key});

  @override
  State<ReceiveGoodsInProgressView> createState() =>
      _ReceiveGoodsInProgressViewState();
}

class _ReceiveGoodsInProgressViewState
    extends State<ReceiveGoodsInProgressView> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _getOrders();

    _scrollController = ScrollController()
      ..addListener(_scrollControllerListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollControllerListener);

    _scrollController.dispose();
    super.dispose();
  }

  void _scrollControllerListener() {
    if (!_scrollController.position.outOfRange &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 300.r) {
      final cubit = context.read<GetReceivingOrdersCubit>();

      if (cubit.inProgressPaginator.hasMore) {
        _getOrders(loadMore: true);
      }
    }
  }

  void _getOrders({bool loadMore = false}) {
    context.read<GetReceivingOrdersCubit>().getReceivingOrdersInProgress(
      loadMore: loadMore,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: context.customColor.text2,
              borderRadius: BorderRadius.circular(20.r),
            ),
            margin: EdgeInsets.only(left: 12.r, right: 12.r, bottom: 12.r),
            padding: EdgeInsets.all(12.r),
            child: BlocBuilder<GetReceivingOrdersCubit, GetReceivingOrdersState>(
              buildWhen: (previous, current) =>
                  current is GetReceivingOrdersInProgressLoading ||
                  current is GetReceivingOrdersInProgressFailure ||
                  current is GetReceivingOrdersInProgressSuccess,
              builder: (context, state) {
                final orders = <ReceiveGoodsOrder>[];

                if (state is GetReceivingOrdersInProgressLoading) {
                  return const AppLoadingWidget();
                } else if (state is GetReceivingOrdersInProgressFailure) {
                  return AppFailureWidget(
                    failure: state.failure,
                    onRetry: _getOrders,
                  );
                } else if (state is GetReceivingOrdersInProgressSuccess) {
                  orders.addAll(state.orders);
                }

                if (orders.isEmpty) {
                  return ReceiveGoodsEmptyWidget(
                    image: AppAssets.preparingPng,
                    title: context.tr.noActiveOrders,
                    description: context
                        .tr
                        .onceASupplierConfirmsShipmentYoullSeeTheOrderHere,
                  );
                }

                return CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    // Group orders by date
                    for (final dateGroup in _groupOrdersByDate(orders)) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Expected Deliveries ${DateFormatter.formatDateMDY(dateGroup.date)} (${dateGroup.orders.length})',
                            style: AppStyles.s12W500.copyWith(
                              color: context.customColor.text3,
                            ),
                          ),
                        ],
                      ).sliverBoxAdapter,
                      8.verticalSpace.sliverBoxAdapter,
                      SliverList.builder(
                        itemCount: dateGroup.orders.length,
                        itemBuilder: (context, index) {
                          return ReceiveGoodsItemListWidget(
                            order: dateGroup.orders[index],
                          );
                        },
                      ),
                      16
                          .verticalSpace
                          .sliverBoxAdapter, // Add space between date groups
                    ],
                  ],
                );
              },
            ),
          ),
        ),
        const ReceiveWithoutPriorOrderButton(),
      ],
    );
  }

  DateTime _parseOrderDate(String raw) {
    const arabicDigits = '٠١٢٣٤٥٦٧٨٩';
    var normalized = raw.trim();
    for (var i = 0; i < 10; i++) {
      normalized = normalized.replaceAll(arabicDigits[i], '$i');
    }
    final parsed = DateTime.tryParse(normalized);
    if (parsed != null) return parsed;
    final dmy = RegExp(r'^(\d{1,2})[-/](\d{1,2})[-/](\d{4})$').firstMatch(normalized);
    if (dmy != null) {
      return DateTime(
        int.parse(dmy.group(3)!),
        int.parse(dmy.group(2)!),
        int.parse(dmy.group(1)!),
      );
    }
    return DateTime.now();
  }

  // Helper method to group orders by date
  List<_DateGroup> _groupOrdersByDate(List<ReceiveGoodsOrder> orders) {
    final Map<DateTime, List<ReceiveGoodsOrder>> grouped = {};

    for (final order in orders) {
      final parsed = _parseOrderDate(order.date);
      final dateOnly = DateFormat('yyyy-MM-dd', 'en').format(parsed);
      final dateOnlyDateTime = DateTime.parse(dateOnly);
      if (!grouped.containsKey(dateOnlyDateTime)) {
        grouped[dateOnlyDateTime] = [];
      }
      grouped[dateOnlyDateTime]!.add(order);
    }

    return grouped.entries
        .map((entry) => _DateGroup(date: entry.key, orders: entry.value))
        .toList()
      ..sort(
        (a, b) => b.date.compareTo(a.date),
      ); // Sort by date descending (newest first)
  }
}

// Helper class for date groups
class _DateGroup {
  final DateTime date;
  final List<ReceiveGoodsOrder> orders;

  _DateGroup({required this.date, required this.orders});
}
