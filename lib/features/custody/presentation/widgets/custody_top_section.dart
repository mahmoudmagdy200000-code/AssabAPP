import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/app_padding_widget.dart';
import '../../../../core/widgets/custom_divider.dart';
import 'custody_balance_page_view_section.dart';

class CustodyTopSection extends StatelessWidget {
  final ValueChanged<int> onPageChanged;

  const CustodyTopSection({super.key, required this.onPageChanged});

  @override
  Widget build(BuildContext context) {
    return AppPaddingWidget(
      bottom: 12.r,
      child: Column(
        children: [
          CustodyBalancePageViewSection(onPageChanged: onPageChanged),
          12.verticalSpace,
          const CustomDivider(),
        ],
      ),
    );
  }
}
