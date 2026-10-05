import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/app_padding_widget.dart';

class ExpenseDetailsTopSection extends StatelessWidget {
  final String title;

  const ExpenseDetailsTopSection({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppPaddingWidget(
      top: 40.r,
      bottom: 0,
      child: Row(
        children: [
          const AppBackButton(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppStyles.s16W600.copyWith(
                  color: context.customColor.text1,
                ),
              ),
              Text(
                context.tr.viewDetailsTimelinesAndStatuses,
                style: AppStyles.s12W400.copyWith(
                  color: context.customColor.text3,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
