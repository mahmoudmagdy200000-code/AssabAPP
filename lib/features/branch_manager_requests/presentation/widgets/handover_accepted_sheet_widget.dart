import 'package:flutter/material.dart';

import '../../../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../../../core/extensions/number_extensions.dart';
import '../../../../../../../../core/styles/app_colors.dart';
import '../../../../../../../../core/styles/app_styles.dart';
import '../../../../../../../../core/widgets/app_button.dart';
import '../../../../core/routing/app_route_name.dart';
import '../../../../core/services/navigation/navigation_service.dart';

class HandoverAcceptedSheetWidget extends StatelessWidget {
  const HandoverAcceptedSheetWidget({
    super.key,
    required this.shiftId,
    this.isManager = false,
  });

  final String shiftId;
  final bool isManager;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(context.tr.shiftAccepted, style: AppStyles.s17W500),

            10.verticalSpace,

            Text(
              context.tr.yourSuccessfullyAcceptedTheHandover,
              textAlign: TextAlign.center,
              style: AppStyles.s13W400.copyWith(color: context.customColor.text4),
            ),

            5.verticalSpace,

            Text(
              isManager
                  ? 'Custody transfer has been verified and recorded. The shift has been successfully reconciled.'
                  : context
                      .tr
                      .allSalesExpensesAndHandoverActionsFromThisPointForwardWillBeRecordedUnderYourName,
              textAlign: TextAlign.center,
              style: AppStyles.s13W400.copyWith(color: context.customColor.text4),
            ),

            60.verticalSpace,

            AppButton(
              onClick: () {
                Navigator.pop(context);
                NavigationService.I.pushNamed(
                  AppRouteName.shiftDetailsScreen,
                  arguments: {
                    'shiftId': shiftId,
                    'isNavigatedFromCashier': !isManager,
                  },
                );
              },
              text: context.tr.shiftDetails,
              borderRadius: BorderRadius.circular(10.r),
              isTransparent: true,
              borderColor: context.customColor.border,
              textColor: AppColors.sBlack,
              enabled: true,
            ),
          ],
        ),
      ),
    );
  }
}
