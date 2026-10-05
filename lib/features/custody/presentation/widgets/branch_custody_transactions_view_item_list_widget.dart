import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/saudi_riyal_svg_widget.dart';
import '../../data/models/branch_custody_transactions_response.dart';

class BranchCustodyTransactionsViewItemListWidget extends StatelessWidget {
  final BranchCustodyTransaction? transaction;

  const BranchCustodyTransactionsViewItemListWidget({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.customColor.reversedTextColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 12.r),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: context.customColor.text2.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            padding: EdgeInsets.all(10.r),
            child: AppSvg(
              assetName: AppAssets.directSupplier,
              width: 20.r,
              height: 20.r,
              colorFilter: ColorFilter.mode(
                context.customColor.text3,
                BlendMode.srcIn,
              ),
            ),
          ),
          14.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        transaction?.type ?? '',
                        softWrap: true,
                        style: AppStyles.s12W600.copyWith(
                          color: context.customColor.text1,
                        ),
                      ),
                    ),
                    SaudiRiyalSvgWidget(color: context.customColor.text3),
                    3.horizontalSpace,
                    Text(
                      transaction?.amount ?? '',
                      style: AppStyles.s12WB.copyWith(
                        color: transaction?.isCashIn == true
                            ? AppColors.lightGreen
                            : context.customColor.error,
                      ),
                    ),
                  ],
                ),
                4.verticalSpace,
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        transaction?.submittedBy ?? '',
                        style: AppStyles.s10W400.copyWith(
                          color: context.customColor.text3,
                        ),
                      ),
                    ),
                    10.horizontalSpace,
                    Text(
                      transaction?.dateTime ?? '',
                      style: AppStyles.s10W500.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
