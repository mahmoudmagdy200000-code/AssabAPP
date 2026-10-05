import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/profit_vs_cash_reconciliation_entity.dart';

class ProfitVsCashReconciliationFinalResultBottomSheet extends StatelessWidget {
  final List<FinalResultInfoEntity> data;

  const ProfitVsCashReconciliationFinalResultBottomSheet({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        top: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.error,
              color: context.theme.primaryColor.withValues(alpha: 0.5),
              size: 20.r,
            ),
            10.verticalSpace,
            Text(
              context.tr.finalResult,
              style: AppStyles.s16W500.copyWith(
                color: context.customColor.text1,
              ),
            ),
            10.verticalSpace,
            Container(
              decoration: BoxDecoration(
                color: context.customColor.text2,
                borderRadius: BorderRadius.circular(15.r),
              ),
              padding: EdgeInsets.all(8.r),
              child: Column(
                spacing: 8.h,
                children: [
                  for (final item in data)
                    Container(
                      decoration: BoxDecoration(
                        color: context.customColor.reversedTextColor,
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      padding: EdgeInsets.all(10.r),
                      child: Row(
                        children: [
                          AppSvg(
                            assetName: AppAssets.search,
                            width: 16.r,
                            colorFilter: ColorFilter.mode(
                              context.customColor.text3,
                              BlendMode.srcIn,
                            ),
                          ),
                          10.horizontalSpace,
                          Flexible(
                            child: Text(
                              item.description,
                              style: AppStyles.s13W400.copyWith(
                                color: context.customColor.text4,
                              ),
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
    );
  }
}
