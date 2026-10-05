import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_asset_image.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:flutter/material.dart';

import '../../../../generated/l10n.dart';

class PriceSimulatorWhatIsChangePriceBottomSheet extends StatelessWidget {
  const PriceSimulatorWhatIsChangePriceBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        top: 0,
        child: Column(
          children: [
            AppAssetImage(
              image: AppAssets.changePrice,
              borderRadius: BorderRadius.zero,
              height: 200.h,
            ),
            20.verticalSpace,
            Text(
              S.of(context).whatIsChangePrice,
              style: AppStyles.s22W500.copyWith(
                color: context.customColor.text1,
              ),
              textAlign: TextAlign.center,
            ),
            10.verticalSpace,
            Text(
              S.of(context).increaseTheCurrentPriceOfASelectedItemByA,
              style: AppStyles.s12W400.copyWith(
                color: context.customColor.text3,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
