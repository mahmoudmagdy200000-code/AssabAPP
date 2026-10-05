import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/arguments/shift_arguments.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../../core/extensions/number_extensions.dart';
import '../../../../../../../core/routing/app_route_name.dart';
import '../../../../../../../core/services/navigation/navigation_service.dart';
import '../../../../../../../core/styles/app_styles.dart';
import '../../../../../../../core/widgets/app_button.dart';
import '../../../../../../../core/widgets/app_padding_widget.dart';
import '../../../../../../../core/widgets/app_scaffold.dart';

class HandoverSuccessWidget extends StatelessWidget {
  const HandoverSuccessWidget({
    super.key,
    // required this.isNavigatedFromCashier,
    required this.shiftArguments,
    this.isOpenedFromShiftDetailsScreen = false,
  });

  final bool isOpenedFromShiftDetailsScreen;
  final ShiftArguments shiftArguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        left: 15.w,
        right: 15.w,
        child: AppScaffold(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                20.verticalSpace,
                AppSvg(
                  assetName: AppAssets.handoverSuccessSvg,
                  width: 150.w,
                  height: 150.h,
                ),

                40.verticalSpace,

                Text(
                  context.tr.handoverRecipientApproval,
                  style: AppStyles.s18W500,
                ),

                20.verticalSpace,

                Text(
                  context.tr.handOverDesc(
                    shiftArguments.nextCashier ?? context.tr.no_name,
                  ),
                  style: AppStyles.s14W400.copyWith(
                    color: context.customColor.text3,
                  ),
                  textAlign: TextAlign.center,
                ),

                10.verticalSpace,

                const Spacer(),
                AppButton(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 15.h,
                  ),
                  borderRadius: BorderRadius.circular(25.r),
                  onClick: () {
                    Navigator.of(context).popUntil(
                      (route) => route.isFirst,
                    ); // Navigates to the First Main Cashier Screen
                  },
                  enabled: true,
                  text: context.tr.goToDashBoard,
                ),
                15.verticalSpace,

                AppButton(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 15.h,
                  ),
                  borderRadius: BorderRadius.circular(25.r),
                  isTransparent: true,
                  onClick: () {
                    if (isOpenedFromShiftDetailsScreen) {
                      NavigationService.I.pop();
                    } else {
                      NavigationService.I.replaceWithNamed(
                        AppRouteName.shiftDetailsScreen,
                        arguments: {'shiftId': shiftArguments.shiftId},
                      );
                    }
                  },
                  enabled: true,
                  text: context.tr.seeDetails,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
