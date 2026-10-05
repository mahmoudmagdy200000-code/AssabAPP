import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_padding_widget.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/button_text_icon.dart';

class ReceiveWithoutPriorOrderButton extends StatelessWidget {
  const ReceiveWithoutPriorOrderButton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPaddingWidget(
      top: 10.r,
      child: ButtonTextIcon(
        onTap: () {
          NavigationService.I.pushNamed(
            AppRouteName.receiveWithoutPriorOrderScreen,
          );
        },
        label: context.tr.receiveWithoutPriorOrder,
        textStyle: AppStyles.s14W500.copyWith(color: context.customColor.text1),
        icon: AppSvg(
          assetName: AppAssets.box,
          width: 14.r,
          colorFilter: ColorFilter.mode(
            context.customColor.text1,
            BlendMode.srcIn,
          ),
        ),
        spaceBetweenTextAndIcon: 8.r,
        borderRadius: BorderRadius.circular(1000.r),
      ),
    );
  }
}
