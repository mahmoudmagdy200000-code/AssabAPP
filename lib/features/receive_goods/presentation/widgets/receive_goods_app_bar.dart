import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/widgets/app_back_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg_button.dart';
import 'package:assab/features/receive_goods/presentation/widgets/receive_goods_quick_links_bottom_sheet_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/styles/app_styles.dart';
import '../cubit/get_receiving_orders/get_receiving_orders_cubit.dart';
import '../cubit/get_receiving_orders/get_receiving_orders_state.dart';

class ReceiveGoodsAppBar extends StatelessWidget {
  const ReceiveGoodsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPaddingWidget(
      top: 40.r,
      child: Row(
        children: [
          const AppBackButton(),
          10.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<GetReceivingOrdersCubit, GetReceivingOrdersState>(
                  buildWhen: (previous, current) =>
                      current is GetReceivingOrdersInProgressSuccess ||
                      current is GetReceivingOrdersMissingSuccess ||
                      current is GetReceivingOrdersCompletedSuccess,
                  builder: (context, state) {
                    int totalOrders = 0;

                    if (state is GetReceivingOrdersInProgressSuccess) {
                      totalOrders = state.orders.length;
                    } else if (state is GetReceivingOrdersMissingSuccess) {
                      totalOrders = state.orders.length;
                    } else if (state is GetReceivingOrdersCompletedSuccess) {
                      totalOrders = state.orders.length;
                    }

                    return Text(
                      '${context.tr.receiveGoods} ($totalOrders)',
                      style: AppStyles.s20W600.copyWith(
                        color: context.customColor.text1,
                      ),
                    );
                  },
                ),
                Text(
                  context.tr.viewActiveOrdersAndConfirmDelivery,
                  style: AppStyles.s12W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
              ],
            ),
          ),
          10.verticalSpace,
          AppSvgButton(
            assetName: AppAssets.more,
            onTap: () {
              AppBottomSheet.show(
                context,
                (context) => const ReceiveGoodsQuickLinksBottomSheetWidget(),
              );
            },
            iconColor: context.customColor.text1,
            withBorder: false,
            bgColor: context.customColor.reversedTextColor,
            iconSize: 15.r,
            padding: EdgeInsets.all(16.r),
          ),
        ],
      ),
    );
  }
}
