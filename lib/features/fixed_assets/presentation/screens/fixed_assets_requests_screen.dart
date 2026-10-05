import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_back_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/paging_cubit/paging_cubit.dart';
import '../../../../core/cubits/paging_cubit/paging_state.dart';
import 'fixed_assets_requests_disposals_view.dart';
import 'fixed_assets_requests_handover_view.dart';
import 'fixed_assets_requests_modification_view.dart';
import 'fixed_assets_requests_transfers_view.dart';

class FixedAssetsRequestsScreen extends StatelessWidget {
  const FixedAssetsRequestsScreen({super.key});

  List<String> texts(BuildContext context) => [
    context.tr.modification,
    context.tr.transfers,
    context.tr.disposals,
    context.tr.handovers,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColor.text2,
      body: Column(
        children: [
          AppPaddingWidget(
            top: 30.r,
            child: Row(
              children: [
                const AppBackButton(),
                12.horizontalSpace,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Asset Records',
                      style: AppStyles.s20W500.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                    Text(
                      'Track your activities & Requests',
                      style: AppStyles.s12W400.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.customColor.reversedTextColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              ),
              padding: EdgeInsets.all(20.r),
              child: Column(
                children: [
                  SizedBox(
                    height: 32.h,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return BlocSelector<PagingCubit, PagingState, bool>(
                          selector: (state) => state.currentIndex == index,
                          builder: (context, state) {
                            return CustomTextButton(
                              text: texts(context)[index],
                              onTap: () {
                                context.read<PagingCubit>().goToStep(index);
                              },
                              padding: EdgeInsets.symmetric(horizontal: 20.r),
                              textColor: state
                                  ? context.theme.primaryColor
                                  : context.customColor.text3,
                              borderColor: state
                                  ? context.theme.primaryColor
                                  : context.customColor.border,
                              borderRadius: 1000.r,
                            );
                          },
                        );
                      },
                      separatorBuilder: (context, index) => 12.horizontalSpace,
                      itemCount: texts(context).length,
                    ),
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
                            FixedAssetsRequestsModificationView(),
                            FixedAssetsRequestsTransfersView(),
                            FixedAssetsRequestsDisposalsView(),
                            FixedAssetsRequestsHandoverView(),
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
