import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/label_text_field.dart';
import '../../../../core/widgets/saudi_riyal_svg_widget.dart';

class VatTextField extends StatelessWidget {
  final TextEditingController? controller;
  final bool includeSaudiRiyalIcon;
  final String hintText;
  final String labelText;
  final TextInputType keyboardType;
  final String? initialValue;
  final void Function(String value)? onChanged;

  const VatTextField({
    super.key,
    this.controller,
    this.includeSaudiRiyalIcon = true,
    required this.hintText,
    required this.labelText,
    this.keyboardType = TextInputType.number,
    this.onChanged,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: context.customColor.border),
      ),
      padding: EdgeInsets.symmetric(vertical: 18.5.r, horizontal: 17.r),
      child: Row(
        children: [
          if (includeSaudiRiyalIcon) ...[
            const SaudiRiyalSvgWidget(),
            6.horizontalSpace,
            Container(
              color: context.customColor.text3,
              width: 1.r,
              height: 14.r,
            ),
            6.horizontalSpace,
          ],
          Expanded(
            child: CustomTextField(
              controller: controller,
              hintText: hintText,
              onChanged: onChanged,
              keyboardType: keyboardType,
              initialValue: initialValue,
            ),
          ),
          12.horizontalSpace,
          Flexible(
            child: LabelTextField(
              text: labelText,
              style: AppStyles.s14W400.copyWith(
                color: context.customColor.text3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
