import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/helpers/shared_preferences_helper.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_asset_image.dart';
import '../../../../core/widgets/app_padding_widget.dart';
import '../../../../core/widgets/app_svg_button.dart';
import '../cubit/get_branch_info/get_branch_info_cubit.dart';
import 'cashier_store_branch_info_bottom_sheet_widget.dart';

class CashierHomeTopSection extends StatelessWidget {
  const CashierHomeTopSection({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPaddingWidget(
      top: 50.r,
      bottom: 14.r,
      child: Row(
        children: [
          AppAssetImage(
            image: AppAssets.testProfile,
            width: 40.w,
            height: 40.w,
            borderRadius: BorderRadius.circular(1000.r),
          ),
          10.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${context.tr.welcome} ${getIt<SharedPreferencesHelper>().getString('u_name')}',
                        style: AppStyles.s16W600.copyWith(
                          color: context.customColor.text1,
                        ),
                      ),
                    ),
                    5.horizontalSpace,
                    Icon(
                      Icons.waving_hand_rounded,
                      size: 15.r,
                      color: const Color(0xffdab194),
                    ),
                  ],
                ),
                AppGestureDetectorButton(
                  onTap: () {
                    AppBottomSheet.pageRoute(
                      context,
                      (_) => BlocProvider(
                        create: (context) =>
                            getIt<GetBranchInfoCubit>()..getBranchInfo(),
                        child: const Expanded(
                          child: CashierStoreBranchInfoBottomSheetWidget(),
                        ),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          context.tr.cashierDashboardForStoreBranch,
                          style: AppStyles.s12W400.copyWith(
                            color: context.customColor.text3,
                          ),
                        ),
                      ),
                      5.horizontalSpace,
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 17.r,
                        color: context.theme.primaryColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          10.horizontalSpace,
          AppSvgButton(
            assetName: AppAssets.notification,
            onTap: () {},
            iconColor: context.customColor.text3,
          ),
        ],
      ),
    );
  }
}
