import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/routing/app_route_name.dart';
import '../../../../../../../core/services/navigation/navigation_service.dart';
import '../../../../../../../core/widgets/app_button.dart';

class SeeDetailsButtonWidget extends StatelessWidget {
  final String shiftId;
  final double? width;
  final bool? isNavigatedFromCashier;
  final bool isCashier;
  const SeeDetailsButtonWidget({
    super.key,
    required this.shiftId,
    this.width,
    this.isNavigatedFromCashier,
    this.isCashier = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      width: width,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      borderRadius: BorderRadius.circular(12.r),
      // isTransparent: true,
      textColor: context.customColor.text1,
      enabled: true,
      background: context.theme.scaffoldBackgroundColor,
      onClick: () {
        NavigationService.I.pushNamed(
          AppRouteName.shiftDetailsScreen,
          arguments: {'shiftId': shiftId, 'isCashier': isCashier},
        );
      },
      text: context.tr.seeDetails,
    );
  }
}
