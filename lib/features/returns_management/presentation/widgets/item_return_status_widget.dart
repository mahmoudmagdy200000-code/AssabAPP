import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../purchase/presentation/widgets/purchase_status_widget.dart';

class ItemReturnStatusWidget extends StatelessWidget {
  final String status;
  final String? subtitle;
  final String description;
  final Color textColor;
  final Color borderColor;
  final Widget? widget;

  const ItemReturnStatusWidget({
    super.key,
    required this.status,
    this.subtitle,
    required this.description,
    required this.textColor,
    required this.borderColor,
    this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: borderColor),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 12.r),
      child: Column(
        children: [
          PurchaseStatusWidget(
            statusText: status,
            backgroundColor: Colors.transparent,
            textColor: textColor,
            withBorder: true,
          ),
          if (subtitle != null) ...[
            6.verticalSpace,
            Text(
              subtitle!,
              style: AppStyles.s14W600.copyWith(
                color: context.customColor.text1,
              ),
            ),
          ],
          4.verticalSpace,
          Text(
            description,
            textAlign: TextAlign.center,
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
          ),
          if (widget != null) 8.verticalSpace,
          ?widget,
        ],
      ),
    );
  }
}
