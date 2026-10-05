import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/custom_divider.dart';
import 'custody_balance_state_page_view_section.dart';

class CustodyBalanceStateTopSection extends StatelessWidget {
  const CustodyBalanceStateTopSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CustodyBalanceStatePageViewSection(),
        12.verticalSpace,
        const CustomDivider(),
      ],
    );
  }
}
