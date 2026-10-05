import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

class SelectionCircule extends StatelessWidget {
  final bool isSelected;
  final int? width;
  final int? height;
  final Color? color;

  const SelectionCircule({
    super.key,
    required this.isSelected,
    this.width,
    this.height,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width?.r ?? 24.r,
      height: height?.r ?? 24.r,
      decoration: BoxDecoration(
        color: isSelected
            ? color ?? context.theme.primaryColor
            : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: context.customColor.border,
          width: isSelected ? 2.r : 1.r,
        ),
      ),
    );
  }
}
