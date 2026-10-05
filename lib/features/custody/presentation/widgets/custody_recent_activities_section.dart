import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/saudi_riyal_svg_widget.dart';
import 'package:flutter/material.dart';

import '../../data/models/custody_personal_balance_response.dart';

class CustodyRecentActivitiesSection extends StatelessWidget {
  final List<CustodyPersonalBalanceResponseRecentActivity> recentActivity;

  const CustodyRecentActivitiesSection({
    super.key,
    required this.recentActivity,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.only(bottom: 12.r, left: 20.r, right: 20.r),
      sliver: DecoratedSliver(
        decoration: BoxDecoration(
          color: context.customColor.reversedTextColor,
          border: Border(
            bottom: BorderSide(color: context.customColor.border),
            left: BorderSide(color: context.customColor.border),
            right: BorderSide(color: context.customColor.border),
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.r),
            bottomRight: Radius.circular(20.r),
          ),
        ),
        sliver: SliverList.builder(
          itemCount: recentActivity.length,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                border: index < recentActivity.length - 1
                    ? Border(
                        bottom: BorderSide(color: context.customColor.border),
                      )
                    : null,
              ),
              padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          recentActivity[index].transactionType,
                          softWrap: true,
                          style: AppStyles.s12W600.copyWith(
                            color: context.customColor.text1,
                          ),
                        ),
                      ),
                      SaudiRiyalSvgWidget(color: context.customColor.text3),
                      3.horizontalSpace,
                      Text(
                        recentActivity[index].amount,
                        style: AppStyles.s12WB.copyWith(
                          color: recentActivity[index].isCashIn
                              ? AppColors.lightGreen
                              : context.customColor.error,
                        ),
                      ),
                    ],
                  ),
                  // Text(
                  //   'Closing Balance from Alharbi',
                  //   style: AppStyles.s12W400.copyWith(
                  //     color: context.customColor.text3,
                  //   ),
                  // ),
                  Text(
                    recentActivity[index].dateTime,
                    style: AppStyles.s10W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
