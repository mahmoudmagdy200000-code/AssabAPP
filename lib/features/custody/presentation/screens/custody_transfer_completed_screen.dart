import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_padding_widget.dart';
import '../../../../core/widgets/custom_text_button.dart';

class CustodyTransferCompletedScreen extends StatelessWidget {
  final VoidCallback? onClickSeeDetails;

  const CustodyTransferCompletedScreen({super.key, this.onClickSeeDetails});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AppPaddingWidget(
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    context.tr.transferCompleted,
                    style: AppStyles.s20WB.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                  12.verticalSpace,
                  Text(
                    context.tr
                        .youveSuccessfullyTransferredAmountToBranchCustody(
                          '255',
                        ),
                    style: AppStyles.s14W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                  Text(
                    context.tr.bothBalancesHaveBeenUpdatedAccordingly,
                    style: AppStyles.s14W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                ],
              ),
            ),
            20.verticalSpace,
            CustomTextButton(
              text: context.tr.backToDashboard,
              onTap: () {
                NavigationService.I.pop();
              },
              textColor: context.customColor.reversedTextColor,
              backgroundColor: context.theme.primaryColor,
              padding: EdgeInsets.symmetric(vertical: 24.r),
              borderRadius: 1000.r,
            ),
            // 12.verticalSpace,
            // CustomTextButton(
            //   text: context.tr.seeDetails,
            //   onTap: onClickSeeDetails ?? () {},
            //   textColor: context.customColor.text1,
            //   borderRadius: 1000.r,
            //   padding: EdgeInsets.symmetric(vertical: 24.r),
            // ),
          ],
        ),
      ),
    );
  }
}
