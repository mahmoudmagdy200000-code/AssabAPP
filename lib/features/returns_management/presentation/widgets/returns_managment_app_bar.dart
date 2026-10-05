import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/widgets/app_back_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/styles/app_styles.dart';
import '../cubit/get_returns/get_returns_cubit.dart';
import '../cubit/get_returns/get_returns_state.dart';
import 'returns_managment_quick_links_bottom_sheet_widget.dart';

class ReturnsManagmentAppBar extends StatelessWidget {
  const ReturnsManagmentAppBar({super.key});

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
                BlocSelector<GetReturnsCubit, GetReturnsState, int>(
                  selector: (state) => state is GetReturnsSuccess
                      ? state.returns.data.length
                      : 0,
                  builder: (context, state) {
                    return Text(
                      '${context.tr.returnedGoods} ($state)',
                      style: AppStyles.s20W600.copyWith(
                        color: context.customColor.text1,
                      ),
                    );
                  },
                ),
                Text(
                  context.tr.manageAllYourPendingAndPastReturns,
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
                (context) =>
                    const ReturnsManagmentQuickLinksBottomSheetWidget(),
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
