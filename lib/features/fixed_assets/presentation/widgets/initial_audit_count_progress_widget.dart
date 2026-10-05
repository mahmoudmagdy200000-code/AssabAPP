import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:flutter/material.dart';

class InitialAuditCountProgressWidget extends StatelessWidget {
  const InitialAuditCountProgressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr.countProgress,
          style: AppStyles.s16W600.copyWith(color: context.customColor.text1),
        ),
        8.verticalSpace,
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 12.r),
          decoration: BoxDecoration(
            color: context.customColor.reversedTextColor,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: context.customColor.border),
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildProgressItem(
                  context,
                  color: context.theme.primaryColor,
                  count: '1',
                  label: context.tr.recorded,
                ),
              ),
              _buildVerticalDivider(context),
              Expanded(
                child: _buildProgressItem(
                  context,
                  color: AppColors.lightGreen,
                  count: '0',
                  label: context.tr.excellent,
                ),
              ),
              _buildVerticalDivider(context),
              Expanded(
                child: _buildProgressItem(
                  context,
                  color: AppColors.orange,
                  count: '0',
                  label: context.tr.maintenance,
                ),
              ),
              _buildVerticalDivider(context),
              Expanded(
                child: _buildProgressItem(
                  context,
                  color: context.customColor.error,
                  count: '0',
                  label: context.tr.problem,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider(BuildContext context) {
    return Container(width: 1, height: 40.h, color: context.customColor.border);
  }

  Widget _buildProgressItem(
    BuildContext context, {
    required Color color,
    required String count,
    required String label,
  }) {
    return Column(
      children: [
        Container(
          width: 8.r,
          height: 8.r,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        4.verticalSpace,
        Text(
          count,
          style: AppStyles.s12W500.copyWith(color: context.customColor.text1),
        ),
        Text(
          label,
          style: AppStyles.s12W400.copyWith(color: context.customColor.text3),
        ),
      ],
    );
  }
}
