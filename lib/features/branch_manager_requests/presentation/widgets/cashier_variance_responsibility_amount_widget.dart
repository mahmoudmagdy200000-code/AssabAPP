import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/extensions/build_context_extensions.dart';
import '../../../../core/extensions/number_extensions.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/saudi_riyal_svg_widget.dart';
import '../../domain/entities/responsibility_entity.dart';
import '../mappers/responsibility_ui_mapper.dart';

class CashierVarianceResponsibilityAmountWidget extends StatelessWidget {
  const CashierVarianceResponsibilityAmountWidget({
    super.key,
    required this.cashier,
  });

  final ResponsibilityDetailsEntity cashier;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSvg(assetName: AppAssets.noProfile, width: 40.w),
        12.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cashier.cashierName,
                style: AppStyles.s14W500.copyWith(
                  color: context.customColor.text1,
                ),
              ),
              4.verticalSpace,
              Text(
                cashier.branchName,
                style: AppStyles.s12W400.copyWith(
                  color: context.customColor.text3,
                ),
              ),
              4.verticalSpace,

              Text(
                cashier.responsibilityStatus.title(context),
                style: AppStyles.s12W400.copyWith(
                  color: cashier.responsibilityStatus.textColor(),
                ),
              ),
              4.verticalSpace,
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: context.customColor.border),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        cashier.varianceAmount.toString(),
                        style: AppStyles.s14W400.copyWith(
                          color: context.customColor.text1,
                        ),
                      ),
                    ),
                    10.horizontalSpace,
                    const SaudiRiyalSvgWidget(),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
