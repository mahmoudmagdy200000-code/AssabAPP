import 'package:assab/core/enums/requests_orders_types_enum.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/features/branch_manager_requests/data/models/orders_response.dart';
import 'package:assab/features/branch_manager_requests/presentation/cubit/get_orders/get_orders_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/widgets/app_padding_widget.dart';
import '../cubit/get_orders/get_orders_state.dart';
import '../widgets/branch_manager_requests_empty_widget.dart';
import '../widgets/item_order_list_widget.dart';
import '../widgets/item_requests_list_widget.dart';

class BranchManagerRequestOrderView extends StatefulWidget {
  const BranchManagerRequestOrderView({super.key});

  @override
  State<BranchManagerRequestOrderView> createState() =>
      _BranchManagerRequestOrderViewState();
}

class _BranchManagerRequestOrderViewState
    extends State<BranchManagerRequestOrderView> {
  late final ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    _getOrders();

    _scrollController = ScrollController();
    _scrollController.addListener(_listenToScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_listenToScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _listenToScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 400.r) {
      if (context.read<GetOrdersCubit>().paginator.hasMore) {
        _getOrders(loadMore: true);
      }
    }
  }

  void _getOrders({bool loadMore = false}) {
    context.read<GetOrdersCubit>().getOrders(loadMore: loadMore);
  }

  @override
  Widget build(BuildContext context) {
    return AppPaddingWidget(
      top: 0,
      bottom: 0,
      child: BlocBuilder<GetOrdersCubit, GetOrdersState>(
        builder: (context, state) {
          final orders = <OrderData>[];

          if (state is GetOrdersLoading) {
            return const AppLoadingWidget();
          } else if (state is GetOrdersFailure) {
            return AppFailureWidget(
              failure: state.failure,
              onRetry: _getOrders,
              withBorder: false,
            );
          } else if (state is GetOrdersSuccess) {
            orders.addAll(state.orders);

            context.read<ValidationCubit>().validateFieldAndStoreValue(
              fieldName: 'count_order',
              value: orders.length.toString(),
              isValid: true,
            );
          }

          if (orders.isEmpty) {
            return BranchManagerRequestsEmptyWidget(
              onRefresh: _getOrders,
              message: context.tr.noOrdersAvailable,
            );
          }

          return RefreshIndicator(
            onRefresh: () async => _getOrders(),
            child: ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: orders.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                final orderOrRequest = orders[index];

                return switch (orderOrRequest.requestType) {
                  RequestsOrdersTypesEnum.order => ItemOrderListWidget(
                    order: orderOrRequest,
                  ),
                  RequestsOrdersTypesEnum.request => ItemRequestsListWidget(
                    request: orderOrRequest,
                  ),
                };
              },
            ),
          );
        },
      ),
    );
  }
}
