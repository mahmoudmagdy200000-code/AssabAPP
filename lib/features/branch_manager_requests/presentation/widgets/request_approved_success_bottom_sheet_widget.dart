import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_padding_widget.dart';
import '../../../../core/widgets/custom_text_button.dart';

class RequestApprovedSuccessBottomSheetWidget extends StatelessWidget {
  final String? title;
  final String? desc;

  const RequestApprovedSuccessBottomSheetWidget({
    super.key,
    this.title,
    this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return AppPaddingWidget(
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title ?? context.tr.requestApproved,
                  style: AppStyles.s20W600.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                12.verticalSpace,
                Text(
                  desc ??
                      context
                          .tr
                          .transferRequesterHasBeenNotifiedThatTheOrderWillBe,
                  textAlign: TextAlign.center,
                  style: AppStyles.s14W400.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
              ],
            ),
          ),
          CustomTextButton(
            text: context.tr.close,
            textColor: context.customColor.text4,
            onTap: () {
              NavigationService.I.popToFirst();
            },
          ),
        ],
      ),
    );
  }
}
