import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:flutter/material.dart';

class CashierNameAndBranch extends StatelessWidget {
  const CashierNameAndBranch({
    super.key,
    required this.Name,
    required this.BranchName,
    this.ShiftCount,
  });

  final String Name;
  final String BranchName;
  final int? ShiftCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(Name, style: AppStyles.s15W500),

        Text(
          BranchName,
          style: AppStyles.s11W500.copyWith(color: context.customColor.text3),
        ),

        if (ShiftCount != null)
          Text(
            context.tr.shiftCountsDaily(ShiftCount!),
            style: AppStyles.s11W500.copyWith(color: context.customColor.text3),
          ),
      ],
    );
  }
}
