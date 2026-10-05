import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/paging_cubit/paging_cubit.dart';
import '../../../../core/cubits/paging_cubit/paging_state.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/app_padding_widget.dart';
import '../../../../core/widgets/custom_text_button.dart';
import 'brand_owner_escalation_requests_completed_view.dart';
import 'brand_owner_escalation_requests_pending_view.dart';

class BrandOwnerEscalationRequestsScreen extends StatelessWidget {
  const BrandOwnerEscalationRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppPaddingWidget(
            top: 30.r,
            child: Row(
              children: [
                const AppBackButton(),
                10.horizontalSpace,
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.tr.escalation,
                        style: AppStyles.s16W500.copyWith(
                          color: context.customColor.text1,
                        ),
                      ),
                      Text(
                        'Review all escalated Handover\'s/Orders',
                        style: AppStyles.s12W400.copyWith(
                          color: context.customColor.text3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.customColor.reversedTextColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
              ),
              padding: EdgeInsets.all(16.r),
              child: Column(
                children: [
                  Row(
                    spacing: 8.w,
                    children: List.generate(2, (index) {
                      final titles = [context.tr.pending, context.tr.completed];

                      return Expanded(
                        child: BlocSelector<PagingCubit, PagingState, bool>(
                          selector: (state) {
                            return state.currentIndex == index;
                          },
                          builder: (context, state) {
                            return CustomTextButton(
                              text: titles[index],
                              textColor: state
                                  ? context.theme.primaryColor
                                  : context.customColor.text3,
                              borderColor: state
                                  ? context.theme.primaryColor
                                  : context.customColor.border,
                              borderRadius: 1000.r,
                              onTap: () {
                                context.read<PagingCubit>().goToStep(index);
                              },
                            );
                          },
                        ),
                      );
                    }),
                  ),
                  10.verticalSpace,
                  Expanded(
                    child: BlocSelector<PagingCubit, PagingState, int>(
                      selector: (state) {
                        return state.currentIndex;
                      },
                      builder: (context, index) {
                        return IndexedStack(
                          index: index,
                          children: const [
                            BrandOwnerEscalationRequestsPendingView(),
                            BrandOwnerEscalationRequestsCompletedView(),
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
