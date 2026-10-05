import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/cubits/validation/validation_state.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/cubits/paging_cubit/paging_state.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_svg.dart';

class BranchManagerRequestAppBar extends StatelessWidget {
  const BranchManagerRequestAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPaddingWidget(
      top: 50.r,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<PagingCubit, PagingState>(
                  builder: (context, pagingState) {
                    return BlocSelector<
                      ValidationCubit,
                      ValidationState,
                      String
                    >(
                      selector: (state) {
                        switch (pagingState.currentIndex) {
                          case 0:
                            return state.fieldsValue['count_handover'] ?? '0';
                          case 1:
                            return state.fieldsValue['count_order'] ?? '0';
                          case 2:
                            return state.fieldsValue['count_variance'] ?? '0';
                          default:
                            return '0';
                        }
                      },
                      builder: (context, state) {
                        return Text(
                          '${context.tr.pending} ($state)',
                          style: AppStyles.s20W600.copyWith(
                            color: context.customColor.text1,
                          ),
                        );
                      },
                    );
                  },
                ),
                Text(
                  context.tr.trackRequestsYouSubmittedOrReceived,
                  style: AppStyles.s12W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
              ],
            ),
          ),
          10.verticalSpace,
          Container(
            decoration: BoxDecoration(
              color: context.customColor.text2,
              borderRadius: BorderRadius.circular(1000.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 7.r, vertical: 7.r),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: context.customColor.reversedTextColor,
                    borderRadius: BorderRadius.circular(1000.r),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.r,
                    vertical: 6.r,
                  ),
                  child: AppSvg(
                    assetName: AppAssets.wait,
                    width: 12.w,
                    height: 12.w,
                  ),
                ),
                12.horizontalSpace,
                AppSvg(
                  assetName: AppAssets.check,
                  width: 12.w,
                  height: 12.w,
                  colorFilter: ColorFilter.mode(
                    context.customColor.text3,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
