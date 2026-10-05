import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../cashier_home/presentation/widgets/cashier_empty_widget.dart';

class CashierLedgerView extends StatelessWidget {
  const CashierLedgerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr.myWorkLists(0),
          style: AppStyles.s16W600.copyWith(color: context.customColor.text1),
        ),
        20.verticalSpace,
        const CustomDivider(),
        20.verticalSpace,
        CashierEmptyWidget(
          title: context.tr.noActivityYet,
          desc: context.tr.noActivityYetDesc,
          image: AppAssets.detailsPng,
        ),
      ],
    );
  }
}
