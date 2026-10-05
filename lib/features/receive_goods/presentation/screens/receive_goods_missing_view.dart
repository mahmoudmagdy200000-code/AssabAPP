import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/extensions/widget_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_failure_widget.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../data/models/receive_goods_in_progress_orders_response.dart';
import '../cubit/get_receiving_orders/get_receiving_orders_cubit.dart';
import '../cubit/get_receiving_orders/get_receiving_orders_state.dart';
import '../widgets/receive_goods_empty_widget.dart';
import '../widgets/receive_goods_item_list_widget.dart';
import '../widgets/receive_without_prior_order_button.dart';

class ReceiveGoodsMissingView extends StatefulWidget {
  const ReceiveGoodsMissingView({super.key});

  @override
  State<ReceiveGoodsMissingView> createState() =>
      _ReceiveGoodsMissingViewState();
}

class _ReceiveGoodsMissingViewState extends State<ReceiveGoodsMissingView> {
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
            _scrollController.position.maxScrollExtent - 200.r) {
      final cubit = context.read<GetReceivingOrdersCubit>();

      if (cubit.missingPaginator.hasMore) {
        _getOrders(loadMore: true);
      }
    }
  }

  void _getOrders({bool loadMore = false}) {
    context.read<GetReceivingOrdersCubit>().getReceivingOrdersMissing(
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
            child:
                BlocBuilder<GetReceivingOrdersCubit, GetReceivingOrdersState>(
                  buildWhen: (previous, current) =>
                      current is GetReceivingOrdersMissingLoading ||
                      current is GetReceivingOrdersMissingFailure ||
                      current is GetReceivingOrdersMissingSuccess,
                  builder: (context, state) {
                    final orders = <ReceiveGoodsOrder>[];

                    if (state is GetReceivingOrdersMissingLoading) {
                      return const AppLoadingWidget();
                    } else if (state is GetReceivingOrdersMissingFailure) {
                      return AppFailureWidget(
                        failure: state.failure,
                        onRetry: _getOrders,
                      );
                    } else if (state is GetReceivingOrdersMissingSuccess) {
                      orders.addAll(state.orders);
                    }

                    if (orders.isEmpty) {
                      return ReceiveGoodsEmptyWidget(
                        image: AppAssets.listPng,
                        title: context.tr.missingDocuments,
                        description: context.tr.missingDocumentsDesc,
                      );
                    }

                    return CustomScrollView(
                      controller: _scrollController,
                      slivers: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              context.tr.receiptsThatAreMissingDocuments,
                              style: AppStyles.s12W500.copyWith(
                                color: context.customColor.text3,
                              ),
                            ),
                          ],
                        ).sliverBoxAdapter,
                        8.verticalSpace.sliverBoxAdapter,
                        SliverList.builder(
                          itemCount: orders.length,
                          itemBuilder: (context, index) {
                            return ReceiveGoodsItemListWidget(
                              order: orders[index],
                            );
                          },
                        ),
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
}
