import 'package:flutter/material.dart';
import '../../../../core/extensions/build_context_extensions.dart';
import '../../../../core/extensions/number_extensions.dart';
import '../../../../core/styles/app_styles.dart';
import '../../data/models/fixed_assets_search_response.dart';

class FixedAssetsSearchResultSummaryWidget extends StatelessWidget {
  final FixedAssetsSearchIResultSummary summary;

  const FixedAssetsSearchResultSummaryWidget({
    super.key,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr.resultSummary,
          style: AppStyles.s16W600.copyWith(color: context.customColor.text1),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: context.theme.scaffoldBackgroundColor,
            border: Border.all(color: context.customColor.text2),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSummaryItem(
                context,
                color: Colors.green,
                count: summary.totalItemsMatchingSearch.toString(),
                subCount: ' of ${summary.totalItems.toString()}',
                label: context.tr.match,
              ),
              _buildDivider(context),
              _buildSummaryItem(
                context,
                color: Colors.blue,
                count: summary.totalItemsMatchingSearchExcellentStatus
                    .toString(),
                label: context.tr.excellent,
              ),
              _buildDivider(context),
              _buildSummaryItem(
                context,
                color: Colors.orange,
                count: summary.totalItemsMatchingSearchMaintenanceStatus
                    .toString(),
                label: context.tr.maintenance,
              ),
              _buildDivider(context),
              _buildSummaryItem(
                context,
                color: Colors.red,
                count: summary.totalItemsMatchingSearchProblemStatus.toString(),
                label: context.tr.problem,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryItem(
    BuildContext context, {
    required Color color,
    required String count,
    String? subCount,
    required String label,
  }) {
    return Column(
      children: [
        Container(
          width: 8.r,
          height: 8.r,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(height: 4.h),
        RichText(
          text: TextSpan(
            text: count,
            style: AppStyles.s12W500.copyWith(color: context.customColor.text1),
            children: [
              if (subCount != null)
                TextSpan(
                  text: subCount,
                  style: AppStyles.s12W500.copyWith(
                    color: context.customColor.text4,
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: AppStyles.s12W400.copyWith(color: context.customColor.text3),
        ),
      ],
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Container(
      width: 1.w,
      height: 40.h,
      color: context.customColor.text2,
    );
  }
}
