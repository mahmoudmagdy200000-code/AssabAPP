import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/extensions/widget_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/app_styles.dart';
import '../widgets/receive_without_prior_order_button.dart';

class ReceiveGoodsDraftView extends StatelessWidget {
  const ReceiveGoodsDraftView({super.key});

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
            child: CustomScrollView(
              slivers: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      context.tr.incompleteInspection,
                      style: AppStyles.s12W500.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                  ],
                ).sliverBoxAdapter,
                8.verticalSpace.sliverBoxAdapter,
                // SliverList.builder(
                //   itemCount: 3,
                //   itemBuilder: (context, index) {
                //     return const ReceiveGoodsItemListWidget();
                //   },
                // ),
              ],
            ),
          ),
        ),
        const ReceiveWithoutPriorOrderButton(),
      ],
    );
  }
}
