import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/utils/date_formatter.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/saudi_riyal_svg_widget.dart';
import '../../data/models/custody_get_past_requests_response.dart';

class BranchCustodyPastRequestsRequestViewItemListWidget
    extends StatelessWidget {
  final Border? border;
  final CustodyGetPastRequestData request;
  final double margin;

  const BranchCustodyPastRequestsRequestViewItemListWidget({
    super.key,
    this.border,
    required this.request,
    required this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.customColor.reversedTextColor,
        borderRadius: BorderRadius.circular(20.r),
        border: border,
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 16.r),
      margin: EdgeInsets.only(bottom: margin),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSvg(
            assetName: AppAssets.custody,
            width: 20.r,
            height: 20.r,
            colorFilter: ColorFilter.mode(
              context.customColor.text3,
              BlendMode.srcIn,
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
                        request.purpose,
                        softWrap: true,
                        style: AppStyles.s12W600.copyWith(
                          color: context.customColor.text1,
                        ),
                      ),
                    ),
                    SaudiRiyalSvgWidget(color: context.customColor.text3),
                    3.horizontalSpace,
                    Text(
                      request.requestedAmount > 0
                          ? '+${request.requestedAmount}'
                          : '-${request.requestedAmount}',
                      style: AppStyles.s12WB.copyWith(
                        color: request.requestedAmount > 0
                            ? AppColors.lightGreen
                            : context.customColor.error,
                      ),
                    ),
                  ],
                ),
                Text(
                  request.purpose,
                  style: AppStyles.s12W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${DateFormatter.formatDateMDY(DateTime.tryParse(request.createdAt))} - ${DateFormatter.formatTimeHM(DateTime.tryParse(request.createdAt))}',
                        style: AppStyles.s10W400.copyWith(
                          color: context.customColor.text3,
                        ),
                      ),
                    ),
                    // 10.horizontalSpace,
                    // Text(
                    //   request.status.getLabel(context),
                    //   style: AppStyles.s10W500.copyWith(
                    //     color: request.status.getLabelColor(context),
                    //   ),
                    // ),
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
