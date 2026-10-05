import 'package:flutter/material.dart';

import '../../../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../../../core/extensions/number_extensions.dart';
import '../../../../../../../../core/styles/app_colors.dart';
import '../../../../../../../../core/styles/app_styles.dart';
import '../../../../../../../../core/widgets/app_button.dart';

class SuccessfullyApprovedHandoverBottomSheetWidget extends StatelessWidget {
  const SuccessfullyApprovedHandoverBottomSheetWidget({
    super.key,
    required this.cashierName,
  });

  final String cashierName;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(context.tr.requestApproved, style: AppStyles.s17W500),

          10.verticalSpace,

          Text(
            context.tr.uApprovedTheHandoverFromCashier(cashierName),
            textAlign: TextAlign.center,
            style: AppStyles.s13W400.copyWith(color: context.customColor.text4),
          ),

          10.verticalSpace,

          Text(
            context.tr.theProcessIsNowMarkedAsComplete,
            style: AppStyles.s13W400.copyWith(color: context.customColor.text4),
          ),

          100.verticalSpace,

          AppButton(
            onClick: () {
              Navigator.pop(context);
            },
            text: context.tr.close,
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
