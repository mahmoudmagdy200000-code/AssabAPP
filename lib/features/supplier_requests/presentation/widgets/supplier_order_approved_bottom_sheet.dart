import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:flutter/material.dart';

import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/widgets/custom_text_button.dart';

class SupplierOrderApprovedBottomSheet extends StatelessWidget {
  final String? title;
  final String? titleDesc;
  final String? assetName;
  final String? oldStatus;
  final String? newStatus;
  final String? description;
  final Color? iconColor;
  final String? dot1;
  final String? dot2;
  final String? dot3;
  final Widget? customStatus;

  const SupplierOrderApprovedBottomSheet({
    super.key,
    this.title,
    this.titleDesc,
    this.assetName,
    this.oldStatus,
    this.newStatus,
    this.description,
    this.iconColor,
    this.dot1,
    this.dot2,
    this.dot3,
    this.customStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title ?? context.tr.orderApproved,
                    style: AppStyles.s20W600.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                  10.verticalSpace,
                  Text(
                    titleDesc ?? context.tr.orderReadyForNextPhase,
                    textAlign: TextAlign.center,
                    style: AppStyles.s14W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                  20.verticalSpace,
                  Container(
                    decoration: BoxDecoration(
                      color: context.customColor.text2,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    padding: EdgeInsets.all(20.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.tr.whatComesNext,
                          style: AppStyles.s16W600.copyWith(
                            color: context.customColor.text1,
                          ),
                        ),
                        10.verticalSpace,
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.r),
                            color: context.customColor.reversedTextColor,
                          ),
                          padding: EdgeInsets.all(16.r),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppSvg(
                                assetName: assetName ?? AppAssets.preparing,
                                width: 24.r,
                                colorFilter: iconColor != null
                                    ? ColorFilter.mode(
                                        iconColor ?? context.customColor.text3,
                                        BlendMode.srcIn,
                                      )
                                    : null,
                              ),
                              12.horizontalSpace,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    customStatus ??
                                        Row(
                                          children: [
                                            Text(
                                              oldStatus ?? context.tr.confirmed,
                                              style: AppStyles.s14W500.copyWith(
                                                color:
                                                    context.customColor.text1,
                                              ),
                                            ),
                                            5.horizontalSpace,
                                            Icon(
                                              Icons.arrow_forward,
                                              size: 16.r,
                                              color: context.customColor.text1,
                                            ),
                                            5.horizontalSpace,
                                            Text(
                                              newStatus ?? context.tr.preparing,
                                              style: AppStyles.s14W500.copyWith(
                                                color:
                                                    context.customColor.text1,
                                              ),
                                            ),
                                          ],
                                        ),
                                    5.verticalSpace,
                                    Text(
                                      context
                                          .tr
                                          .uploadAllRequiredDocumentsBeforePreparingTheOrder,
                                      style: AppStyles.s12W400.copyWith(
                                        color: context.customColor.text3,
                                      ),
                                    ),
                                    if (dot1 != null)
                                      _dotWidget(context, dot1!),
                                    if (dot2 != null)
                                      _dotWidget(context, dot2!),
                                    if (dot3 != null)
                                      _dotWidget(context, dot3!),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            CustomTextButton(
              text: context.tr.backToDashboard,
              onTap: () {
                NavigationService.I.popToFirst();
              },
              backgroundColor: context.theme.primaryColor,
              textColor: context.customColor.reversedTextColor,
              padding: EdgeInsets.symmetric(vertical: 18.r),
              borderRadius: 1000.r,
            ),
            // if (title != null) ...[
            //   20.verticalSpace,
            //   CustomTextButton(
            //     text: context.tr.backToDashboard,
            //     onTap: () {
            //       NavigationService.I.popToFirst();
            //     },
            //     backgroundColor: context.theme.primaryColor,
            //     textColor: context.customColor.reversedTextColor,
            //     padding: EdgeInsets.symmetric(vertical: 18.r),
            //     borderRadius: 1000.r,
            //   ),
            //   16.verticalSpace,
            //   CustomTextButton(
            //     text: context.tr.seeOrderDetailsModification,
            //     onTap: () {
            //       NavigationService.I.pop();
            //     },
            //     backgroundColor: Colors.transparent,
            //     textColor: context.customColor.text1,
            //     padding: EdgeInsets.symmetric(vertical: 18.r),
            //     borderRadius: 1000.r,
            //   ),
            // ],
          ],
        ),
      ),
    );
  }

  Widget _dotWidget(BuildContext context, String dotText) {
    return Column(
      children: [
        5.verticalSpace,
        Row(
          children: [
            Icon(Icons.circle, size: 3.r, color: context.customColor.text1),
            5.horizontalSpace,
            Expanded(
              child: Text(
                dotText,
                style: AppStyles.s12W500.copyWith(
                  color: context.customColor.text1,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
