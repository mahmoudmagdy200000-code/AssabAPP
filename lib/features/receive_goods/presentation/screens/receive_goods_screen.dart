import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:assab/core/cubits/paging_cubit/paging_state.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/receive_goods_app_bar.dart';
import 'receive_goods_completed_view.dart';
import 'receive_goods_in_progress_view.dart';
import 'receive_goods_missing_view.dart';

class ReceiveGoodsScreen extends StatelessWidget {
  const ReceiveGoodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColor.text2,
      body: Column(
        children: [
          const ReceiveGoodsAppBar(),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.customColor.reversedTextColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    height: 33.h,
                    margin: EdgeInsets.symmetric(
                      horizontal: 12.r,
                      vertical: 12.r,
                    ),
                    child: Row(
                      children: List.generate(3, (index) {
                        final texts = [
                          context.tr.inProgress,
                          context.tr.missing,
                          context.tr.completed,
                        ];

                        return BlocSelector<PagingCubit, PagingState, int>(
                          selector: (state) => state.currentIndex,
                          builder: (context, state) {
                            final isSelected = state == index;

                            return Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: CustomTextButton(
                                      text: texts[index],
                                      onTap: () {
                                        context.read<PagingCubit>().goToStep(
                                          index,
                                        );
                                      },
                                      textColor: isSelected
                                          ? context.theme.primaryColor
                                          : context.customColor.text1,
                                      borderRadius: 1000.r,
                                      borderColor: isSelected
                                          ? context.theme.primaryColor
                                          : context.customColor.border,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 14.r,
                                      ),
                                    ),
                                  ),
                                  if (index != 2) 12.horizontalSpace,
                                ],
                              ),
                            );
                          },
                        );
                      }),
                    ),
                  ),
                  6.verticalSpace,
                  Expanded(
                    child: BlocSelector<PagingCubit, PagingState, int>(
                      selector: (state) => state.currentIndex,
                      builder: (context, state) {
                        return IndexedStack(
                          index: state,
                          children: const [
                            ReceiveGoodsInProgressView(),
                            ReceiveGoodsMissingView(),
                            ReceiveGoodsCompletedView(),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
