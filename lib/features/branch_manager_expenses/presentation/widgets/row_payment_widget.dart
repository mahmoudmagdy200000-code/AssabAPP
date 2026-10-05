import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/app_styles.dart';

class RowPaymentWidget extends StatelessWidget {
  final String paymentMethod;
  const RowPaymentWidget({super.key, required this.paymentMethod});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            context.tr.paymentMethod,
            textAlign: TextAlign.start,
            style: AppStyles.s14W400.copyWith(color: context.customColor.text3),
          ),
        ),
        Expanded(
          child: Text(
            paymentMethod,
            textAlign: TextAlign.end,
            style: AppStyles.s14W500.copyWith(color: context.customColor.text1),
          ),
        ),
      ],
    );
  }
}
