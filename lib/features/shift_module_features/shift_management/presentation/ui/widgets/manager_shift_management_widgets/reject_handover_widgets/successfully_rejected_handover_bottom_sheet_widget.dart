import 'package:flutter/material.dart';

import '../../../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../../../core/extensions/number_extensions.dart';
import '../../../../../../../../core/routing/app_route_name.dart';
import '../../../../../../../../core/services/navigation/navigation_service.dart';
import '../../../../../../../../core/styles/app_colors.dart';
import '../../../../../../../../core/styles/app_styles.dart';
import '../../../../../../../../core/widgets/app_button.dart';

class SuccessfullyRejectedHandoverBottomSheetWidget extends StatelessWidget {
  const SuccessfullyRejectedHandoverBottomSheetWidget({
    super.key,
    this.shiftId,
    this.isFromRequestsScreen = false,
  });

  final String? shiftId;
  final bool? isFromRequestsScreen;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(context.tr.handoverRejected, style: AppStyles.s17W500),

          10.verticalSpace,

          Text(
            context.tr.theHandoverHasBeenRejected,
            style: AppStyles.s13W400.copyWith(color: context.customColor.text4),
          ),

          100.verticalSpace,

          AppButton(
            onClick: () {
              if (isFromRequestsScreen ?? false) {
                NavigationService.I.pushNamed(
                  AppRouteName.shiftDetailsScreen,
                  arguments: {
                    'shiftId': shiftId,
                    'isNavigatedFromCashier': false,
                  },
                );
              } else {
                Navigator.pop(context);
              }
            },
            text: isFromRequestsScreen ?? false
                ? context.tr.shiftDetails
                : context.tr.close,
            borderRadius: BorderRadius.circular(10.r),
            isTransparent: true,
            borderColor: context.customColor.border,
            textColor: AppColors.sBlack,
            enabled: true,
          ),
        ],
      ),
    );
  }
}
