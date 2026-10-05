import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  final Color? color;
  final double? thickness;

  const CustomDivider({super.key, this.color, this.thickness});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1.h,
      thickness: thickness,
      color: color ?? context.customColor.text2,
    );
  }
}
