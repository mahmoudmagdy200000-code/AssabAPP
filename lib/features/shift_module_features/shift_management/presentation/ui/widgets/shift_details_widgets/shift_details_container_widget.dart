import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

class ShiftDetailsContainerWidget extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  const ShiftDetailsContainerWidget({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          padding ?? EdgeInsets.symmetric(vertical: 25.h, horizontal: 22.w),
      decoration: BoxDecoration(
        color: context.customColor.reversedTextColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: context.customColor.border, width: 1.w),
      ),
      child: child,
    );
  }
}
