import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';

class RecurringOrderCreatedSuccessfullyScreen extends StatelessWidget {
  const RecurringOrderCreatedSuccessfullyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: AppPaddingWidget(
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      context.tr.recurringOrderScheduled,
                      style: AppStyles.s20W600.copyWith(
                        color: context.customColor.text1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    12.verticalSpace,
                    Text(
                      context.tr.yourRecurringOrderHasBeenSuccessfullyCreated,
                      style: AppStyles.s14W400.copyWith(
                        color: context.customColor.text3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              20.verticalSpace,
              CustomTextButton(
                text: context.tr.backToDashboard,
                onTap: () {
                  NavigationService.I.popUntil((route) => route.isFirst);
                },
                backgroundColor: context.theme.primaryColor,
                textColor: context.customColor.reversedTextColor,
                borderRadius: 1000.r,
                padding: EdgeInsets.symmetric(vertical: 18.r),
              ),
              10.verticalSpace,
              CustomTextButton(
                text: context.tr.goToRecurringOrders,
                onTap: () {
                  NavigationService.I.popUntil((route) => route.isFirst);

                  NavigationService.I.pushNamed(
                    AppRouteName.recurringOrdersScreen,
                  );
                },
                backgroundColor: Colors.transparent,
                textColor: context.customColor.text1,
                borderRadius: 1000.r,
                padding: EdgeInsets.symmetric(vertical: 18.r),
              ),
              10.verticalSpace,
              CustomTextButton(
                text: context.tr.goToSubmitOrder,
                onTap: () {
                  NavigationService.I.pop();
                },
                backgroundColor: Colors.transparent,
                textColor: context.customColor.text1,
                borderRadius: 1000.r,
                padding: EdgeInsets.symmetric(vertical: 18.r),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
