import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routing/app_route_name.dart';
import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_failure_widget.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../data/models/receive_goods_in_progress_orders_response.dart';
import '../cubit/get_receiving_orders/get_receiving_orders_cubit.dart';
import '../cubit/get_receiving_orders/get_receiving_orders_state.dart';
import '../widgets/receive_goods_empty_widget.dart';
import '../widgets/receive_goods_item_list_widget.dart';

class ReceiveGoodsCompletedView extends StatefulWidget {
  const ReceiveGoodsCompletedView({super.key});

  @override
  State<ReceiveGoodsCompletedView> createState() =>
      _ReceiveGoodsCompletedViewState();
}

class _ReceiveGoodsCompletedViewState extends State<ReceiveGoodsCompletedView> {
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

      if (cubit.completedPaginator.hasMore) {
        _getOrders(loadMore: true);
      }
    }
  }

  void _getOrders({bool loadMore = false}) {
    context.read<GetReceivingOrdersCubit>().getReceivingOrdersCompleted(
      loadMore: loadMore,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          context.tr.purchaseHistoryReturns,
          textAlign: TextAlign.center,
          style: AppStyles.s14W600.copyWith(color: context.customColor.text1),
        ),
        8.verticalSpace,
        Row(
          children: [
            30.horizontalSpace,
            Expanded(
              child: Text(
                context.tr.viewAllYourCompletedPurchasesAndRequestAReturnIf,
                textAlign: TextAlign.center,
                style: AppStyles.s13W400.copyWith(
                  color: context.customColor.text3,
                ),
              ),
            ),
            30.horizontalSpace,
          ],
        ),
        20.verticalSpace,
        Text(
          context.tr.clickTheButtonBelowToSeeFullDetails,
          textAlign: TextAlign.center,
          style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
        ),
        8.verticalSpace,
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: context.customColor.text2,
              borderRadius: BorderRadius.circular(20.r),
            ),
            margin: EdgeInsets.only(left: 12.r, right: 12.r, bottom: 12.r),
            padding: EdgeInsets.all(4.r),
            child: BlocBuilder<GetReceivingOrdersCubit, GetReceivingOrdersState>(
              buildWhen: (previous, current) =>
                  current is GetReceivingOrdersCompletedLoading ||
                  current is GetReceivingOrdersCompletedFailure ||
                  current is GetReceivingOrdersCompletedSuccess,
              builder: (context, state) {
                final orders = <ReceiveGoodsOrder>[];

                if (state is GetReceivingOrdersCompletedLoading) {
                  return const AppLoadingWidget();
                } else if (state is GetReceivingOrdersCompletedFailure) {
                  return AppFailureWidget(
                    failure: state.failure,
                    onRetry: _getOrders,
                  );
                } else if (state is GetReceivingOrdersCompletedSuccess) {
                  orders.addAll(state.orders);
                }

                if (orders.isEmpty) {
                  return ReceiveGoodsEmptyWidget(
                    image: AppAssets.returnManagementPng,
                    title: context.tr.noFullyReceivedOrdersYet,
                    description: context
                        .tr
                        .onceYouFinishReviewingAndConfirmingAnOrderItllAppearHereForReference,
                  );
                }
                return ListView.builder(
                  controller: _scrollController,
                  itemCount: orders.length,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return ReceiveGoodsItemListWidget(order: orders[index]);
                  },
                );
              },
            ),
          ),
        ),
        AppPaddingWidget(
          top: 10.r,
          child: CustomTextButton(
            text: context.tr.purchaseHistory,
            onTap: () {
              NavigationService.I.pushNamed(AppRouteName.purchaseHistoryScreen);
            },
            borderRadius: 1000.r,
            borderColor: Colors.transparent,
            backgroundColor: context.theme.primaryColor,
            textColor: context.customColor.reversedTextColor,
            padding: EdgeInsets.symmetric(vertical: 13.r),
          ),
        ),
      ],
    );
  }
}
